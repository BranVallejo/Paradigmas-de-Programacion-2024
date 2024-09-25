% Acá va el código
%                               [1]
% persona(Personsa, edad, Genero).
% generoInteresado(Persona,  GeneroQueLeInteresa).
% edadInteresada(Persona, EdadMinima, EdadMaxima).
% gustaYDisgusta(Persona, [Gustos], [Disgustos]).

persona(pablo  , 21, masculino).
persona(natalia, 21,  femenino).
generoInteresado(pablo  ,  femenino).
generoInteresado(natalia, masculino).
generoInteresado(natalia,  femenino).
edadInteresada(pablo  , 20, 55).
edadInteresada(natalia, 20, 30).
gustaYDisgusta(pablo, [futbol, basket, comer, bailar, musica], [f1, manualidades, literatura, historia, debate]).
gustaYDisgusta(natalia, [futbol, pintar, comer, musica], [politica]).

perfilIncompleto(Persona) :- persona(Persona), not(perfilCompleto(Persona)).

perfilCompleto(Persona) :-
    persona(Persona, _, _), interesesCompletos(Persona),
    gustosYDisgustosCompletos(Persona).

interesesCompletos(Persona) :- generoInteresado(Persona, _), edadInteresada(Persona, _, _).
gustosYDisgustosCompletos(Persona) :-
    datosSuficientes(Persona, gustos, 5),
    datosSuficientes(Persona, disgustos, 5).

datosSuficientes(Persona, gustos, Cantidad) :-  gustaYDisgusta(Persona, Gustos, _), cantidadSuficiente(Gustos, Cantidad).
datosSuficientes(Persona, disgustos, Cantidad) :-  gustaYDisgusta(Persona, _, Disgustos), cantidadSuficiente(Disgustos, Cantidad).
cantidadSuficiente(Datos, Cantidad) :- length(Datos, CantidadDeDatos), CantidadDeDatos >= Cantidad.

persona(Persona) :- persona(Persona, _, _).
genero(Genero) :- persona(_, _, Genero).

%                               [2]
almaLibre(Persona) :-  persona(Persona), forall(genero(Genero), generoInteresado(Persona, Genero)).
almaLibre(Persona) :- edadInteresada(Persona, EdadMinima, EdadMaxima), diferenciaEntreEdadesMinima(EdadMaxima, EdadMinima, 30).

diferenciaEntreEdadesMinima(UnaEdad, OtraEdad, DiferenciaMinima) :-
    Diferencia is UnaEdad - OtraEdad, Diferencia > DiferenciaMinima.

%                               [3]
quiereLaHerencia(Persona) :-
    persona(Persona, Edad, _), edadInteresada(Persona, EdadMinima, _),
    diferenciaEntreEdadesMinima(EdadMinima, Edad, 30).

indeseable(Persona) :- persona(Persona), not(pretendiente(_, Persona)).

%                               [4]
pretendiente(Enamorado, Persona) :-
    leInteresaSuEdad(Enamorado, Persona),
    leInteresaSuGenero(Enamorado, Persona),
    Enamorado \= Persona.
    
leInteresaSuGenero(Enamorado, Persona) :- persona(Persona, _, GeneroPersona), generoInteresado(Enamorado, GeneroPersona).
leInteresaSuEdad(Enamorado, Persona) :- 
    persona(Persona, EdadPersona, _),
    edadInteresada(Enamorado, EdadMinima, EdadMaxima), 
    between(EdadMinima, EdadMaxima, EdadPersona).

%                               [5]
hayMatch(UnaPersona, OtraPersona) :- pretendiente(UnaPersona, OtraPersona), pretendiente(OtraPersona, UnaPersona).
% No hace falta restringir que sean diferentes porque de eso ya se encarga pretendiente/2.

%                               [6]
trianguloAmoroso(UnaPersona, OtraPersona, TerceraPersona) :-
    pretencionCircular(UnaPersona, OtraPersona, TerceraPersona),
    trioSinMatches(UnaPersona, OtraPersona, TerceraPersona).

pretencionCircular(UnaPersona, OtraPersona, TerceraPersona) :-
    pretendiente(UnaPersona, OtraPersona), 
    pretendiente(OtraPersona, TerceraPersona),
    pretendiente(TerceraPersona, UnaPersona).

trioSinMatches(UnaPersona, OtraPersona, TerceraPersona) :-
    not(hayMatch(UnaPersona, OtraPersona)),
    not(hayMatch(UnaPersona, TerceraPersona)),
    not(hayMatch(TerceraPersona, OtraPersona)).

%                               [7]
unoParaElOtro(UnaPersona, OtraPersona) :-
    hayMatch(UnaPersona, OtraPersona),
    noLeDisgustaNadaDelOtro(UnaPersona, OtraPersona),
    noLeDisgustaNadaDelOtro(OtraPersona, UnaPersona).

noLeDisgustaNadaDelOtro(UnaPersona, OtraPersona) :-
    not(leDisgustaAlgoDelOtro(UnaPersona, OtraPersona)).

leDisgustaAlgoDelOtro(UnaPersona, OtraPersona) :- unGusto(OtraPersona, OtroGusto), unDisgusto(UnaPersona, OtroGusto).
    
unGusto(Persona, UnGusto) :- gustaYDisgusta(Persona, Gustos, _), member(UnGusto, Gustos).

unDisgusto(Persona, UnDisgusto) :- gustaYDisgusta(Persona, _, Disgustos), member(UnDisgusto, Disgustos).
    
%                               [8]
/*

indiceDeAmor(Envia, Recibe, NumeroIndice) :-
    persona(Envia), persona(Recibe), indice(NumeroIndice), Envia \= Recibe.

indice(NumeroIndice) :- member(NumeroIndice, [1,2,3,4,5,6,7,8,9,10]).
*/

% indiceDeAmor(Envia, Recibe, IndiceDeAmor).

indiceDeAmor(pablo, natalia, 10).
indiceDeAmor(pablo, natalia, 9).
indiceDeAmor(pablo, natalia, 9).

indiceDeAmor(natalia, pablo, 1).
indiceDeAmor(natalia, pablo, 2).
indiceDeAmor(natalia, pablo, 1).

%indiceDeAmor(pablo, natalia, 10).
%indiceDeAmor(pablo, natalia, 10).
%indiceDeAmor(pablo, natalia, 10).

% desbalance(PersonaConMásIndice, PersonaConMenosIndice).
desbalance(UnaPersona, OtraPersona) :-
    persona(UnaPersona), persona(OtraPersona),
    UnaPersona \= OtraPersona,
    indiceDeAmorPromedio(UnaPersona, OtraPersona,UnIndice),
    indiceDeAmorPromedio(OtraPersona, UnaPersona, OtroIndice),
    masDelDoble(UnIndice, OtroIndice).

masDelDoble(UnNumero, OtroNumero) :- UnNumero > OtroNumero * 2.

indiceDeAmorPromedio(UnaPersona, OtraPersona, IndiceDeAmorFinal) :-
    findall(Indice, indiceDeAmor(UnaPersona, OtraPersona, Indice), Indices),
    promedio(Indices, IndiceDeAmorFinal).

promedio(Lista, PromedioFinal) :- sumlist(Lista, Sumatoria), length(Lista, Cantidad), PromedioFinal is Sumatoria / Cantidad.

%                               [9]
% ghostea(Ghosteado, Ghosteador).
ghostea(UnaPersona, OtraPersona) :- leEscribio(UnaPersona, OtraPersona), not(leEscribio(OtraPersona, UnaPersona)).

leEscribio(UnaPersona, OtraPersona) :- indiceDeAmor(UnaPersona, OtraPersona, _). % Algo redundante, pero se lee más fácil ghostea/2.

%%%% Fin %%%
