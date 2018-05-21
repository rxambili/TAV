function [ TG ] = T_Gabor( signal,nb_echantillons_par_mesure)

TG = [];
for i = 1 :nb_echantillons_par_mesure:size(signal,1)-nb_echantillons_par_mesure
    TG = [ TG fft(signal(i:i+nb_echantillons_par_mesure))];
end
        


end

