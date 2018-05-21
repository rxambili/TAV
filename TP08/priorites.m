function [ P] = priorites( u,D,C,delta_D,delta_D_ext,t )

[nb_lignes,nb_colonnes,nb_canaux] = size(u);

D = double(D);
u_lab = rgb2lab(u);
u_L = u_lab(:,:,1);

indices_delta_D = find(delta_D > 0);
nb_points_delta_D = length(indices_delta_D);

indices_delta_D_ext = find(delta_D_ext > 0);
nb_points_delta_D_ext = length(indices_delta_D_ext);


P = zeros(size(D));
A = zeros(nb_points_delta_D,1);

[grad_u_X,grad_u_Y] = gradient(u_L);


for i_D = 1:nb_points_delta_D
    
    [i_p, j_p] = ind2sub(size(D),indices_delta_D(i_D));
    
    % Bornes du voisinage de p :
	i_min_p = max(1,i_p-t);
	i_max_p = min(nb_lignes,i_p+t);
	j_min_p = max(1,j_p-t);
	j_max_p = min(nb_colonnes,j_p+t);
    
    % trouver i_D_ext dans delta_D_ext le plus proche de i_D
    [i_ext, j_ext] = ind2sub(size(D),indices_delta_D_ext);
    distance_ext_int = (i_ext-i_p).^2 + (j_ext -j_p).^2;
    [~, i_D_ext] = min(distance_ext_int);
    [i_p_ext, j_p_ext] = ind2sub(size(D),indices_delta_D_ext(i_D_ext));
      
    grad_u_p = [grad_u_Y(i_p_ext,j_p_ext);-grad_u_X(i_p_ext,j_p_ext)];
    D_p = delta_D(i_min_p:i_max_p,j_min_p:j_max_p);
    
    
    [t_X, t_Y] = gradient(D_p);
    t_p = [t_X(i_p-i_min_p,j_p-j_min_p); t_Y(i_p-i_min_p,j_p-j_min_p)];
    norme = sqrt(t_p(1)^2+t_p(2)^2);
    if norme ~= 0
        t_p = t_p./norme;
    end
    
    A(i_D) = abs(dot(t_p,grad_u_p));
    
    c = mean(mean(C(i_min_p:i_max_p,j_min_p:j_max_p)));
    
    P(i_p,j_p) = c*A(i_D);
        
      
end

end

