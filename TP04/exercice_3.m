clear;
close all;

exercice_2;

% Estimation des parametres par les moindres carres ordinaires :
x = transpose(xy_donnees_bruitees(1,:));
y = transpose(xy_donnees_bruitees(2,:));

x_c = x - mean(x);
y_c = y - mean(y);

% x_g = x_c/sqrt(mean(x_c.^2));
% y_g = y_c/sqrt(mean(y_c.^2));


X_chapeau = MCT(x_c,y_c);
[C_chapeau,theta_0_chapeau,a_chapeau,b_chapeau] = conversion(X_chapeau);

C_chapeau = C_chapeau + [mean(x); mean(y)];
% a_chapeau = a_chapeau*sqrt(mean(x_c.^2));
% b_chapeau = b_chapeau*sqrt(mean(y_c.^2));

% Affichage de l'ellipse estimee par MCO :
affichage_ellipse(C_chapeau,theta_0_chapeau,a_chapeau,b_chapeau,theta_points_ellipse,'y-',3);
lg = legend(' Ellipse',' Donnees bruitees',' Estimation par MV',' Estimation par MCO',' Estimation par MCT','Location','Best');
set(lg,'FontSize',20);


% Calcul du score de l'ellipse estimee par MCO :
R_chapeau = [cos(theta_0_chapeau) -sin(theta_0_chapeau) ; sin(theta_0_chapeau) cos(theta_0_chapeau)];
c_chapeau = sqrt(a_chapeau*a_chapeau-b_chapeau*b_chapeau);
F_1_chapeau = R_chapeau*[c_chapeau ; 0]+C_chapeau;
F_2_chapeau = R_chapeau*[-c_chapeau ; 0]+C_chapeau;
fprintf('Score de l''estimation par MCT = %.3f\n',score(F_1,F_2,a,F_1_chapeau,F_2_chapeau,a_chapeau));
