% Acá va el código
% juego(Nombre)
juego(minecraft).
juego(counterStrike).
juego(wow).
juego(rompecabezas).

genero(accion).
genero(puzzle).
genero(rol).

% juego(Nombre, tipo(carac))
% juego(Nombre, accion).
% juego(Nombre, rol(CantUsuariosActivos)).
% juego(Nombre, puzzle(CantNiveles, Dificultad)).
juego(minecraft, rol(200000)).
juego(counterStrike, accion).
juego(wow, rol(3000000)).
juego(rompecabezas, puzzle(10, facil)).

% precio(Nombre, Precio).
% descuento(Nombre, Descuento).
precio(minecraft, 60).
precio(counterStrike, 80).
precio(wow, 10).
precio(rompecabezas, 70).

descuento(minecraft, 55).
descuento(rompecabezas, 60).

% 1)
cuantoSale(Juego, PrecioFinal) :-
    juego(Juego),
    not(descuento(Juego, _)),
    precio(Juego, PrecioFinal).

cuantoSale(Juego, PrecioFinal) :-
    juego(Juego),
    descuento(Juego, Descuento),
    precio(Juego, Precio),
    PrecioFinal is Precio - Precio * (Descuento / 100).

% 2)
tieneUnBuenDescuento(Juego) :-
    juego(Juego),
    descuento(Juego, Descuento),
    Descuento >= 50.

% 3)
popular(Juego) :- juego(Juego, accion).
popular(Juego) :- 
    juego(Juego, rol(Usuarios)),
    Usuarios > 1000000.
popular(Juego) :- juego(Juego, puzzle(_, facil)).
popular(Juego) :- juego(Juego, puzzle(25, _)).
popular(minecraft).
popular(counterStrike).

% 4)
% usuario(Nombre).
% tiene(Usuario, Juego).
% planeaAdquirir(Usuario, Juego, paraEl).
% planeaAdquirir(Usuario, Juego, regalo(OtroUsuario)).

usuario(ema).
usuario(pablo).
tiene(ema, wow).
tiene(ema, minecraft).
tiene(pablo, wow).
planeaAdquirir(ema, minecraft, regalo(pablo)).
planeaAdquirir(ema, rompecabezas, paraEl).
planeaAdquirir(pablo, counterStrike, regalo(ema)).

adictoALosDescuentos(Usuario) :-
    usuario(Usuario),
    forall(planeaAdquirir(Usuario, Juego, _), tieneUnBuenDescuento(Juego)).

fanatico(Usuario, Genero) :-
    usuario(Usuario), genero(Genero),
    % juego(UnJuego), juego(OtroJuego), está de más creo. Sigue siendo totalmente inversible, por qué?
    tiene(Usuario, UnJuego), tiene(Usuario, OtroJuego),
    esDelGenero(UnJuego, Genero), esDelGenero(OtroJuego, Genero), 
    UnJuego \= OtroJuego.

esDelGenero(Juego, accion) :-
    juego(Juego), genero(Genero), juego(Juego, acccion).    

esDelGenero(Juego, rol) :-
    juego(Juego), genero(Genero), juego(Juego, rol(_)).        

esDelGenero(Juego, puzzle) :-
    juego(Juego), genero(Genero), juego(Juego, puzzle(_, _)).   

% 5)
monotematico(Usuario, Genero) :-
    usuario(Usuario), genero(Genero),
    forall(tiene(Usuario, Juego), esDelGenero(Juego, Genero)).
    
% 6)
buenosAmigos(UnUsuario, OtroUsuario) :-
    usuario(UnUsuario), usuario(OtroUsuario),
    planeaAdquirir(UnUsuario, UnJuego, regalo(OtroUsuario)),
    planeaAdquirir(OtroUsuario, OtroJuego, regalo(UnUsuario)),
    popular(UnJuego), popular(OtroJuego).

% 7)
cuantoGastara(Usuario, GastoTotal) :-
    usuario(Usuario),
    findall(Precio, (planeaAdquirir(Usuario, Juego, _), cuantoSale(Juego, Precio)), Precios),
    sumlist(Precios, GastoTotal).