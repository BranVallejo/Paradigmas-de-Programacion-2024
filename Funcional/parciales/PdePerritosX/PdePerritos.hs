import Text.Show.Functions

data Perrito = Perrito {
    raza :: String,
    juguetesFavoritos :: [Juguete],
    tiempoAPermanecer :: Float,
    energia :: Float
} deriving (Show)

data Guarderia = Guarderia{
    nombre :: Nombre,
    rutina :: [Actividad]
} deriving (Show)

type Nombre = String
type Juguete = String

type Actividad = (Ejercicio,Float)

type Ejercicio = Perrito -> Perrito
type AfectarPerrito = Perrito -> Perrito

-- #######################
-- ####### PARTE A #######
-- #######################

--Funciones básicas
modificarEnergia :: (Float -> Float) -> AfectarPerrito
modificarEnergia unaFuncion unPerrito = unPerrito {energia = unaFuncion $ energia unPerrito}

modificarJuguetes :: ([Juguete] -> [Juguete]) -> AfectarPerrito
modificarJuguetes unaFuncion unPerrito = unPerrito {juguetesFavoritos = unaFuncion $ juguetesFavoritos unPerrito}

--Ejercicios
jugar :: Ejercicio
jugar unPerrito
    |  energia unPerrito - 10 >= 0 = modificarEnergia (flip (-) 10) unPerrito
    | otherwise = modificarEnergia (const 0) unPerrito

ladrar :: Float -> Ejercicio
ladrar cantidadDeLadridos = modificarEnergia ( + (cantidadDeLadridos / 2))

regalar :: Juguete -> Ejercicio
regalar unJuguete = modificarJuguetes (unJuguete :)

diaDeSpa :: Ejercicio
diaDeSpa unPerrito
    | tiempoAPermanecer unPerrito > 50 || esDeRazaExtravagante unPerrito = regalar "Peine de goma" . modificarEnergia (const 100) $ unPerrito
    | otherwise = unPerrito

esDeRazaExtravagante :: Perrito -> Bool
esDeRazaExtravagante unPerrito = raza unPerrito == "polmenaria" || raza unPerrito == "dalmata"

diaDeCampo :: Ejercicio
diaDeCampo = modificarJuguetes (drop 1)

zara :: Perrito
zara = Perrito {
    raza = "dalmata",
    juguetesFavoritos = ["Pelota", "Mantita"],
    tiempoAPermanecer = 90,
    energia = 80
}

guarderiaPdePerritos :: Guarderia
guarderiaPdePerritos = Guarderia {
    nombre = "guarderiaPdePerritos",
    rutina = [(jugar,30), (ladrar 18, 20), (regalar "Pelota",0), (diaDeSpa,120), (diaDeCampo,720)]
}

-- #######################
-- ####### PARTE B #######
-- #######################

puedeEntrarEnUnaGuarderia :: Guarderia -> Perrito -> Bool
puedeEntrarEnUnaGuarderia unaGuarderia unPerrito = tiempoDeRutina unaGuarderia > tiempoAPermanecer unPerrito

tiempoDeRutina :: Guarderia -> Float
tiempoDeRutina unaGuarderia = sum . map snd . rutina $ unaGuarderia

perrosResponsables :: Perrito -> Bool
perrosResponsables unPerrito = (3 <) . length . juguetesFavoritos . diaDeCampo $ unPerrito

realizarRutinadeLaGuarderia :: Guarderia -> AfectarPerrito
realizarRutinadeLaGuarderia unaGuarderia unPerrito
    | puedeEntrarEnUnaGuarderia unaGuarderia unPerrito = realizarRutina unaGuarderia unPerrito
    | otherwise = unPerrito

-- Perrito - Rutina
realizarRutina :: Guarderia -> AfectarPerrito
realizarRutina unaGuarderia unPerrito = foldl (flip($)) unPerrito (map fst . rutina $ unaGuarderia)


realizarRutinaManada :: Guarderia -> [Perrito] -> [Perrito]
realizarRutinaManada unaGuarderia unosPerritos = map (realizarRutina unaGuarderia) unosPerritos

quedanCansados :: Guarderia -> [Perrito] -> [Perrito]
quedanCansados unaGuarderia unosPerritos = filter estaCansado . realizarRutinaManada unaGuarderia $ unosPerritos

estaCansado :: Perrito -> Bool
estaCansado = (5 >) . energia

-- #######################
-- ####### PARTE C #######
-- #######################

pio :: Perrito
pio = Perrito {
    raza = "Labrador",
    juguetesFavoritos = soguitasInfinitas,
    energia = 159,
    tiempoAPermanecer = 314
}

soguitasInfinitas :: [Juguete]
soguitasInfinitas = map (\unNumero -> ("Soguita " ++ show unNumero)) [1..]


{-
¡Infinita diversión! ♾ Pi es un perrito un poco especial… Su raza es labrador y tiene
muchos, muchos, incontables juguetes favoritos. Con la particularidad de que son todas
soguitas numeradas del 1 al infinito. Su tiempo de permanencia es de 314 minutos y su
energía es de 159.
Luego de modelar a Pi, respondé las siguientes preguntas justificando y escribiendo la
consulta que harías en la consola:
1. ¿Sería posible saber si Pi es de una raza extravagante?
2. ¿Qué pasa si queremos saber si Pi tiene…
a. … algún huesito como juguete favorito?
b. … alguna pelota luego de pasar por la Guardería de Perritos?
c. … la soguita 31112?
3. ¿Es posible que Pi realice una rutina?
4. ¿Qué pasa si le regalamos un hueso a Pi?

-- 1
    Sí, será posible porque para saber la raza solo necesitamos consultar al String raza. Al no ser
    una lista infinita no tiene posibilidad quedarse evaluando indefinidamente una condicion.
-- 2
    a) Al no tener ningún hueso, Haskell estaría buscando indeterminadamente y no converge a
    una solución. Ya que para esto la lista tendría que ser finita. O tener un hueso, que no es el caso.
    b) Al tener la certeza de que pelota estará en la lista, podemos asegurar que habrá un resultado.
    C) Vamos a poder tener el resultado de la soguita 311112, quizas lleve un tiempo
    hasta que devuelva un resultado, pero eventualmente lo tendremos. Esto debido a que no permanece
    evaluando hasta que termina la lista, al encontrar la soguita que busca nos devuelve el resultado
    y termina su ejecución.
-- 3
    Es posible mientras ninguna actividad caiga en los errores mencionados arriba ya que no podría devolver 
    un resultado, estancandose en esa actividad y no terminandola.
-- 4
    Se agrega al inicio.

-}

{-
Repeat 

Cycle 
   cycle ["Soguita"]
   [Soguita, Soguita, Soguita]

Iterate 


Replicate
    ghci> replicate 3 "gola"
    ["gola","gola","gola"]

funcion Show

-}

