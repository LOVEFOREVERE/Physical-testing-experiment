function dc=DC(ypred,ytrue)
    % 初始化DC指标数组
    a = zeros(size(ytrue, 2), 1);
    
    % 遍历真实值数组的每个元素
    for t = 1:size(ytrue, 2)
        % 如果是第一个元素，没有前一个元素可以比较，跳过
        if t == 1
            continue;
        end
        
        % 计算真实值和预测值的变化量
        y_change_true = ytrue(t) - ytrue(t-1);
        y_change_pred = ypred(t) - ypred(t-1);
        
        % 判断预测值和真实值的变化趋势是否一致
        if y_change_true * y_change_pred > 0
            a(t) = 1;
        else
            a(t) = 0;
        end
    end
    
    % 计算DC指标
    dc = sum(a) / size(ytrue, 2);
end

