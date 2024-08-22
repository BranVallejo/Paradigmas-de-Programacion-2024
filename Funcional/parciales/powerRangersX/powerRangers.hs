import Text.Show.Functions
--Datas

-- #############
-- ##### 1 #####
-- #############

--a
data Persona = Persona {
    buena :: Bool,
    habilidadesPersona :: Habilidades
} deriving (Show)

type Color = String
type Habilidades = [String]

--b
data PowerRanger = PowerRanger {
    color :: Color,
    habilidadesPowerRanger :: Habilidades,
    nivelDePelea :: Int
} deriving (Show)

--Ejemplos
pablo :: Persona
pablo = Persona {
    buena = True,
    habilidadesPersona = ["Tiro lejano", "Salto vertical", "Barrida"]
}

jason :: Persona
jason = Persona {
    buena = True,
    habilidadesPersona = ["Liderazgo", "Artes marciales", "Trabajo en equipo"]
}

skull :: Persona
skull = Persona {
    buena = False,
    habilidadesPersona = ["Intimidación", "Pelear sucio", "Desobediencia"]
}

kimberly :: Persona
kimberly = Persona {
    buena = True,
    habilidadesPersona = ["Gimnasia", "Arquería", "Empatía"]
}

bulk :: Persona
bulk = Persona {
    buena = False,
    habilidadesPersona = ["Fuerza bruta", "Intimidación", "Desobediencia"]
}

ema :: PowerRanger
ema = PowerRanger {
    color = "Blanco",
    habilidadesPowerRanger = ["Super Patada", "Super Abrazo de oso", "Super caminata"],
    nivelDePelea = 8001
}

fernando :: PowerRanger
fernando = PowerRanger {
    color = "Rojo",
    habilidadesPowerRanger = ["Super velocidad", "Super adelantamiento"],
    nivelDePelea = 33
}


pablito :: PowerRanger
pablito = PowerRanger {
    color = "Morado",
    habilidadesPowerRanger = ["Super descenso", "Super fuego"],
    nivelDePelea = 2011
}

-- #############
-- ##### 2 #####
-- #############
convertirEnPowerRanger :: String -> Persona -> PowerRanger
convertirEnPowerRanger unColor unaPersona = PowerRanger {
    color = unColor,
    habilidadesPowerRanger = mejorarHabilidades $ unaPersona,
    nivelDePelea = calcularNivelDePelea $ unaPersona
}

convertirEnPowerRanger2 :: String -> Persona -> PowerRanger
convertirEnPowerRanger2 unColor unaPersona = PowerRanger unColor (mejorarHabilidades $ unaPersona) (calcularNivelDePelea $ unaPersona)

mejorarHabilidades :: Persona -> Habilidades
mejorarHabilidades unaPersona =  map ("Super " ++) . habilidadesPersona $ unaPersona

-- "Es más de 8000!" 0o0
calcularNivelDePelea :: Persona -> Int
calcularNivelDePelea unaPersona = length . concat . habilidadesPersona $ unaPersona


-- #############
-- ##### 3 #####
-- #############

-- ###############################################
-- ###############################################
-- #####     CLAVE ESTA FUNCION: ZIPWITH     #####
-- ###############################################
-- ###############################################
formarEquipoRanger :: [Color] -> [Persona] -> [PowerRanger]
formarEquipoRanger unosColores unasPersonas = zipWith convertirEnPowerRanger unosColores . filter esBueno $ unasPersonas

formarEquipoRanger2 :: [Color] -> [Persona] -> [PowerRanger]
formarEquipoRanger2 unosColores unasPersonas = zipWith convertirEnPowerRanger unosColores . filter buena $ unasPersonas
esBueno :: Persona -> Bool
esBueno unaPersona = buena $ unaPersona


-- #############
-- ##### 4 #####
-- #############

-- Se que existe la funcion find, y mi consola no la detecta, pero es bastante util
-- igual entiendo que el objetivo del ejercicio no es llamar a la funcion, sino desarrollarla
-- a)
findOrElse :: (b -> Bool) -> b -> [b] -> b
findOrElse unaCondicion unValor unaLista
    | or . map unaCondicion $ unaLista = head . filter unaCondicion $ unaLista
    | otherwise = unValor


-- b)
rangerLider :: [PowerRanger] -> PowerRanger
rangerLider unosRangers = findOrElse (serElRojo) (head $ unosRangers) $ unosRangers

serElRojo :: PowerRanger -> Bool
serElRojo unRanger = (== "Rojo") . color $ unRanger


-- #############
-- ##### 5 #####
-- #############

-- a)

maximumBy :: (Ord b) => (a -> b) -> [a] -> a
maximumBy unaFuncion [x] = x
maximumBy unaFuncion (x:y:xs)
    | (unaFuncion x) > (unaFuncion y) = maximumBy unaFuncion (x:xs)
    | otherwise = maximumBy unaFuncion (y:xs)

{-
Se entiene más así:

maximumBy :: (Ord b) => [a] -> (a -> b) -> a
maximumBy unaLista unaFuncion 

Pero lo cambie porque me era más útil
-}

-- b)

rangerMasPoderoso :: [PowerRanger] -> PowerRanger
rangerMasPoderoso unosRangers = maximumBy sacarPoder unosRangers

sacarPoder :: PowerRanger -> Int
sacarPoder unRanger = nivelDePelea $ unRanger




-- #############
-- ##### 6 #####
-- #############
rangerHabilidoso :: PowerRanger -> Bool
rangerHabilidoso unRanger = (5 < ). length . habilidadesPowerRanger $ unRanger


-- #############
-- ##### 7 #####
-- #############

-- A)
alfa5 :: PowerRanger
alfa5 = PowerRanger {
    color = "Metalico",
    nivelDePelea = 0,
    habilidadesPowerRanger = repeat "ay"
}

--B)
{-
Un caso donde no terminaría es en el uso de la función rangerHabilidoso ya que nunca terminaría
de contar las habilidades que tiene para verificar si son mayores a 5.
Donde sí funcionaría sería en alfa5 es serElRojo, o usarla en RangerLider.
-}

-- #############
-- ##### 8 #####
-- #############

data ChicaSuperPoderosa = ChicaSuperPoderosa {
    colorDelPelo :: String,
    cantidadDePelo :: Int
} deriving (Show)

bombon :: ChicaSuperPoderosa
bombon = ChicaSuperPoderosa {
    colorDelPelo = "Rojo",
    cantidadDePelo = 1414
}

burbuja :: ChicaSuperPoderosa
burbuja = ChicaSuperPoderosa {
    colorDelPelo = "Celeste",
    cantidadDePelo = 333
}

bellota :: ChicaSuperPoderosa
bellota = ChicaSuperPoderosa {
    colorDelPelo = "Verde",
    cantidadDePelo = 332
}

chicaLider :: [ChicaSuperPoderosa] -> ChicaSuperPoderosa
chicaLider unasChicas = findOrElse (serLaRoja) (head $ unasChicas) $ unasChicas

serLaRoja :: ChicaSuperPoderosa -> Bool
serLaRoja unaChica = (== "Rojo") . colorDelPelo $ unaChica