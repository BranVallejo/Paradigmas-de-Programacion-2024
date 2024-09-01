% rata(Nombre, DondeViven).
% humano(Nombre).
% sabeCocinar(Cocinero, Plato, Experiencia).
% trabajaEn(Cocinero, Restaurante)
rata(remy, gusteaus).
rata(emile, barMalabar).
rata(django, pizzeriaJeSuis).

humano(linguini).
humano(colette).
humano(horst).
humano(amelie).

sabeCocinar(linguini, ratatouille, 3).
sabeCocinar(linguini, sopa, 5).
sabeCocinar(colette, salmonAsado, 9).
sabeCocinar(horst, ensaladaRusa, 8).
sabeCocinar(linguini, salmonAsado, 5).

trabajaEn(linguini, gusteaus).
trabajaEn(colette, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(amelie, gusteaus).

restaurante(gusteaus).
restaurante(barMalabar).
restaurante(pizzeriaJeSuis).
restaurante(laFarola). % Ficticio para pruebas

plato(ratatouille).
plato(sopa).
plato(salmonAsado).
plato(ensaladaRusa).

%                                       [1]
inspeccionSatisfactoria(Restaurante) :- 
    restaurante(Restaurante),
    not(rata(_, Restaurante)).

%                                       [2]
chef(Cocinero, Restaurante) :-
    trabajaEn(Cocinero, Restaurante), 
    sabeCocinar(Cocinero, _, _).

%                                       [3]
chefcito(Rata) :-
    trabajaEn(linguini, Restaurante),
    rata(Rata, Restaurante).

%                                       [4]
cocinaBien(Cocinero, Plato) :- sabeCocinar(Cocinero, Plato, Experiencia), Experiencia > 7.
cocinaBien(remy, Plato) :- plato(Plato).

% Podría generar los platos con sabeCocinar(_, Plato, _), pero creo que de esa forma es más
% fácil de expandir a futuro. Porque capaz que hay un plato que se agrega y nadie sabe cocinar.
% Capaz es innecesario, pero me baso en que en el tp Ale me dijo que era mejor que genere
% las tecnologías con un generador propio y no con un desarrollo(Jugador, Tecnologia), porque
% capaz que nadie genero una tecnologia y me la estaba comiendo ¿Qué opinás?

%                                       [5]
encargadoDe(Plato, CocineroEncargado, Restaurante) :-
    plato(Plato),
    trabajaEn(CocineroEncargado, Restaurante),
    sabeCocinar(CocineroEncargado, Plato, ExperienciaMayor), 
    forall((trabajaEn(OtroCocinero, Restaurante), sabeCocinar(OtroCocinero, Plato, OtraExperiencia)), ExperienciaMayor >= OtraExperiencia ).


plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).

%                                       [6]
saludable(Plato) :-
    calorias(Plato, UnasCalorias),
    UnasCalorias < 75.

calorias(Plato, Calorias) :-
    plato(Plato, entrada(Ingredientes)),
    length(Ingredientes, CantidadDeIngredientes),
    Calorias is 15 * CantidadDeIngredientes.

calorias(Plato, Calorias) :- plato(Plato, postre(Calorias)).

calorias(Plato, Calorias) :-
    plato(Plato, principal(Guarnicion, Tiempo)),
    caloriasGuarni(Guarnicion, CaloriasGuarni),
    Calorias is Tiempo * 5 + CaloriasGuarni.

caloriasGuarni(pure, 20).
caloriasGuarni(papasFritas, 50).

%                                       [7]
criticaPositiva(Restaurante, Critico) :-
    restaurante(Restaurante),
    inspeccionSatisfactoria(Restaurante),
    pasaLaVaraDe(Restaurante, Critico).


pasaLaVaraDe(Restaurante, christophe) :- cantidadDeChefs(Restaurante, Cantidad), Cantidad > 3.

pasaLaVaraDe(Restaurante, antonEgo) :- especialistasEn(Restaurante, ratatouille).

pasaLaVaraDe(Restaurante, cormillot) :-
    soloTienePlatosSaludables(Restaurante),
    todasLasEntradasConZanahoria(Restaurante).

todasLasEntradasConZanahoria(Restaurante) :-
    forall(plato(_, entrada(Ingredientes)), member(zanahoria, Ingredientes)).

soloTienePlatosSaludables(Restaurante) :-
    forall((trabajaEn(UnCocinero, Restaurante), sabeCocinar(UnCocinero, Plato,_)), saludable(Plato)).

cantidadDeChefs(Restaurante, Cantidad) :-
    findall(UnChef, chef(UnChef, Restaurante), ChefsDelRestaurante),
    length(ChefsDelRestaurante, Cantidad).

especialistasEn(Restaurante, Plato) :- forall(trabajaEn(Cocinero, Restaurante), cocinaBien(Cocinero, Plato)).