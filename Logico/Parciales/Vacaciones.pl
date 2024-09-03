%                                           [1]
% viajero(Nombre).
% viajaA(Viajero, Destino).
% destino(Destino).
viajero(Viajero) :- viajaA(Viajero, _).

viajaA(dodain, pehuenia).
viajaA(dodain, sanMartin).
viajaA(dodain, esquel).
viajaA(dodain, sarmiento).
viajaA(dodain, camarones).
viajaA(dodain, playasDoradas).
viajaA(alf, bariloche).
viajaA(alf, sanMartin).
viajaA(alf, elBolson).
viajaA(nico, bariloche).
viajaA(vale, calafate).
viajaA(vale, elBolson).
viajaA(martu, Destino) :- viajaA(nico, Destino).
viajaA(martu, Destino) :- viajaA(alf, Destino).

% Sobre Juan no agrego nada ya que solo agrego los que viajaron y sí van a suceder, por
% el mismo motivo no pongo nada de Carlos. 
% Podría haber usado listas pero esto me parece más simple y además si quiero agregarle
% un viaje a alguien simplemente agrego otro "viajaA(Persona, Destino)." y listo. Si
% hubiese elegido listas tendría que modificar el "original" todo el tiempo.


destino(elBolson).
destino(bariloche).
destino(sanMartin).
destino(pehuenia).
destino(esquel).
destino(sarmiento).
destino(camarones).
destino(playasDoradas).
destino(calafate).
%                                           [2]

% atraccion(Nombre, parqueNacional()).
% atraccion(Nombre, cerro(Altura)).
% atraccion(Nombre, cuerpoDeAgua(Tipo, SePuedePescar, TemperaturaPromedioAgua)).
% atraccion(Nombre, playa(DiferenciaDeMareas)).
% atraccion(Nombre, excursion()).

% tieneAtraccion(Destino, Atraccion)

atraccion(losAlerces, parqueNacional()).
atraccion(trochita, excursion()).
atraccion(travelin, excursion()).
atraccion(bateaMahuida, cerro(2000)).
atraccion(moquehue, cuerpoDeAgua(cuerpoAgua, sePuedePescar, 14)).
atraccion(alumine, cuerpoDeAgua(cuerpoAgua, sePuedePescar, 19)).

tieneAtraccion(esquel, losAlerces).
tieneAtraccion(esquel, trochita).
tieneAtraccion(esquel, travelin).
tieneAtraccion(villaPehuenia, bateaMahuida).
tieneAtraccion(villaPehuenia, moquehue).
tieneAtraccion(villaPehuenia, alumine).


%                                           [3]

vacacionesCopadas(Viajero) :-
    viajero(Viajero),
    forall(viajaA(Viajero, Destino), tieneUnaAtraccionCopada(Destino)).

tieneUnaAtraccionCopada(Destino) :- 
    tieneAtraccion(Destino, Atraccion), atraccionCopada(Atraccion).

atraccionCopada(Atraccion) :- atraccion(Atraccion, cerro(Altura)), Altura > 2000.
atraccionCopada(Atraccion) :- atraccion(Atraccion, cuerpoDeAgua(_, sePuedePescar, _)).
atraccionCopada(Atraccion) :- atraccion(Atraccion, cuerpoDeAgua(_, _, Temperatura)), Temperatura > 20.
atraccionCopada(Atraccion) :- atraccion(Atraccion, playa(Diferencia)), Diferencia < 5.
atraccionCopada(Atraccion) :- atraccion(Atraccion, excursion(Nombre)), length(Nombre, Largo), Largo > 7.
atraccionCopada(Atraccion) :- atraccion(Atraccion, parqueNacional()).


%                                           [4]
% costo(Destino, Costo).
costo(sarmiento, 100).
costo(esquel, 150).
costo(pehuenia, 180).
costo(sanMartin, 150).
costo(camarones, 135).
costo(playasDoradas, 170).
costo(bariloche, 140).
costo(calafate, 240).
costo(elBolson, 145).
costo(marDelPlata, 140).

vacacionesGasoleras(Viajero) :-
    viajero(Viajero),
    forall(viajaA(Viajero, Destino), esGasolero(Destino)).

esGasolero(Destino) :- costo(Destino, Costo), Costo < 160.


%                                           [5]
% Es del tema Explosion combinatoria, no lo hice. El tiempo apremia.