
clear;clc;close all;
%% 导入数据
data=xlsread(['yuce.xlsx']); 

P_train=data(1:700,1:7)';
T_train=data(1:700,8)';

P_test=data(701:1000,1:7)';
T_test=data(701:1000,8)';
%% 归一化
% 训练集
[Pn_train,inputps] = mapminmax(P_train,0,1);
Pn_test = mapminmax('apply',P_test,inputps);
% 测试集
[Tn_train,outputps] = mapminmax(T_train,0,1);
Tn_test = mapminmax('apply',T_test,outputps);



%所有的数据输入类型应该为 N*dim，其中N为数据组数，dim为数据的维度
Pn_train = Pn_train';
Pn_test = Pn_test';
Tn_train = Tn_train';
Tn_test = Tn_test';

%% DELM参数设置
ELMAEhiddenLayer = [2,3];%ELM—AE的隐藏层数，[n1,n2,...,n],n1代表第1个隐藏层的节点数。
ActivF = 'sig';%ELM-AE的激活函数设置
C = inf; %正则化系数
%% 优化算法参数设置：
%计算权值的维度
dim = ELMAEhiddenLayer(1)*size(Pn_train,2);
if length(ELMAEhiddenLayer)>1
    for i = 2:length(ELMAEhiddenLayer)
        dim = dim + ELMAEhiddenLayer(i)*ELMAEhiddenLayer(i-1);
    end
end
popsize = 20;%种群数量
Max_iteration = 50;%最大迭代次数
lb = -1;%权值下边界
ub = 1;%权值上边界
fobj = @(X)fun(X,Pn_train,Tn_train,Pn_test,Tn_test,ELMAEhiddenLayer,ActivF,C);
[Best_score,Best_pos,DBO_cg_curve]=DBO(popsize,Max_iteration,lb,ub,dim,fobj);
figure
plot(DBO_cg_curve,'linewidth',1.5)
xlabel('迭代次数')
ylabel('适应度值')
grid on
title('蜣螂算法收敛曲线')
%% 利用蜣螂获得的初始权重，进行训练
BestWeitht = Best_pos;
%DELM训练
OutWeight = DELMTrainWithInitial(BestWeitht,Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%训练集测试结果
predictValueTrainDBO = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% 反归一化
predictValueTrainDBO = mapminmax('reverse',predictValueTrainDBO,outputps);
% 均方误差
Error1DBO = (predictValueTrainDBO' - T_train);
MSE1DBO = mse(Error1DBO);
%测试集测试结果
predictValueTestDBO = DELMPredict(Pn_test,OutWeight,ELMAEhiddenLayer);
% 反归一化
predictValueTestDBO = mapminmax('reverse',predictValueTestDBO,outputps);
% 均方误差
Error2DBO = (predictValueTestDBO' - T_test);
MSE2DBO = mse(Error2DBO);

%% 基础DELM训练
%DELM训练
OutWeight = DELMTrain(Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%% 训练集测试结果
predictValueTrain = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% 反归一化
predictValueTrain = mapminmax('reverse',predictValueTrain,outputps);
% 均方误差
Error1 = (predictValueTrain' - T_train);
MSE1 = mse(Error1);

%% 测试集结果画图

[mae_elm_do,rmse_elm_do,mape_elm_do,tic_elm_do,vpe_elm_do,dc_elm_do] = evluation(T_test,predictValueTestDBO');
plot(T_test)
hold on
plot(predictValueTestDBO')
R2 = 1 - (sum ((T_test - predictValueTestDBO').^2) / sum ((predictValueTestDBO' - mean (predictValueTestDBO')).^2));
