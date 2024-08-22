% TEG
jugador(rojo).
jugador(azul).
jugador(verde).
jugador(amarillo).
jugador(naranja).

ubicadoEn(argentina, americaDelSur).
ubicadoEn(brasil, americaDelSur).
ubicadoEn(canada, americaDelNorte).
ubicadoEn(portugal, europa).
ubicadoEn(estadosUnidos, americaDelNorte).
%
ubicadoEn(nigeria, africa).
ubicadoEn(egipto, africa).
ubicadoEn(sudAfrica, africa).
ubicadoEn(zimbawe, africa).
ubicadoEn(chad, africa).

aliados(rojo, amarillo).

ocupa(azul, argentina).
ocupa(rojo, brasil).
ocupa(azul, estadosUnidos).
ocupa(verde, portugal).
ocupa(amarillo, canada).
%
ocupa(rojo, nigeria).
ocupa(azul, egipto).
ocupa(verde, sudAfrica).
ocupa(amarillo, zimbawe).
ocupa(naranja, chad).


limitrofes(argentina, brasil).
limitrofes(estadosUnidos, canada).

% 1 )

tienePresenciaEn(Continente, Jugador) :-
    ocupa(Jugador, Pais),
    ubicadoEn(Pais, Continente).

% 2 )

puedenAtacarse(UnJugador, OtroJugador) :-
    ocupa(UnJugador, UnPais),
    ocupa(OtroJugador, OtroPais),
    limitrofes(UnPais, OtroPais).

% 3 )

sinTensiones(UnJugador, OtroJugador) :-
    sonAliados(UnJugador, OtroJugador). % Duda 1

sinTensiones(UnJugador, OtroJugador) :-
    jugador(UnJugador),
    jugador(OtroJugador),
    not(puedenAtacarse(UnJugador, OtroJugador)).

sonAliados(UnJugador, OtroJugador) :-
    aliados(UnJugador, OtroJugador).

sonAliados(UnJugador, OtroJugador) :-
    aliados(OtroJugador, UnJugador).
    
% 4 )

perdio(Jugador) :-
    jugador(Jugador),
    not(ocupa(Jugador, _)).

% 5 )

controla(Jugador, Continente) :-
    jugador(Jugador),
    ubicadoEn(_, Continente),
    forall(ubicadoEn(Pais, Continente), ocupa(Jugador,Pais)).

% 6 )

renido(Continente):-
    ubicadoEn(_, Continente),
    forall(jugador(Jugador), ocupaPaisEnContinente(Jugador, Continente)).

ocupaPaisEnContinente(Jugador, Continente) :-
    ocupa(Jugador, Pais),
    ubicadoEn(Pais, Continente).

% 7 )
atrincherado(Jugador) :-
    ocupaPaisEnContinente(Jugador, Continente),
    forall(ocupa(Jugador, Pais), ubicadoEn(Pais, Continente)).


/*
atrincherado(Jugador) :-
    jugador(Jugador),
    ocupa(Jugador, Pais),
    ubicadoEn(Pais, Continente),
    forall( (ubicadoEn(_, OtroContinente), OtroContinente \= Continente),
            not(ocupaPaisEnContinente(Jugador, OtroContinente))
          ).

atrincherado(Jugador):-
    jugador(Jugador),
    ocupa(Jugador, Pais),
    ubicadoEn(Pais, Continente),
    not((ocupa(Jugador, OtroPais), ubicadoEn(OtroPais, OtroContinente), OtroContinente \= Continente)).
*/

% 8 )

% ################################################################################################
 receta(Nombre, Ingrediente).
 ingrediente(Ingrediente).
 calorias(Ingrediente, Calorias).

% 1)
trivial(Receta) :-
    receta(Receta, [_]).

% relaciona una receta con su ingrediente mas calorico.
% ENCUENTRA EL MAXIMO
elPeor(Ingredientes, Peor) :-
    member(Peor, Ingredentes),
    calorias(Peor, CaloriasDelPeor),
    forall(member(Ingrediente, Ingredientes),
    (calorias(Ingrediente, Calorias), CaloriasDelPeor >= Calorias)).

caloriasTotales(Receta, Total) :-
    receta(Receta, Ingredientes),
    findall(caloriasDeIngrediente, (member(Ing, Ingredientes), calorias(Ing, caloriasDeIngrediente)), caloriasDeLosIngredientes),
    sumlist(caloriasDeLosIngredientes, Total).
    
% relaciona una receta con sus ingredientes sin el peor
% FILTRA EN UNA LISTA

versionLight(Receta, IngredientesLight) :-
    receta(Receta, Ingredientes),
    elPeor(Ingredientes, PeorIngrediente),
    findall(Ing,(member(Ing, Ingredientes), Ing \= PeorIngrediente),IngredientesLight).

% se cumple para una receta con algun ingrediente de más de 1000cal
% ENCUENTRA EL QUE ES MAS GRANDE QUE

guasada(Receta) :-
    receta(Receta, Ingredientes),
    member(IngredienteGuaso, Ingredientes),
    calorias(IngredienteGuaso, Kcal),
    Kcal > 1000.