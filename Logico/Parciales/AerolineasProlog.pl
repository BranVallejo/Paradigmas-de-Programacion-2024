% aeropuerto(COD, Ciudad)

% ciudad(Nombre, País, Tipo())

% vuelo(Origen, Destino, aerolinea, precio). % Quizas podría haber usado más 

% persona(nombre, dinero, millas prolog, CiudadDeUbicacion)

aeropuerto(aep, buenosAires).
aeropuerto(eze, buenosAires).
aeropuerto(gru, saoPaulo).
aeropuerto(scl, santiagoDeChile).

ciudad(buenosAires, argentina, importanciaCultural([obelisco, congreso, cabildo])).
ciudad(saoPaulo, brasil, paradisiaca()).
ciudad(santiagoDeChile, chile, negocios()).
ciudad(palawan, filipinas, paradisiaca()).
ciudad(chicago, estadosUnidos, negocios()).
ciudad(paris, francia, importanciaCultural([torreEiffel, arcoDelTriunfo, museoLouvre, catedralDeNotreDame])).

vuelo(aep, gru, aerolineasProlog, 75000).
vuelo(gru, scl, aerolineasProlog, 65000).
vuelo(aep, eze, flyBondi, 10000).


aerolinea(aerolineasProlog).
aerolinea(flyBondi).

%                                        [1]
deCabotaje(Aerolinea) :-
    aerolinea(Aerolinea),
    forall(vuelo(Origen, Destino, Aerolinea, _), sonDelMismoPais(Origen, Destino)).

sonDelMismoPais(Origen, Destino) :- perteneceA(Origen, Pais), perteneceA(Destino, Pais).

perteneceA(Aeropuerto, Pais) :- aeropuerto(Aeropuerto, Ciudad), ciudad(Ciudad, Pais, _).

%                                        [2] Creo que este está mal, tira paris o palawan y no tienen vuelos
viajeDeIda(Ciudad) :-
    ciudad(Ciudad, _, _),
    forall(aeropuerto(Aeropuerto, Ciudad), soloIda(Aeropuerto)).

soloIda(Aeropuerto) :- not(vuelo(Aeropuerto, _, _, _)), vuelo(_, Aeropuerto, _, _).

%                                        [3]

relativamenteDirectas(UnAeropuerto, OtroAeropuerto) :-
    aeropuerto(UnAeropuerto, _), aeropuerto(OtroAeropuerto, _),
    vueloDirecto(UnAeropuerto, OtroAeropuerto).

relativamenteDirectas(UnAeropuerto, OtroAeropuerto) :-
    aeropuerto(UnAeropuerto, _), aeropuerto(OtroAeropuerto, _),
    unaEscala(UnAeropuerto, OtroAeropuerto).

vueloDirecto(UnAeropuerto, OtroAeropuerto) :- vuelo(UnAeropuerto, OtroAeropuerto, _, _).

unaEscala(UnAeropuerto, OtroAeropuerto) :- vuelo(UnAeropuerto, Escala, _, _), vuelo(Escala, OtroAeropuerto, _, _).

%                                        [4]
% persona(nombre, dinero, millas prolog, CiudadDeUbicacion)
persona(emanuel, 100000, 50000, buenosAires).
persona(pablo, 0, 5000000, santiagoDeChile).

puedeViajar(Persona, UnaCiudad, OtraCiudad) :-
    puedePagar(Persona, UnaCiudad, OtraCiudad).

puedeViajar(Persona, UnaCiudad, OtraCiudad) :-
    puedeCanjear(Persona, UnaCiudad, OtraCiudad).

puedePagar(Persona, UnaCiudad, OtraCiudad) :-
    persona(Persona, Dinero, _, _),
    aeropuerto(Origen, UnaCiudad), aeropuerto(Destino, OtraCiudad),
    vuelo(Origen, Destino, _, Precio),
    Precio =< Dinero.

puedeCanjear(Persona, UnaCiudad, OtraCiudad) :-
    persona(Persona, _, Millas, _),
    aeropuerto(Origen, UnaCiudad), aeropuerto(Destino, OtraCiudad),
    millasNecesarias(Origen, Destino, PrecioMillas),
    Millas >= PrecioMillas.

millasNecesarias(UnAeropuerto, OtroAeropuerto, 500) :- sonDelMismoPais(UnAeropuerto, OtroAeropuerto).
millasNecesarias(UnAeropuerto, OtroAeropuerto, PrecioMillas) :- 
    not(sonDelMismoPais(UnAeropuerto, OtroAeropuerto)),
    vuelo(UnAeropuerto, OtroAeropuerto, _, PrecioOriginal),
    PrecioMillas is PrecioOriginal * 0.2.

%                                        [5]
quiereViajar(Persona, Ciudad) :-
    persona(Persona, Dinero, Millas, _), ciudad(Ciudad, _, _),
    Dinero > 5000, Millas > 100,
    ciudadAtractiva(Ciudad).

ciudadAtractiva(Ciudad) :- ciudad(Ciudad, _, paradisiaca()).
ciudadAtractiva(Ciudad) :- 
    ciudad(Ciudad, _, importanciaCultural(Lugares)), 
    length(Lugares, Cantidad),
    Cantidad >= 4.
ciudadAtractiva(Ciudad) :- ciudad(Ciudad, qatar, negocios()).

%                                        [6]
persona(eduardo, 50000, 750, buenosAires).

tieneQueAhorrarUnPoquitoMas(Persona, Ciudad) :-
    % persona(Persona, Dinero, Millas, CiudadDeOrigen),
    quiereViajar(Persona, Ciudad), not(puedePagar(Persona, CiudadDeOrigen, Ciudad)),
    masCercaEconomicamente(Persona, Ciudad),
    not(pagarTodoDesdeOrigen(Persona)).

masCercaEconomicamente(Persona, CiudadEconomica) :-
    persona(Persona, _, _, CiudadDeOrigen),
    aeropuerto(AeropuertoOrigen, CiudadDeOrigen), aeropuerto(AeropuertoEconomico, CiudadEconomica),
    vuelo(AeropuertoOrigen, AeropuertoEconomico, _, PrecioBarato),
    forall(vuelo(AeropuertoOrigen, OtroAeropuerto, _, Precio), Precio > PrecioBarato).
    
    
pagarTodoDesdeOrigen(Persona) :-
    persona(Persona, _, _, CiudadDeOrigen),
    aeropuerto(AeropuertoOrigen, CiudadDeOrigen),
    forall(puedoIrDe(CiudadDeOrigen, UnaCiudad), puedePagar(Persona, CiudadDeOrigen, UnaCiudad)).

% puedo ir de unaciudad a otra ciudad si existe algun vuelo de UnAeropuerto a OtroAeropuerto
puedoIrDe(UnaCiudad, OtraCiudad) :-
    aeropuerto(UnAeropuerto, UnaCiudad),
    aeropuerto(OtroAeropuerto, OtraCiudad),
    vuelo(UnAeropuerto, OtroAeropuerto, _, _),
    UnaCiudad \= OtraCiudad.
    
% vuelo(gru, scl, aerolineasProlog, 65000).

    

