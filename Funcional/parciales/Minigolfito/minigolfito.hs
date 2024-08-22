import Text.Show.Functions

--datas

-- Modelo inicial
data Jugador = Jugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Int,
  precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = Tiro {
  velocidad :: Int,
  precision :: Int,
  altura :: Int
} deriving (Eq, Show)

tiroVeloz :: Tiro
tiroVeloz = Tiro {
    velocidad = 100,
    precision = 700,
    altura = 0
}

type Puntos = Int

-- Funciones útiles

between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


-- ###########
-- #####1#####
-- ###########
type Palo = Habilidad -> Tiro

--A)
-- 3 formas de hacer un putter
--fav
putter :: Palo
putter unaHabilidad = Tiro 10 (precisionJugador unaHabilidad * 2) 0

--putter (Habilidad fuerzaJugador precisionJugador) = Tiro 10 (precisionJugador*2) 0
 
{-
putter (Habilidad fuerzaJugador precisionJugador) = Tiro {
    velocidad = 10,
    precision = precisionJugador * 2,
    altura = 0
}
-}

madera :: Palo
madera unaHabilidad = Tiro 100 (div (precisionJugador unaHabilidad) 2) 5

hierro :: Int -> Palo
hierro numero unaHabilidad = Tiro (fuerzaJugador unaHabilidad * numero) (div (precisionJugador unaHabilidad) numero) (numero - 3)

--B)
palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

-- ###########
-- #####2#####
-- ###########

golpe :: Jugador -> Palo -> Tiro
golpe unJugador unPalo = unPalo . habilidad $ unJugador

-- ###########
-- #####3#####
-- ###########
--Forma genérica de modificar. Puedo agregar, quitar, subir o bajar porcentualmente.
modificarVelocidad :: (Int -> Int) -> Tiro -> Tiro
modificarVelocidad unaFuncion unTiro = Tiro (unaFuncion $ velocidad unTiro) (precision unTiro) (altura unTiro)

modificarPrecision :: (Int -> Int) -> Tiro -> Tiro
modificarPrecision unaFuncion unTiro = Tiro (velocidad unTiro) (unaFuncion $ precision unTiro) (altura unTiro)

modificarAltura :: (Int -> Int) -> Tiro -> Tiro
modificarAltura unaFuncion unTiro = Tiro (velocidad unTiro) (precision unTiro) (unaFuncion $ altura unTiro)

tiroDetenido :: Tiro -> Tiro
tiroDetenido unTiro = Tiro 0 0 0



type Obstaculo = Tiro -> Tiro

type Condicion = Tiro -> Bool

type Consecuencia = Tiro -> Tiro

superarObstaculo :: Condicion -> Consecuencia -> Obstaculo
superarObstaculo condicionesObstaculo consecuenciasObstaculo unTiro
    | condicionesObstaculo $ unTiro = consecuenciasObstaculo unTiro
    | otherwise = tiroDetenido unTiro


condicionesTunel :: Condicion
condicionesTunel unTiro = 90 <  precision unTiro && altura unTiro == 0

consecuenciasTunel :: Consecuencia
consecuenciasTunel unTiro = modificarAltura (const 0). modificarPrecision (const 100). modificarVelocidad (*2) $ unTiro

tunelConRampita :: Obstaculo
tunelConRampita unTiro = superarObstaculo condicionesTunel consecuenciasTunel unTiro

--B)

laguna :: Int -> Obstaculo
laguna largoDeLaguna unTiro = superarObstaculo condicionesLaguna (consecuenciasLaguna largoDeLaguna) $ unTiro

condicionesLaguna :: Condicion
condicionesLaguna unTiro = 80 <  velocidad unTiro && between 1 5 (altura unTiro)

consecuenciasLaguna :: Int -> Consecuencia
consecuenciasLaguna largoDeLaguna unTiro = modificarAltura (flip div largoDeLaguna) $ unTiro

--C)
hoyo :: Obstaculo
hoyo unTiro = superarObstaculo condicionesHoyo consecuenciasHoyo unTiro

condicionesHoyo :: Condicion
condicionesHoyo unTiro = 95 <  precision unTiro && altura unTiro == 0 && between 5 20 (velocidad unTiro)

consecuenciasHoyo :: Consecuencia
consecuenciasHoyo unTiro = tiroDetenido unTiro



-- #############
-- ##### 4 #####
-- #############
--A)
palosUtiles :: Jugador -> Obstaculo -> Palo
palosUtiles unaPersona unObstaculo = 