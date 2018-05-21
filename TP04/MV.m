function [F_1_chapeau,F_2_chapeau,a_chapeau] = MV(xy_donnees,x_F,y_F,a)
nb_tirages = length(a);
k_min = 1;
min_sum_e = inf;
for k=1:nb_tirages
   e = sqrt((xy_donnees(1,:) - x_F(1,k)).^2 + (xy_donnees(2,:) - y_F(1,k)).^2) + ...
       sqrt((xy_donnees(1,:) - x_F(2,k)).^2 + (xy_donnees(2,:) - y_F(2,k)).^2) - 2*a(k);
   sum_e = sum(e.^2);
   if sum_e < min_sum_e
       k_min = k;
       min_sum_e = sum_e;
   end
end

F_1_chapeau = [x_F(1,k_min); y_F(1,k_min)];
F_2_chapeau = [x_F(2,k_min); y_F(2,k_min)];
a_chapeau = a(k_min); 
end

