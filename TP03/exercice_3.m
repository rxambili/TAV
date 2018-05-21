clear;
close all;
load exercice_2;
load texture;
figure('Name','Simulation d''une flamme de bougie','Position',[0.33*L,0,0.67*L,H]);

I_max = 255;

% Simulation de flammes :
[nb_lignes_texture,nb_colonnes_texture] = size(texture);
largeur = 1000;				% Largeur de l'image
echelle_en_largeur = 0.5*largeur/(limites(4)-limites(3));
hauteur = 1000;				% Hauteur de l'image
h = round(0.85*hauteur);		% Hauteur de la flamme
y = 0:1/(h-1):1;			% Ordonnees normalisees entre 0 et 1
x_centre = (beta_0+gamma_0)/2;		% Abscisse du centre de la flamme
N = 40;					% Longueur de la sequence simulee
for k = 1:N
	I = zeros(hauteur,largeur);
	[x_gauche,x_droite] = simulation(y,beta_0,gamma_0,delta_moyen,sigma_delta,d);
    if length(find(x_droite < x_gauche)) == 0
        for i =1:h
            x_d = round(x_droite(i)*echelle_en_largeur);
            x_g = round(x_gauche(i)*echelle_en_largeur);
            l = x_d-x_g;
            x = 0:1/(l-1):1;
            ind_x = round(x*(nb_colonnes_texture-1))+ones(size(x));        
            I(i,x_g+1:x_d) = texture(round(y(h-i+1)*(nb_lignes_texture-1))+1,ind_x);
        end
        I = I/max(I(:));
        imagesc(I);
        axis xy;
        axis off;
        colormap(hot);		% Table de couleurs donnant des couleurs chaudes (doc colormap)
        pause(0.1);
    end
end
