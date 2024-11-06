function predictValue = DELMPredict(P_train,Weight,ELMAEhiddenLayer)
hiddenLayerSize = length(ELMAEhiddenLayer); %获取ELM-AE的层数
for i = 1:hiddenLayerSize
   P_train =  P_train*Weight{1,i};
end
beta = Weight{1,hiddenLayerSize+1};
predictValue = P_train*beta;
end