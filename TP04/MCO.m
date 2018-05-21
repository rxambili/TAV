function X_chapeau = MCO(x,y)

A = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
A = [A; [1 0 1 0 0 0]];
b = zeros(size(x));
b = [b; 1];

X_chapeau = (A'*A)\(A'*b);


end

