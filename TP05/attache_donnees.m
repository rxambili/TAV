function [ AD ] = attache_donnees( I, moyennes, variances )

N = length(moyennes);
AD = zeros(size(I,1),size(I,2),N);

for k=1:N
    AD(:,:,k) = 0.5*log(variances(1,k)) + 0.5.*((I - moyennes(1,k)).^2/variances(1,k));
end

