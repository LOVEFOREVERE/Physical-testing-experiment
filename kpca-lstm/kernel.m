function K = kernel(X, type, para)

%%  核函数

% 无核函数
if strcmp(type, 'simple')
    K = X * X';
end

% 多项式核函数
if strcmp(type, 'poly')
    K = X * X' + 1;
    K = K .^ para;
end

% 高斯核函数
if strcmp(type, 'gaussian')
    K = distanceMatrix(X) .^ 2;
    K = exp(-K ./ (2 * para .^ 2));
end

end