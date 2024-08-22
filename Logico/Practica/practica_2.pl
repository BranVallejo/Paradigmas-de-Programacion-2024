% Video de la carcel
% https://www.youtube.com/live/yId9hLw5CwE?si=J0rYAQGlglOqsYgZ

% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotráfico([metanfetaminas])).
prisionero(alex, narcotráfico([heroína])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotráfico([heroina, opio])).
prisionero(dayanara, narcotráfico([metanfetaminas])).

% controla(Controlador, Controlado)
controla(Controlador, Controlado).

% 2)
conflictoDeIntereses(UnaPersona, OtraPersona) :- %al usarse en controla, no hace falta generarlos
    controla(UnaPersona, Tercero),
    controla(OtraPersona, Tercero),
    not(controla(UnaPersona, OtraPersona)),
    not(controla(OtraPersona, UnaPersona)),
    OtraPersona \= UnaPersona.

% 3)
peligroso(Prisionero) :-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), crimenGrave(Crimen)).

crimenGrave(homicidio(_)).

crimenGrave(narcotrafico([Drogas])) :- member(metanfetaminas, Drogas).
    
crimenGrave(narcotrafico([Drogas])) :-
    length(Drogas, CantidadDeDrogas),
    CantidadDeDrogas >= 5.
        
% 4)
ladronDeGuanteBlanco(Prisionero) :-
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen), crimenDeGuanteBlanco(Crimen)).

crimenDeGuanteBlanco(robo(Monto)) :-
    Monto > 100000.

% 5) #EjercicioClave de uso de findall
condena(Prisionero, Anios) :-
    prisionero(Prisionero, _),
    findall(AniosDePena, (prisionero(Prisionero, Crimen), pena(Crimen, AniosDePena) ), PenasDeCrimenes),
    sumlist(PenasDeCrimenes, Anios).

pena(robo(Monto), AniosDePena) :-
    AniosDePena is Monto / 10000.

pena(homicidio(Victima), 9) :-
    guardia(Victima).

pena(homicidio(Victima), 7) :- % tengo que excluir los guardias, si no me los contaría 2 veces
    not(guardia(Victima)).

pena(narcotráfico(Drogas), AniosDePena) :-
    length(Drogas, CantidadDeDrogas),
    AniosDePena is CantidadDeDrogas * 2.
    
% 6)  #EjercicioClave el predicado de controladoDirectaO... es my bueno, porque es recursivo.
capoDiTutiLiCapi(Prisionero) :-
    prisionero(Prisionero, _),
    not(controla(_, Prisionero)),
    %controla(Prisionero, _).
    forall(persona(Persona), controladoDirectaOIndirectamente(Prisionero, Persona)).

persona(Persona) :- guardia(Persona).
persona(Persona) :- prisionero(Persona, _).

%controladoDirectaOIndirectamente(Controlador, Controlado).
controladoDirectaOIndirectamente(Controlador, Controlado) :- 
    controla(Controlador, Controlado).

controladoDirectaOIndirectamente(Controlador, Controlado) :- 
    controla(Controlador, Tercero),
    controladoDirectaOIndirectamente(Tercero, Controlado).




% #############################################################################################
% Video de Festival de Rock
% https://www.youtube.com/live/ioQZbTLnS_s?si=Qp527rp3dw1FiwDj

%festival(NombreDelFestival, Bandas, Lugar).
% Relaciona el nombre de un festival con la lista de los nombres de bandas que tocan en él
% y el lugar dónde se realiza.
festival(lollapalooza, [gunsAndRoses, theStrokes, ..., littoNebbia], hipodromoSanIsidro).

%lugar(Nombre, Capacidad, PrecioBase).
% Relaciona un lugar con su capacidad y el precio base que se cobran las entradas ahí.
lugar(hipodromoSanIsidro, 85000, 3000).

%banda(nombre, nacionalidad, popularidad).
% Relaciona una banda con su nacionalidad y su popularidad.
banda(gunsAndRoses, eeuu, 69420).

%entradaVendida(NombreDelFestival, TipoDeEntrada).
% Indica la venta de una entrada de cierto tipo para el festival 
% indicado.
% Los tipos de entrada pueden ser alguno de los siguientes: 
%     - campo
%     - plateaNumerada(Fila)
%     - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

%plusZona(Lugar, Zona, Recargo).
% Relacion una zona de un lugar con el recargo que le aplica al precio de las plateas generales.
plusZona(hipodromoSanIsidro, zona1, 1500).


% 1 )
itinerante(Festival) :-
    festival(NombreFestival, Bandas, Lugar1),
    festival(NombreFestival, Bandas, Lugar2),
    Lugar1 \= Lugar2.

% 2)
careta(Festival) :-
    festival(Festival, _, _),
    not(entradaVendida(Festival, campo)).

careta(personalFest).

% 3) 
nacAndPop(Festival) :-
    festival(Festival, Bandas, _),
    not(careta(Festival)),
    forall(member(Bandas, Banda), (banda(Banda, argentina, Popularidad), Popularidad > 1000)).

% 4)
sobrevendido(Festival) :-
    festival(Festival, _, Lugar),
    lugar(Lugar, Capacidad, _),
    findall(Entrada, entradaVendida(Festival, Entrada), Entradas),
    length(Entradas, Cantidad),
    Cantidad > Capacidad.

% 5) #EjercicioClave de uso de findall
recaudacionTotal(Festival, TotalRecaudado) :-
    festival(Festival, _, Lugar),
    findall(Valor, (entradaVendida(Festival, Entrada), precio(Entrada, Lugar, Valor)), PreciosDeEntradas),
    sumlist(PreciosDeEntradas, TotalRecaudado).
    
precio(campo, Lugar, Valor) :-
    lugar(Lugar, _, Valor).

precio(plateaGeneral(Zona), Lugar, Valor) :-
    lugar(Lugar, _, ValorBase),
    plusZona(Lugar, Zona, ValorZona),
    Valor is ValorBase + ValorZona.

precio(plateaNumerada(NumeroDePlatea), Lugar, Valor) :-
    lugar(Lugar, _, ValorBase),
    Valor is ValorBase * 3,
    NumeroDePlatea > 10.

precio(plateaNumerada(NumeroDePlatea), Lugar, Valor) :-
    lugar(Lugar, _, ValorBase),
    Valor is ValorBase * 6,
    NumeroDePlatea =< 10.

% 6) 
% Relaciona dos bandas si tocaron juntas en algún recital o si una de ellas tocó con una banda del mismo palo que la otra, pero más popular.

tocaronJuntas(Banda1, Banda2) :-
    festival(_, Bandas, _),
    member(Banda1, Bandas),
    member(Banda2, Bandas),
    Banda1 \= Banda2.

esMasPopular(Banda1, Banda2) :-
    banda(Banda1, _, PopularidadBanda1),
    banda(Banda2, _, PopularidadBanda2),
    PopularidadBanda1 > PopularidadBanda2.

delMismoPalo(UnaBanda, OtraBanda) :-
    tocaronJuntas(UnaBanda, OtraBanda).

delMismoPalo(UnaBanda, OtraBanda) :-
    tocaronJuntas(UnaBanda, TerceraBanda),
    delMismoPalo(OtraBanda, TerceraBanda),
    esMasPopular(TerceraBanda, OtraBanda).