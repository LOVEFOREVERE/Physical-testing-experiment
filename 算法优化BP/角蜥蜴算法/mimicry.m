%  Programmer: Hernan Peraza    hperaza@ipn.mx
%****************************************************
function o = mimicry(Xbest, X, Max_iter, SearchAgents_no,t)
  colorPalette = [0 0.00015992 0.001571596 0.001945436 0.002349794 0.00353364 0.0038906191 0.003906191 0.199218762 0.19999693 0.247058824 0.39999392 0.401556397 0.401559436 0.498039216 0.498046845 0.499992341 0.49999997 0.601556397 0.8 0.900000447 0.996093809 0.996109009 0.996872008 0.998039245 0.998046875 0.998431444 0.999984801 0.999992371 1];
  Delta= 2;
  [r1, r2, r3, r4]= R(SearchAgents_no);
  [c1, c2]= getColor(colorPalette);  
  o= Xbest +  (Delta-Delta*t/Max_iter) * (c1*((sin(X(r1,:))-cos(X(r2,:))) - ((-1)^getBinary) * c2*cos(X(r3,:))-sin(X(r4,:))));
end
%***********************************************************************