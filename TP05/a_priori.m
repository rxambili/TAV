function [y] = a_priori(i,j,k,k_ij,beta)

[nblignes nbcolonnes] = size(k);
y=0;

if (i == 1 && j==1) % Coin haut gauche;
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i+1,j+1));    
elseif (i==nblignes && j==1) % coin bas gauche
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i-1,j+1));
elseif (i==1 && j==nbcolonnes) % coin haut droite
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i+1,j-1));
elseif (i==nblignes && j==nbcolonnes) % coin bas droite
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i-1,j-1));
elseif (i==1) 
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i+1,j-1));
    y=y+(k_ij~=k(i+1,j+1));
elseif (i==nblignes)
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i-1,j-1));
    y=y+(k_ij~=k(i-1,j+1));
elseif (j==1)
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i-1,j+1));
    y=y+(k_ij~=k(i+1,j+1));
elseif (j==nbcolonnes)
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i-1,j-1));
    y=y+(k_ij~=k(i+1,j-1));
else
    y=y+(k_ij~=k(i-1,j));
    y=y+(k_ij~=k(i+1,j));
    y=y+(k_ij~=k(i,j+1));
    y=y+(k_ij~=k(i,j-1));
    y=y+(k_ij~=k(i-1,j-1));
    y=y+(k_ij~=k(i-1,j+1));
    y=y+(k_ij~=k(i+1,j-1));
    y=y+(k_ij~=k(i+1,j+1));
end
y=beta*y;
end

