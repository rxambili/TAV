%--------------------------------------------------------------------------
% ENSEEIHT - 2IMA - Traitement des donnees Audio-Visuelles
% TP8 - Realite diminuee
% fonction rapiecage_1.m :
%--------------------------------------------------------------------------

function [u_nouv,D_nouv,C_nouv] = rapiecage_2(bornes_V_p,bornes_V_q_chapeau,u,D,C)

	nb_canaux = size(u,3);

	% Bornes du voisinage de p :
	i_min_p = bornes_V_p(1);
	i_max_p = bornes_V_p(2);
	j_min_p = bornes_V_p(3);
	j_max_p = bornes_V_p(4);

	% Bornes du voisinage de q :
	i_min_q = bornes_V_q_chapeau(1);
	i_max_q = bornes_V_q_chapeau(2);
	j_min_q = bornes_V_q_chapeau(3);
	j_max_q = bornes_V_q_chapeau(4);

	% Initialisations :
	u_nouv = u;
	D_nouv = D;
    C_nouv = C;
    
	% Mise a jour de u :
	D_p = D(i_min_p:i_max_p,j_min_p:j_max_p);
	piece = repmat(D_p,[1,1,nb_canaux]).*u(i_min_q:i_max_q,j_min_q:j_max_q,:);
	u_nouv(i_min_p:i_max_p,j_min_p:j_max_p,:) = u(i_min_p:i_max_p,j_min_p:j_max_p,:) + piece;

	% Mise a jour de D :
	D_nouv(i_min_p:i_max_p,j_min_p:j_max_p) = 0;
    
    
    % Mise à jour de C :
    
    C_p = C_nouv(i_min_p:i_max_p,j_min_p:j_max_p);
        
%     indices_zeros = ind2sub(size(C_p),find(C_p == 0));
    C_p(C_p == 0) = mean(mean(C_p)); 
        
    C_nouv(i_min_p:i_max_p,j_min_p:j_max_p) = C_p;
    	
end
