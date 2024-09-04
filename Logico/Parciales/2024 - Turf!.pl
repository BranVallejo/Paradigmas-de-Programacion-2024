%                                               [1]
% jockey(Nombre, Altura, Peso).
% caballo(Nombre).
% representaA(Jockey, Caballeriza).

jockey(valdivieso, 155, 52).
jockey(leguisamo , 161, 49).
jockey(lezcano   , 149, 50).
jockey(baratucci , 153, 55).
jockey(falero    , 157, 52).

caballo(botafogo).
caballo(oldMan  ).
caballo(energica).
caballo(matBoy  ).
caballo(yatasto ).

prefiereA(Caballo, Jockey) :- leGusta(Caballo, Jockey).

leGusta(botafogo, Jockey) :- jockey(Jockey, _, Peso), Peso < 52.
leGusta(botafogo, baratucci).
leGusta(oldMan, Jockey) :- jockey(Jockey, _, _), atom_length(Jockey, Letras), Letras > 7.
leGusta(energica, Jockey) :- not(leGusta(botafogo, Jockey)).
leGusta(botafogo, Jockey) :- jockey(Jockey, Altura, _), Altura > 170.

representaA(valdivieso,      elTute).
representaA(falero    ,      elTute).
representaA(lezcano   , lasHormigas).
representaA(baratucci ,  elCharabon).
representaA(leguisamo ,  elCharabon).

caballeriza(Caballeriza) :- representaA(_, Caballeriza).
% gano(Caballo, Premio).
ganoPremio(botafogo,     granPremioNacional).
ganoPremio(botafogo,    granPremioRepublica).
ganoPremio(oldMan  ,    granPremioRepublica).
ganoPremio(oldMan  , campeonatoPalermoDeOro).
ganoPremio(matBoy  ,    granPremioCriadores).

%                                               [2]
masDeUnJockey(Caballo):- 
    prefiereA(Caballo, UnJockey), prefiereA(Caballo, OtroJockey), 
    UnJockey \= OtroJockey.

%                                               [3]
rechazaAlaCaballeriza(Caballo, Caballeriza) :-
    caballo(Caballo), caballeriza(Caballeriza),
    forall(representaA(Jockey, Caballeriza), not(prefiereA(Caballo, Jockey))).

%                                               [4]
piolin(Jockey) :-
    jockey(Jockey, _, _),
    forall(ganoPremioImportante(Caballo), prefiereA(Caballo, Jockey)).

ganoPremioImportante(Caballo) :- ganoPremio(Caballo, Premio), premioImportante(Premio).

premioImportante(granPremioNacional).
premioImportante(granPremioRepublica).

%                                               [5]
% Ej Resultado: [botafogo, oldMan, yatasto, energica]
apuestaGanadora(Apuesta, Resultado) :-
    apuesta(Apuesta, Detalle),
    ganaLaApuesta(Apuesta, Detalle, Resultado).

ganaLaApuesta(aGanador, detalle(UnCaballo), Resultado) :- salePrimero(UnCaballo, Resultado).
ganaLaApuesta(aSegundo, detalle(UnCaballo), Resultado) :- saleSegundo(UnCaballo, Resultado).
ganaLaApuesta(exacta, detalle(UnCaballo, OtroCaballo), Resultado) :- salePrimero(UnCaballo, Resultado), saleSegundo(OtroCaballo, Resultado).
ganaLaApuesta(imperfecta, detalle(UnCaballo, OtroCaballo), Resultado) :- salePrimeroOSegundo(UnCaballo, Resultado), salePrimeroOSegundo(OtroCaballo, Resultado).

% apuesta(aGanador, detalle(Caballo)).
% apuesta(aSegundo, detalle(Caballo)).
% apuesta(exacta, detalle(UnCaballo, OtroCaballo)).
% apuesta(imperfecta, detalle(UnCaballo, OtroCaballo)).

apuesta(aGanador  ,         detalle(botafogo)).
apuesta(aSegundo  ,           detalle(oldMan)).
apuesta(exacta    , detalle(botafogo, oldMan)).
apuesta(imperfecta, detalle(oldMan, botafogo)).

salePrimero(Caballo, Resultado) :- nth1(1, Resultado, Caballo).
saleSegundo(Caballo, Resultado) :- nth1(2, Resultado, Caballo).
salePrimeroOSegundo(Caballo, Resultado) :- salePrimero(Caballo, Resultado).
salePrimeroOSegundo(Caballo, Resultado) :- saleSegundo(Caballo, Resultado).


%                                               [6]
% Hice eso, pero para resolverlo cćmo te lo piden necesito Explosión combinatoria. Ahí queda.


esDeColor(botafogo,  negro).
esDeColor(oldMan  , marron).
esDeColor(energica,   gris).
esDeColor(energica,  negro).
esDeColor(matBoy  , marron).
esDeColor(matBoy  , blanco).
esDeColor(yatasto , marron).
esDeColor(yatasto , blanco).

color(Color) :- esDeColor(_, Color).
