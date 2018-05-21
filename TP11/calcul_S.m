function [S,taux_compression] = calcul_S( signal,nb_echantillons_par_mesure,proportion )

S = T_Gabor(signal,nb_echantillons_par_mesure);
[nb_lignes, nb_colonnes] = size(S);
n = ceil(nb_lignes/2);
S(n:end,:) = 0;
nb_conservees = floor(n*proportion);
S(nb_conservees+1:n,:) = 0;

taux_compression = (nb_lignes*nb_colonnes)/(nb_conservees*nb_colonnes);

end

