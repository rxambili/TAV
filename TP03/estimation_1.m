function delta_estime = estimation_1(d,y,x_gauche,beta_0,x_droite,gamma_0)

p = length(y);
for j = 1:p
	for i = 1:d
		A(j,i) = nchoosek(d,i)*y(j)^i*(1-y(j))^(d-i);
	end
end
F = [A(:,1:d-1) zeros(size(A(:,1:d-1))) ; zeros(size(A(:,1:d-1))) A(:,1:d-1)];
e = [A(:,d) ; A(:,d)];
F = [F, e];
D = x_gauche-beta_0*(1-y).^d;
E = x_droite-gamma_0*(1-y).^d;
G = [D ; E];

delta_estime = F\G;
