% receta(Plato, Duración, Ingredientes) 
receta(empanadaDeCarneFrita, 20, [harina, carne, cebolla, picante, 
aceite]). 
receta(empanadaDeCarneAlHorno, 20, [harina, carne, cebolla, picante]). 
receta(lomoALaWellington, 125, [lomo, hojaldre, huevo, mostaza]). 
receta(pastaTrufada, 40, [spaghetti, crema, trufa]). 
receta(souffleDeQueso, 35, [harina, manteca, leche, queso]). 
receta(tiramisu, 30, [vainillas, cafe, mascarpone]). 
receta(rabas, 20, [calamar, harina, sal]). 
receta(parrilladaDelMar, 40, [salmon, langostinos, mejillones]). 
receta(sushi, 30, [arroz, salmon, sesamo, algaNori]). 
receta(hamburguesa, 15, [carne, pan, cheddar, huevo, panceta, trufa]). 
receta(padThai, 40, [fideos, langostinos, vegetales]). 
 
% elabora(Chef, Plato) 
elabora(guille, empanadaDeCarneFrita). 
elabora(guille, empanadaDeCarneAlHorno). 
elabora(vale, rabas). 
elabora(vale, tiramisu). 
elabora(vale, parrilladaDelMar). 
elabora(ale, hamburguesa). 
elabora(lu, sushi). 
elabora(mar, padThai). 
 
% cocinaEn(Restaurante, Chef) 
cocinaEn(pinpun, guille). 
cocinaEn(laPececita, vale). 
cocinaEn(laParolacha, vale). 
cocinaEn(sushiRock, lu). 
cocinaEn(olakease, lu). 
cocinaEn(guendis, ale). 
cocinaEn(cantin, mar).

% tieneEstilo(Restaurante, Estilo) 
tieneEstilo(pinpun, bodegon(parqueChas, 6000)). 
tieneEstilo(laPececita, bodegon(palermo, 20000)). 
tieneEstilo(laParolacha, italiano(15)). 
tieneEstilo(sushiRock, oriental(japon)). 
tieneEstilo(olakease, oriental(japon)). 
tieneEstilo(cantin, oriental(tailandia)). 
tieneEstilo(cajaTaco, mexicano([habanero, rocoto])). 
tieneEstilo(guendis, comidaRapida(5)).

% italiano(CantidadDePastas) 
% oriental(País) 
% bodegon(Barrio, PrecioPromedio) 
% mexicano(VariedadDeAjies) 
% comidaRapida(cantidadDeCombos)

% acá decidí escribir todos los platos/chefs/restautantes. Quizás me tome 4', o sea repetitivo.
% Pero vale la pena ya que simplifica todo más adelante.
% Nota para el profesorado: ¿Qué opinás de esto?

restautante(pinpun).
restautante(laPececita).
restautante(laParolacha).
restautante(sushiRock).
restautante(olakease).
restautante(guendis).
restautante(cantin).

plato(empanadaDeCarneAlHorno).
plato(empanadaDeCarneAlHorno).
plato(lomoALaWellington).
plato(pastaTrufada).
plato(souffleDeQueso).
plato(tiramisu).
plato(rabas).
plato(parrilladaDelMar).
plato(sushi).
plato(hamburguesa).
plato(padThai).

chef(guille).
chef(vale).
chef(lu).
chef(ale).
chef(mar).

% 1)
esCrack(Chef) :-
    chef(Chef),
    cocinaEn(UnRestaurante, Chef),
    cocinaEn(OtroRestaurante, Chef),
    UnRestaurante \= OtroRestaurante.

esCrack(Chef) :-
    chef(Chef),
    elabora(Chef, padThai).

% 2)
esOtaku(Chef) :-
    chef(Chef),
    forall(cocinaEn(UnRestaurante, Chef), esJapones(UnRestaurante)).

esJapones(Restaurante) :-
    tieneEstilo(Restaurante, oriental(japon)).

% 3)
esTop(Plato) :-
    plato(Plato), %podría haber usado el receta(Plato, Duración, Ingredientes), pero me pareció más simple esto.
    forall(elabora(UnChef, Plato), esCrack(UnChef)).

% 4)
esDificil(Plato) :-
    plato(Plato),
    receta(Plato, UnaDuracion, _),
    UnaDuracion > 120.

esDificil(Plato) :-
    plato(Plato),
    tieneIngrediente(Plato, trufa).
    
esDificil(souffleDeQueso).

tieneIngrediente(Plato, Ingrediente) :-
    plato(Plato),
    receta(Plato, _, Ingredientes),
    member(Ingrediente, Ingredientes).

/*
Seria sobredelegar?
duracion(Plato, Duracion) :-
    plato(Plato),
    receta(Plato, Duracion, _).
*/

% 5)
seMereceLaMichelin(Restaurante) :-
    restautante(Restaurante),
    cocinaEn(Restaurante, UnChef),
    esCrack(UnChef),
    esMichelinero(Restaurante).

esMichelinero(Restaurante):- tieneEstilo(Restaurante, otiental(tailandia)).
esMichelinero(Restaurante):- tieneEstilo(Restaurante, bodegon(palermo, _)).
esMichelinero(Restaurante):- tieneEstilo(Restaurante, italiano(5)).
esMichelinero(Restaurante):- 
    tieneEstilo(Restaurante, mexicano(Ingredientes)),
    member(habanero, Ingredientes),
    member(rocoto, Ingredientes).

% 6)
tieneMayorRepertorio(UnRestaurante, OtroRestaurante) :-
    restautante(UnRestaurante),
    restautante(OtroRestaurante),
    cantidadDePlatosDelRestaurante(UnRestaurante, UnaCantidad),
    cantidadDePlatosDelRestaurante(OtroRestaurante, OtraCantidad),
    UnRestaurante \= OtroRestaurante,
    UnaCantidad > OtraCantidad.

cantidadDePlatosDelRestaurante(Restaurante, Cantidad) :-
    cocinaEn(Restaurante, UnChef),
    cantidadDePlatos(UnChef, Cantidad).

% 7)
% Pregunta para el profesorado:
% ¿Por qué el punto 7 "cantidadDePlatos/2" es inversible para Calificacion? Lo probé y es totalmente
% inversible, pero no entiendo por qué es inversible para Calificacion ya que se usa por 1ra vez en
% "Calificacion is Cantidad * 5" y eso no es inversible por lo que tengo entendido.

calificacionGastronomica(Restaurante, Calificacion) :-
    restautante(Restaurante),
    cantidadDePlatosDelRestaurante(Restaurante, Cantidad),
    Calificacion is Cantidad * 5.

cantidadDePlatos(Chef, Cantidad) :-
    chef(Chef),
    findall(UnPlato, elabora(Chef, UnPlato), CartaDelChef),
    length(CartaDelChef, Cantidad).

% Dato, 1ro hice el 7 y luego el 6 por eso está todo un poco desordenado.
