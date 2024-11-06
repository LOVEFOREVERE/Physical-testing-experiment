function [mae,rmse,mape,tic,vpe,dc]=evluation(result,Test)
% result 预测结果 Test 真实值
     mae = mean(abs(result-Test));
     rmse = sqrt(mean((result-Test).^2));
     % mape = mean(abs((result-Test)./Test))*100;
     mape =sum(abs((result-Test)./Test))/length(Test)*100;
     tic=(sqrt(mean((result-Test).^2)))/(sqrt(mean((Test).^2))+sqrt(mean((result).^2)));
     et=result-Test; %预测值-真实值
     vpe=sqrt(mean((et-mean(et)).^2));
     dc=DC(result,Test);

end