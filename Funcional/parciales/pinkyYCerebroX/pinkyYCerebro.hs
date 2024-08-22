import Text.Show.Functions
import Data.List (union, intersect)


data Animal = Animal {
    especie :: Especie,
    coeficienteIntelectual :: CoeficienteIntelectual,
    capacidades :: [Habilidad]
} deriving (Show)

type CoeficienteIntelectual = Int
type Habilidad = String
type Especie = String
-- ###############
-- ###### 1 ######
-- ###############

delfin :: Animal
delfin = Animal {
    especie = "Cetaceo",
    coeficienteIntelectual = 333,
    capacidades = ["Nadar", "Comunicarse con ruidos", "Respirar"]
}

perro :: Animal
perro = Animal {
    especie = "Can",
    coeficienteIntelectual = 300,
    capacidades = ["Ladrar","Ser el mejor amigo del hombre", "Traer pelota", "Respirar"]
}

gato :: Animal
gato = Animal {
    especie = "Felino",
    coeficienteIntelectual = 310,
    capacidades = ["Trepar","Caer bien", "Maullar", "Respirar"]
}


pinky :: Animal
pinky = Animal {
    especie = "nose",
    coeficienteIntelectual = 310000,
    capacidades = ["hacer narf","hacer quue", "Maullar", "hacer jaft", "Respirar"]
}

-- ###############
-- ###### 2 ######
-- ###############

type TransformarAnimal = Animal -> Animal

inteligenciaSuperior :: Int -> TransformarAnimal
inteligenciaSuperior unNumero unAnimal = unAnimal {coeficienteIntelectual = coeficienteIntelectual unAnimal + unNumero}

pinkificar :: TransformarAnimal
pinkificar unAnimal = unAnimal {capacidades = []}

superPoderes :: TransformarAnimal
superPoderes unAnimal
    |  verEspecie "elefante" unAnimal = agregarHabilidad "No tenerle miedo a los ratones" $ unAnimal
    |  verEspecie "raton" unAnimal && coeficienteIntelectual unAnimal > 100 = agregarHabilidad "Hablar" $ unAnimal
    | otherwise = unAnimal


agregarHabilidad :: Habilidad -> TransformarAnimal
agregarHabilidad unaHabilidad unAnimal = unAnimal {capacidades = unaHabilidad : capacidades unAnimal}

verEspecie :: String -> Animal -> Bool
verEspecie unaEspecie unAnimal = (unaEspecie ==) . especie $ unAnimal

-- ###############
-- ###### 3 ######
-- ###############

type Criterio = Animal -> Bool
esAntropomorfico :: Criterio
esAntropomorfico unAnimal = tieneLaHabilidad "hablar" unAnimal && coeficienteIntelectual unAnimal > 60

tieneLaHabilidad :: Habilidad -> Criterio
tieneLaHabilidad unaHabilidad unAnimal = any (== unaHabilidad) . capacidades $ unAnimal


noTanCuerdo :: Criterio
noTanCuerdo unAnimal =  (2 <) . length . filter pinkiesco . capacidades $ unAnimal

pinkiesco :: Habilidad -> Bool
pinkiesco unaHabilidad = (("hacer " ==) . take 6 $ unaHabilidad) && palabraPinkiesca unaHabilidad

palabraPinkiesca :: String -> Bool
palabraPinkiesca unaPalabra = ((4 >=) . length . drop 6 $ unaPalabra) && (tieneUnaVocal . drop 6 $ unaPalabra)

tieneUnaVocal :: String -> Bool
tieneUnaVocal palabra = any esVocal palabra

esVocal :: Char -> Bool
esVocal unaLetra =  elem unaLetra "aeiouAEIOU"


-- ###############
-- ###### 4 ######
-- ###############

data Experimento = Experimento {
    experimentos :: [TransformarAnimal],
    criterioDeExito :: Criterio
} deriving(Show)

raton :: Animal
raton = Animal{
    especie = "Roedor",
    coeficienteIntelectual = 17,
    capacidades = ["destruenglonir el mundo", "hacer planes desalmados"]
}

experimentoDePrueba :: Experimento
experimentoDePrueba = Experimento {
    experimentos = [pinkificarlo,inteligenciaSuperior 10, superPoderes],
    criterioDeExito = esAntropomorfico
}

pinkificarlo :: TransformarAnimal
pinkificarlo unAnimal = agregarHabilidad "hacer parw" . agregarHabilidad "hacer raft" . agregarHabilidad "hacer naft" $ unAnimal

experimentoExitoso :: Experimento -> Animal -> Bool
experimentoExitoso unExperimento = criterioDeExito unExperimento . aplicarExperimento unExperimento

aplicarExperimento :: Experimento -> TransformarAnimal
aplicarExperimento unExperimento unAnimal = foldl (flip($)) unAnimal . experimentos $ unExperimento

aplicarExperimentoAMuchosAnimales :: Experimento -> [Animal] -> [Animal]
aplicarExperimentoAMuchosAnimales unExperimento unosAnimales = map (aplicarExperimento unExperimento) $ unosAnimales

-- ###############
-- ###### 5 ######
-- ###############

--             animales    capacidades    experimento
type Reporte = [Animal] -> [Habilidad] -> Experimento

--1)
 --Pruebas
--Si cambio los tipos a: Reporte -> [CoheficienteIntelectual]    se rompe
crearReporte :: [Animal] -> [Habilidad] -> String ->  Experimento -> [Animal]
crearReporte unosAnimales unasCapacidades tieneONo unExperimento = tienenAlgunaDeLasCapacidades unasCapacidades tieneONo. aplicarExperimentoAMuchosAnimales unExperimento $ unosAnimales

listaDeCoeficientes :: [Animal] -> [Habilidad] -> String -> Experimento -> [CoeficienteIntelectual]
listaDeCoeficientes unosAnimales unasCapacidades tieneONo unExperimento =  map coeficienteIntelectual . crearReporte unosAnimales unasCapacidades tieneONo $ unExperimento

listaDeEspecies :: [Animal] -> [Habilidad] -> String -> Experimento -> [Especie]
listaDeEspecies unosAnimales unasCapacidades tieneONo unExperimento =  map especie . crearReporte unosAnimales unasCapacidades tieneONo $ unExperimento

listaCantidadDeCapacidades :: [Animal] -> [Habilidad] -> String -> Experimento -> [Int]
listaCantidadDeCapacidades unosAnimales unasCapacidades tieneONo unExperimento =  map (length . capacidades). crearReporte unosAnimales unasCapacidades tieneONo $ unExperimento



--Compara Animales - Lista de habilidades
tienenAlgunaDeLasCapacidades :: [Habilidad] -> String -> [Animal] -> [Animal]
tienenAlgunaDeLasCapacidades unasCapacidades tieneONo unosAnimales = filter (tieneAlgunaDelasCapacidades unasCapacidades tieneONo) unosAnimales

-- [perro, gato, liebre]          ["hablar", "correr". "saltar"]
-- ["ladrar", "morder", "saltar"]
-- ["ladrar"]

--Compara Animal - Lista de habilidades
tieneAlgunaDelasCapacidades :: [Habilidad] -> String -> Animal -> Bool
tieneAlgunaDelasCapacidades unasCapacidades tieneONo unAnimal = any (estaEnLaLista unasCapacidades tieneONo). capacidades $ unAnimal

--Compara Habilidad - Lista de habilidades
estaEnLaLista :: [Habilidad] -> String -> Habilidad -> Bool
estaEnLaLista unasCapacidades tieneONo unaHabilidad
    |(tieneONo == "Tiene") = any (== unaHabilidad) unasCapacidades
    | otherwise = any (/= unaHabilidad) unasCapacidades












--Si cambio los tipos a: Reporte -> [CoheficienteIntelectual]    se rompe
crearReporte :: [Animal] -> [Habilidad] -> Experimento -> [Animal]
crearReporte unosAnimales unasCapacidades unExperimento =   tienenAlgunaDeLasCapacidades unasCapacidades . aplicarExperimentoAMuchosAnimales unExperimento $ unosAnimales

listaDeCoeficientes :: [Animal] -> [Habilidad] -> Experimento -> [CoeficienteIntelectual]
listaDeCoeficientes unosAnimales unasCapacidades unExperimento =  map coeficienteIntelectual . crearReporte unosAnimales unasCapacidades unExperimento

listaDeEspecies :: [Animal] -> [Habilidad] -> Experimento -> [Especie]
listaDeEspecies unosAnimales unasCapacidades unExperimento =  map especie . tienenAlgunaDeLasCapacidades unasCapacidades . aplicarExperimentoAMuchosAnimales unExperimento $ unosAnimales

--listaCantidadDeCapacidades :: [Animal] -> [Habilidad] -> Experimento -> [Int]
--listaCantidadDeCapacidades unosAnimales unasCapacidades unExperimento =  . tienenAlgunaDeLasCapacidades unasCapacidades . aplicarExperimentoAMuchosAnimales unExperimento $ unosAnimales



--Compara Animales - Lista de habilidades
tienenAlgunaDeLasCapacidades :: [Habilidad] -> [Animal] -> [Animal]
tienenAlgunaDeLasCapacidades unasCapacidades unosAnimales = filter (tieneAlgunaDelasCapacidades unasCapacidades) unosAnimales

-- [perro, gato, liebre]          ["hablar", "correr". "saltar"]
-- ["ladrar", "morder", "saltar"]
-- ["ladrar"]

--Compara Animal - Lista de habilidades
tieneAlgunaDelasCapacidades :: [Habilidad] -> Animal -> Bool
tieneAlgunaDelasCapacidades unasCapacidades unAnimal = any (estaEnLaLista unasCapacidades). capacidades $ unAnimal

--Compara Habilidad - Lista de habilidades
estaEnLaLista :: [Habilidad] -> Habilidad -> Bool
estaEnLaLista unasCapacidades unaHabilidad = any (== unaHabilidad) unasCapacidades
