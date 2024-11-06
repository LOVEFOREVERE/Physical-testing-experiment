function  fitness=fun(X,Pn_train,Tn_train,Pn_test,Tn_test,ELMAEhiddenLayer,ActivF,C)
%DELM训练
OutWeight = DELMTrainWithInitial(X,Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%% 训练集测试结果
predictValueTrain = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% 均方误差
Error1 = (predictValueTrain - Tn_train);
MSE1 = mse(Error1);


%% 测试集测试结果
predictValueTest = DELMPredict(Pn_test,OutWeight,ELMAEhiddenLayer);
% 均方误差
Error2 = (predictValueTest - Tn_test);
MSE2 = mse(Error2);

fitness = MSE1+MSE2;


end