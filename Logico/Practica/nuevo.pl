% Base de conocimientos
    % De aridad 1
saiyajin(gohan).
saiyajin(goku).
saiyajin(bardock).
saiyajin(trunks).
saiyajin(vegeta).

super(goku).
super(gohan).
super(trunks).
super(vegeta).

    % De aridad 2
raza(pura, vegeta).
raza(pura, goku).
raza(pura, bardock).
raza(mixta, gohan).
raza(mixta, trunks).

% armo reglas, tienen Concecuentes y Antededentes

% Disyuncion AND, para que el Consecuente sea True, todos los antecedentes
% tienen que serlo también

guerrero(Persona):-
    saiyajin(Persona).

superSaiyan(Persona):-
    saiyajin(Persona),
    super(Persona).

saiyajinPuro(Persona):-
    saiyajin(Persona),
    raza(pura, Persona).

% Disyunsion OR
% Tenemos que armar 2 cláusulas por separado.
    % "Una persona es fueste si es de raza pura o raza mixta"
fuerte(Persona):-
    raza(pura, Persona).

fuerte(Persona):-
    raza(mixta, Persona).

%fuerte(Persona):- raza(mixta, Persona). tambien se puede escribir así



% Consulta individual - Le pregunto algo en particular, responde true o false
    % saiyajin(gohan).
    % true

% Consulta existencial - Le pregunto quienes son los verdaderos, 
% responde enumerando las variables que cumplen
    % saiyajin(Quien).
    %goku
    %gohan
    %vegeta
    %trunks

/*
    inversibilidad quiere decir que el predicado puede ligar una variable.
    Si un predicado no es inversible podemos hacer preguntas individuales
    pero no existenciales.
    Cuanto más inversible es un predicado, más consultas puedo hacer
*/

% amigo(Uno, Otro)
amigo(nico, fernando).
amigo(axel, Persona) :-
    amigo(Persona, nico).
amigo(alf, _).

% decimos que el predicado amigo es inversible para el 1er parametro.

% padre(Padre, Hijo).
padre(abraham, homero).
padre(homero, bart).


% abuelo(Abuelo, Nieto).
abuelo(Abuelo, Nieto) :-
    padre(Papa, Nieto),
    padre(Abuelo, Papa).

abuelo(fry, fry).

% si uso una variable por primera vez dentro de un not, 
% primero debo ligarla

/* forall:
es como el All de Haskell, me dice si todos los elementos
de un universo cumplen una condicion. Hay que ligar las 
variables antes de usarlo */

% forall(universo, condicion).

% practica del 2do video 
/*
% habitat(Animal, Bioma).
% animal(Animal).
% come(Comerdor, Comido).


hostil(Animal, Bioma) :-
    animal(Animal),%                                                                 <------ asi ligo ambas variables
    habitat(_, Bioma),% como bioma no tiene su relacion como animal, hago esto      <- _/
    forall(habitat(Cazador, Bioma), come(Cazador, Animal)).

terrible(Animal, Bioma) :-
    animal(Animal),%                                                                 <------ asi ligo ambas variables
    habitat(_, Bioma),% como bioma no tiene su relacion como animal, hago esto      <- _/
    forall(come(Cazador, Animal) , habitat(Cazador, Bioma)).

compatibles(UnAnimal, OtroAnimal) :-
    animal(UnAnimal),
    animal(OtroAnimal),
    not(come(OtroAnimal,UnAnimal)),
    not(come(UnAnimal,OtroAnimal)).

adaptable(Animal) :-
    animal(Animal), % Si no ligo Animal, entonces se usaria por primera vez en un predicado que no es inversible
    forall(habitat(_, Bioma), habitat(Animal, Bioma)).

raro(Animal) :-
    habitat(Animal, Bioma),
    not((habitat(Animal, OtroBioma), Bioma \ OtroBioma))
*/        