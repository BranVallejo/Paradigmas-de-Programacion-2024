esPersonaje(aang). 
esPersonaje(katara). 
esPersonaje(zoka). 
esPersonaje(appa). 
esPersonaje(momo). 
esPersonaje(toph). 
esPersonaje(tayLee). 
esPersonaje(zuko). 
esPersonaje(azula). 
esPersonaje(iroh). 
 
esElementoBasico(fuego). 
esElementoBasico(agua). 
esElementoBasico(tierra). 
esElementoBasico(aire).

% elementoAvanzadoDe/2 relaciona un elemento básico con otro avanzado asociado

elementoAvanzadoDe(fuego, rayo). 
elementoAvanzadoDe(agua, sangre). 
elementoAvanzadoDe(tierra, metal).

% controla/2 relaciona un personaje con un elemento que controla  
controla(zuko, rayo). 
controla(toph, metal). 
controla(katara, sangre). 
controla(aang, aire). 
controla(aang, agua). 
controla(aang, tierra). 
controla(aang, fuego). 
controla(azula, rayo). 
controla(iroh, rayo).

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])). 
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])). 
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])). 
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, 
enfermeria, salaDeGuerra, templo, zonaDeRecreo])). 
visito(aang, nacionDelFuego(palacioReal, 1000)). 
visito(katara, tribuAgua(norte)). 
visito(katara, tribuAgua(sur)). 
visito(aang, temploAire(norte)). 
visito(aang, temploAire(oeste)). 
visito(aang, temploAire(este)). 
visito(aang, temploAire(sur)).

lugar(temploAire(sur)).
lugar(temploAire(este)).
lugar(temploAire(norte)).
lugar(temploAire(oeste)).
lugar(tribuAgua(sur)).
lugar(tribuAgua(norte)).
lugar(nacionDelFuego(palacioReal, 1000)).
lugar(reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])).
lugar(reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios, enfermeria, salaDeGuerra, templo, zonaDeRecreo])).

% 1)
esElAvatar(Personaje) :-
    esPersonaje(Personaje),
    forall(esElementoBasico(UnElemento), controla(Personaje, UnElemento)).
    
% 2)
noEsMaestro(Personaje) :-
    esPersonaje(Personaje),
    not(controla(Personaje, _)).

esMaestroPrincipiante(Personaje) :-
    esPersonaje(Personaje),
    not(controlaAlgunElementoAvanzado(Personaje)).

esMaestroAvanzado(Personaje) :-
    esPersonaje(Personaje),
    controlaAlgunElementoAvanzado(Personaje).

esMaestroAvanzado(Personaje) :-
    esPersonaje(Personaje),
    esElAvatar(Personaje).
% Esto capaz estaba de más o estoy sobredelegando, porque lo uso 2 veces y son 3 lineas.
% Pero queda prolijo y es más lejible.
controlaAlgunElementoAvanzado(Personaje) :-
    esPersonaje(Personaje),
    controla(Personaje, UnElemento),
    elementoAvanzadoDe(_, UnElemento).



% 3)
% ¿Puede pasar que el contenido de la lista sea igual pero en diferente orden? No sucede en este parcial
% por lo que creo que sería innecesario.
sigueA(Perseguidor, Perseguido) :-
    esPersonaje(Perseguidor), esPersonaje(Perseguido),
    Perseguidor \= Perseguido,
    forall(visito(Perseguido, UnLugar), visito(Perseguidor, UnLugar)).

% esta bien que cuando pregunto: sigueA(Perseguidor, Perseguido). Me dice aang persigue a appa.
% porque en teoria appa no visito ningun lugar.
sigueA(zuko, aang).

% 4)
%esDignoDeConocer(Lugar).
esDignoDeConocer(Lugar) :-
    lugar(Lugar),
    lugarDigno(Lugar).

lugarDigno(temploAire(_)).
lugarDigno(tribuAgua(norte)).
lugarDigno(reinoTierra(_, Lugares)) :-
    not(member(muro, Lugares)).

% 5) Este va a dar false porque ningún lugar cumple. Por lo menos de los que están ahora.
esPopular(Lugar) :-
    lugar(Lugar),
    findall(Visitante, visito(Visitante, Lugar), Visitantes),
    length(Visitantes, CantidadDeVisitantes),
    CantidadDeVisitantes > 4.
    
% 6) Creo que el 6 es eso, no sé como sería inversible eso pero bueno.
esPersonaje(bumi).
controla(bumi, tierra).
visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo, sectorMedio])). 

esPersonaje(suki).
lugar(nacionDelFuego(prisionDeMaximaSeguridad, 200)).

