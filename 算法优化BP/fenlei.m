data=xlsread(['yucenvz.xlsx']); 
x=data(1:700,1);

% 构建协方差矩阵
covX = cov(x);

% 构建混合矩阵
covM = eye(size(covX, 1));

% 估计混合矩阵和源信号的矩阵
for i = 1:size(covX, 1)
    covM(i, i) = 1 / (covX(i, i) + 1);
end

% 分离源信号
source = inv(covM) * covX;

% 显示分离得到的源信号
disp('分离得到的源信号：');
disp(source);
