
data1=xlsread(['trainx.xlsx']); 
data2=xlsread(['yuce.xlsx']); 
data2=data2(1:1000,8);
data=[data1 data2];
num_samples =1000;
res=data;
% 训练集和测试集划分
outdim = 1;                                  % 最后一列为输出
num_size = 0.7;                              % 训练集占数据集比例
num_train_s = round(num_size * num_samples); % 训练集样本个数
f_ = size(res, 2) - outdim;                  % 输入特征维度
num_train_s =700;

P_train = res(1: num_train_s, 1: f_)';
T_train = res(1: num_train_s, f_ + 1: end)';
M = size(P_train, 2);

P_test = res(num_train_s + 1: end, 1: f_)';
T_test = res(num_train_s + 1: end, f_ + 1: end)';
N = size(P_test, 2);

%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%  格式转换
for i = 1 : M 
    vp_train{i, 1} = p_train(:, i);
    vt_train{i, 1} = t_train(:, i);
end

for i = 1 : N 
    vp_test{i, 1} = p_test(:, i);
    vt_test{i, 1} = t_test(:, i);
end

%  创建LSTM网络，
layers = [ ...
    sequenceInputLayer(f_)              % 输入层
    bilstmLayer(100)                      
    reluLayer                           
    fullyConnectedLayer(outdim)         % 回归层
    regressionLayer];

%  参数设置
options = trainingOptions('adam', ...                 % 优化算法Adam
    'MaxEpochs', 100, ...                            % 最大训练次数
    'MiniBatchSize',25,...
    'GradientThreshold', 1, ...                       % 梯度阈值
    'InitialLearnRate', 0.001, ...                    % 初始学习率
    'LearnRateSchedule', 'piecewise', ...             % 学习率调整
    'LearnRateDropPeriod', 70, ...                   % 训练60次后开始调整学习率
    'LearnRateDropFactor',0.2, ...                    % 学习率调整因子
    'L2Regularization', 0.001, ...                    % 正则化参数
    'ExecutionEnvironment', 'cpu',...                 % 训练环境
    'Verbose', 0, ...                                 % 关闭优化过程
    'Plots', 'training-progress');                    % 画出曲线

%  训练
net = trainNetwork(vp_train, vt_train, layers, options);
%analyzeNetwork(net);% 查看网络结构
%  预测
t_sim1 = predict(net, vp_train); 
t_sim2 = predict(net, vp_test); 

%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);
T_train1 = T_train;
T_test2 = T_test;

%  数据格式转换
T_sim1 = cell2mat(T_sim1);% cell2mat将cell元胞数组转换为普通数组
T_sim2 = cell2mat(T_sim2);

[mae_elm_do,rmse_elm_do,mape_elm_do,tic_elm_do,vpe_elm_do,dc_elm_do] = evluation(T_test2,T_sim2');
plot(T_test2)
hold on
plot(T_sim2')
R2 = 1 - (sum ((T_test2 - T_sim2').^2) / sum ((T_sim2' - mean (T_sim2')).^2));



