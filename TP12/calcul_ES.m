function ES = calcul_ES(S,indices_partition,valeurs_t,valeurs_f_S)

[nb_lignes, nb_colonnes] = size(S);

nb_bandes = length(indices_partition)-1;
ES = [];

for p=1:nb_bandes
    if p==nb_bandes
        bande = abs(S(indices_partition(p):indices_partition(p+1),:));
    else
        bande = abs(S(indices_partition(p):indices_partition(p+1)-1,:));
    end
    
    [max_bande, ind_max_bande] = max(bande,[],1);
    
    seuil = std(max_bande) + mean(max_bande);
    for i=1:nb_colonnes
        if (max_bande(i) >= seuil)
            ind_f_S = ind_max_bande(i) + indices_partition(p)-1;
            ES = [ES; [valeurs_t(i) valeurs_f_S(ind_f_S)]];
        end

    end
end


end

