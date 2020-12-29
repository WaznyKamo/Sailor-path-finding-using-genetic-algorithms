% Krzyzowanie dwoch ciagow permutacyjnych R1 i R2 metoda PMX
% zamieniajac podciagi ograniczone indeksami k1 i k2
% i modyfikujac reszte, tak by uzyskac prawidlowe 
% permutacje potomne P1 i P2
function [P1,P2] = krzyzowaniePMX(R1,R2,k1,k2)
d = length(R1);
r1 = R1(k1:k2);
r2 = R2(k1:k2);

indy1 = zeros(1,d);
indy1(r1) = r2;                % numery miast na ktore nastepuje zamiana w pierwszym ciagu
indy2 = zeros(1,d);
indy2(r2) = r1;

P1 = R1;
P2 = R2;

i=1;
while i <= d
    if (i==k1)
        i=k2+1;
    end
    
    if (i<=d)&&(indy2(P1(i)) > 0)        
        P1(i) = indy2(P1(i));
    else
        i = i+1;
    end
end

i=1;
while i <= d
    if (i==k1)
        i=k2+1;
    end
    
    if (i<=d)&&(indy1(P2(i)) > 0)
        P2(i) = indy1(P2(i));
    else
        i = i+1;
    end
end

P1(k1:k2) = r2;
P2(k1:k2) = r1;