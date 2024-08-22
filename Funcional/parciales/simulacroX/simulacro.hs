data Auto = Auto {
    marca :: String,
    modelo :: String,
    desgastes :: Desgaste,
    velocidadMaxima :: Float,
    tiempoDeCarrera :: Float
} deriving(Show)

type Desgaste = (Float, Float)


-- #########
-- ####1####
-- #########
ferrari :: Auto
ferrari = Auto {
    marca = "Ferrari",
    modelo = "F50",
    desgastes = (0,0),
    velocidadMaxima = 65,
    tiempoDeCarrera = 0
}

lamborghini :: Auto
lamborghini = Auto {
    marca = "lamborghini",
    modelo = "Diablo",
    desgastes = (7,4),
    velocidadMaxima = 65,
    tiempoDeCarrera = 0
}

fiat :: Auto
fiat = Auto {
    marca = "Fiat",
    modelo = "600",
    desgastes = (33,27),
    velocidadMaxima = 44,
    tiempoDeCarrera = 0
}


autoDeJuguete :: Auto
autoDeJuguete = Auto {
    marca = "HotWheels",
    modelo = "Rojo",
    desgastes = (100,100),
    velocidadMaxima = 20,
    tiempoDeCarrera = 0
}

-- #########
-- ####2####
-- #########

buenEstado :: Auto -> Bool
buenEstado unAuto = ((60 >). snd. desgastes $ unAuto) && ((40 >). fst. desgastes $ unAuto)

noDaMas :: Auto -> Bool
noDaMas unAuto = ((80 <). snd. desgastes $ unAuto) || ((80 <). fst. desgastes $ unAuto)


-- #########
-- ####3####
-- #########
type AfectarAuto = Auto -> Auto
afectarRuedas :: Float -> AfectarAuto
afectarRuedas unNumero unAuto =  unAuto {desgastes = (unNumero * fst (desgastes unAuto), snd (desgastes unAuto))}



afectarChasis :: Float -> AfectarAuto
afectarChasis unNumero unAuto =  unAuto {desgastes = (fst (desgastes unAuto), unNumero * snd (desgastes unAuto))}
--Debe haber una forma mas prolija de hacer eso, pero no la recuerdo

repararAuto :: AfectarAuto
repararAuto = afectarRuedas 0 . afectarChasis 0.15



-- #########
-- ####4####
-- #########
data Pista = Pista {
    nombre :: String,
    partes :: [ParteDeLaPista]
} 

--type ParteDeLaPista = AfectarAuto
type ParteDeLaPista = Auto -> Auto

-- A)
curva :: Float -> Float -> ParteDeLaPista
curva unAngulo unaLongitud unAuto = sumarTiempo(unaLongitud / (velocidadMaxima unAuto /2))  . afectarRuedas (3 * unaLongitud /unAngulo)  $ unAuto 

sumarTiempo :: Float -> AfectarAuto
sumarTiempo unTiempo unAuto = unAuto {tiempoDeCarrera = tiempoDeCarrera unAuto + unTiempo}

curvaPeligrosa :: ParteDeLaPista
curvaPeligrosa = curva 60 300

curvaTranca :: ParteDeLaPista
curvaTranca = curva 110 550

--B)
recta :: Float -> ParteDeLaPista
recta unaLongitud unAuto =  sumarTiempo (unaLongitud / velocidadMaxima unAuto ) . afectarChasis (unaLongitud * 0.01) $ unAuto

tramoRectoClassic :: ParteDeLaPista
tramoRectoClassic = recta 750

tramito :: ParteDeLaPista
tramito = recta 280

--C)

box :: ParteDeLaPista -> AfectarAuto
box tramo unAuto 
    | buenEstado unAuto = tramo unAuto
    | otherwise =  sumarTiempo 10. repararAuto $ unAuto

--D)



--E)
ripio :: ParteDeLaPista -> ParteDeLaPista
ripio parte = parte . parte

--Main> ripio (tramito) lamborghini

-- F)
tramoConObstruccion :: Float -> ParteDeLaPista -> ParteDeLaPista
tramoConObstruccion tamañoDeLaObstruccion tramo = afectarRuedas( 2 * tamañoDeLaObstruccion) . tramo 



-- #########
-- ####5####
-- #########

pasarPorTramo :: ParteDeLaPista -> AfectarAuto
pasarPorTramo tramo unAuto
    | not . noDaMas $ unAuto = tramo unAuto
    | otherwise = unAuto

-- #########
-- ####6####
-- #########
--A)
--
superPista :: Pista
superPista = Pista {
    nombre = "superPista",
    partes = [tramoRectoClassic, curvaTranca, tramito, tramito, curva 80 400, curva 115 650, recta 970, curvaPeligrosa, ripio tramito, box (recta 800)]
}

{-
tramoRectoClassic
curvaTranca
2 tramitos consecutivos, pero el primero está mojado
Curva con ángulo de 80º, longitud 400m; con obstrucción de 2m
Curva con ángulo de 115º, longitud 650m
Tramo recto de 970m
curvaPeligrosa
tramito con ripio
Boxes con un Tramo Recto de 800m

-}

darUnaVuelta :: Pista -> AfectarAuto
darUnaVuelta unaPista unAuto = foldl (flip($)) unAuto (partes unaPista)

--pasarSiPuede funcion que haga el $ si el auto puede

peganLaVuelta :: Pista -> [Auto] -> [Auto]
peganLaVuelta unaPista = map (darUnaVuelta unaPista)
--peganLaVuelta unaPista unosAutos = map (darUnaVuelta unaPista) unosAutos


-- #########
-- ####7####
-- #########

data Carrera = Carrera{
    nombrecarrera :: String,
    circuito :: Pista,
    vueltas :: Int
} 


tourDeBuenosAires :: Carrera
tourDeBuenosAires = Carrera{
    nombrecarrera = "Gran Premio de Buenos Aires 2024",
    circuito = superPista,
    vueltas = 20
} 