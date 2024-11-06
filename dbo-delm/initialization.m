
% 种群初始化
function Positions=initialization(SearchAgents_no,dim,ub,lb)
Positions = zeros(SearchAgents_no,dim); 
for i=1:SearchAgents_no
    for j=1:dim
        Positions(i,j)=rand*(ub(j)-lb(j))+lb(j);
    end
end
end
