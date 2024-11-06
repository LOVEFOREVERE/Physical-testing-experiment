%% ��ʼ��
clear
close all
clc
warning off
rng(0)


data = xlsread('yuce1.xlsx');%6��Ҳ�� mape15%
data = data(1:1000,8);
a_w = data(1:700);b_w = data(701:1000);
x1 = 1:700;x2 = 701:1000;
plot(x1,a_w,'color',[0.7,0.6,0.3], 'LineWidth', 2);
hold on
plot(x2,b_w,'color',[0.1,0.6,0.7], 'LineWidth', 2)
hold on
% plot(700.5*ones(16),[0:15],'-.black')
hold off
xlabel('Sample point','FontSize',20)
ylabel('Score','FontSize',20)
title('2022 Boys combined scores','FontSize',20)
set(gca,'FontSize',20);



data=xlsread(['yuce1.xlsx']); 
input_train=data(1:700,1:7)';
output_train=data(1:700,8)';
input_test=data(701:1000,1:7)';
output_test=data(701:1000,8)';
%% ���ݹ�һ��
[inputn,inputps]=mapminmax(input_train,0,1);
[outputn,outputps]=mapminmax(output_train);
inputn_test=mapminmax('apply',input_test,inputps);
%% ��ȡ�����ڵ㡢�����ڵ����
inputnum=size(input_train,1);
outputnum=size(output_train,1);
disp('/////////////////////////////////')
disp('������ṹ...')
disp(['�����Ľڵ���Ϊ��',num2str(inputnum)])
disp(['�����Ľڵ���Ϊ��',num2str(outputnum)])
disp(' ')
disp('������ڵ��ȷ������...')

%ȷ��������ڵ����
%���þ��鹫ʽhiddennum=sqrt(m+n)+a��mΪ�����ڵ������nΪ�����ڵ������aһ��ȡΪ1-10֮�������
MSE=1e+5; %��ʼ����С���
for hiddennum=fix(sqrt(inputnum+outputnum))+1:fix(sqrt(inputnum+outputnum))+5
    %��������
    net=newff(inputn,outputn,hiddennum,{'tansig','purelin'},'trainlm');% ����ģ��
    % �������
    net.trainParam.epochs=1000;         % ѵ������
    net.trainParam.lr=0.01;                   % ѧϰ����
    net.trainParam.goal=0.000001;        % ѵ��Ŀ����С���
    net.trainParam.showWindow=0;  %���ط������
    % ����ѵ��
    net=train(net,inputn,outputn);
    an0=sim(net,inputn);  %������,���ɲ���ѵ�������в���
    test_simu0=mapminmax('reverse',an0,outputps); %�ѷ���õ������ݻ�ԭΪԭʼ��������
    mse0=mse(test_simu0,output_train);  %����ľ������
    disp(['������ڵ���Ϊ',num2str(hiddennum),'ʱ��ѵ�����ľ������Ϊ��',num2str(mse0)])

    %������ѵ�������ڵ�
    if mse0<MSE
        MSE=mse0;
        hiddennum_best=hiddennum;
    end
end
clear net0
disp(['��ѵ�������ڵ���Ϊ��',num2str(hiddennum_best),'��ѵ�����ľ������Ϊ��',num2str(MSE)])

%% �������������ڵ��BP������
disp(' ')
disp('��׼��BP�����磺')
net0=newff(inputn,outputn,hiddennum_best,{'tansig','purelin'},'trainlm');% ����ģ��
%�����������
net0.trainParam.epochs=1000;         % ѵ����������������Ϊ1000��
net0.trainParam.lr=0.01;                   % ѧϰ���ʣ���������Ϊ0.01
net0.trainParam.goal=0.00001;                    % ѵ��Ŀ����С����������Ϊ0.0001
net0.trainParam.show=25;                % ��ʾƵ�ʣ���������Ϊÿѵ��25����ʾһ��
net0.trainParam.mc=0.01;                 % ��������
net0.trainParam.min_grad=1e-6;       % ��С�����ݶ�
net0.trainParam.max_fail=6;               % ���ʧ�ܴ���
net0.trainParam.showWindow = false;
net0.trainParam.showCommandLine = false;            %���ط������
%��ʼѵ��
net0=train(net0,inputn,outputn);

%Ԥ��
an0=sim(net0,inputn_test); %��ѵ���õ�ģ�ͽ��з���
%Ԥ��������һ����������
test_simu0=mapminmax('reverse',an0,outputps); %�ѷ���õ������ݻ�ԭΪԭʼ��������
%���ָ��
mse0=mse(output_test,test_simu0);

dim=inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum+outputnum;    %�Ա�������

SearchAgents_no = 10;
Max_iter = 30;
lb = -2.*ones(1,dim);
ub = 2.*ones(1,dim);

net=newff(inputn,outputn,hiddennum_best,{'tansig','purelin'},'trainlm');% ����ģ��
%�����������
net.trainParam.epochs=1000;         % ѵ����������������Ϊ1000��
net.trainParam.lr=0.01;                   % ѧϰ���ʣ���������Ϊ0.01
net.trainParam.goal=0.00001;                    % ѵ��Ŀ����С����������Ϊ0.0001
net.trainParam.show=25;                % ��ʾƵ�ʣ���������Ϊÿѵ��25����ʾһ��
net.trainParam.mc=0.01;                 % ��������
net.trainParam.min_grad=1e-6;       % ��С�����ݶ�
net.trainParam.max_fail=6;               % ���ʧ�ܴ���
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false;            %���ط������

fobj = @(x)fitness(x,inputnum,hiddennum_best,outputnum,net,inputn,outputn,inputn_test,outputps,output_test);
temp=clock;temp=sum(temp(4:6))*sum(temp(2:3));temp=round(temp/10);setdemorandstream(temp);%���д�������������������ӣ�ȷ��������Ը���
number = 2;   
str={'GOOSE','HLOA','HO','PO','BFO','CPO','LEA','GA','PSO','GWO'};

disp('�����Ż�����ȴ�����')
H1 = cell2mat(str(number));
eval(['[fMin , bestX, Convergence_curve ] =',H1,'(SearchAgents_no,Max_iter,lb,ub,dim,fobj);'])

%% ���ƽ�������
figure
plot(Convergence_curve,'r-','linewidth',2)
xlabel('��������')
ylabel('�������')
legend('�����Ӧ��')
title('��������')

setdemorandstream(temp);%���д�������������������ӣ�ȷ��������Ը���
[~,optimize_test_simu]=fitness(bestX,inputnum,hiddennum_best,outputnum,net,inputn,outputn,inputn_test,outputps,output_test);


%% �Ƚ��㷨���
test_y = output_test;
Test_all = [];

y_test_predict = test_simu0;
[test_MAE,test_MAPE,test_MSE,test_RMSE,test_R2]=calc_error(y_test_predict,test_y);
Test_all=[Test_all;test_MAE test_MAPE test_MSE test_RMSE test_R2];


y_test_predict = optimize_test_simu;
[test_MAE,test_MAPE,test_MSE,test_RMSE,test_R2]=calc_error(y_test_predict,test_y);
Test_all=[Test_all;test_MAE test_MAPE test_MSE test_RMSE test_R2];
 	
xlswrite('�Ż�bp.xlsx', optimize_test_simu);
plot(optimize_test_simu);
hold on
plot(test_y);
str={'��ʵֵ','��׼BP','�Ż���BP'};
str1=str(2:end);
str2={'MAE','MAPE','MSE','RMSE','R2'};
data_out=array2table(Test_all);
data_out.Properties.VariableNames=str2;
data_out.Properties.RowNames=str1;
disp(data_out)


[mae_elm_do,rmse_elm_do,mape_elm_do,tic_elm_do,vpe_elm_do,dc_elm_do] = evluation(test_y, optimize_test_simu);
plot(test_y)
hold on
plot( optimize_test_simu)
R2 = 1 - (sum ((test_y -  optimize_test_simu).^2) / sum (( optimize_test_simu - mean ( optimize_test_simu)).^2));
xlabel('Sample point','FontSize',20)
ylabel('Score','FontSize',20)
title('2022 Girls combined scores','FontSize',20)
legend('Actual value','HLOA-BP projections','FontSize',20)
set(gca,'FontSize',20);

figure
plot(test_y,optimize_test_simu,'ob');
xlabel('Real value')
ylabel('Projected value')
string1 = {'Boys Test Set Effect';['R^2_p=' num2str(R2)  '  RMSEP=' num2str(test_RMSE) ]};
title(string1)
hold on ;h=lsline();
set(h,'LineWidth',1,'LineStyle','-','Color',[1 0 1])
set(gca,'FontSize',20);

error2=test_y-optimize_test_simu;
figure;
ploterrhist(error2,['Girls Test set error histogram']);
legend('Test set error','FontSize',20)
xlabel('Error')
ylabel('Quantities')
title('Girls Test set error histogram','FontSize',20)
set(gca,'FontSize',20);