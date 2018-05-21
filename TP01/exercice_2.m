clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Separation des composantes princiaples','Position',[0,0,0.67*L,0.67*H]);
%figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

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
% figure(2);				% Deuxieme fenetre d'affichage
% plot3(R,V,B,'b.');
% axis equal;
% xlabel('R');
% ylabel('V');
% zlabel('B');
% rotate3d;

% Matrice des donnees :
X = [R(:) V(:) B(:)];			% Les trois canaux sont vectorises et concatenes

% Matrice de variance/covariance :
g = mean(X);
Xc = X - ones(size(X,1),1) * g;
E = (1/size(X,1)) * Xc'*Xc;


% Coefficients de correlation lineaire :
Cor_RV = E(1,2)/sqrt(E(1,1)*E(2,2));
Cor_RB = E(1,3)/sqrt(E(1,1)*E(3,3));
Cor_VB = E(2,3)/sqrt(E(2,2)*E(3,3));


% Proportions de contraste :
denom = sum(diag(E));
C_R = E(1,1)/denom;
C_V = E(2,2)/denom;
C_B = E(3,3)/denom;


%%ACP

[W, D] = eig(E);
[~, indices] = sort(diag(D),'descend');
vect_principaux = W(:,indices);

% Composantes principales
C = Xc * vect_principaux;

% Matrice de variance/covariance :
newE = (1/size(C,1)) * C'*C;

% Coefficients de correlation lineaire :
Cor_C12 = newE(1,2)/sqrt(newE(1,1)*newE(2,2));
disp(['Coefficient de corrélation linéaire entre C1 et C2 : ',num2str(Cor_C12)]);
Cor_C13 = newE(1,3)/sqrt(newE(1,1)*newE(3,3));
disp(['Coefficient de corrélation linéaire entre C1 et C3 : ',num2str(Cor_C13)]);
Cor_C23 = newE(2,3)/sqrt(newE(2,2)*newE(3,3));
disp(['Coefficient de corrélation linéaire entre C2 et C3 : ',num2str(Cor_C23)]);



% Proportions de contraste :
denom = sum(diag(newE));
C_C1 = newE(1,1)/denom;
disp(['Proportion de constraste de la 1ère composante : ',num2str(C_C1)]);
C_C2 = newE(2,2)/denom;
disp(['Proportion de constraste de la 2ème composante : ',num2str(C_C2)]);
C_C3 = newE(3,3)/denom;
disp(['Proportion de constraste de la 3ème composante : ',num2str(C_C3)]);



% Redimensionnement
newI = reshape(C,size(I));


%affichage d'une image RVB :
figure(2);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20);

% Decoupage de l'image en trois composantes et conversion en doubles :
C1 = double(newI(:,:,1));
C2 = double(newI(:,:,2));
C3 = double(newI(:,:,3));

% Affichage de la composante C1 :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(-C1);
axis off;
axis equal;
title('C1','FontSize',20);

% Affichage de la composante C2 :
subplot(2,2,3);
imagesc(-C2);
axis off;
axis equal;
title('C2','FontSize',20);

% Affichage de la composante C3 :
subplot(2,2,4);
imagesc(-C3);
axis off;
axis equal;
title('C3','FontSize',20);







