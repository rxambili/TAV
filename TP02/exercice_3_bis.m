clear;
close all;
load exercice_1;
figure('Name','Image tiree aleatoirement','Position',[0.2*L,0.2*H,0.6*L,0.5*H]);
s = 6.6e+03;			% Seuil de reconnaissance a regler convenablement

% Tirage aleatoire d'une image de test :
individu = randi(15);
posture = 1;
fichier = [chemin '/i' num2str(individu,'%02d') num2str(posture,'%1d') '.mat'];
load(fichier);
img = eval(['i' num2str(individu,'%02d') num2str(posture,'%1d')]);
image_test = double(img(:))';

% Affichage de l'image de test :
colormap gray;
imagesc(img);
axis image;
axis off;

%% Calcul du nombre N de composantes principales a prendre en compte :
C=X_c*W; % composantes principales des données d'apprentissage

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


%% N premieres composantes principales des images d'apprentissage :
C_N = C(:,1:N);     % N premieres composantes principales

% % N premieres composantes principales de l'image de test :
X_c_test = image_test - individu_moyen;
C_test = X_c_test*W;
C_test_N = C_test(1,1:N);

% % Determination de l'image d'apprentissage la plus proche :
d = zeros(n,1);
for i=1:n
    d(i) = sqrt(sum((C_test_N - C_N(i,:)).^2));
end
[dmin,imin] = min(d);


% % Affichage du resultat :
if dmin<s
    indice_individu_reconnu = ceil(imin/nb_postures);
	individu_reconnu = numeros_individus(indice_individu_reconnu); 
	title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu)];...
		['Je reconnais l''individu numero ' num2str(individu_reconnu)]},'FontSize',12);
else
    if ismember(individu, numeros_individus) 
        title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu)];...
            'Je ne reconnais pas cet individu ! Malheuresement...'},'FontSize',12);
    else
        title({['Posture numero ' num2str(posture) ' de l''individu numero ' num2str(individu)];...
            'Je ne reconnais pas cet individu ! Je complète les données !'},'FontSize',12);
        % on ajoute l'individu dans les données
        numeros_individus = [ numeros_individus, individu];
        nb_individus = length(numeros_individus);
        n = nb_individus*nb_postures;
    
        % On met à jour la matrice X
        for k = 1:nb_postures
            fichier = [chemin '/i' num2str(individu,'%02d') num2str(numeros_postures(k),'%1d') '.mat'];
            load(fichier);
            img = eval(['i' num2str(individu,'%02d') num2str(numeros_postures(k),'%1d')]);
            if (size(img,1) ~= nb_lignes) || (size(img,2) ~= nb_colonnes)
                disp('Probleme : les images ne sont pas toutes de meme taille !');
                exit;
            end
            X = [X ; double(img(:))'];
        end
    
        % On recalcule les eigenfaces
        exercice_1_bis;
    end
end
