function  fitness=fun(X,Pn_train,Tn_train,Pn_test,Tn_test,ELMAEhiddenLayer,ActivF,C)
%DELMѵ��
OutWeight = DELMTrainWithInitial(X,Pn_train,Tn_train,ELMAEhiddenLayer,ActivF,C);
%% ѵ�������Խ��
predictValueTrain = DELMPredict(Pn_train,OutWeight,ELMAEhiddenLayer);
% �������
Error1 = (predictValueTrain - Tn_train);
MSE1 = mse(Error1);


%% ���Լ����Խ��
predictValueTest = DELMPredict(Pn_test,OutWeight,ELMAEhiddenLayer);
% �������
Error2 = (predictValueTest - Tn_test);
MSE2 = mse(Error2);

fitness = MSE1+MSE2;


end