%                                      -[1]-

%comida().
%precio(comida, precio).
% MODELADO DE COMIDA
comida(hamburguesa).
comida(panchitoConPapas).
comida(lomitoCompleto).
comida(caramelo).

precio(hamburguesa, 2000).
precio(panchitoConPapas,1500).
precio(lomitoCompleto, 2500).


% MODELADO DE ATRACCIONES
% atraccion(Nombre, tipo(caracPropias)). ej: atraccion(tobogan, tranquila(chicos)).

% Tipo: tranquila(Nombre, todos/chicos). *Chicos = Solo para niños
atraccion(autitosChocadores, tranquila(todos)).
atraccion(laCasaEmbrujada, tranquila(todos)).
atraccion(laberinto, tranquila(todos)).
atraccion(tobogan, tranquila(chicos)).
atraccion(calesita, tranquila(chicos)).

%  Tipo: intensa(CoeficienteDeLanzamiento)
atraccion(barcoPirata, intensa(14)).
atraccion(tazasChinas, intensa(6)).
atraccion(simulador3D, intensa(2)).

% Tipo: montaniaRusa(girosInvertidos, duracion(mins)).
atraccion(abismoMortalRecargada, montaniaRusa(3, 134)).
atraccion(paseoPorElBosque, montaniaRusa(0, 45)).

% Tipo: acuatica()

% MODELADO DE VISITANTES
% visitante(Visitante,Edad, Dinero).
% sentimientoVisitante(Visitante, Hambre, Aburrimiento).
% perteneceA(Visitante, NombreGrupo). % este es un dato opcional, y como no me conviene ponerlo dentro del functor le hago otra clausura y listo
% grupo(NombreGrupo).


grupo(viejitos).
visitante(eusebio, 80, 3000).
visitante(carmela, 80, 0).
sentimientoVisitante(eusebio, 50, 0).
sentimientoVisitante(carmela, 0, 25).
perteneceA(eusebio, viejitos).
perteneceA(carmela, viejitos).

visitante(ema, 21, 3000).
sentimientoVisitante(ema, 0, 0).
visitante(sabrina, 21, 2600).
sentimientoVisitante(ema, 42, 6).

% por comodidad y simpleza
visitante(Visitante) :- visitante(Visitante, _, _).

%                                      -[2]-
felicidadPlena(Visitante) :-
    visitante(Visitante), perteneceA(Visitante, _),
    sentimientoTotal(Visitante, 0).

podriaEstarMejor(Visitante) :-
    visitante(Visitante), sentimientoTotal(Visitante, hambrimiento), % hambrimiento = hambre + aburrimiento
    between(1, 50, hambrimiento).

podriaEstarMejor(Visitante) :-
    visitante(Visitante), 
    vinoSolo(Visitante),
    sentimientoTotal(Visitante, 0).

vinoSolo(Visitante) :- visitante(Visitante), not(perteneceA(Visitante, _)).

necesitaEntretenerse(Visitante) :-
    visitante(Visitante), sentimientoTotal(Visitante, hambrimiento), 
    between(51, 99, hambrimiento).

seQuiereIrACasa(Visitante) :-
    visitante(Visitante), sentimientoTotal(Visitante, hambrimiento), 
    hambrimiento >= 100.

sentimientoTotal(Visitante, Hambrimiento) :-
    visitante(Visitante), sentimientoVisitante(Visitante, Hambre, Aburrimiento),
    Hambrimiento is Hambre + Aburrimiento.

    
%                                      -[3]-

puedeSatisfacerSuHambre(Grupo, Comida) :-
    grupo(Grupo),
    comida(Comida),
    forall(perteneceA(Visitante, Grupo), leAlcanzaYSeSatisface(Visitante, Comida)).

leAlcanzaYSeSatisface(Visitante, Comida) :-
    visitante(Visitante), comida(Comida),
    puedeComprar(Visitante, Comida),
    loSatisface(Visitante, Comida).

puedeComprar(Visitante, Comida) :-
    visitante(Visitante, _, Dinero), comida(Comida),
    precio(Comida, PrecioComida),
    Dinero >= PrecioComida.
    
loSatisface(Visitante, hamburguesa) :-
    visitante(Visitante), sentimientoVisitante(Visitante, Hambre, _),
    Hambre < 50.

loSatisface(Visitante, panchitoConPapas) :- esChico(Visitante).

loSatisface(Visitante, lomitoCompleto).

esChico(Visitante) :- visitante(Visitante, Edad, _), Edad < 13.

leAlcanzaYSeSatisface(Visitante, caramelo) :- % Caso excepcional de los caramelos. Punto donde más dudas tengo.
    visitante(Visitante), 
    not(puedeComprar(Visitante, _)). % De esta forma te aseguras que no le alcanza para nada sin importar si en el futuro se agregan más comidas con otros precios


%                                      -[4]-
lluviaDeHamburguesas(Visitante, Atraccion) :-
    visitante(Visitante), atraccion(Atraccion, _),
    puedeComprar(visitante, hamburguesa),
    atraccionLluviosa(Atraccion, Visitante).

atraccionLluviosa(Atraccion, _) :-
    atraccion(Atraccion, intensa(Intensidad)), Intensidad > 10.

atraccionLluviosa(tobogan, _).

atraccionLluviosa(Atraccion, Visitante) :- % Le paso el visitante porque lo necesito acá. Quizás no es lo mejor, se aceptan sugerencias.
    visitante(Visitante), atraccion(Atraccion, _), % ¿Está mal que repita esto siempre? Capaz que esta no necesita ser inversible pero me gusta que por las dudas lo sea.
    montaniaRusaPeligrosa(Visitante, Atraccion).

montaniaRusaPeligrosa(Visitante, Atraccion) :-
    visitante(Visitante), atraccion(Atraccion, montaniaRusa(Giros, Duracion)),
    not(esChico(Visitante)),
    not(necesitaEntretenerse(Visitante)),
    montaniaConMasGirosInvertidos(Atraccion).

montaniaRusaPeligrosa(Visitante, Atraccion) :-
    visitante(Visitante), atraccion(Atraccion, montaniaRusa(_, Duracion)),
    esChico(Visitante),
    Duracion > 60.

montaniaConMasGirosInvertidos(MontaniaMax) :-
    atraccion(MontaniaMax, montaniaRusa(GirosMax, _)),
    forall(atraccion(Montania, montaniaRusa(Giros,_)), GirosMax >= Giros).
    
%                                      -[5]-
mes(enero).
mes(febrero).
mes(marzo).
mes(abril).
mes(mayo).
mes(junio).
mes(julio).
mes(agosto).
mes(septiembre).
mes(octubre).
mes(noviembre).
mes(diciembre).

% opcionesDeEntretenimiento(Visitante, Mes, Opcion)

opcionesDeEntretenimiento(Visitante, Mes, PuestoDeComida) :-
    visitante(Visitante), mes(Mes), comida(PuestoDeComida),
    puedeComprar(Visitante, PuestoDeComida).

opcionesDeEntretenimiento(Visitante, Mes, AtraccionTranqui) :-
    visitante(Visitante), mes(Mes), esChico(Visitante),
    atraccion(AtraccionTranqui, _).

opcionesDeEntretenimiento(Visitante, Mes, AtraccionTranqui) :-
    visitante(Visitante), mes(Mes), not(esChico(Visitante)),
    atraccion(AtraccionTranqui, tranquila(todos)).

opcionesDeEntretenimiento(Visitante, Mes, AtraccionIntensa) :-
    visitante(Visitante), mes(Mes),
    atraccion(AtraccionIntensa, intensa(_)).

opcionesDeEntretenimiento(Visitante, Mes, AtraccionIntensa) :-
    visitante(Visitante), mes(Mes),
    atraccion(AtraccionIntensa, intensa(_)).

