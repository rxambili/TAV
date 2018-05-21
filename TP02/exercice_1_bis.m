% Calcul de l'individu moyen :
individu_moyen = mean(X);

% Centrage des donnees :
X_c = X - ones(n,1)*individu_moyen;


% Calcul de la matrice Sigma_2 (de taille n x n) :
Sigma_2 = (1/n) .* (X_c*X_c');

% Calcul des vecteurs/valeurs propres de la matrice Sigma_2 :
[W2,D] = eig(Sigma_2);

% Tri par ordre decroissant des valeurs propres de Sigma_2 :
[~,indices_tri] = sort(diag(D),'descend');

% Tri des vecteurs propres de Sigma_2 dans le meme ordre :
W_tri = W2(:,indices_tri);

% Elimination du dernier vecteur propre de Sigma_2 :
W_elim = W_tri(:,1:n-1);

% Vecteurs propres de Sigma (deduits de ceux de Sigma_2) :
W = X_c' * W_elim;

% Normalisation des vecteurs propres de Sigma :
normes_col = sqrt(sum(W.^2,1));
W = W ./ (ones(p,1) * normes_col);

save exercice_1;
