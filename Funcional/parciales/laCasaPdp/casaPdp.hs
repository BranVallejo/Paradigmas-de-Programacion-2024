import Text.Show.Functions
--Datas


data Ladron = Ladron {
    nombreLadron :: String,
    habilidades :: [Habilidad],
    armas :: [Arma]
} deriving(Show)

data Rehen = Rehen {
    nombreRehen :: String,
    complot :: Int,
    miedo :: Int,
    planContraLadrones :: Plan
} deriving(Show)

type Plan = [RebelarseContraLadron]

--Types
type IntimidarRehen = Rehen -> Rehen
type Habilidad = String -- puse string porque no me parecio que se necesitaba un uso especial, además en el enunciado dice 
                        -- "Cuando el que se hace el malo es Berlín, aumenta el miedo del rehén tanto como la cantidad de letras que sumen sus habilidades.""
                        -- Pienso que hay que usar concat => Asumo que son Strings
--DUDA Estoy sobre utilizando IntimidarRehen??
--DUDA Acá debería poner eso, o type Arma = Rehen -> Rehen
type Arma = IntimidarRehen
--DUDA a veces el complot queda negativo ¿deberíamos hacer algo con esos casos? Ej: uso ghci> pistola 3 pablo

pistola :: Int -> Arma
pistola unCalibre unRehen = aumentarMiedo (3*length("pistola")) . reducirComplot (5 * unCalibre) $ unRehen

reducirComplot :: Int -> IntimidarRehen
reducirComplot numero unRehen = unRehen {
    complot = complot unRehen - numero
}
-- DUDA quise escribirlo con composición, y quedó así: (-) (numero) . complot unRehen - numero
--se que el (-) (numero) quedó raro pero es la unica forma que lo hice andar. Debería elegir aplicar siempre composicion? 
--O en estos casos dejo el que está porque es más fácil de leer | Lo mismo en la de aumentarMiedo


reducirComplotALaMitad :: IntimidarRehen
reducirComplotALaMitad unRehen = unRehen {
    complot = (flip div 2) . complot $ unRehen
}

aumentarMiedo :: Int -> IntimidarRehen
aumentarMiedo numero unRehen = unRehen {
    miedo = (+ numero) . miedo $ unRehen
}

ametralladora :: Int -> Arma
ametralladora balasRestantes unRehen = aumentarMiedo balasRestantes . reducirComplotALaMitad $ unRehen

-- Una composición es trivial cuando se puede leer de izquierda a derecha  || Una composición es trivial cuando se requiere una manejo y entendimiento de dominio e 

disparos :: Ladron -> IntimidarRehen
disparos unLadron unRehen = (flip ($) unRehen) . elegirArmaMasAterradora unRehen . armas $ unLadron

elegirArmaMasAterradora :: Rehen -> [Arma] -> Arma
elegirArmaMasAterradora unRehen [x] = x
elegirArmaMasAterradora unRehen (x:y:xs)
    | (miedo . x $ unRehen)  > (miedo . y $ unRehen) = elegirArmaMasAterradora unRehen (x:xs)
    | otherwise = elegirArmaMasAterradora unRehen (y:xs)



hacerseElMalo :: Ladron -> IntimidarRehen
hacerseElMalo unLadron unRehen
    | (== "Berlin") . nombreLadron $ unLadron = aumentarMiedoBerlin unLadron unRehen
    -- hice aumentarMiedoBerlin porque poner toda la logica ahí era demasiado, o no??
    | (== "Rio") . nombreLadron $ unLadron = reducirComplot (-20) unRehen
    | otherwise = aumentarMiedo 10 unRehen
 
aumentarMiedoBerlin :: Ladron -> IntimidarRehen
aumentarMiedoBerlin unLadron unRehen = unRehen {miedo = miedo unRehen - (length . concat . habilidades $ unLadron)} 
--Sin los parentesis rompe, todavía me cuesta distinguir cuando usarlos o no

type RebelarseContraLadron = Ladron -> Ladron -- quizas type RebelarseContraLadron = Rehen -> Ladron -> Ladron???

-- "Siempre que tengan más complot que miedo" ¿Tengo que hacer sienpre la guarda preguntando si pasa eso?
atacarAlLadron :: Rehen -> Rehen -> RebelarseContraLadron                    -- ||
atacarAlLadron unRehen unCompaniero unLadron                                 -- ||
    | complot unRehen < miedo unRehen = unLadron    -- <========================
    | otherwise = quitarArmas unCompaniero unLadron

--todos los Rehen -> Rehen son IntimidarRehen???? Yo creo que no
quitarArmas :: Rehen -> RebelarseContraLadron 
quitarArmas unCompaniero unLadron = unLadron {armas = drop (cantDeArmasQuitadas unCompaniero ) . armas $ unLadron} 
-- Antes ((flip div 3) .length . nombreRehen $ unCompaniero )
cantDeArmasQuitadas :: Rehen -> Int
cantDeArmasQuitadas unRehen = (flip div 10) .length . nombreRehen $ unRehen

esconderse :: Rehen -> RebelarseContraLadron
esconderse unRehen unLadron = unLadron {armas = drop ((flip div 3) . length . habilidades $ unLadron ) . armas $ unLadron} 

-- Pensé que quizás podría usar de nuevo quitarArma porque en el anterior decía "dividido por 10" y ahora "dividido 3" entonces dije "ahh esto es una variable"
-- pero antes me tenía que fijar en la cantidad de letras de un compañero y ahora en las habilidades del ladron. Así que lo dejé así. 
-- QUIZAS debería crear un criterio, pero al ser 2 casos, pensé que no valía la pena. Vos decime.

-- ##################
-- ####### 1 ########
-- ##################

tokio :: Ladron
tokio = Ladron {
    nombreLadron = "Tokio",
    habilidades = ["trabajo psicologico", "Entrar en moto"],
    armas = [pistola 9, pistola 9, ametralladora 30]
}

profesor :: Ladron
profesor = Ladron {
    nombreLadron = "Profesor",
    habilidades = ["Disfrazarse de payaso", "Disfrazarse de linyera", "Estar un paso adelante"],
    armas = []
}

--extra
emanuel :: Ladron
emanuel = Ladron {
    nombreLadron = "Emanuel",
    habilidades = ["Patada rompedora", "Curar aliados"],
    armas = [pistola 9, pistola 9]
}

pablo :: Rehen
pablo = Rehen {
    nombreRehen = "Pablo",
    complot = 40,
    miedo = 30,
    planContraLadrones = [esconderse pablo]
}

arturito :: Rehen
arturito = Rehen {
    nombreRehen = "arturito",
    complot = 70,
    miedo = 50,
    planContraLadrones = [esconderse arturito, atacarAlLadron arturito pablo]
}


-- ##################
-- ####### 2 ########
-- ##################
-- Acá podría usar RebelarseContraLadron, pero no le veo mucho sentido. De nuevo ¿Todos los Ladron -> Ladron son RebelarseContraLadron?
-- otra alternativa sería ponerle un nombre más genérico como "ModificarLadron" (sugerencia de Mariano), pero claro entonces en el data de Rehen, el plan
-- te quedaría una lista de ModificarLadron y RebelarseContraLadron queda mucho mejor

esInteligente :: Ladron -> Bool
esInteligente (Ladron "Profesor" _ _) = True
esInteligente (Ladron _ habilidades _) = (>= 2) . length $ habilidades

-- esInteligente unLadron(Ladron "Profesor" _ _) = True
-- esInteligente unLadron(Ladron _ habilidades _) = (2 <=) . length . habilidades $ unLadron    se puede hacer de esa manera o algo así?


-- ##################
-- ####### 3 ########
-- ##################

conseguirArma :: Arma -> Ladron -> Ladron
conseguirArma unArma unLadron = unLadron {
    armas = unArma : armas unLadron
}

-- ##################
-- ####### 4 ########
-- ##################
-- Que un ladrón intimide a un rehén, usando alguno de los métodos planeados
{-
¿¿Eso me pide la consigna??
ghci> disparos tokio pablo
Rehen {nombreRehen = "Pablo", complot = 20, miedo = 60, planContraLadrones = [<function>]}
-}


-- ##################
-- ####### 5 ########
-- ##################

-- Que un ladrón calme las aguas, disparando al techo frente a un grupo de rehenes, de los cuales se calman los que tengan más de 60 de complot.
-- Que se calme un rehen => complot = 0 || miedo = 0??



-- ##################
-- ####### 6 ########
-- ##################

puedeEscaparse :: Ladron -> Bool
--puedeEscaparse unLadron = any (== "Disfrazarse de") . map (take 14) . habilidades $ unLadron
puedeEscaparse unLadron = any ((== "Disfrazarse de") . take 14)  . habilidades $ unLadron 
--De estas 2 soluciones alguna te parece mejor?

-- ##################
-- ####### 7 ########
-- ##################

siLaCosaPintaMal :: [Ladron] -> [Rehen] -> Bool
siLaCosaPintaMal unosLadrones unosRehenes = ((nivelDeComplotPromedio $ unosRehenes) >) . (nivelDeMiedoPromedio unosRehenes *) . cantDeArmasTotales $ unosLadrones

cantDeArmasTotales :: [Ladron] -> Int
cantDeArmasTotales unosLadrones = sum . parametroDePersonas (length . armas) $ unosLadrones

parametroDePersonas :: (a -> Int) -> [a] -> [Int]
parametroDePersonas unaFuncion unasPersonas = map (unaFuncion) $ unasPersonas

nivelDeMiedoPromedio :: [Rehen] -> Int
nivelDeMiedoPromedio unosRehenes = sacarPromedio . parametroDePersonas miedo $ unosRehenes

nivelDeComplotPromedio :: [Rehen] -> Int
nivelDeComplotPromedio unosRehenes = sacarPromedio . parametroDePersonas complot $ unosRehenes

sacarPromedio :: [Int] -> Int
sacarPromedio valores = (flip div (length valores)) . sum $ valores

{-
Funciones hechas con lógica repetida
cantDeArmasTotales :: [Ladron] -> Int
cantDeArmasTotales unosLadrones = sum . map (length . armas) $ unosLadrones
en el resto era algo parecido, la logica de sacarPromedio la tenía ahí
Creo quedó bien, pero me tomó bastante tiempo, espero que esto mejore con la práctica
-}

-- ##################
-- ####### 8 ########
-- ##################

-- No entiendo que hay que hacer, solo sacarle 10 a todos los rehenes que tengamos?
-- O, tengo un grupo de rehenes, un ladron, y a ese ladron le aplico todos los planes de todos los rehenes. Previamente le bajo 10 de complot a cada rehen.
-- los rehenes pueden tener varios planes, no?


rehenesRevelanContraLadron :: [Rehen] -> RebelarseContraLadron
rehenesRevelanContraLadron unosRehenes unLadron = foldl (flip($)) unLadron . plan $ unosRehenes


aplicarPlanesContraUnLadron :: Plan -> RebelarseContraLadron --Hecho así para aplicarlo arriba sin el flip
aplicarPlanesContraUnLadron planes unLadron =  foldl (flip($)) unLadron planes

{-
[evento, evento, evento, evento] unaCiudad
evento $ unaCiudad

[unRehen, unRehen, unRehen, unRehen] unLadron
[[RebelarseContraLadron], [RebelarseContraLadron, RebelarseContraLadron]] unLadron

[RebelarseContraLadron] $ unLadron
[RebelarseContraLadron, RebelarseContraLadron] $ unLadron
-}


-- ##################
-- ####### 9 ########
-- ##################

planValencia :: [Ladron] -> [Rehen] -> Int
planValencia unosLadrones unosRehenes = (1000000 *) . cantDeArmasTotales . rehenesRevelanContraLadrones unosRehenes . ametralladoraATodos $ unosLadrones

ametralladoraATodos :: [Ladron] -> [Ladron]
ametralladoraATodos unosLadrones = map (conseguirArma (ametralladora 45)) $ unosLadrones

--quedaba muy largo poner "todosLosRehenesRevelanContraTodosLosLadrones"
rehenesRevelanContraLadrones :: [Rehen] -> [Ladron] -> [Ladron]
rehenesRevelanContraLadrones unosRehenes unosLadrones = 




-- ##################
-- ####### 10 #######
-- ##################


-- ##################
-- ####### 11 #######
-- ##################

{-
Sí porque esa lista de infinitas habilidades no interactúa con nuestra función, por lo que nunca se quedaría haciendo un cálculo infinito.
-}

-- ##################
-- ####### 12 #######
-- ##################

{-
funcion :: (a -> Bool) -> Int -> [a] -> String -> Bool
funcion cond num lista str = (> str) . sum . map (length . num) . filter (lista cond)
-}

--num = [a -> ??=]
