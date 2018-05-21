%--------------------------------------------------------------------------
% ENSEEIHT - 2IMA - Traitement des donnees Audio-Visuelles
% TP7 - Restauration d'images
% exercice_1.m : Debruitage avec modele de Tikhonov (niveaux de gris)
%--------------------------------------------------------------------------

clear
close all
clc

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Debruitage avec le modele de Tikhonov','Position',[0.06*L,0.1*H,0.9*L,0.7*H])

% Lecture de l'image :
u0 = double(imread('randonneur.jpg'));
[nb_lignes,nb_colonnes,nb_canaux] = size(u0);
u_max = max(u0(:));

% Lecture du masque : 
D = double(imread('randonneur_masque.jpg'));

% Ajout d'un bruit gaussien :
sigma_bruit = 0;
u0 = u0 + sigma_bruit*u_max*randn(nb_lignes,nb_colonnes);

% Affichage de l'image bruitee :
subplot(1,2,1)
	imagesc(max(0,min(1,u0/u_max)),[0 1])
	colormap gray
	axis image off
	title('Image bruitee','FontSize',20)

% Operateur gradient :
nb_pixels = nb_lignes*nb_colonnes;
e = ones(nb_pixels,1);
Dx = spdiags([-e e],[0 nb_lignes],nb_pixels,nb_pixels);
Dx(nb_pixels-nb_lignes+1:nb_pixels,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels,nb_pixels);
Dy(nb_lignes:nb_lignes:nb_pixels,:) = 0;

% Second membre b du systeme :

W_sans_D = ones(size(D)) - D./255;
W_sans_D = spdiags(W_sans_D(:),0,nb_pixels,nb_pixels);
 


bR = u0(:,:,1);
bR = W_sans_D*bR(:);
bV = u0(:,:,2);
bV = W_sans_D*bV(:);
bB = u0(:,:,3);
bB = W_sans_D*bB(:);

% Matrice R de preconditionnement :
Lap = -Dx'*Dx - Dy'*Dy;
epsilon = 0.01;
lambda = 1; % Poids de la regularisation
A = speye(nb_pixels) - lambda*Lap;
R = ichol(A,struct('droptol',1e-3));

% Resolution du systeme A*x = b (gradient conjugue preconditionne) :
u = u0;
k = 0;
continuer = true;
while continuer
    R_k = u(:,:,1);
    V_k = u(:,:,2);
    B_k = u(:,:,3);
    u_pre = u;
    
    W = 1./(sqrt((Dx*R_k(:)).^2+(Dy*R_k(:)).^2)+epsilon);
    W = spdiags(W,0,nb_pixels,nb_pixels);
    div = -Dx'*W*Dx - Dy'*W*Dy;
    A = W_sans_D - lambda*div; 
    [x,flagR] = pcg(A,bR,1e-5,50,R',R,R_k(:));    
    R_k = reshape(x,nb_lignes,nb_colonnes);
    
    W = 1./(sqrt((Dx*V_k(:)).^2+(Dy*V_k(:)).^2)+epsilon);
    W = spdiags(W,0,nb_pixels,nb_pixels);
    div = -Dx'*W*Dx - Dy'*W*Dy;
    A =  W_sans_D - lambda*div; 
    [x,flagV] = pcg(A,bV,1e-5,50,R',R,V_k(:));    
    V_k = reshape(x,nb_lignes,nb_colonnes);
    
    W = 1./(sqrt((Dx*B_k(:)).^2+(Dy*B_k(:)).^2)+epsilon);
    W = spdiags(W,0,nb_pixels,nb_pixels);
    div = -Dx'*W*Dx - Dy'*W*Dy;
    A =  W_sans_D - lambda*div;
    [x,flagB] = pcg(A,bB,1e-5,50,R',R,B_k(:));    
    B_k = reshape(x,nb_lignes,nb_colonnes);
    
    u(:,:,1) = R_k;
    u(:,:,2) = V_k;
    u(:,:,3) = B_k;    
    
    continuer = norm(u(:) - u_pre(:)) > norm(u_pre(:))/1000;
    
    drawnow nocallbacks ;
    % Affichage de l'image restauree :
    subplot(1,2,2)
	imagesc(max(0,min(1,u/u_max)),[0 1])
	colormap gray
	axis image off
	title('Image restauree','FontSize',20)
    
    k=k+1;
    
end



