
clear;clc;close all;
%% ��������
data=xlsread(['yuce.xlsx']); 

P_train=data(1:700,1:7)';
T_train=data(1:700,8)';

P_test=data(701:1000,1:7)';
T_test=data(701:1000,8)';
%% ��һ��
% ѵ����
[Pn_train,inputps] = mapminmax(P_train,0,1);
Pn_test = mapminmax('apply',P_test,inputps);
% ���Լ�
[Tn_train,outputps] = mapminmax(T_train,0,1);
Tn_test = mapminmax('apply',T_test,outputps);



%���е�������������Ӧ��Ϊ N*dim������NΪ����������dimΪ���ݵ�ά��
Pn_train = Pn_train';
Pn_test = Pn_test';
Tn_train = Tn_train';
Tn_test = Tn_test';

%% DELM��������
ELMAEhiddenLayer = [2,3];%ELM��AE�����ز�����[n1,n2,...,n],n1�����1�����ز�Ľڵ�����
ActivF = 'sig';%ELM-AE�ļ��������
C = inf; %����ϵ��
%% �Ż��㷨�������ã�
%����Ȩֵ��ά��
dim = ELMAEhiddenLayer(1)*size(Pn_train,2);
if length(ELMAEhiddenLayer)>1
    for i = 2:length(ELMAEhiddenLayer)
        dim = dim + ELMAEhiddenLayer(i)*ELMAEhiddenLayer(i-1);
    end
end
popsize = 20;%��Ⱥ����
Max_iteration = 50;%����������
lb = -1;%Ȩֵ�±߽�
ub = 1;%Ȩֵ�ϱ߽�
fobj = @(X)fun(X,Pn_train,Tn_train,Pn_test,Tn_test,ELMAEhiddenLayer,ActivF,C);
[Best_score,Best_pos,DBO_cg_curve]=DBO(popsize,Max_iteration,lb,ub,dim,fobj);
figure
plot(DBO_cg_curve,'linewidth',1.5)
xlabel('��������')
ylabel('��Ӧ��ֵ')
grid on
title('�����㷨��������')
%% ���������õĳ�ʼȨ�أ�����ѵ��
BestWeitht = Best_pos;
%DELMѵ��
OutWeight = DELMTrainWithInitial(BestWeitht,Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%ѵ�������Խ��
predictValueTrainDBO = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% ����һ��
predictValueTrainDBO = mapminmax('reverse',predictValueTrainDBO,outputps);
% �������
Error1DBO = (predictValueTrainDBO' - T_train);
MSE1DBO = mse(Error1DBO);
%���Լ����Խ��
predictValueTestDBO = DELMPredict(Pn_test,OutWeight,ELMAEhiddenLayer);
% ����һ��
predictValueTestDBO = mapminmax('reverse',predictValueTestDBO,outputps);
% �������
Error2DBO = (predictValueTestDBO' - T_test);
MSE2DBO = mse(Error2DBO);

%% ����DELMѵ��
%DELMѵ��
OutWeight = DELMTrain(Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%% ѵ�������Խ��
predictValueTrain = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% ����һ��
predictValueTrain = mapminmax('reverse',predictValueTrain,outputps);
% �������
Error1 = (predictValueTrain' - T_train);
MSE1 = mse(Error1);

%% ���Լ������ͼ

[mae_elm_do,rmse_elm_do,mape_elm_do,tic_elm_do,vpe_elm_do,dc_elm_do] = evluation(T_test,predictValueTestDBO');
plot(T_test)
hold on
plot(predictValueTestDBO')
R2 = 1 - (sum ((T_test - predictValueTestDBO').^2) / sum ((predictValueTestDBO' - mean (predictValueTestDBO')).^2));
