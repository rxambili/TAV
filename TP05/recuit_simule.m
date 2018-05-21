function [ k u ] = recuit_simule(k_cour,k_nouv,U_cour,U_nouv,T)


if U_nouv < U_cour
    k = k_nouv;
    u = U_nouv;
elseif rand < exp(-(U_nouv-U_cour)/T)
    k = k_nouv;
    u = U_nouv;
else
    k=k_cour;
    u=U_cour;
end

