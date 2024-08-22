import Text.Show.Functions

data Auto = Auto{
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving(Show)

data Carrera = Carrera {
    circuito :: String,
    corredores :: [Auto]
} deriving(Show)

alonso :: Auto
alonso = Auto{
    color = "Verde",
    velocidad = 333,
    distancia = 143
}

verstappen :: Auto
verstappen = Auto {
    color = "Azul",
    velocidad = 330,
    distancia = 132
}


leclerc :: Auto
leclerc = Auto {
    color = "Rojo",
    velocidad = 328,
    distancia = 128
}

-- #############
-- ##### 1 #####
-- #############
type SituacionDePilotoEnCarrera = [Auto] -> Bool

-- A)
estaCerca :: Auto -> Auto -> Bool
estaCerca unAuto otroAuto = (10 >) . distanciaEntreAutos otroAuto $ unAuto

distanciaEntreAutos :: Auto -> Auto -> Int
distanciaEntreAutos unAuto otroAuto = abs . (distancia otroAuto - ) . distancia $ unAuto

-- B)
vaTranquilo :: Auto -> SituacionDePilotoEnCarrera
vaTranquilo unAuto unosAutos = (vaGanando unAuto $ unosAutos) && (estaSolo unAuto $ unosAutos) 

-- Se puede hacer con composición?

vaGanando :: Auto -> SituacionDePilotoEnCarrera
vaGanando unAuto unosAutos = and . map (estaAdelante unAuto) $ unosAutos --Se puede escribir esto haciendo que lo de la deracha del $ sea unAuto?

estaAdelante :: Auto -> Auto -> Bool
estaAdelante unAuto otroAuto =  (distancia otroAuto < ) . distancia $ unAuto

estaSolo :: Auto -> SituacionDePilotoEnCarrera
estaSolo unAuto unosAutos =  not . or . map (estaCerca unAuto) $ unosAutos

{-
 Iba a hacer el 1 con un data donde carrera tenga una lista de autos, pero despues me di
 cuenta que el piloto que estoy comparando también tendŕia que estar ahí dentro
 por lo que tendría que hacer que se saltee en las comparaciones. por ejemplo puedo
 creer que está con otro piloto cabeza a cabeza, pero es él mismo. Asi que me fui por lo mas
 simple que es una lista de Autos
-}

-- C)
puesto :: Auto -> [Auto] -> Int
puesto unAuto unosAutos = (1 +) . length . filter (== False) . map (estaAdelante unAuto) $ unosAutos

--No usé el data carreras, pero decía que los use como mejor me parezca y fue así
-- ¿Hay problemas?

-- #############
-- ##### 2 #####
-- #############
--A

type AfectarAuto = Auto -> Auto

corra :: Int -> AfectarAuto
corra unTiempo unAuto = unAuto {
    distancia = (unTiempo * (velocidad unAuto) +) . distancia $ unAuto 
}

--B ) I)


-- Mi modo

--me confunde el hecho de que dice alterar y yo la estoy subiendo, está bien?
-- me haceRuido que no estoy usando el int->int, AHHH creo que "un modificador de tipo Int -> Int"
-- se refiere a las operaciones suma y resta, no? porque van de Int -> Int, si usas las usas con int y de forma parcial
-- Al final no estaba tan erradas mis conclusiones, pero ejecuté mal
alterarLaVelocidad :: (Int -> Int) -> AfectarAuto 
alterarLaVelocidad modificador unAuto = unAuto {
    velocidad = modificador . velocidad $ unAuto
}

bajarLaVelocidad :: (Int -> Int -> Int) -> Int -> AfectarAuto
bajarLaVelocidad modificador unaVelocidad unAuto 
    | (0 <) . (`-`unaVelocidad ) . unaVelocidad $ unAuto = 
    | otherwise = alterarLaVelocidad (- unaVelocidad) unAuto

-- Función auxiliar para reducir la velocidad utilizando guardas
reducir :: Int -> Int -> Int
reducir cantidad velocidad 
    | velocidad - cantidad > 0 = velocidad - cantidad
    | otherwise                = 0

-- Función para reducir la velocidad de un auto sin permitir que sea negativa
reducirVelocidad :: Int -> Auto -> Auto
reducirVelocidad cantidad = alterarVelocidad (reducir cantidad)



