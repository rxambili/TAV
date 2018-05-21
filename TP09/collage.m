function u = collage(r,s,interieur)

r = double(r);
s = double(s);



% Dimensions de r :
[nb_lignes_r,nb_colonnes_r,nb_canaux] = size(r);

nb_pixels_r = nb_lignes_r*nb_colonnes_r;
e = ones(nb_pixels_r,1);
Dx = spdiags([-e e],[0 nb_lignes_r],nb_pixels_r,nb_pixels_r);
Dx(nb_pixels_r-nb_lignes_r+1:nb_pixels_r,:) = 0;
Dy = spdiags([-e e],[0 1],nb_pixels_r,nb_pixels_r);
Dy(nb_lignes_r:nb_lignes_r:nb_pixels_r,:) = 0;

A = -Dx'*Dx - Dy'*Dy;


bord_r = ones(nb_lignes_r,nb_colonnes_r);
bord_r(2:nb_lignes_r-1,2:nb_colonnes_r-1) = zeros(nb_lignes_r-2,nb_colonnes_r-2);
bord_r = find(bord_r == 1);

nb_bord_r = length(bord_r);

A(bord_r,:) = sparse(1:nb_bord_r,bord_r,ones(nb_bord_r,1),nb_bord_r,nb_pixels_r);




% Calcul de l'imagette resultat im, canal par canal :
u = r;

for k = 1:nb_canaux
	u_k = u(:,:,k);  
    r_k = r(:,:,k);
	s_k = s(:,:,k);
    
	g_k_x = Dx*r_k(:);
    g_k_y = Dy*r_k(:);
    
    grad_s_x = Dx*s_k(:);
    grad_s_y = Dy*s_k(:);
    
    g_k_x(interieur) = grad_s_x(interieur);
    g_k_y(interieur) = grad_s_y(interieur);
    
    
    b_k = -Dx'*g_k_x - Dy'*g_k_y;
    
	b_k(bord_r) = u_k(bord_r);
    u_k = A\b_k;    
	u(:,:,k) = reshape(u_k,nb_lignes_r,nb_colonnes_r);
end
