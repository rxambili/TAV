function [delta_moyen,sigma_delta] = estimation_2(delta)

delta_moyen = mean(delta);
delta_c = delta - delta_moyen;
sigma_delta = sqrt(mean(delta_c.^2));