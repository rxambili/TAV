function [mu,Sigma] = estimation_mu_Sigma(X)

mu = mean(X,1);
Xc = X - ones(size(X,1),1)*mu;

Sigma = (1/size(X,1)) * Xc'*Xc;


end

