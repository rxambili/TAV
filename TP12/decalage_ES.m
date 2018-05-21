function score = decalage_ES(ES_extrait,delta_t,ES_nuages,f_min);

[nb_lignes, nb_colonnes] = size(ES_extrait);

% decalage
ES_extrait_decale = ES_extrait;
ES_extrait_decale(:,1) = ES_extrait_decale(:,1) + delta_t;


% DT = delaunay(ES_nuages);
[~, D] = dsearchn(ES_nuages,ES_extrait_decale);

score = mean(D);
% plot(ES_extrait_decale(:,1),log(ES_extrait_decale(:,2)/f_min),'o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5);

end

