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
u0 = double(imread('Barbara.png'));
[nb_lignes,nb_colonnes,nb_canaux] = size(u0);
u_max = max(u0(:));


% Affichage de l'image :
subplot(1,3,1)
	imagesc(max(0,min(1,u0/u_max)),[0 1])
	colormap gray
	axis image off
	title('Image','FontSize',20)
    

% spectre de u
u_chap = fft2(u0);
u_chap = fftshift(u_chap);
    
% Operateur gradient :
nb_pixels = nb_lignes*nb_colonnes;
e = ones(nb_pixels,1);
Dx = spdiags([-e e],[0 nb_lignes],nb_pixels,nb_pixels);
Dx(nb_pixels-nb_lignes+1:nb_pixels,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels,nb_pixels);
Dy(nb_lignes:nb_lignes:nb_pixels,:) = 0;

% Second membre b du systeme :
b = u0(:);

iter_max = 1000;

epsilon = 0.5;
lambda = 1000; % Poids de la regularisation
gamma = 0.0001; % pas de descente


% Frequences en x et en y (axes = repere matriciel) :
[n_x,n_y] = meshgrid(1:nb_lignes,1:nb_colonnes);
n_x = n_x/nb_lignes-0.5;	% Frequences dans l'intervalle [-0.5,0.5]
n_y = n_y/nb_colonnes-0.5;
eta = 0.05;
passe_bas = 1./(1+(n_x.^2+n_y.^2)./eta);


% Resolution du systeme A*x = b (gradient conjugue preconditionne) :
c = u0;
k = 0;
continuer = true;
while continuer
    
    cxx = -Dx'*Dx*c(:);
    cyy = - Dy'*Dy*c(:);
    cx = Dx*c(:);
    cy = Dy*c(:);
    cxy = Dx'*Dy*c(:);
    
    dernier_terme = (cxx.*(cy.^2 + epsilon) + cyy.*(cx.^2 + epsilon) - 2.*cx.*cy.*cxy)./((cx.^2 + cy.^2 + epsilon).^(3/2)); 
    dernier_terme = reshape(dernier_terme,nb_lignes,nb_colonnes);
    % spectre de c
    c_chap = fft2(c);
    c_chap = fftshift(c_chap);
    
    s_t = abs(c_chap - u_chap);
    s_t = passe_bas.*s_t;
    
    TF = real(ifft2(ifftshift(s_t)));
    
    c = c - gamma*(TF - lambda*dernier_terme);
    
    
    
    % image texture
    t = u0 - c;
    
    k=k+1;
    continuer = k < iter_max;
    
    
    if (mod(k,20) == 0)
        drawnow nocallbacks
        % Affichage de l'image cartoon :
        subplot(1,3,2)
        imagesc(c)
        colormap gray
        axis image off
        title(['Image cartoon ', num2str((k/iter_max) *100),'%'],'FontSize',20)

        drawnow nocallbacks
        % Affichage de l'image texture :
        subplot(1,3,3)
        imagesc(t)
        colormap gray
        axis image off
        title(['Image texture ', num2str((k/iter_max) *100),'%'],'FontSize',20)
    end
    
    
end


