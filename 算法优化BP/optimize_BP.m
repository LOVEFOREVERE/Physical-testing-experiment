%% 初始化
clear
close all
clc
warning off
rng(0)


data = xlsread('yuce1.xlsx');%6月也可 mape15%
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
%% 数据归一化
[inputn,inputps]=mapminmax(input_train,0,1);
[outputn,outputps]=mapminmax(output_train);
inputn_test=mapminmax('apply',input_test,inputps);
%% 获取输入层节点、输出层节点个数
inputnum=size(input_train,1);
outputnum=size(output_train,1);
disp('/////////////////////////////////')
disp('神经网络结构...')
disp(['输入层的节点数为：',num2str(inputnum)])
disp(['输出层的节点数为：',num2str(outputnum)])
disp(' ')
disp('隐含层节点的确定过程...')

%确定隐含层节点个数
%采用经验公式hiddennum=sqrt(m+n)+a，m为输入层节点个数，n为输出层节点个数，a一般取为1-10之间的整数
MSE=1e+5; %初始化最小误差
for hiddennum=fix(sqrt(inputnum+outputnum))+1:fix(sqrt(inputnum+outputnum))+5
    %构建网络
    net=newff(inputn,outputn,hiddennum,{'tansig','purelin'},'trainlm');% 建立模型
    % 网络参数
    net.trainParam.epochs=1000;         % 训练次数
    net.trainParam.lr=0.01;                   % 学习速率
    net.trainParam.goal=0.000001;        % 训练目标最小误差
    net.trainParam.showWindow=0;  %隐藏仿真界面
    % 网络训练
    net=train(net,inputn,outputn);
    an0=sim(net,inputn);  %仿真结果,依旧采用训练集进行测试
    test_simu0=mapminmax('reverse',an0,outputps); %把仿真得到的数据还原为原始的数量级
    mse0=mse(test_simu0,output_train);  %仿真的均方误差
    disp(['隐含层节点数为',num2str(hiddennum),'时，训练集的均方误差为：',num2str(mse0)])

    %更新最佳的隐含层节点
    if mse0<MSE
        MSE=mse0;
        hiddennum_best=hiddennum;
    end
end
clear net0
disp(['最佳的隐含层节点数为：',num2str(hiddennum_best),'，训练集的均方误差为：',num2str(MSE)])

%% 构建最佳隐含层节点的BP神经网络
disp(' ')
disp('标准的BP神经网络：')
net0=newff(inputn,outputn,hiddennum_best,{'tansig','purelin'},'trainlm');% 建立模型
%网络参数配置
net0.trainParam.epochs=1000;         % 训练次数，这里设置为1000次
net0.trainParam.lr=0.01;                   % 学习速率，这里设置为0.01
net0.trainParam.goal=0.00001;                    % 训练目标最小误差，这里设置为0.0001
net0.trainParam.show=25;                % 显示频率，这里设置为每训练25次显示一次
net0.trainParam.mc=0.01;                 % 动量因子
net0.trainParam.min_grad=1e-6;       % 最小性能梯度
net0.trainParam.max_fail=6;               % 最高失败次数
net0.trainParam.showWindow = false;
net0.trainParam.showCommandLine = false;            %隐藏仿真界面
%开始训练
net0=train(net0,inputn,outputn);

%预测
an0=sim(net0,inputn_test); %用训练好的模型进行仿真
%预测结果反归一化与误差计算
test_simu0=mapminmax('reverse',an0,outputps); %把仿真得到的数据还原为原始的数量级
%误差指标
mse0=mse(output_test,test_simu0);

dim=inputnum*hiddennum_best+hiddennum_best+hiddennum_best*outputnum+outputnum;    %自变量个数

SearchAgents_no = 10;
Max_iter = 30;
lb = -2.*ones(1,dim);
ub = 2.*ones(1,dim);

net=newff(inputn,outputn,hiddennum_best,{'tansig','purelin'},'trainlm');% 建立模型
%网络参数配置
net.trainParam.epochs=1000;         % 训练次数，这里设置为1000次
net.trainParam.lr=0.01;                   % 学习速率，这里设置为0.01
net.trainParam.goal=0.00001;                    % 训练目标最小误差，这里设置为0.0001
net.trainParam.show=25;                % 显示频率，这里设置为每训练25次显示一次
net.trainParam.mc=0.01;                 % 动量因子
net.trainParam.min_grad=1e-6;       % 最小性能梯度
net.trainParam.max_fail=6;               % 最高失败次数
net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false;            %隐藏仿真界面

fobj = @(x)fitness(x,inputnum,hiddennum_best,outputnum,net,inputn,outputn,inputn_test,outputps,output_test);
temp=clock;temp=sum(temp(4:6))*sum(temp(2:3));temp=round(temp/10);setdemorandstream(temp);%此行代码用于生成随机数种子，确保结果可以复现
number = 2;   
str={'GOOSE','HLOA','HO','PO','BFO','CPO','LEA','GA','PSO','GWO'};

disp('正在优化，请等待……')
H1 = cell2mat(str(number));
eval(['[fMin , bestX, Convergence_curve ] =',H1,'(SearchAgents_no,Max_iter,lb,ub,dim,fobj);'])

%% 绘制进化曲线
figure
plot(Convergence_curve,'r-','linewidth',2)
xlabel('进化代数')
ylabel('均方误差')
legend('最佳适应度')
title('进化曲线')

setdemorandstream(temp);%此行代码用于生成随机数种子，确保结果可以复现
[~,optimize_test_simu]=fitness(bestX,inputnum,hiddennum_best,outputnum,net,inputn,outputn,inputn_test,outputps,output_test);


%% 比较算法误差
test_y = output_test;
Test_all = [];

y_test_predict = test_simu0;
[test_MAE,test_MAPE,test_MSE,test_RMSE,test_R2]=calc_error(y_test_predict,test_y);
Test_all=[Test_all;test_MAE test_MAPE test_MSE test_RMSE test_R2];


y_test_predict = optimize_test_simu;
[test_MAE,test_MAPE,test_MSE,test_RMSE,test_R2]=calc_error(y_test_predict,test_y);
Test_all=[Test_all;test_MAE test_MAPE test_MSE test_RMSE test_R2];
 	
xlswrite('优化bp.xlsx', optimize_test_simu);
plot(optimize_test_simu);
hold on
plot(test_y);
str={'真实值','标准BP','优化后BP'};
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