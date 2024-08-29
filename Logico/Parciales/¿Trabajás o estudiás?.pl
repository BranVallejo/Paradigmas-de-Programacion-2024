persona(juan).
persona(ana).
persona(marta).
persona(carlos).
persona(tita).
persona(cacho).

trabaja(juan, programacion, acme).
trabaja(ana, testing, acme).
trabaja(ana, programacion, acme).
trabaja(marta, ceo, acme).
trabaja(carlos, programacion, narnia).
trabaja(carlos, docente, escuela).

% estudia(Persona, Titulo, AñosDeEstudio, Universidad).
estudia(juan,sistemas,5,utn).
estudia(tita,sistemas,3,utn).
estudia(ana,computacion,4, uba).
estudia(ana,computacion,3, utn).
estudia(carlos, medicina,7,umm).
estudia(cacho, medicina,5,uuu).

% habilita(titulo, trabajo).
habilita(sistemas,programacion).
habilita(sistemas, testing).
habilita(computacion, testing).
habilita(medicina, urgenciasMedicas).
habilita(medicina, cirugia).

%                           [1]
trabajaDeLoQueEstudio(Persona) :-
    trabaja(Persona, _, _), % ligo persona y al mismo tiempo verifico si trabaja.
    esUnTrabajoAcordeASusEstudios(Persona, _).

trabajaDeAlgoQueNoEstudio(Persona) :-
    trabaja(Persona, Trabajo, _),
    not(esUnTrabajoAcordeASusEstudios(Persona, Trabajo)).

noTrabajaEnNadaDeLoQueEstudio(Persona) :- 
    persona(Persona),
    forall(trabaja(Persona, Trabajo, _), not(esUnTrabajoAcordeASusEstudios(Persona, Trabajo))).
% porque no trabaja, o porque su trabajo no tiene que ver con esto. Por eso no le puse 
% el "trabaja(Persona, Trabajo, _)" Sino no se cumple el ejemplo que dice el enunciado de medicina.


esUnTrabajoAcordeASusEstudios(Persona, Trabajo) :-
    persona(Persona), 
    estudia(Persona, Titulo, _, _),
    habilita(Titulo, Trabajo).
    
/*
?- trabajaDeLoQueEstudio(Quien).
Quien = juan ;
Quien = ana ;
Quien = ana ;
Quien = ana ;
Quien = ana ;

?- trabajaDeAlgoQueNoEstudio(Quien).
Quien = ana ;
Quien = marta ;
Quien = carlos ;

?- noTrabajaEnNadaDeLoQueEstudio(Quien).
Quien = marta ;
Quien = carlos ;
Quien = carlos.
*/    

%                           [2]
todosSusEstudiantesTienenEmpleo(Universidad) :-
    estudia(_, _, _, Universidad),
    forall(estudia(Estudiante, _, _, Universidad), trabaja(Estudiante, _, _)).

ningunEstudianteTieneEmpleoVinculado(Carrera) :-
    estudia(_, Carrera, _, _),
    forall(estudia(Estudiante, Carrera, _, _), noTrabajaEnNadaDeLoQueEstudio(Estudiante)).
    
/*
?- todosSusEstudiantesTienenEmpleo(Cual).
Cual = uba ;
Cual = umm ;

?- ningunEstudianteTieneEmpleoVinculado(Cual).
Cual = medicina ;
Cual = medicina.
*/

%                           [3]
hayMuchaVinculacion(Universidad, LugarLaboral) :-
    estudia(_, _, _, Universidad),
    trabaja(_, _, LugarLaboral),
    findall(Persona, (trabaja(Persona, _, LugarLaboral), estudia(Persona, _, _, Universidad)), EstudiantesVinculados),
    length(EstudiantesVinculados, Cantidad),
    Cantidad >= 5.

/*
?- hayMuchaVinculacion(Uni, Lugar).
false.

Si Cantidad >= 3:
    ?- hayMuchaVinculacion(Uni, Lugar).
    Uni = utn,
    Lugar = acme ;
*/

%                           [4]
esfuerzo(LugarLaboral, Persona, AniosDeEstudio) :-
    trabaja(Persona, _, LugarLaboral),
    aniosDeEstudioTotal(Persona, AniosDeEstudio).

aniosDeEstudioTotal(Persona, AniosTotales) :-
    persona(Persona), estudia(_, _, AniosDeEstudio, _), 
    findall(Anios, estudia(Persona, _, Anios, _), AniosEnVariasUni),
    sumlist(AniosEnVariasUni, AniosTotales).

% Justificacion:
% esfuerzo/1 es totalmente inversible ya que Persona y LugarLaboral los estoy ligando con trabaja, y AniosDeEstudio lo 
% estoy usando por primera vez en aniosDeEstudioTotal/2 que es totalmente inversible.    
/*
?- esfuerzo(acme, Persona, Años).
Persona = juan,
Años = 5 ;
Persona = juan,
Años = 5 ;
Persona = juan,
Años = 5 ;
Persona = juan,
Años = 5 ;
Persona = juan,
Años = 5 ;
Persona = juan,
Años = 5 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = ana,
Años = 7 ;
Persona = marta,
Años = 0 ;
Persona = marta,
Años = 0 ;
Persona = marta,
Años = 0 ;
Persona = marta,
Años = 0 ;
Persona = marta,
Años = 0 ;
Persona = marta,
Años = 0.
*/


    
