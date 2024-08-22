import Lib
import Text.Show.Functions


data Ciudad = Ciudad {
    nombre :: String,
    anioDeFundacion :: Float,
    atraccionesPrincipales :: [String],
    costoDeVida :: Float
} deriving (Show, Eq)

--Ciudades

buenosAires :: Ciudad
buenosAires = Ciudad {
    nombre = "Buenos Aires",
    anioDeFundacion = 1536,
    atraccionesPrincipales = ["Obelisco", "Guerrin", "La Boca", "El monumental"],
    costoDeVida = 2000
}

baradero :: Ciudad
baradero = Ciudad {
    nombre = "Baradero",
    anioDeFundacion = 1615,
    atraccionesPrincipales = ["Parque del Este", "Museo Alejando Barbich"],
    costoDeVida = 150
}

nullish :: Ciudad
nullish = Ciudad {
    nombre = "Nullish",
    anioDeFundacion = 1800,
    atraccionesPrincipales = [],
    costoDeVida = 140
}

caletaOlivia :: Ciudad
caletaOlivia = Ciudad {
    nombre = "Caleta Olivia",
    anioDeFundacion = 1901,
    atraccionesPrincipales = ["El Gorosito", "Faro Costanera"],
    costoDeVida = 120
}

maipu :: Ciudad 
maipu = Ciudad {
    nombre = "Maipu",
    anioDeFundacion = 1878,
    atraccionesPrincipales = ["Fortin Kakel"],
    costoDeVida = 115
}

azul :: Ciudad
azul = Ciudad {
    nombre = "Azul",
    anioDeFundacion = 1832,
    atraccionesPrincipales = ["Teatro Espanol", "Parque Municipal Sarmiento", "Costanera Cacique Catriel"],
    costoDeVida = 190
}

-- Crear años
data Anio = Anio {
    numero :: Int,
    eventos :: [Evento]
} deriving (Show)
--Tipo Evento
type Evento = Ciudad -> Ciudad

veinteVeintiuno :: Anio
veinteVeintiuno = Anio {
    numero = 2021,
    eventos = [crisis, nuevaAtraccion "playa"]
}

veinteVeintidos :: Anio
veinteVeintidos = Anio {
    numero = 2022,
    eventos = [crisis, remodelacion 5, reevaluacion 7]
}

dosMilQuince :: Anio
dosMilQuince = Anio {
    numero = 2015,
    eventos = []
}

veinteVeintitres :: Anio
veinteVeintitres = Anio {
    numero = 2023,
    eventos = [crisis, nuevaAtraccion "parque", remodelacion 10, remodelacion 20]
}
{-
veinteVeinticuatro :: Anio
veinteVeinticuatro = Anio {
    numero = 2023,
    eventos = []
}
-}



--Saber si el año 2023 que tiene los siguientes eventos:
-- crisis, agregar como atracción "parque", hacer una remodelación al 10%, y hacer una remodelación al 20%, sobre Azul tiene los eventos ordenados.
--1

valorDeLaCiudad :: Ciudad -> Float

valorDeLaCiudad ciudad
    | anioDeFundacion ciudad < 1800 = 5 * (1800 - (anioDeFundacion ciudad))
    | null (atraccionesPrincipales ciudad) = (costoDeVida ciudad) * 2.0
    | otherwise = (costoDeVida ciudad) * 3.0

--2
-- Alguna atraccion copada
esVocal :: Char -> Bool
esVocal letra = elem letra "aeiouAEIOU"

primeraLetraVocal :: String -> Bool
primeraLetraVocal = esVocal . head

algunaAtraccionCopada :: Ciudad -> Bool
algunaAtraccionCopada ciudad = any primeraLetraVocal (atraccionesPrincipales ciudad)

--Ciudad Sobria

palabraConMasLetras :: String -> Int -> Bool
palabraConMasLetras palabra letras = length palabra > letras

-- Quieren que hagamos esto de ponerle nosotros la cant de letras?
-- Ahora que leo el punto Reevaluacion, me parece que lo que hice encaja más con reevaluación

ciudadSobria :: Ciudad -> Int -> Bool
ciudadSobria ciudad numero = all ( `palabraConMasLetras` numero) (atraccionesPrincipales ciudad)

--Ciudad Con nombre Raro

palabraConMenosLetras :: String -> Int -> Bool
palabraConMenosLetras palabra letras = length palabra < letras

ciudadConNombreRaro :: Ciudad -> Bool
ciudadConNombreRaro ciudad = (nombre ciudad) `palabraConMenosLetras` 5


--3 --EVENTOS

nuevaAtraccion ::  String -> Ciudad -> Ciudad

nuevaAtraccion atraccion ciudad = ciudad {
    atraccionesPrincipales = atraccion : (atraccionesPrincipales ciudad),
    costoDeVida = costoDeVida ciudad * 1.20
    }

-- Crisis en ciudades infinitas

quitarUltimo :: [a] -> [a]
quitarUltimo [] = []        --esto es para cuando no hay atracciones ==> Lista vacía
quitarUltimo [_] = []       --para borrar el ultimo elemento
quitarUltimo (x:xs) = x : quitarUltimo xs


crisis :: Ciudad -> Ciudad
crisis ciudad = ciudad {
    atraccionesPrincipales = quitarUltimo (atraccionesPrincipales ciudad),
    costoDeVida = costoDeVida ciudad * 0.9
    }


--Remodelacion

-- ¿Cómo pasar de tener "50%" a "1.5" para usarlo en la multiplicacion?
--( 50 / 100 ) + 1              Divido por 100 y sumo 1
--debe haber una forma mejor, ahora no se me ocurre

remodelacion :: Float -> Ciudad -> Ciudad
-- Le puse float porque no me dejaba hacer la división
remodelacion porcentajeDeMejora ciudad = ciudad {
    nombre = "New " ++ nombre ciudad,
    costoDeVida = costoDeVida ciudad * ((porcentajeDeMejora/100)+1)
}


--Reevaluacion
--Ciudad sobria está hecha arriba
reevaluacion :: Int -> Ciudad -> Ciudad
reevaluacion cantLetras ciudad
    | ciudadSobria ciudad cantLetras = ciudad { costoDeVida = costoDeVida ciudad * 1.1}
    | otherwise = ciudad { costoDeVida = costoDeVida ciudad - 3}


--4
{-
    - Nueva Atraccion:
        ghci> nuevaAtraccion "la bombonera" buenosAires
        Ciudad {nombre = "Buenos Aires", anioDeFundacion = 1536.0, atraccionesPrincipales = ["la bombonera","Obelisco","Guerrin","La Boca","El monumental"], costoDeVida = 2400.0}
    - Remodelacion:
        ghci> remodelacion 25 buenosAires
        Ciudad {nombre = "New Buenos Aires", anioDeFundacion = 1536.0, atraccionesPrincipales = ["Obelisco","Guerrin","La Boca","El monumental"], costoDeVida = 2500.0}
    - Crisis:
        ghci> crisis buenosAires
        Ciudad {nombre = "Buenos Aires", anioDeFundacion = 1536.0, atraccionesPrincipales = ["Obelisco","Guerrin","La Boca"], costoDeVida = 1800.0}
    - Reevaluacion
        ghci> reevaluacion 10 buenosAires
        Ciudad {nombre = "Buenos Aires", anioDeFundacion = 1536.0, atraccionesPrincipales = ["Obelisco","Guerrin","La Boca","El monumental"], costoDeVida = 1997.0}
-}

--  5.1 Los años pasan...

-- Función losAniosPasan utilizando foldr
losAniosPasan :: Anio -> Ciudad -> Ciudad
losAniosPasan anio ciudad = foldl (flip ($)) ciudad (eventos anio)


--  5.2 Algo mejorfoldl

--Defino el tipo Criterio
type Criterio = Evento -> Ciudad -> Bool

--algunos criterios de comparacion podrian ser:

cantidadDeAtracciones:: Ciudad -> Int
cantidadDeAtracciones = length . atraccionesPrincipales 

largoNombreCiudad:: Ciudad -> Int
largoNombreCiudad = length . nombre  

mejoraCostoDeVida :: Criterio
mejoraCostoDeVida evento ciudad = (costoDeVida ciudad <)  . costoDeVida . evento $ ciudad  --revisa el costo de vida

mejoraAtraccionesPrincipales :: Criterio
mejoraAtraccionesPrincipales evento ciudad = (cantidadDeAtracciones ciudad) <  (cantidadDeAtracciones . evento $ ciudad) --revisa la cant de atracciones y las compara

mejoraNombre :: Criterio
mejoraNombre evento ciudad = (largoNombreCiudad ciudad) <  (largoNombreCiudad . evento $ ciudad) --revisa quien tiene el nombre más largo

--Funcion Algo Mejor
algoMejor :: Criterio -> Evento -> Ciudad -> Bool
algoMejor criterio evento ciudad = criterio evento ciudad

--  5.3 Costo de vida que suba

--Funcion que revisa si al aplicar un evento aumenta el costo de vida
aumentaAlAplicarEvento :: Ciudad -> Evento -> Bool
aumentaAlAplicarEvento ciudad evento = (costoDeVida . evento $ ciudad) > costoDeVida ciudad

--Funcion Costo de Vida que suba
costoDeVidaQueSuba:: Anio-> Ciudad -> Ciudad
costoDeVidaQueSuba anio ciudad = aplicarEventoSegunCriterio aumentaAlAplicarEvento ciudad anio --Con Foldl

aplicarEventoSegunCriterio :: (Ciudad -> Evento -> Bool) -> Ciudad -> Anio -> Ciudad
aplicarEventoSegunCriterio criterio ciudad anio = (foldl (flip ($)) ciudad ) . filter (criterio ciudad) . eventos $ anio --Con Foldl

-- 5.4 Costo De Vida que baje

disminuyeAlAplicarEvento :: Ciudad -> Evento -> Bool
disminuyeAlAplicarEvento unaCiudad unEvento = not . aumentaAlAplicarEvento unaCiudad $ unEvento

costoDeVidaQueBaje:: Anio-> Ciudad -> Ciudad
costoDeVidaQueBaje anio ciudad = aplicarEventoSegunCriterio disminuyeAlAplicarEvento ciudad anio --Con Foldl

-- 5.5 Valor Que Suba
aumentaElValor :: Ciudad -> Evento -> Bool
aumentaElValor ciudad evento = (valorDeLaCiudad . evento $ ciudad) > valorDeLaCiudad ciudad

valorQueSuba :: Anio -> Ciudad -> Ciudad
valorQueSuba anio ciudad = aplicarEventoSegunCriterio aumentaElValor ciudad anio

--6.1 Eventos ordenados

eventosOrdenados :: Anio -> Ciudad -> Bool
eventosOrdenados anio unaCiudad = (estaOrdenadoDeMenorAMayor ($ unaCiudad)) . eventos $ anio

{-
estaOrdenadoDeMenorAMayor :: (b -> Ciudad) -> [b] -> Bool
estaOrdenadoDeMenorAMayor ($ unaCiudad) [eventos]
-}
estaOrdenadoDeMenorAMayor :: (b -> Ciudad) -> [b] -> Bool
estaOrdenadoDeMenorAMayor funcion listaDeElementos = estaOrdenadoDeMenorAMayorNumeros . (map (costoDeVida . funcion)) $ listaDeElementos

estaOrdenadoDeMenorAMayorNumeros :: [Float] -> Bool
estaOrdenadoDeMenorAMayorNumeros [] = False
estaOrdenadoDeMenorAMayorNumeros [_] = True
estaOrdenadoDeMenorAMayorNumeros (x:y:xs) = x < y && estaOrdenadoDeMenorAMayorNumeros (y:xs)



-- 6.2 Ciudades ordenadas
ciudadesOrdenadas :: Evento -> [Ciudad] -> Bool
ciudadesOrdenadas evento ciudades = estaOrdenadoDeMenorAMayor evento ciudades
{-
                                            *como no hacerlo*
    | ((== 0) . length ) $ ciudades = False
    | ((== 1) . length ) $ ciudades = True
    | parDeCiudadesOrdenadas (evento (head ciudades)) (evento (ciudades !! 1)) evento = ciudadesOrdenadas evento (menosUnaCiudad ciudades)
    | otherwise = False
-}
--6.3 Años ordenados
aniosOrdenados :: [Anio] -> Ciudad -> Bool
aniosOrdenados unosAnios ciudad = estaOrdenadoDeMenorAMayor (aplicarEventosDeUnAnio ciudad) unosAnios

aplicarEventosDeUnAnio :: Ciudad -> Anio -> Ciudad
aplicarEventosDeUnAnio unaCiudad unAnio = foldl (flip ($)) unaCiudad (eventos unAnio)

--  7 Al infinito, y más allá...

-- Eventos 

-- Función para obtener el siguiente porcentaje de remodelación
siguientePorcentaje :: Float -> Float
siguientePorcentaje p = p + 1

-- Año 2024 con eventos
veinteVeinticuatro :: Anio
veinteVeinticuatro = Anio {
    numero = 2024,
    eventos = crisis : reevaluacion 7 : map remodelacion (iterate siguientePorcentaje 0)
}

-- Ciudades ordenadas
discoRayado :: [Ciudad]
discoRayado = [azul, nullish] ++ cycle[caletaOlivia, baradero]

-- Años ordenados
laHistoriaSinFin :: [Anio]
laHistoriaSinFin = [veinteVeintiuno,veinteVeintidos] ++ repeat veinteVeintitres


{-Teorico 7.1
¿Puede haber un resultado posible para la función del punto 6.1 (eventos ordenados) para el año 2024?
Justificarlo relacionándolo con conceptos vistos en la materia.


En el caso de anio 2024, en la secuencia de reevaluacion 7 a remodelacion del 1% es menor al anterior. 
Por lo tanto si se puede aplicar y da un resultado posible False. Esto es debido a que por mas que sea
una lista infita, la evaluacion perezosa que aplica haskell en el momento que encuentra un motivo lo hace, y lo corta.
-}

{-Teorico 7.2
Mismo caso en sentido de evaluacion perezosa de haskell, evalua hasta cierto punto que condiciona el resultado.
En caso de que la lista esté ordenada, se quedaría evaluando infinitamente. 
Si está desordenada buscaría el primer caso donde no cumpla la condición y sería False. -}


{-Teorico 7.3
En este caso al evaluar en la funcion AniosOrdenados, tiene que haber un orden creciente en cuanto al costo de vida, osea que el anterior
anio sea menor que el siguiente(debido a los eventos). Segun lo propuesto en la HistoriaSinFin aunque 2021 y 2022 sean  crecientes, como 2023 se repetira 
infinitamente nunca el anterior anio va ser estrictamente menor que el siguiente lo cual me llevaria a una solucion que seria False.
-}