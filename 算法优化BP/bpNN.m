function [output] = bpNN(data_input)
data=data_input;
for i = 1 :695
    train_data(i,1:4) = data(i,1:4);
    train_output(i,1) = data(i,5);
end
for j=1:299
    test_data(j,1:4) = data(700+j, 1:4);
end
pn=train_data';
tn=train_output';
p=test_data';
net = newff(minmax(pn),[20 1],{'logsig','purelin'},'trainlm');
net.trainParam.show=500;
net.trainParam.epochs=500;                          %训练次数
net.trainParam.lr=0.01; 
%网格参数
net=init(net);

[net,tr]=train(net,pn,tn);  %网络训练      

output=sim(net,p);

end