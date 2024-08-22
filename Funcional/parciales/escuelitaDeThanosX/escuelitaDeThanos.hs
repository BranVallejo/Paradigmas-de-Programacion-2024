import Text.Show.Functions

data Guantelete = Guantelete {
    materiales :: Material,
    gemas :: [Gema]
} deriving(Show)

--data Gema = alma | mente | espacio | poder | tiempo | gemaLoca deriving(Show)
type Gema = Personaje -> Personaje
data Material = Hierro | Uru | Goma deriving(Show, Eq)

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: [Habilidad],
    planetaDeOrigen :: Planeta
} deriving(Show)

type Habilidad = String

type Planeta = String
--data Planeta = "Tierra" | Saturno | Venus | Neptuno | Urano | Mercurio | Marte | Jupiter deriving(Show)
--Habilidad?

type Universo = [Personaje]

-- Definición de personajes
ironMan :: Personaje
ironMan = Personaje {
    nombre = "Tony Stark",
    edad = 48,
    energia = 100,
    habilidades = ["Inteligencia", "Tecnología avanzada", "Armadura"],
    planetaDeOrigen = "Tierra"
}

drStrange :: Personaje
drStrange = Personaje {
    nombre = "Stephen Strange",
    edad = 45,
    energia = 90,
    habilidades = ["Magia", "Manipulación del tiempo", "Teletransportación"],
    planetaDeOrigen = "Tierra"
}

groot :: Personaje
groot = Personaje {
    nombre = "Groot",
    edad = 25,
    energia = 80,
    habilidades = ["Fuerza sobrehumana", "Regeneración", "Control de árboles", "Soy Groot"],
    planetaDeOrigen = "Marte"
}

wolverine :: Personaje
wolverine = Personaje {
    nombre = "Logan",
    edad = 137,
    energia = 85,
    habilidades = ["Regeneración", "Esqueletos y garras de adamantium", "Sentidos agudizados"],
    planetaDeOrigen = "Tierra"
}

viudaNegra :: Personaje
viudaNegra = Personaje {
    nombre = "Natasha Romanoff",
    edad = 35,
    energia = 75,
    habilidades = ["Espionaje", "Artes marciales", "Agilidad"],
    planetaDeOrigen = "Tierra"
}

spiderman :: Personaje
spiderman = Personaje {
    nombre = "Peter Parker",
    edad = 18,
    energia = 85,
    habilidades = ["Agilidad", "Reflejos", "Lanzar telaranias", "Sentido aracnido"],
    planetaDeOrigen = "Tierra"
}


--Guantes
guanteDeThanos = Guantelete {
    materiales = Uru,
    gemas = [alma "telarañas", mente 10000, espacio "Marte", poder, tiempo, gemaLoca (alma "telarañas")]
}

guanteIncompleto = Guantelete {
    materiales = Uru,
    gemas = [alma "telarañas", poder, tiempo]
}

--Universos

universo42 = [ironMan, wolverine, viudaNegra, groot, drStrange]
universoViejos = [ironMan, wolverine, drStrange]

-- ##################
-- ####### 1 ########
-- ##################

--- no tiene las 6 gemas | no uru | heries par | heroes impar

chasquido :: Guantelete -> Universo -> Universo
chasquido unGuantelete unUniverso 
    | guanteleteListo unGuantelete = reducirUniversoALaMitad unUniverso
    | otherwise = unUniverso

guanteleteListo :: Guantelete -> Bool
guanteleteListo unGuantelete = guanteleCompleto unGuantelete && materiales unGuantelete == Uru

guanteleCompleto :: Guantelete -> Bool
guanteleCompleto unGuantelete = (== 6) . length . gemas $ unGuantelete

reducirUniversoALaMitad :: Universo -> Universo
reducirUniversoALaMitad unUniverso = take (mitadUniverso unUniverso) unUniverso

mitadUniverso :: Universo -> Int
mitadUniverso unUniverso = (flip div 2) . length $ unUniverso

-- prueba del 1 | funciona
-- ghci> chasquido guanteDeThanos universo42 

-- ##################
-- ####### 2 ########
-- ##################

aptoParaPendex :: Universo -> Bool
aptoParaPendex unUniverso = any esPendex unUniverso

esPendex :: Personaje -> Bool
esPendex = (< 45) . edad

-- [ironman, drStrange, Spiderman]

energiaDelUniverso :: Universo -> Int
energiaDelUniverso unUniverso = sum . map (energia) $ unUniverso

-- ##################
-- ####### 3 ########
-- ##################

-- type Gema = Personaje -> Personaje
-- alma | mente | espacio | poder | tiempo | gemaLoca
{-
mente :: Int -> Gema
mente 10 :: Gema
gemas :: [Gema]
-}

mente :: Int -> Gema
mente valor unPersonaje = quitarEnergia valor $ unPersonaje

quitarEnergia :: Int -> Gema
quitarEnergia energiaPerdida unPersonaje = unPersonaje {
    energia = energia unPersonaje - energiaPerdida
}

alma :: Habilidad -> Gema
alma habilidad unPersonaje = quitarEnergia 10 . quitarHabilidad habilidad $ unPersonaje

quitarHabilidad :: Habilidad -> Gema
quitarHabilidad habilidad unPersonaje = unPersonaje {
    habilidades = filter (/= habilidad) (habilidades unPersonaje)
}

espacio :: Planeta -> Gema
espacio unPlaneta unPersonaje = quitarEnergia 20 . cambiarPlaneta unPlaneta $ unPersonaje

cambiarPlaneta :: Planeta -> Gema
cambiarPlaneta unPlaneta unPersonaje = unPersonaje {
    planetaDeOrigen = unPlaneta
}

poder :: Gema
poder unPersonaje = quitarEnergia (energia unPersonaje) . quitarHabilidades $ unPersonaje

quitarHabilidades :: Gema
quitarHabilidades unPersonaje
    | (<= 2) . length . habilidades $ unPersonaje = unPersonaje {habilidades = []} 
    | otherwise = unPersonaje

tiempo :: Gema
tiempo unPersonaje = quitarEnergia 50 . reducirEdad $ unPersonaje

reducirEdad :: Gema
reducirEdad unPersonaje
    | (< 18). (flip div 2) . edad $ unPersonaje = unPersonaje {edad = 18}
    | otherwise = unPersonaje {edad = (flip div 2) . edad $ unPersonaje}

--porque cuando hago eso no funciona
{-
gemaLoca :: Personaje -> Gema -> Gema
gemaLoca unPersonaje unaGema = unaGema . unaGema $ unPersonaje
-}
gemaLoca :: Gema -> Gema
gemaLoca unaGema = unaGema . unaGema

-- ##################
-- ####### 4 ########
-- ##################

guanteDeCocina = Guantelete {
    materiales = Goma,
    gemas = [alma "Quitar Mjolnir", gemaLoca (alma "programacion en Haskell")]
}

-- ##################
-- ####### 5 ########
-- ##################

-- DUDA
-- Con "utilizar :: [Gema] -> Gema" también funciona, pero no es una gema
-- todos los Personaje -> Personaje, deberia cambiarlos poer Gema??

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas unEnemigo = foldl (flip($)) unEnemigo gemas

-- ##################
-- ####### 6 ########
-- ##################

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa unGuantelete unaPersona = gemaMasFuerte unaPersona . gemas $ unGuantelete

gemaMasFuerte :: Personaje -> [Gema] -> Gema
gemaMasFuerte unaPersona [x] = x
gemaMasFuerte unaPersona (x:y:xs)
    | (energia . x $ unaPersona) > (energia . y $ unaPersona) = gemaMasFuerte unaPersona (x:xs)
    | otherwise = gemaMasFuerte unaPersona (y:xs)

