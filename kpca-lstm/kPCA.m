function [Y, eigVec, eigVal] = kPCA(p_train, dim, type, para)

%%  获取样本数目
N = size(p_train, 1);

%%  核主成分分析
K0 = kernel(p_train, type, para);
oneN = ones(N, N) / N;
K = K0 - oneN * K0 - K0 * oneN + oneN * K0 * oneN;

%%  特征值分析
[V, D] = eig(K / N);
eigVal = diag(D);
[~, idx] = sort(eigVal, 'descend');
eigVal = eigVal(idx);

%%  特征向量分析
eigVec = V(:, idx);
norm_eigVector = sqrt(sum(eigVec .^ 2));
eigVec = eigVec ./ repmat(norm_eigVector, size(eigVec, 1), 1);

%%  降维
eigVec = eigVec(:, 1: dim);
Y = K0 * eigVec;

end