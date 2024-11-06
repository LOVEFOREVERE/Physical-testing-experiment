%_________________________________________________________________________%
% DBO 蜣螂优化算法             %
% %write by Jack旭 ： https:///mbd.pub/o/bread/mbd-YZaTlppv
%_________________________________________________________________________%

function [Best_score,Best_pos,curve] = DBO(pop,MaxIter,lb,ub,dim,fobj)
if(max(size(ub)) == 1)
   ub = ub.*ones(1,dim);
   lb = lb.*ones(1,dim);  
end
PballRolling = 0.2; %滚球蜣螂比例
PbroodBall = 0.4; %产卵蜣螂比例
PSmall = 0.2; %小蜣螂比例
Pthief = 0.2; %偷窃蜣螂比例
BallRollingNum = pop*PballRolling; %滚球蜣螂数量
BroodBallNum = pop*PbroodBall;%产卵蜣螂数量
SmallNum = pop*PSmall;%小蜣螂数量
ThiefNum = pop*Pthief;%偷窃蜣螂数量

X = initialization(pop,dim,ub,lb);%种群初始化
fitness = zeros([1,pop]);
for i =1:pop
    fitness(i)=fobj(X(i,:));
end
%记录种群最优值
[GbestScore,minIndex] = min(fitness);
GbestPos = X(minIndex,:);
Xl = X; %用于记录X(t-1)
 %当前代种群
cX = X;
cFit=fitness;
for t=1:MaxIter
    disp(['第',num2str(t),'次迭代']);
    %% 蜣螂滚动 文献中式（1），（2）更新位置
    %种群最差值
    [fmax,maxIndex]=max(fitness);
    Worst=X(maxIndex,:); 
    r2=rand;
    for i=1:BallRollingNum
        if r2<0.9
            if rand>0.5
                alpha=1;
            else
                alpha=-1;
            end
            b=0.3;
            k=0.1;
            X(i,:)=X(i,:)+b.*abs(cX(i,:)-Worst)+alpha.*k*(Xl(i,:));
        else
            theta=randi(180);
            if(theta == 0 || theta == 90 || theta==180)
                X(i,:)=cX(i,:);
            else
                theta = theta*pi/180;
                X(i,:)=cX(i,:)+tan(theta).*abs(cX(i,:)-Xl(i,:));
            end
        end
        for j=1:dim
            if X(i,j)>ub(j)
                X(i,j)=ub(j);
            end
            if X(i,j)<lb(j)
                X(i,j)=lb(j);
            end
        end
        fitness(i)=fobj(X(i,:));
        if fitness(i)<GbestScore
            GbestScore=fitness(i);
            GbestPos=X(i,:);
        end
    end
    %当前迭代最最优
    [~,minIndex]=min(fitness);
    GbestB = X(minIndex,:);
    %% 蜣螂产卵 ，文献中式（3）
    R=1-t/MaxIter;
    X1=GbestB*(1-R);
    X2=GbestB*(1+R);
    Lb = max(X1,lb);
    Ub = min(X2,ub);
    for i = BallRollingNum+1:BallRollingNum+BroodBallNum
        b1=rand;
        b2=rand;
        X(i,:)=GbestB+b1*(cX(i,:)-Lb)+b2*(cX(i,:)-Ub);
        for j=1:dim
            if X(i,j)>ub(j)
                X(i,j)=ub(j);
            end
            if X(i,j)<lb(j)
                X(i,j)=lb(j);
            end
        end
        fitness(i)=fobj(X(i,:));
        if fitness(i)<GbestScore
            GbestScore=fitness(i);
            GbestPos=X(i,:);
        end
    end
    %当前迭代最最优
    [~,minIndex]=min(fitness);
    GbestB = X(minIndex,:);
    %小蜣螂更新
    %文献中（5）(6)
    R=1-t/MaxIter;
    X1=GbestPos*(1-R);
    X2=GbestPos*(1+R);
    Lb = max(X1,lb);
    Ub = min(X2,ub);
    for i=BallRollingNum+BroodBallNum+1:BallRollingNum+BroodBallNum+SmallNum
        C1=rand;
        C2=rand;
        X(i,:)=GbestPos+C1*(cX(i,:)-Lb)+C2*(cX(i,:)-Ub);
        for j=1:dim
            if X(i,j)>ub(j)
                X(i,j)=ub(j);
            end
            if X(i,j)<lb(j)
                X(i,j)=lb(j);
            end
        end
        fitness(i)=fobj(X(i,:));
        if fitness(i)<GbestScore
            GbestScore=fitness(i);
            GbestPos=X(i,:);
        end
    end
    %% 偷窃蜣螂更新
    %文献中式（7）
    for i=pop-ThiefNum:pop
        g=randn();
        S=0.5;
        X(i,:)=GbestPos+g.*S.*(abs(cX(i,:)-GbestB)+abs(cX(i,:)-GbestPos));
        for j=1:dim
            if X(i,j)>ub(j)
                X(i,j)=ub(j);
            end
            if X(i,j)<lb(j)
                X(i,j)=lb(j);
            end
        end
        fitness(i)=fobj(X(i,:));
        if fitness(i)<GbestScore
            GbestScore=fitness(i);
            GbestPos=X(i,:);
        end
    end
    %记录t代种群
    Xl=cX;
    %更新当前代种群
    for i=1:pop
        if fitness(i)<cFit(i)
            cFit(i)=fitness(i);
            cX(i,:)=X(i,:);
        end
    end
    Best_score = GbestScore;
    Best_pos = GbestPos;
    curve(t)=GbestScore;
end
end

