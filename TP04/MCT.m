function X_chapeau = MCT(x,y)

A = [x.^2, x.*y, y.^2, x, y, ones(size(x))];

[U,S,V] = svd(A);
[~,I_sort] = sort(diag(S),'descend');
V = V(:,I_sort);

X_chapeau = V(:,end);

end

