%--------------------------------------------------------------------------
% ENSEEIHT - 2IMA - Traitement des donnees Audio-Visuelles
% TP8 - Realite diminuee
% exercice_1.m : Traitement des pixels par tirage aleatoire
%--------------------------------------------------------------------------

clear
close all
clc

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Inpainting par rapiecage','Position',[0.06*L,0.1*H,0.9*L,0.75*H])

% Lecture de l'image :
u0 = double(imread('regate.jpg'));
nb_canaux = size(u0,3);
u_max = max(u0(:));

% Affichage de l'image originale :
subplot(1,2,1)
	imagesc(max(0,min(1,u0/u_max)),[0 1])
	axis image off
	title('Image originale','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end

% Selection et affichage du domaine D a modifier :
disp('Selectionnez un polygone (double-clic pour valider)')
[D,x_D,y_D] = roipoly();

for k = 1:length(x_D)-1
	
	line([x_D(k) x_D(k+1)],[y_D(k) y_D(k+1)],'Color','b','LineWidth',2);
	
end

% Affichage de l'image resultat :
u = u0;

for c = 1:nb_canaux
	
	u(:,:,c) = (~D).*u(:,:,c);
	
end

subplot(1,2,2)
	imagesc(max(0,min(1,u/u_max)),[0 1])
	axis image off
	title('Image resultat','FontSize',20)
	if nb_canaux == 1
		colormap gray
	end
drawnow nocallbacks

% Initialisation de la frontiere de D :
[delta_D, delta_D_ext] = frontieres(D);
indices_delta_D = find(delta_D > 0);
nb_points_delta_D = length(indices_delta_D);

% Parametres :
t = 9;				% Voisinage d'un pixel de taille (2t+1) x (2t+1)
T = 50;				% Fenetre de recherche de taille (2T+1) x (2T+1)
k = 0;

C = ones(size(D));
C(D) = 0;
% C(delta_D) = 0;


% Tant que la frontiere de D n'est pas vide :
while nb_points_delta_D > 0
    k = k+1;
	% Pixel p de la frontiere de D :
    
    P = priorites( u,D,C,delta_D,delta_D_ext,t );
    [P_tri , I_tri] = sort(P(:),'descend');
    
    existe_q = 0;
    k_q = 1;
    
    while existe_q == 0 && k_q <= nb_points_delta_D
        p = I_tri(k_q);
        [i_p, j_p] = ind2sub(size(D),p);

        % Recherche du pixel q_chapeau :

        [existe_q,bornes_V_p,bornes_V_q_chapeau] = d_min(i_p,j_p,u,D,t,T);
        k_q = k_q+1;
    end
    
	% S'il existe au moins un pixel q eligible :
	if existe_q == 1

		% Rapiecage et mise a jour de D :
		[u,D,C] = rapiecage_2(bornes_V_p,bornes_V_q_chapeau,u,D,C);

		% Mise a jour de la frontiere de D :
		[delta_D, delta_D_ext] = frontieres(D);
        indices_delta_D = find(delta_D > 0);
        nb_points_delta_D = length(indices_delta_D);

		% Affichage de l'image resultat :
		subplot(1,2,2)
		imagesc(max(0,min(1,u/u_max)),[0 1])
		axis image off
		title('Image resultat','FontSize',20)
		if nb_canaux == 1
			colormap gray
		end
		drawnow nocallbacks
    else
       disp("pas de q"); 
    end
end
