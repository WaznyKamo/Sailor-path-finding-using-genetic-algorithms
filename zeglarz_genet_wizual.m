% Zeglarz plynie lodka od startu do mety uczac sie omijac przeszkody oraz
% zdobywac nagrody .
close

liczba_epizodow = 10                    % liczba epizodow wizualizaacji

load strategia_max_ewol;

for epizod=1:liczba_epizodow
    stan = [ceil(rand*length(tablica_nagrod(:,1))) 1]; % losowe pole z pierwszej kolumny

    koniec = 0;
    nr_pos = 0;
    tablica_nag = tablica_nagrod;
    suma_nagr(epizod) = 0;
    tab_akcji = [];
    tab_stanow = [];
    while (koniec == 0)
        nr_pos = nr_pos + 1;                            % numer posuniecia


        % Wybor akcji:
        akcja = strategia_max_ewol(stan(1),stan(2));

        [stan_n, nagroda,tablica_nag] = srodowisko(stan, akcja, tablica_nag);

        tab_akcji = [tab_akcji akcja];
        tab_stanow = [tab_stanow stan'];
        nagroda_dyskontowa = nagroda;
        if (gamma < 1)
            nagroda_dyskontowa = nagroda*gamma^(nr_pos-1);
        end
        suma_nagr(epizod) = suma_nagr(epizod) + nagroda_dyskontowa;

        stan = stan_n;      % przejscie do nastepnego stanu


        % wizualizacja przeplywu:
        rysuj_akwen(tablica_nag,strategia_max_ewol, stan);
        title(sprintf('epizod = %d, posuniecie = %d, suma nagrod = %f',epizod,nr_pos,suma_nagr(epizod)));
        pause(0.15)


        % Koniec epizodu jesli uzyskano maksymalna liczbe krokow lub
        % dojechano do mety
        if (nr_pos == max_liczba_krokow || stan(2) == length(tablica_nagrod(1,:)))
            koniec = 1;
        end
    end % while
    sprintf('srednia suma nagrod = %f',mean(suma_nagr))
end


