% PARCIAL ONE PIECE
% https://youtu.be/UtAZNmuxdRI?si=hY47Uf9MuflHfx3o

% Relaciona Pirata con Tripulacion

tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).
%
% Ejemplo inventado para probar el punto 7:
tripulante(ema, piratasDePablo).
tripulante(pablo, piratasDePablo).
tripulante(ivan, piratasDePablo).
% Relaciona Pirata, Evento y Monto

impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

% 1)
/*Relacionar a dos tripulaciones y un evento si ambas participaron del mismo, lo cual sucede si dicho evento impactó en la recompensa
 de al menos un pirata de cada tripulación. Por ejemplo:
- Debería cumplirse para las tripulaciones heart y sombreroDePaja siendo dressrosa el evento del cual participaron ambas tripulaciones.
- No deberían haber dos tripulaciones que participen de llegadaAEastBlue, sólo los piratasDeArlong participaron de ese evento.*/

tripulacionesEnElMismoEvento(UnaTripulacion, OtraTripulacion, Evento) :-
    tripulacionParticipo(UnaTripulacion, Evento),
    tripulacionParticipo(OtraTripulacion, Evento),
    UnaTripulacion \= OtraTripulacion.

tripulacionParticipo(Tripulacion, Evento) :-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata, Evento, _).

% 2)
/*Saber quién fue el pirata que más se destacó en un evento, en base al impacto que haya tenido su recompensa.
En el caso del evento de dressrosa sería Zoro, porque su recompensa subió en $200.000.000.
*/
pirataMasDestacadoEn(PirataDestacado, Evento) :-
    impactoEnRecompensa(PirataDestacado, Evento, MontoDestacado),
    forall(impactoEnRecompensa(Pirata, Evento, Monto), (Monto =< MontoDestacado)).

/*
Solucion de la profe: ¿está bien la mía o debería irme a la de ella?
pirataMasDestacadoEn(Pirata, Evento) :-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    forall(impactoEnRecompensa(OtroPirata, Evento, OtraRecompensa), (OtraRecompensa < Recompensa, OtroPirata \= Pirata)).
*/

% 3)
/*Saber si un pirata pasó desapercibido en un evento, que se cumple si su recompensa no se vio impactada por 
dicho evento a pesar de que su tripulación participó del mismo. Por ejemplo esto sería cierto para Bepo para
el evento dressrosa, pero no para el evento sabaody por el cual su recompensa aumentó, ni para eniesLobby porque
su tripulación no participó.*/
pasoDesapercibido(PirataDesapercibido, Evento) :- %como debo escribir los nombres de los predicados? "pasoDesapercibido", "pasarDesapercibido"?
    tripulante(PirataDesapercibido, Tripulacion),
    tripulacionParticipo(Tripulacion, Evento),
    not(impactoEnRecompensa(PirataDesapercibido, Evento, _)).

% 4)
/*Saber cuál es la recompensa total de una tripulación, que es la suma de las recompensas actuales de sus miembros.*/
% DUDA: Si hago recompensaTripulacion(Tripulaciones, Recompensa). Me devuelve la tripulación con su recompensa, pero por ejemplo la de sombreroDePaja me la
% devuelve 6 veces, imagino que es porque tiene 6 tripulantes. Eso está mal?? Me la tiene que devolver sí o sí 1 vez??
recompensaTripulacion(Tripulacion, RecompensaTotal) :- % Inversible para su primer parámetro
    tripulante(_,Tripulacion),
    findall(Recompensa, (tripulante(Pirata, Tripulacion), recompensaPirataTotal(Pirata, Recompensa)), RecompensasDePiratas),
    sumlist(RecompensasDePiratas, RecompensaTotal).

recompensaPirataTotal(Pirata, Recompensa) :-
    tripulante(Pirata, _),
    findall(Monto, impactoEnRecompensa(Pirata,_, Monto), Montos),
    sumlist(Montos, Recompensa).

% 5)
/*Saber si una tripulación es temible. Lo es si todos sus integrantes son peligrosos o si la recompensa total de la tripulación supera los $500.000.000.
 Consideramos peligrosos a piratas cuya recompensa actual supere los $100.000.000.*/

tripulacionTemible(Tripulacion) :-
    recompensaTripulacion(Tripulacion, Monto),
    Monto > 500000000.

tripulacionTemible(Tripulacion) :-
    tripulante(Pirata, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), pirataPeligroso(Pirata)).

pirataPeligroso(Pirata) :-
    recompensaPirataTotal(Pirata, Recompensa),
    Recompensa > 100000000.

% :) :) :) :) :) :)
% SEGUNDA - PARTE
% :) :) :) :) :) :)
/*
Sabemos que:

    Luffy comió la fruta gomugomu de tipo paramecia, que no se considera peligrosa.
    Buggy comió la fruta barabara de tipo paramecia, que no se considera peligrosa.
    Law comió la fruta opeope de tipo paramecia, que se considera peligrosa.
    Chopper comió una fruta hitohito de tipo zoan que lo convierte en humano.
    Nami, Zoro, Ussop, Sanji, Bepo, Arlong y Hatchan no comieron frutas del diablo.
    Lucci comió una fruta nekoneko de tipo zoan que lo convierte en leopardo.
    Smoker comió la fruta mokumoku de tipo logia que le permite transformarse en humo.
*/
% Acá usé un poquito la resolución para arrancar, no iba mal encaminado.

pirataPeligroso(Pirata) :-
    comio(Pirata, Fruta),
    frutaPeligrosa(Fruta).

%comio(Pirata, tipoDeFruta(...)).
comio(luffy, paramecia(gomugomu)).
comio(buggy, paramecia(barabara)).
comio(law, paramecia(opeope)).
comio(chopper, zoan(hitohito, humano)).
comio(lucci, zoan(nekoneko, leopardo)).
comio(smoker, logia(mokumoku, humo)).
% Ejemplo inventado para probar el punto 7:
comio(ema, logia(pikapika, luz)).
comio(pablo, zoan(inuinu, perro)).
comio(ivan, logia(batabata, manteca)).

% fruta(tipoDeFruta(Nombre, CaracteristicaPropia)).
% fruta(paramecia(Nombre)).
% fruta(zoan(Nombre, Animal)).
% fruta(logia(Nombre, Elemento)).

% frutaPeligrosa(tipoDeFruta(...))
frutaPeligrosa(paramecia(opeope)).
frutaPeligrosa(logia(_, _)).
frutaPeligrosa(zoan(_, lobo)).
frutaPeligrosa(zoan(_, leopardo)).
frutaPeligrosa(zoan(_, anaconda)).

/*
Justificacion y explicación para el corrector: Originalmente comenzé a pensar el modelado de las frutas a medida que iba leyendo el enunciado, haciendo cosas como:
fruta(Nombre, tipo(CaracterísticaParticular)). ej: fruta(hitohito, zoan(humano)).
Pero me di cuenta que había un problema, porque la fruta paramecia no tenía un dato para poner dentro como en la fruta logia o zoan.
¿Qué podía hacer? poner "fruta(gomugomu, paramecia(_))." o "fruta(gomugomu, paramecia())." No me convencía y recuerdo que en la clase lo marcaron como algo malo (creo).
 Luego de darme un ayudín con el video ví que tenía sentido poner el nombre dentro, ya que es un dato que comparten todas las frutas, aprovechando la herramienta de los
 functores que no me darían problemas de tener a las frutas paramecias con 1 solo dato dentro y el resto de frutas con 2.
Creo que hubiera sido más fácil si no me hubiera apurado y lo hubiese encarado con una perspectiva Top-Down donde arraque por la otra cláusula de "pirataPeligroso". Así
como lo hacen en el video. Después pude seguirlo sin problemas
*/

% 7)

piratasDeAsfalto(Tripulacion) :-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion), noPuedeNadar(Pirata)).

noPuedeNadar(Pirata) :- % Quizás estoy sobredelegando pero es más declarativo. 
    comio(Pirata, _).