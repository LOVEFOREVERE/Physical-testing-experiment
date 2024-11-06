%  ********************************************
%  HLOA: Horned Lizard Optimization Algorithm 
%  Developed in MATLAB R2018a(9.4)                                        %
%  Author/Programmer:  Dr. Hernan Peraza-Vazquez                                     %
%  email: hperaza@ipn.mx                                %
%  Telegram: @CodebugMx                                                                   %
%  Paper: A Novel Metaheuristic Inspired by Horned Lizard Defense Tactics %
%  Artificial Intelligence Review - Springer (2024) 
%  Doi:  	10.1007/s10462-023-10653-7
%_________________________________________________________________________%
function [vMin,theBestVct,Convergence_curve]=HLOA(SearchAgents_no,Max_iter,lb,ub,dim,fobj)

Positions=initialization(SearchAgents_no,dim,ub,lb);
 for i=1:size(Positions,1)
      Fitness(i)=fobj(Positions(i,:)); % get fitness     
 end
 [vMin minIdx]= min(Fitness);  % the min fitness value vMin and the position minIdx
theBestVct= Positions(minIdx,:);  % the best vector 
[vMax maxIdx]= max(Fitness); % the max fitness value vMax and the position maxIdx
Convergence_curve=zeros(1,Max_iter);
Convergence_curve(1)= vMin;
alphaMelanophore= alpha_melanophore(Fitness,vMin,vMax);
t=0;% Loop counter
% Main 
for t=1:Max_iter  
   for r=1:SearchAgents_no
     if( 0.5 < rand)   % se mimetiza 
             v(r,:)= mimicry(theBestVct, Positions, Max_iter, SearchAgents_no, t);
     else
            if(mod(t,2))
                v(r,:)= shootBloodstream(theBestVct, Positions(r,:), Max_iter,t); 
            else
                v(r,:)= randomWalk(theBestVct,Positions(r,:));
            end
     end   
      Positions(maxIdx,:)= Skin_darkening_or_lightening(theBestVct, Positions, SearchAgents_no);
     if (alphaMelanophore(r) <= 0.3)
         v(r,:)= remplaceSearchAgent(theBestVct, Positions,SearchAgents_no);
    end        
     %----------------------------------------------------------------------        
     % Return back the search agents that go beyond the boundaries of the search space
      v(r,:)=checkBoundaries(v(r,:), lb, ub);
     % Evaluate new solutions
     Fnew= fobj(v(r,:));
     % Update if the solution improves
     if Fnew <= Fitness(r);
        Positions(r,:)= v(r,:);
        Fitness(r)= Fnew;
     end
     if Fnew <= vMin
         theBestVct= v(r,:);
         vMin= Fnew;
     end 
   end
   %update max and alpha-melanophore
   [vMax maxIdx]= max(Fitness);
  alphaMelanophore = alpha_melanophore(Fitness,vMin,vMax);
   Convergence_curve(t)= vMin; 
 end
%***********************************[End HLOA Algorithm]
