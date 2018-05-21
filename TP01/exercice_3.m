clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Separation des canaux RVB','Position',[0,0,0.67*L,0.67*H]);
figure('Name','Combinaisons linéaires des 3 canaux RVB','Position',[0,0,0.67*L,0.67*H]);
%figure('Name','Nuage de pixels dans le repere RVB','Position',[0.67*L,0,0.33*L,0.45*H]);

% Lecture et affichage d'une image RVB :
I = imread('coloredChips.png');
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
Cor_C13 = newE(1,3)/sqrt(newE(1,1)*newE(3,3));
Cor_C23 = newE(2,3)/sqrt(newE(2,2)*newE(3,3));


% Proportions de contraste :
denom = sum(diag(newE));
C_C1 = newE(1,1)/denom;
C_C2 = newE(2,2)/denom;
C_C3 = newE(3,3)/denom;


% Redimensionnement
newI = reshape(C,size(I));

% Decoupage de l'image en trois composantes et conversion en doubles :
C1 = double(newI(:,:,1));
C2 = double(newI(:,:,2));
C3 = double(newI(:,:,3));

% Combinaisons linéaire (1) et (2)

I1 = (1/3)*(R+V+B);
I2 = 0.2989*R+0.5870*V+0.1140*B;

% Test si contraste inversé
X_I1C1 = [I1(:) C1(:)];
g_I1C1 = mean(X_I1C1);
X_I1C1_c = X_I1C1 - ones(size(X_I1C1,1),1)*g_I1C1;
Sigma_I1C1 = (1/size(X_I1C1,1)) * (X_I1C1_c)'*X_I1C1_c;
Cor_I1C1 = Sigma_I1C1(1,2)/(Sigma_I1C1(1,1)*Sigma_I1C1(2,2));

if Cor_I1C1 < 0
    C1 = -C1;
end
    

%affichage d'une image RVB :
figure(2);				% Premiere fenetre d'affichage
subplot(2,2,1);				% La fenetre comporte 2 lignes et 2 colonnes
imagesc(I);
axis off;
axis equal;
title('Image RVB','FontSize',20)

% Affichage de la première composante principale :
colormap gray;				% Pour afficher les images en niveaux de gris
subplot(2,2,2);
imagesc(C1);
axis off;
axis equal;
title('C1','FontSize',20);

% Affichage de la combinaison linéaire (1) :
subplot(2,2,3);
imagesc(I1);
axis off;
axis equal;
title('Combinaison lin�aire (1)','FontSize',10);

% Affichage de la combinaison linéaire (2) :
subplot(2,2,4);
imagesc(I2);
axis off;
axis equal;
title('Combinaison lin�aire (2)','FontSize',10);