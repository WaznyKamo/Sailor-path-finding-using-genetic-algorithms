% Reprodukcja ruletkowa - wybiera obiekty w liczbach
% proporcjonalnych do ich ocen
% NowaPop = rep_rul(Popul,Oceny)
% Popul - populacja obiektow w kolumnach
% Oceny - oceny poszcz. obiektow, musza byc >= 0
% NowaPop - nowa populacja obiektow
function NowaPop = rep_rul(Popul,Oceny)

OcenyKum = cumsum(Oceny);                 % Oceny skumulowane
liczba_oso = length(Oceny);          % liczba osobnikow 
Los = rand(1,1,liczba_oso)*OcenyKum(end);   % losowanie miejsc na planszy ruletki
for i=1:liczba_oso  
   Ind = find(OcenyKum > Los(i));         
   Indeksy(i) = Ind(1);                   % wyznaczenie indeksu osobnika przech. do nast. pokolenia
end
NowaPop = Popul(:,:,Indeksy);               % nowa populacja