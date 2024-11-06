%% 带初始权重的DELM训练函数
%输入-----------------------
%InputWietht:输入的初始权重
%P_train 输入数据，数据格式为N*dim,N代表数据组数，dim代表数据维度。
%T_train 输入标签数据
%ActiveF 为激活函数，如'sig','sin','hardlim','tribas'等。
%C为正则化系数
%输出： outWeight为输出权重
function OutWeight = DELMTrainWithInitial(InputWietht,P_train,T_train,ELMAEhiddenLayer,ActivF,C)
hiddenLayerSize = length(ELMAEhiddenLayer); %获取ELM-AE的层数
outWieght = {};%用于存放所有的权重
P_trainOrg = P_train;
count = 1;
%% ELM-AE提取数据特征
for i = 1:hiddenLayerSize
    Num = ELMAEhiddenLayer(i)*size(P_train,2);
    InputW = InputWietht(count:count+Num-1);
    count = count+Num;
    InputW = reshape(InputW,[ELMAEhiddenLayer(i),size(P_train,2)]);
    [~,B,Hnew] = ELM_AEWithInitial(InputW,P_train,ActivF,ELMAEhiddenLayer(i)); %获取权重
    OutWeight{i} = B';
    P_train =P_train*B'; %输入经过第一层后传递给下一层
end
%% 最后一层ELM进行监督训练
P = P_train;
N =size(P,2);
I = eye(N);
beta = pinv((P'*P+I/C))*P'*T_train;
OutWeight{hiddenLayerSize + 1} = beta; %存储最后一层ELM的信息。
end