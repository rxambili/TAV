clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('gantrycrane.png');
figure(1);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois canaux et conversion en doubles :
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));

% Affichage du canal R :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(R);
axis off;
axis equal;
title('Canal R','FontSize',20);

% Affichage du canal V :
subplot(2,2,3);
imagesc(V);
axis off;
axis equal;
title('Canal V','FontSize',20);

% Affichage du canal B :
subplot(2,2,4);
imagesc(B);
axis off;
axis equal;
title('Canal B','FontSize',20);

% % Affichage du nuage de pixels dans le repere RVB :
figure(2);				% Deuxieme fenetre d'affichage
plot3(R,V,B,'b.');
axis equal;
xlabel('R');
ylabel('V');
zlabel('B');
rotate3d;

% Matrice des donnees :
X = [R(:) V(:) B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
g = mean(X);
Xc = X - ones(size(X,1),1) * g;
E = (1/size(X,1)) * (Xc'*Xc);


% Coefficients de correlation lineaire :
Cor_RV = E(1,2)/sqrt(E(1,1)*E(2,2));
disp(['Coefficient de corrélation linéaire entre les canaux R et V : ',num2str(Cor_RV)]); 
Cor_RB = E(1,3)/sqrt(E(1,1)*E(3,3));
disp(['Coefficient de corrélation linéaire entre les canaux R et B : ',num2str(Cor_RB)]);
Cor_VB = E(2,3)/sqrt(E(2,2)*E(3,3));
disp(['Coefficient de corrélation linéaire entre les canaux V et B : ',num2str(Cor_VB)]);



% Proportions de contraste :
denom = sum(diag(E));
C_R = E(1,1)/denom;
disp(['Proportion de constraste dans le canal R : ',num2str(C_R)]);
C_V = E(2,2)/denom;
disp(['Proportion de constraste dans le canal V : ',num2str(C_V)]);
C_B = E(3,3)/denom;
disp(['Proportion de constraste dans le canal B : ',num2str(C_B)]);

%mauvaise idÃ©e car il y a perte d'info

