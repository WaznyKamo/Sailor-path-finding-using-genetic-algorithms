% Zeglarz plynie lodka od startu do mety uczac sie omijac przeszkody oraz
% zdobywac nagrody.
% Z kazdego pola akwenu mozna dostac sie do jednego z
% czterech pol sasiednich (lewo prawo,gora,dol) wykonujac analogiczna do
% tego celu akcje, z tym ze z powodu przypadkowych podmuchow wiatru przejscie
% do wybranego stanu nastepuje z prawdopodobienstwem < 1. Z niezerowym
% prawdopodobienstwem mozna zas poplynac w bok lub do tylu.
% Celem uczenia jest znalezienie strategi optymalnej.

clear

% DEFINICJA PROBLEMU:
gamma = 1                               % wspolczynnik dyskontowania definiuje uzytecznosc nagrod w zaleznosci
                                        % od tego kiedy sa zdobywane (jesli < 1 nagrody i kary tym mniej 
                                        % wartosciowe im bardziej odlegle w czasie)                                     
% tablica_nagrod = load('tablica_mala.txt');
% tablica_nagrod = load('tablica_prosta.txt');
% tablica_nagrod = load('tablica_latwa.txt');
tablica_nagrod = load('tablica_srednia.txt');
% tablica_nagrod = load('tablica_pola_ujemne.txt');
% tablica_nagrod = load('tablica_duza.txt');
%tablica_nagrod = load('tablica_spira.txt');




% TUTAJ NALEZY ZDEFINIOWAC/USTAWIC WARTOSCI PARAMETROW UCZENIA:
%
liczba_epizodow = 4                      % liczba epizodow/epoke (im wiecej, tym wieksza wiarygodnosc oceny)
% kazdy epizod rozpoczyna sie od
% wylosowania pola starowego w
% pierwszej kolumnie
liczba_osobnikow = 20                     % liczba rozwiazan w populacji 
wsp_selekcji = 1.4;                       % wspolczynnik nacisku selekcyjnego
p_mut = 0.2                              % prawdopodobienstwo mutacji pojedynczego genu
p_krz = 0.1                              % prawdopodobienstwo mutacji osobnika
% czy_elitarnie = ...                      % najlepszy osobnik przechodzi do nastepnej populacji bez zmian
% inny_parametr = ...


liczba_epok = 1000                        % liczba epok uczenia
[lwierszy, lkolumn] = size(tablica_nagrod)
popul = ceil(rand(lwierszy, lkolumn,liczba_osobnikow)*4);            % losowa populacja poczatkowa (kazdy osobnik to strategia)
max_liczba_krokow = ceil(2.5*sum(size(tablica_nagrod)))              % maksymalna liczba krokow w epizodzie
ocena_maks_ewol = -1e10;                                             % maksymalna ocena w calej ewolucji
strategia_max_ewol = [];                                             % najlepsza strategia w calej ewolucji

for epoka = 1:liczba_epok
    oceny = [];

    % Wyznaczanie ocen dla poszczegolnych osobnikow:
    for oso = 1:liczba_osobnikow
        strategia = popul(:,:,oso);
        suma_nagr = [];
        for epizod=1:liczba_epizodow
            stan = [ceil(rand*lwierszy) 1];                             % stan poczatkowy epizodu np. [1 1]

            koniec = 0;
            nr_pos = 0;
            tablica_nag = tablica_nagrod;
            suma_nagr(epizod) = 0;
            while (koniec == 0)
                nr_pos = nr_pos + 1;                            % numer posuniecia

                % Wybor akcji (1 - w prawo, 2 - do gory, 3 - w lewo, 4 - do dolu):
                akcja = strategia(stan(1),stan(2));

                [stan_n, nagroda,tablica_nag] = srodowisko(stan, akcja, tablica_nag);

                stan = stan_n;      % przejscie do nastepnego stanu

                % Koniec epizodu jesli uzyskano maksymalna liczbe krokow lub
                % dojechano do mety
                if (nr_pos == max_liczba_krokow || stan(2) == length(tablica_nagrod(1,:)))
                    koniec = 1;
                end
                nagroda_dyskontowa = nagroda;
                if (gamma < 1)
                    nagroda_dyskontowa = nagroda*gamma^(nr_pos-1);
                end
                suma_nagr(epizod) = suma_nagr(epizod) + nagroda_dyskontowa;
            end % while po krokach epizodu
        end % po epizodach
        %sprintf('srednia suma nagrod = %f',mean(suma_nagr))
        %rysuj_akwen(tablica_nagrod,Q);
        oceny(oso) = mean(suma_nagr);
    end % po osobnikach - rozwiazaniach

    % Sprawdzenie czy nie ma rekordu - najlepszej dotychczasowej oceny
    [ocena_maks,oso_max] = max(oceny);
    strategia_max = popul(:,:,oso_max);
    
    if ocena_maks_ewol < ocena_maks
        ocena_maks_ewol = ocena_maks;
        strategia_max_ewol = strategia_max;
        save strategia_max_ewol strategia_max_ewol;
        disp(sprintf('rekord w epoce %d: %f, srednia suma nagrod = %f',epoka,ocena_maks,mean(oceny)));
        
        %rysuj_akwen(tablica_nagrod,strategia_max_ewol, [1 1]);
        %pause(0.1);
    end

    

   
   % TUTAJ NALEZY UMIESCIC KOD REALIZUJACY REPRODUKCJE, KRZYZOWANIE I
   % MUTACJE ROZWIAZAN:
   % 
   % Reprodukcja - ruletkowa (to tylko przyklad, moze byc inna!):
   ocena_min = min(oceny);
   fitness = (oceny - ocena_min + 0.003).^wsp_selekcji;  % ocena musi byc dodatnia i tym wieksza im lepsze rozwiazanie
   popul = rep_rul(popul,fitness);    

   % ..................

            
%    Krzyzowanie:
   for osobnik_krzyzowany=1:liczba_osobnikow-1
       if (rand < p_krz)
%            dziecko = round((popul(:,:,osobnik_krzyzowany) + popul(:,:,osobnik_krzyzowany+1))/2);
%            popul(:,:,osobnik_krzyzowany) = dziecko;
% 
            wymieniana_kolumna=randi(lkolumn);
            wymieniany_osobnik = randi(liczba_osobnikow);
            wymieniana_wartosc = popul(:,wymieniana_kolumna,osobnik_krzyzowany);
            popul(:,wymieniana_kolumna,osobnik_krzyzowany)=popul(:,wymieniana_kolumna,wymieniany_osobnik);
            popul(:,wymieniana_kolumna,wymieniany_osobnik ) = popul(:,wymieniana_kolumna,osobnik_krzyzowany);
           
% krzyzowanie PMX zamieniając pierwszy wiersz:
%            k_start = 1+floor(rand*lkolumn);            % losuje granice podciagu do zamiany pomiedzy dwoma rozwiazaniami
%            k_koniec = k_start+floor(rand*(lkolumn-k_start));
% 
%            
%            r1 = popul(1,k_start:k_koniec,osobnik_krzyzowany);
%            r2 = popul(1,k_start:k_koniec,osobnik_krzyzowany+1);
%            
%            indy1 = zeros(1,lkolumn);
%            indy1(r1) = r2;
%            indy2 = zeros(1,lkolumn);
%            indy2(r2) = r1;
%            
%            P1 = popul(1,:,osobnik_krzyzowany);
%            P2 = popul(1,:,osobnik_krzyzowany+1);
%            i=1;           
%            while i <= lkolumn
%                if (i==k_start)
%                    i=k_koniec+1;
%                end
%                
%                if (i<=lkolumn)&&(indy2(P1(i)) > 0)        
%                     P1(i) = indy2(P1(i));
%                     i = i+1;
%                else
%                    i = i+1;
%                end
%            end
%            
%            i=1;           
%            while i <= lkolumn
%                if (i==k_start)
%                    i=k_koniec+1;
%                end
%                
%                if (i<=lkolumn)&&(indy2(P2(i)) > 0)        
%                     P2(i) = indy2(P2(i));
%                     i = i+1;
%                else
%                    i = i+1;
%                end
%            end
%            P1(k_start:k_koniec) = r2;
%            P2(k_start:k_koniec) = r1;
%            popul(1,:,osobnik_krzyzowany) = P1';
%            popul(1,:,osobnik_krzyzowany+1) = P2';
%             
       end
   end


   
   % Mutacja:
   for osobnik_mutowany=1:liczba_osobnikow
       if (rand < p_mut)
           wiersz = randi(lwierszy);
           kolumna = randi(lkolumn);
           nowy_ruch = randi(4);
           popul(wiersz, kolumna, osobnik_mutowany) = nowy_ruch;
       end
   end
   
   
   
   disp(sprintf('Minela %d epoka, ocena_srednia = %f, ocena_maks = %f',epoka,mean(oceny),max(oceny)));
   
   if mod(epoka,20) == 0
       save popul popul;
   end
end % po epokach uczenia
