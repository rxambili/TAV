function [ AD_RVB ] = attache_donnees_RVB( I, moyennes, variances )

N = size(variances,3);
AD_RVB = zeros(size(I,1),size(I,2),N);

for k=1:N 
    for i=1:size(I,1)
        for j=1:size(I,2)
            x_moins_moy = zeros(3,1);
            x_moins_moy(1,1) = I(i,j,1) - moyennes(1,k);
            x_moins_moy(2,1) = I(i,j,2) - moyennes(2,k);
            x_moins_moy(3,1) = I(i,j,3) - moyennes(3,k);
            AD_RVB(i,j,k) = 0.5*log(det(variances(:,:,k))) + 0.5*(x_moins_moy'*(variances(:,:,k)\x_moins_moy));
        end
    end
end

