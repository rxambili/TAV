%% TP13 Reconnaissance de phonèmes.

clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

liste_phonemes={'a','e','e_aigu','e_grave','i','o','o_ouvert','ou','u'};
nb_enregistrements = 5;
nb_coefficients = 882;
nb_phonemes = length(liste_phonemes);

% Calcul des coefficients spectraux et cepstraux pour chaque
% enregistrements d'apprentissage
spectre = [];
cepstre = [];
spectre_means = [];
cepstre_means = [];
bonne_classification = [];

for i=1:nb_phonemes
    spectre_a_moyenner = [];
    cepstre_a_moyenner = [];
    for j=1:nb_enregistrements
        nom_fichier = strcat('Apprentissage/',liste_phonemes{i},'_',num2str(j),'.wav');
        [signal,f_echantillonnage] = audioread(nom_fichier);
        [coefficients_spectre,coefficients_cepstre] = spec_ceps(signal, f_echantillonnage, nb_coefficients);
        
        
        spectre = [spectre; mean(coefficients_spectre)];
        spectre_a_moyenner = [spectre_a_moyenner; mean(coefficients_spectre)];
        cepstre = [cepstre; mean(coefficients_cepstre)];  
        cepstre_a_moyenner = [cepstre_a_moyenner; mean(coefficients_cepstre)];
        
        bonne_classification = [bonne_classification; i];
    end
    spectre_means = [spectre_means; mean(spectre_a_moyenner,1)];
    cepstre_means = [cepstre_means; mean(cepstre_a_moyenner,1)];
end

% Classification non supervisée par l’algorithme des k-moyennes


[IDX_spectre, C_spectre] = kmeans(spectre,nb_phonemes,'Start',spectre_means,'EmptyAction','error');
[IDX_cepstre, C_cepstre] = kmeans(cepstre,nb_phonemes,'Start',cepstre_means,'EmptyAction','error');

% Calcul du taux de bonnes classifications

pourcentage_spectres = (sum(IDX_spectre == bonne_classification)/length(bonne_classification))*100
pourcentage_cepstres = (sum(IDX_cepstre == bonne_classification)/length(bonne_classification))*100

% ACP
[n,p] = size(cepstre);
% Centrage des donnees :
g = mean(cepstre);
cepstre_c = cepstre - ones(n,1)*g;


% Calcul de la matrice Sigma_2 (de taille n x n) :
Sigma_2 = (1/n) .* (cepstre_c*cepstre_c');

% Calcul des vecteurs/valeurs propres de la matrice Sigma_2 :
[W2,D] = eig(Sigma_2);

% Tri par ordre decroissant des valeurs propres de Sigma_2 :
[~,indices_tri] = sort(diag(D),'descend');

% Tri des vecteurs propres de Sigma_2 dans le meme ordre :
W_tri = W2(:,indices_tri);

% Elimination du dernier vecteur propre de Sigma_2 :
W_elim = W_tri(:,1:n-1);

% Vecteurs propres de Sigma (deduits de ceux de Sigma_2) :
W = cepstre_c' * W_elim;

% Normalisation des vecteurs propres de Sigma :
normes_col = sqrt(sum(W.^2,1));
W = W ./ (ones(p,1) * normes_col);

C = cepstre_c * W;

C_2D = C(:,1:2);
liste_color={'. b','. g','. r','. c','. m','. y','* b','* g','* r'};
C_3D = C(:,1:3);

% 
% figure(1)
% hold on
% for i=1:size(C_2D,1)
%     if IDX_cepstre(i) == bonne_classification(i)
%         color = liste_color{IDX_cepstre(i)};
%     else
%         color = '. k';
%     end
%     plot(C_2D(i,1),C_2D(i,2),color);
% end

figure(2)
hold on
for i=1:size(C_3D,1)
    if IDX_cepstre(i) == bonne_classification(i)
        color = liste_color{IDX_cepstre(i)};
    else
        color = '. k';
    end
    plot3(C_3D(i,1),C_3D(i,2),C_3D(i,3),color);
end

save phonemes

