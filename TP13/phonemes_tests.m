clear;
close all;
load phonemes;
% Tirage aleatoire d'un test :
phoneme = randi(9);
enregistrement = 5 + randi(5);
nom_fichier = strcat('/mnt/n7fs/ens/tp_queau/Tests/',liste_phonemes{phoneme},'_',num2str(enregistrement),'.wav');
[signal,f_echantillonnage] = audioread(nom_fichier);

[coefficients_spectre,coefficients_cepstre] = spec_ceps(signal, f_echantillonnage, nb_coefficients);

spectre = mean(coefficients_spectre);
cepstre = mean(coefficients_cepstre);



% ACP

% Composantes principales



cepstre_c = cepstre - g;
C_test = cepstre_c * W;



% Calcul du nombre N de composantes principales a prendre en compte :

% Matrice de variance/covariance :
Sigma = (1/size(C,1)) * C'*C;

% Proportion de contraste :
trace_Sigma = trace(Sigma);
N=0;
p_contraste = 0;

while p_contraste < 0.95 && N < size(C,2)
    N = N+1;
    p_contraste = p_contraste + Sigma(N,N)/trace_Sigma;
end

C_N = C(:,1:N);
C_test_N = C_test(1,1:N);
C_N_means = cepstre_means*W(:,1:N);

% % Determination de l'enregistrement d'apprentissage le plus proche :
n =size(C_N,1);
d = zeros(n,1);
for i=1:n
    d(i) = sqrt(sum((C_test_N - C_N(i,:)).^2));
end

% n =size(C_N_means,1);
% d = zeros(n,1);
% for i=1:size(C_N_means,1)
%     d(i) = sqrt(sum((C_test_N - C_N_means(i,:)).^2));
% end

[dmin,imin] = min(d);

s = 0.43;			% Seuil de reconnaissance a regler convenablement

if dmin<s
    indice_phoneme_reconnu = ceil(imin/nb_enregistrements);
%     indice_phoneme_reconnu = imin;
	phoneme_reconnu = liste_phonemes{indice_phoneme_reconnu}; 
	disp(['Enregistrement ' num2str(enregistrement) ' du phoneme ' liste_phonemes{phoneme} ...
		' -> Je reconnais le phoneme  ' phoneme_reconnu]);
else
	disp(['Enregistrement ' num2str(enregistrement) ' du phoneme ' liste_phonemes{phoneme} ...
		' -> Je ne reconnais pas cet individu !']);
end

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
plot3(C_test_N(1,1),C_test_N(1,2),C_test_N(1,3),'+ r');
