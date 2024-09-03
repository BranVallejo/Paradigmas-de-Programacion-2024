%                                               [1]
kioskero(dodain).
kioskero(lucas ).
kioskero(juanC ).
kioskero(juanF ).
kioskero(leoC  ).
kioskero(martu ).

% atiende(Kioskero, Dia, horaInicio, horaFin).
atiende(dodain,     lunes,   9, 15).
atiende(dodain, miercoles,   9, 15).
atiende(dodain,   viernes,   9, 15).
atiende(lucas ,    martes,  10, 20).
atiende(juanC ,    sabado,  18, 22).
atiende(juanC ,   domingo,  18, 22).
atiende(juanF ,    jueves,  10, 20).
atiende(juanF ,   viernes,  12, 20).
atiende(leoC  ,     lunes,  14, 18).
atiende(leoC  , miercoles,  14, 18).
atiende(martu , miercoles,  23, 24).
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(dodain, Dia,   HoraInicio, HoraFin).
atiende(vale, Dia, HoraInicio, HoraFin) :- atiende(juanC, Dia,   HoraInicio, HoraFin).

dia(Dia) :- atiende(_, Dia, _, _).

%                                               [2]
quienAtiende(Kioskero, Dia, Hora) :-
    atiende(Kioskero, Dia, HoraInicio, HoraFin),
    between(HoraInicio, HoraFin, Hora).

%                                           [3] foreverAlone
atiendeSolo(Kioskero, Dia, Hora) :-
    quienAtiende(Kioskero, Dia, Hora),
    not(atiendeConAlguien(Kioskero, Dia, Hora)).

atiendeConAlguien(Kioskero, Dia, Hora) :-
    quienAtiende(Kioskero, Dia, Hora),
    quienAtiende(OtroKioskero, Dia, Hora),
    Kioskero \= OtroKioskero.

%                                           [4] Explosión combinatoria, skip.

%                                           [5]
% venta(Quien, DiaDelMes, [Ventas])).
% golosinas(precio), cigarrillos([Marcas]), bebidas(3, alcoholica)

venta(dodain, 10, [golosinas(1200), cigarrillos([jockey]), golosinas(50)]).
venta(dodain, 12, [bebidas(8, alcoholica), bebidas(1, noAlcoholica), golosinas(10)]).
venta(martu, 12, [golosinas(1000), cigarrillos([chesterfield, colorado, parisiennes])]).
venta(lucas, 11, [golosinas(600)]).
venta(lucas, 18, [bebidas(2, noAlcoholica), cigarrillos([derby])]).

esSuertuda(Kioskero) :-
    venta(Kioskero, _, _),
    forall(venta(Kioskero, _, Ventas), primeraImportante(Ventas)).

primeraImportante(Ventas) :- nth1(1, Ventas, PrimeraVenta), ventaImportante(PrimeraVenta).

ventaImportante(golosinas(Precio)) :- Precio > 100.
ventaImportante(cigarrillos(Marcas)) :- length(Marcas, Cantidad), Cantidad > 2.
ventaImportante(bebidas(CantidadDeBebidas, _)) :- CantidadDeBebidas > 5.
ventaImportante(bebidas(_, alcoholica)).
