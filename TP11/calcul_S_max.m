function [indices_S_max,S_max,taux_compression] = calcul_S_max(signal,nb_echantillons_par_mesure,n);

TG = T_Gabor(signal,nb_echantillons_par_mesure);
[nb_lignes, nb_colonnes] = size(TG);
n_neg = ceil(nb_lignes/2);
TG(n_neg:end,:) = 0;


[TG_tri , I_tri] = sort(abs(TG),1,'descend');

indices_S_max = I_tri(1:n,:);
S_max = zeros(n,nb_colonnes);
for i=1:nb_colonnes    
    S_max(:,i) = TG(indices_S_max(:,i),i);
end

taux_compression = (nb_lignes*nb_colonnes)/(n*nb_colonnes);


end

