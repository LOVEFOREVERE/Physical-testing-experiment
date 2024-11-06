%微信公众号搜索：淘个代码，获取更多免费代码
%禁止倒卖转售，违者必究！！！！！
%唯一官方店铺：https://mbd.pub/o/author-amqYmHBs/work
%%
%微信公众号搜索：淘个代码，获取更多免费代码
%禁止倒卖转售，违者必究！！！！！
%唯一官方店铺：https://mbd.pub/o/author-amqYmHBs/work
%%

clear all 
clc

PD_no=100;  %Number
F_name='F12';     %Name of the test function
Max_iter=600;           %Maximum number of iterations
 
[LB,UB,Dim,F_obj]=Get_F(F_name); %Get details of the benchmark functions
[Best_PD,PDBest_P,PDConv]=HLOA(PD_no,Max_iter,LB,UB,Dim,F_obj); % Call HLOA

figure('Position',[454   445   694   297]);
subplot(1,2,1);
func_plot(F_name);     % Function plot
title('Parameter space')
xlabel('x_1');
ylabel('x_2');
zlabel([F_name,'( x_1 , x_2 )'])
subplot(1,2,2);       % Convergence plot
semilogy(PDConv,'linewidth',1);

xlabel('Iteration#');
ylabel('Best fitness so far');
legend('HLOA');



display(['The best-obtained solution by HLOA is : ', num2str(PDBest_P)]);  
display(['The best optimal value of the objective funciton found by HLOA is : ', num2str(Best_PD)]);  
%微信公众号搜索：淘个代码，获取更多免费代码
%禁止倒卖转售，违者必究！！！！！
%唯一官方店铺：https://mbd.pub/o/author-amqYmHBs/work

%微信公众号搜索：淘个代码，获取更多免费代码
%禁止倒卖转售，违者必究！！！！！
%唯一官方店铺：https://mbd.pub/o/author-amqYmHBs/work
