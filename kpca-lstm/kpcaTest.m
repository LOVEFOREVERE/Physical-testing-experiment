%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

disp('…………………………………………………………………………………………………………………………')
disp('KPCA降维过程')
disp('…………………………………………………………………………………………………………………………')

%%  读取数据
p_train=xlsread("yuce.xlsx");
p_train = p_train(1:1000,1:7);
%%  参数设置
para = 10;           % 核函数参数  调整会影响KPCA的结果
num=size(p_train,2);   % 总输入维度
%%  降维
[zes, ~, kes] = kPCA(p_train, num, 'poly', para);

%%  贡献率
Vars = kes(1: num) / sum(kes);

figure
bar(Vars)
xlabel('特征')
ylabel('信息占比')
string = {'KPCA后各特征贡献率'};
title(string)
grid

com=0;
for rem=1:length(Vars)
    com=com+Vars(rem);
    if com>0.9    % 取贡献率大于90%的成分
        break;
    end
end

disp(['降维后保留',num2str(rem),'个主成分'])  % 降维后维度

KPCA_data=zes(:,1:rem);% 保留主成分

save KPCA_data  KPCA_data
xlswrite('trainx.xlsx',KPCA_data);