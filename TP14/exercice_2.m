clear;
close all;

load exercice_1;


X_moy = [mean(X_pensees,1) ; mean(X_oeillets,1); mean(X_chrysanthemes,1)];
X = [X_pensees ; X_oeillets; X_chrysanthemes];


[IDX, C] = kmeans(X,3,'Start',X_moy,'EmptyAction','error');

pourcentage_classification = (sum(IDX == bonne_classification)/length(bonne_classification))*100


