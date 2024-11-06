function predictValue = DELMPredict(P_train,Weight,ELMAEhiddenLayer)
hiddenLayerSize = length(ELMAEhiddenLayer); %��ȡELM-AE�Ĳ���
for i = 1:hiddenLayerSize
   P_train =  P_train*Weight{1,i};
end
beta = Weight{1,hiddenLayerSize+1};
predictValue = P_train*beta;
end