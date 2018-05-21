clear;
close all;
load exercice_1;
h = figure('Position',[0,0,0.67*L,0.67*H]);
figure('Name','RMSE en fonction du nombre de composantes principales','Position',[0.67*L,0,0.33*L,0.3*L]);

% Calcul de la RMSE entre images originales et images reconstruites :
RMSE_max = 0;
C = X_c*W;		% Composantes principales des donnees d'apprentissage
for q = 0:n-1
	C_q = C(:,1:q);		% q premieres composantes principales
    W_q = W(:,1:q);		% q premieres eigenfaces
	X_reconstruit = individu_moyen + C_q*W_q';
	figure(1);
	set(h,'Name',['Utilisation des ' num2str(q) ' premieres composantes principales']);
	colormap gray;
	hold off;
	for k = 1:n
		subplot(nb_individus,nb_postures,k);
		img = reshape(X_reconstruit(k,:),nb_lignes,nb_colonnes);
		imagesc(img);
		hold on;
		axis image;
		axis off;
	end

	figure(2);
	hold on;
	RMSE = sqrt(mean((X(:) - X_reconstruit(:)).^2));
	RMSE_max = max(RMSE,RMSE_max);
	plot(q,RMSE,'r+','MarkerSize',8,'LineWidth',2);
	axis([0 n-1 0 1.1*RMSE_max]);
	hx = xlabel('$q$','FontSize',20);
	set(hx,'Interpreter','Latex');
	hy = ylabel('RMSE','FontSize',20);

	pause(0.01);
end
