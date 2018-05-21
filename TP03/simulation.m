function [x_gauche,x_droite] = simulation(y,beta_0,gamma_0,delta_moyen,sigma_delta,d)


delta_tires = sigma_delta .* randn(1,2*d-1) + delta_moyen;
beta_tires = [delta_tires(1:d-1), delta_tires(end)];
gamma_tires = delta_tires(d:end);
x_gauche = bezier(y,beta_0,beta_tires);
x_droite = bezier(y,gamma_0,gamma_tires);