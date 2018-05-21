clear;
close all;
load exercice_1;
figure('Name',['Plan des deux premieres composantes principales'],'Position',[0,0,0.67*L,0.67*H]);

% Affichage des deux premieres composantes principales des donnees d'apprentissage :
C = X_c*W;			% Composantes principales des donnees d'apprentissage

% Matrice de variance/covariance :
Sigma_C = (1/size(C,1)) * C'*C;

% Proportion de contraste :
trace_Sigma_C = trace(Sigma_C);
C_C1 = Sigma_C(1,1)/trace_Sigma_C
C_C2 = Sigma_C(2,2)/trace_Sigma_C


hold on;
for i = 1:nb_individus
	lignes = (i-1)*nb_postures+1:i*nb_postures;
	plot(C(lignes,1),C(lignes,2),['*' 0.5*(rand(1,3)+1)],'MarkerSize',10,'LineWidth',2);
end
proportion = 0.5;
ecart_x = max(C(:,1))-min(C(:,1));
min_x = min(C(:,1))-proportion*ecart_x;
max_x = max(C(:,1))+proportion*ecart_x;
ecart_y = max(C(:,2))-min(C(:,2));
min_y = min(C(:,2))-proportion*ecart_y;
max_y = max(C(:,2))+proportion*ecart_y;
axis([min_x max_x min_y max_y]);
axis equal;
xlabel('C1','FontSize',20);
ylabel('C2','FontSize',20);
