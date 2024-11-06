
%% 淘个代码 %%
% 2023/07/19 %
%微信公众号搜索：淘个代码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [error,test_simu] = fitness(x,inputnum,hiddennum_best,outputnum,net,inputn,outputn,inputn_test,outputps,output_test)


temp=clock;temp=sum(temp(4:6))*sum(temp(2:3));temp=round(temp/10);setdemorandstream(temp);%此行代码用于生成随机数种子，确保结果可以复现
%该函数用来计算适应度值
hiddennum=hiddennum_best;
%提取

w1=x(1:inputnum*hiddennum);%取到输入层与隐含层连接的权值
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);%隐含层神经元阈值
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);%取到隐含层与输出层连接的权值
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);%输出层神经元阈值

net.trainParam.showWindow = false;
net.trainParam.showCommandLine = false;  %隐藏仿真界面

%网络权值赋值
net.iw{1,1}=reshape(w1,hiddennum,inputnum);%将w1由1行inputnum*hiddennum列转为hiddennum行inputnum列的二维矩阵
net.lw{2,1}=reshape(w2,outputnum,hiddennum);%更改矩阵的保存格式
net.b{1}=reshape(B1,hiddennum,1);%1行hiddennum列，为隐含层的神经元阈值
net.b{2}=reshape(B2,outputnum,1);

%网络训练
net=train(net,inputn,outputn);

% an0=sim(net,inputn);
% train_simu=mapminmax('reverse',an0,outputps);
an=sim(net,inputn_test);
test_simu=mapminmax('reverse',an,outputps);

error=sqrt(sum(((test_simu-output_test)).^2)/length(output_test));
   %适应度函数选取为测试集的RMSE，适应度函数值越小，表明模型的预测精度越高，注意newff函数搭建的BP，产生了交叉验证，因此选另外的数据预测误差作为适应度函数是合理。
end




