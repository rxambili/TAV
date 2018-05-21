function [ im_moy ] = moyenne(im)

R = double(im(:,:,1));
V = double(im(:,:,2));
B = double(im(:,:,3));

terme_normalisation = max(1,R+V+B);
R_norm = R./terme_normalisation;
V_norm = V./terme_normalisation;

im_moy = [mean(mean(R_norm)) mean(mean(V_norm))];



end

