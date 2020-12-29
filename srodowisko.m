% funkcja srodowiska - na podstawie stanu (x,y) i akcji (1,2,3 lub 4) wyznacza stan nastepny
% oraz nagrode
% mozliwe akcje: 1 - w prawo, 2 - do gory, 3 - w lewo, 4 - do dolu 

function [stan_nast,nagroda,tablica_nagrod] = srodowisko(stan,akcja,tablica_nagrod)

[xmax, ymax] = size(tablica_nagrod);
mozliwe_akcje = [1 2 3 4 1 2 3 4];

prawd_bok = 0.10;                           % prawdopodobienstwo skretu w bok  
prawd_tyl = 0.02;                           % prawdopodobienstwo poplyniecia do tylu
nagroda_za_odb = -0.5;                      % nagroda (praktycznie kara) za odbicie sie od sciany

los = rand;                                 % odpowiednik wiatru
akcja_wyk = (los < 1-2*prawd_bok-prawd_tyl)*akcja + ...        % akcja wykonana z uwzglednieniem wiatru
    (los >= 1-2*prawd_bok-prawd_tyl)*((los < 1-prawd_bok-prawd_tyl)*mozliwe_akcje(akcja+1) + ...
    (los >= 1-prawd_bok-prawd_tyl)*((los < 1-prawd_tyl)*mozliwe_akcje(akcja+3) + ...
    (los >= 1-prawd_tyl)*mozliwe_akcje(akcja+2)));



% przejscie do stanu nastepnego, chyba ze koniec akwenu, wowczas sprezyste
% odbicie od nabrzeza:
stan_nast = stan + (akcja_wyk == 1)*[0 1] + (akcja_wyk == 2)*[-1 0] + (akcja_wyk == 3)*[0 -1] + (akcja_wyk == 4)*[1 0];
kara_za_odb = ((stan_nast(1) < 1)+(stan_nast(1) > xmax)+(stan_nast(2) < 1)+(stan_nast(2) > ymax))*nagroda_za_odb;
stan_nast(1) = stan_nast(1) + 2*(stan_nast(1) < 1) - 2*(stan_nast(1) > xmax);  
stan_nast(2) = stan_nast(2) + 2*(stan_nast(2) < 1) - 2*(stan_nast(2) > ymax);

nagroda = tablica_nagrod(stan_nast(1),stan_nast(2)) + kara_za_odb;

if tablica_nagrod(stan_nast(1),stan_nast(2)) > 0 
   tablica_nagrod(stan_nast(1),stan_nast(2)) = 0;          % zerowanie nagrod
end