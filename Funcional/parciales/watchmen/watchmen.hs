import Text.Show.Functions

algunosVigilantes :: [Vigilante]
algunosVigilantes = [elComediante, buhoNocturno0, rorschach, espectroDeSeda0,ozimandias,buhoNocturno0,espectroDeSeda1]

data Vigilante = Vigilante {
    nombre :: Nombre,
    habilidades :: [String],
    momentoDeAparicion :: Int,
    estaActivo :: Bool,
    esAgenteDelGobierno :: Bool
}

type Nombre = String

elComediante = Vigilante "El Comediante" ["Fuerza"] 1942 True True
buhoNocturno0 = Vigilante "Buho Nocturno" ["Lucha", "Ingenierismo"] 1963 True False
rorschach = Vigilante "Rorschach" ["Perseverancia", "Deduccion", "Sigilo"] 1964 True False
espectroDeSeda0 = Vigilante "Espectro de Seda" ["Lucha", "Sigilo", "Fuerza"] 1962 True False
ozimandias = Vigilante "Ozimandias" ["Inteligencia", "Más Inteligencia Aún"] 1968 True False
buhoNocturno1 = Vigilante "Buho Nocturno" ["Lucha", "Inteligencia", "Fuerza"] 1939 True False
espectroDeSeda1 = Vigilante "Espectro de Seda" ["Lucha", "Sigilo"] 1940 True False
drManhattan = Vigilante "Dr. Manhattan" ["Manipulación Cuántica", "Omnisciencia"] 1959 True True

type Evento = [Vigilante] -> [Vigilante]

destruccionDeNiushork :: Evento
destruccionDeNiushork unosVigilantes = seRetira "Dr Manhattan" . seMuere "Rorschach" $ unosVigilantes

seMuere :: Nombre -> Evento
seMuere unNombre unosVigilantes = filter ((unNombre /=) . nombre) $ unosVigilantes

seRetira :: Nombre -> Evento
seRetira unNombre unosVigilantes

-- hago un filter en la condicion de que tengan nombre 



--aplicarEventos :: [Evento] -> [Vigilante]
