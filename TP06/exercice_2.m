clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Parametres divers :
% N = 50;					% Nombre de disques d'une configuration
R = 10;					% Rayon des disques
R_carre = R*R;
nb_points_disque = 30;
increment_angulaire = 2*pi/nb_points_disque;
theta = 0:increment_angulaire:2*pi;
q_max = 120;
rose = [253 108 158]/255;
nb_valeurs_a_afficher = q_max;
pas_entre_deux_affichages = floor(q_max/nb_valeurs_a_afficher);
temps_affichage = 0.001;


beta = 1.0;
S = 130;
gamma = 5.0;
T_0 = 0.1;
lambda_0 = 100.0;
alpha = 0.99;

% Lecture et affichage de l'image :
I = imread('colonie.png');
I = rgb2gray(I);
I = double(I);
I = I(100:500,100:500);
[nb_lignes,nb_colonnes] = size(I);
figure('Name',['Detection des flamants roses'],'Position',[0,0,L,0.65*H]);

% Configuration initiale
abscisses_disques = [];
ordonnees_disques = [];
nvg_moyens_disques = [];
AD = [];
valeurs_q = 0;
U = 0;

% Courbe d'evolution de l'énergie :
subplot(1,2,2);
plot(valeurs_q,U,'.','Color',rose);
axis([0 q_max -400 0]);
set(gca,'FontSize',20);
hx = xlabel('Nombre d''iterations','FontSize',30);
hy = ylabel('Energie','FontSize',30);

% Initialisations
T = T_0;
lambda = lambda_0;

% Recherche de la configuration optimale :
for q = 1:q_max
    abscisses_disques_pre = abscisses_disques;
    ordonnees_disques_pre = ordonnees_disques;
    
	% Naissances
    N_tilde = poissrnd(lambda);
    
    % Tirage aleatoire de N_tilde nouveaux disques:
	abscisses_nouveau = nb_colonnes*rand(1,N_tilde);
	ordonnees_nouveau = nb_lignes*rand(1,N_tilde);
    nvg_moyens_nouveau = zeros(1,N_tilde);
    for k=1:N_tilde
        nvg_moyens_nouveau(k) = nvg_moyen(abscisses_nouveau(k),ordonnees_nouveau(k),R,I);
    end
    abscisses_disques = [abscisses_disques abscisses_nouveau];
    ordonnees_disques = [ordonnees_disques ordonnees_nouveau];
    nvg_moyens_disques = [nvg_moyens_disques nvg_moyens_nouveau];
    
    
    % Calcul de l'attache aux données pour chaque disques
    AD_nouveau = zeros(1,N_tilde);
    for k=1:N_tilde
        AD_nouveau(k) = 1-(2/(1+exp(-gamma*((nvg_moyens_nouveau(k)/S)-1))));
    end
    AD = [AD AD_nouveau];   
    
    % Tri des disques
    [AD_triee, I_tri] = sort(AD,'descend');
    U_q = 0;
    I_mort=[];
    
    % Morts
    for k = 1:length(AD_triee)
        i = I_tri(k);
        abscisses_tmp = abscisses_disques;
        ordonnees_tmp = ordonnees_disques;
        abscisses_tmp(I_mort) = [];
        ordonnees_tmp(I_mort) = [];
        nb_recouvrements = sum(sqrt((abscisses_disques(i)-abscisses_tmp).^2 + (ordonnees_disques(i)-ordonnees_tmp).^2) <= sqrt(2)*R) - 1;
        
        p = lambda/(lambda + exp(-(AD(i) + beta*nb_recouvrements)/T));
        if rand < p
            I_mort = [I_mort i];            
        else
            U_q = U_q + beta*nb_recouvrements;
        end
    end
    
    abscisses_disques(I_mort) = [];
    ordonnees_disques(I_mort) = [];
    nvg_moyens_disques(I_mort) = [];
    AD(I_mort) = [];
    
    U_q = U_q + sum(AD);
    
    % Test de convergence
    if length(abscisses_disques)==length(abscisses_disques_pre) && length(ordonnees_disques)==length(ordonnees_disques_pre)
        if any(ismember(abscisses_disques,abscisses_disques_pre)) || any(ismember(ordonnees_disques,ordonnees_disques_pre))
            T = alpha*T;
            lambda = alpha*lambda;
        end
    else
        T = alpha*T;
        lambda = alpha*lambda;
    end
    
    hold off;
	subplot(1,2,1);
	imagesc(I);
	axis image;
	axis off;
	colormap gray;
	hold on;
	for k = 1:length(abscisses_disques)
		abscisses_affichage = abscisses_disques(k)+R*cos(theta);
		ordonnees_affichage = ordonnees_disques(k)+R*sin(theta);
		indices = find(abscisses_affichage>0 & abscisses_affichage<nb_colonnes & ...
				ordonnees_affichage>0 & ordonnees_affichage<nb_lignes);
        plot(abscisses_affichage(indices),ordonnees_affichage(indices),'Color',rose,'LineWidth',3);
	end
	pause(temps_affichage);

	% Courbe d'evolution de l'énergie :
	if rem(q,pas_entre_deux_affichages)==0
		valeurs_q = [valeurs_q q];
        U = [U U_q];
        
		subplot(1,2,2);
		plot(valeurs_q,U,'.-','Color',rose,'LineWidth',3);
		axis([0 q_max -400 0]);
		set(gca,'FontSize',20);
		hx = xlabel('Nombre d''iterations','FontSize',30);
		hy = ylabel('Energie','FontSize',30);
	end
end

