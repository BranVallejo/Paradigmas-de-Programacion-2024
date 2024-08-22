import Text.Show.Functions
import Data.Char (toUpper, isUpper)


data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [Habilidad],
    objetos :: [Objeto]
} deriving(Show)

type Objeto = Barbaro -> Barbaro
type Habilidad = String

--Bárbaro

ema :: Barbaro
ema = Barbaro {
    nombre = "Ema",
    fuerza = 63,
    habilidades = ["Curar", "Patear"],
    objetos = []    
}

mariano :: Barbaro
mariano = Barbaro {
    nombre = "Mariano",
    fuerza = 14,
    habilidades = ["Furia", "Lanzar hacha", "Salto doble"],
    objetos = [amuletoMistico "aprobar algorimos", espada 10]
}
-- #############
-- ##### 1 #####
-- #############
type AfectarBarbaro = Barbaro -> Barbaro

agregarFuerza :: Int -> AfectarBarbaro
agregarFuerza unaCantidadDeFuerza unBarbaro = unBarbaro { fuerza = fuerza unBarbaro + unaCantidadDeFuerza}

modificarFuerza :: (Int -> Int) -> AfectarBarbaro
modificarFuerza unaFuncion unBarbaro = unBarbaro { fuerza = unaFuncion $ fuerza unBarbaro}

agregarHabilidad :: Habilidad -> AfectarBarbaro
agregarHabilidad unaHabilidad unBarbaro = unBarbaro { habilidades = unaHabilidad : habilidades unBarbaro } 
    
modificarHabilidades :: ([Habilidad] -> [Habilidad]) -> AfectarBarbaro
modificarHabilidades unaFuncion unBarbaro = unBarbaro { habilidades = unaFuncion $ habilidades unBarbaro }


agregarObjeto :: Objeto -> AfectarBarbaro
agregarObjeto unObjeto unBarbaro = unBarbaro { objetos =  unObjeto : objetos unBarbaro }

modificarObjetos :: ([Objeto] -> [Objeto]) -> AfectarBarbaro
modificarObjetos unaFuncion unBarbaro = unBarbaro { objetos = unaFuncion $ objetos unBarbaro }




espada :: Int -> Objeto
espada unPeso unBarbaro = agregarFuerza (unPeso * 2) $ unBarbaro

amuletoMistico :: Habilidad -> Objeto
amuletoMistico unaHabilidad unBarbaro = agregarHabilidad unaHabilidad $ unBarbaro 

varitasDefectuosas :: Objeto
varitasDefectuosas unBarbaro = agregarHabilidad "Hacer magia" . modificarObjetos (const []) $ unBarbaro

ardilla :: Objeto
ardilla unBarbaro = unBarbaro

cuerda :: Objeto -> Objeto -> Objeto
cuerda unObjeto otroObjeto  = otroObjeto . unObjeto

-- #############
-- ##### 2 #####
-- #############

{-
No funciona, pero va por ahí. Me dijeron que puede no funcionar pero si conceptualmente está bien puede pasar, por eso no lo arreglé.

convertirAMayusculas :: Habilidad -> Habilidad
convertirAMayusculas unaPalabra = map toUpper unaPalabra

megafono :: Objeto
megafono unBarbaro = modificarHabilidades usarMegafono $ unBarbaro

-- está mal porque usar megafono te devuelve el string concatenado y en mayusculas, pero yo quiero una lista de todo eso, no eso suelto
usarMegafono :: [Habilidad] -> [Habilidad]
usarMegafono unasHabilidades =  concat . map convertirAMayusculas  $ unasHabilidades

megafotoBarbarico :: Objeto
megafotoBarbarico = cuerda ardilla megafono
-}

-- #############
-- ##### 3 #####
-- #############

type Aventura = [Evento]

type Evento = Barbaro -> Bool

sobreviveAEvento :: Barbaro -> Evento -> Bool
sobreviveAEvento unBarbaro unEvento = unEvento unBarbaro

--1
invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes = tieneLaHabilidad "Escribir poesía atroz"

tieneLaHabilidad :: Habilidad -> Barbaro -> Bool
tieneLaHabilidad unaHabilidad = elem unaHabilidad . habilidades
--2
cremalleraDelTiempo :: Evento
cremalleraDelTiempo unBarbaro = nombreIgual "Faffy" unBarbaro || nombreIgual "Astro" unBarbaro

nombreIgual :: String -> Barbaro -> Bool
nombreIgual unNombre unBarbaro = nombre unBarbaro == unNombre

--3

saqueo :: Evento
saqueo unBarbaro = fuerza unBarbaro > 80 && tieneLaHabilidad "Robar" unBarbaro


gritoDeGuerra :: Evento
gritoDeGuerra unBarbaro = length (objetos unBarbaro) == poderDeGritoDeGuerra unBarbaro

poderDeGritoDeGuerra :: Barbaro -> Int
poderDeGritoDeGuerra = letrasDeSusHabilidades

letrasDeSusHabilidades :: Barbaro -> Int
letrasDeSusHabilidades = length . concat . habilidades


caligrafia :: Evento
caligrafia unBarbaro = all reglasDeCaligrafia  . habilidades $ unBarbaro 

--reglasDeCaligrafia

reglasDeCaligrafia :: Habilidad -> Bool
reglasDeCaligrafia unaHabilidad =  tieneTresVocales unaHabilidad && arrancaConMayuscula unaHabilidad

arrancaConMayuscula :: Habilidad -> Bool
arrancaConMayuscula = isUpper . head 

tieneTresVocales :: Habilidad -> Bool
tieneTresVocales = (3 <) . length . map esVocal

esVocal :: Char -> Bool
esVocal unaLetra = elem unaLetra "aeiouAEIOU"

ritual :: Aventura 
ritual = [saqueo, caligrafia, gritoDeGuerra]

ritualDeFechorias :: Aventura -> Barbaro -> Bool
ritualDeFechorias unosEventos unBarbaro = any ($ unBarbaro) unosEventos

--"Ojo que ritualDeFechorias y sobrevivientes no son tan diferentes" No debe haber logica repetida
--las veo diferentes no veo donde podrían compartir lógica
-- la de lu es muy similar. Confío en que la mia está bien

sobrevivientes :: Aventura -> [Barbaro] -> [Barbaro]
sobrevivientes unosEventos unosBarbaros = sobrevientesAVariosEventos unosEventos unosBarbaros

-- 1 barbaro muchos eventos (osea una aventura)
sobreviveAVariosEventos :: Aventura -> Barbaro -> Bool
sobreviveAVariosEventos unosEventos unBarbaro = all ($ unBarbaro) unosEventos

--Muchos Barbaros muchos eventos
sobrevientesAVariosEventos :: Aventura -> [Barbaro] -> [Barbaro]
sobrevientesAVariosEventos unosEventos unosBarbaros = filter (sobreviveAVariosEventos unosEventos) unosBarbaros

-- #############
-- ##### 4 #####
-- #############
--Se puede con foldl1??
--A)

sinRepetidos :: (Eq a) => [a] -> [a]
sinRepetidos [x] = [x]
sinRepetidos (x:y:xs)
    | any (== x) (y:xs) = sinRepetidos (y:xs)
    | otherwise = x : sinRepetidos (y:xs)



--B)
--No lo hice

{-
C) No se puede aplicar sobre los objetos porque son funciones y no pertenecen a la clase de tipos Eq.
Se puede aplicar sobre los nombres ya que son una lista de Char's, nos quita las letras repetidas
del nombre. Ej: ghci> sinRepetidos "Alfonso"  > "Alfnso"

-}