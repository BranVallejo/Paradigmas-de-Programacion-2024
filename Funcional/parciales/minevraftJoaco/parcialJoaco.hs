--Joaquín Santiago Barreiro
data Personaje = Personaje {
    nombre :: String,
    puntaje ::Int,
    inventario :: [Material]
}deriving (Show,Eq)

data Material = Material {
    name :: String,
    cantidad :: Int
}deriving(Show,Eq)

data Receta = Receta{
    nombreReceta :: String,
    materialesNecesarios :: [Material],
    tiempoCraft :: Int,
    objetoCreado :: Material
}deriving(Show,Eq)

steve = Personaje "steve" 100 [madera]
madera = Material "madera" 1
hierro = Material "hierro" 1
mesa = Material "mesa" 1
puerta = Material "puerta" 1

recetaXD = Receta "mesa" [madera] 10 mesa
receta2 = Receta "puerta" [madera] 10 puerta

puedeCraftear jugador receta = all (==True) (map (\material -> elem material (inventario jugador)) (materialesNecesarios receta))

craftear jugador receta 
    | puedeCraftear jugador receta = actualizarTodo jugador receta
    | otherwise = jugador{puntaje= puntaje jugador - 100}

actualizarTodo jugador receta = jugador{inventario = objetoCreado receta:quitarMateriales jugador receta, puntaje = puntaje jugador + tiempoCraft receta * 10}

quitarMateriales jugador receta = filter (\material -> not(elem material (materialesNecesarios receta))) (inventario jugador)

--Punto 2

listRecetas = [recetaXD,receta2]

duplicaPuntaje jugador recetas = map objetoCreado (filter (\recetas -> puntajeDespCraftear jugador recetas >=  2* puntaje jugador ) recetas)

puntajeDespCraftear jugador receta = puntaje (craftear jugador receta)

craftSucesivoIz jugador recetas = foldl (\jugador receta -> craftear jugador receta) jugador recetas

craftSucesivoDr jugador recetas = foldr (\receta jugador -> craftear jugador receta) jugador recetas

masPuntosIzDer jugador recetas
    | puntaje (craftSucesivoIz jugador recetas) > puntaje (craftSucesivoDr jugador recetas) = "Izquierda"
    | puntaje (craftSucesivoIz jugador recetas) > puntaje (craftSucesivoDr jugador recetas) = "Derecha"
    | otherwise = "igual izquierda y derecha"

--Mine 2

data Bioma = Bioma{
    nombreBioma :: String,
    elementoNecesario :: Material,
    elementosDelBioma :: [Material]
}

desierto = Bioma "desierto" madera [mesa,puerta,hierro]

minar herramienta jugador bioma
   | tieneElementoNecesario jugador bioma = jugador{puntaje = puntaje jugador + 50, inventario = obtenerMaterial herramienta bioma:inventario jugador}
   | otherwise = jugador

tieneElementoNecesario jugador bioma = elem (elementoNecesario bioma) (inventario jugador) 

hacha materiales = head

espada materiales = last

pico n materiales = materiales !! n


obtenerMaterial herramienta bioma = herramienta (elementosDelBioma bioma)(elementosDelBioma bioma)

--Punto 2

pala materiales = head . reverse

hoz metariales = last . reverse



--Ejmplos

minarConHoz = minar hoz steve desierto 
minarConHacha = minar espada steve desierto

--a


--Punto 3

--en la funcion obtenerMaterial esta itera los elementos del bioma, en el momento de querer ejecutar la misma
--estaria iterando de manera infinita entonces nunca seria capaz de terminar de ejecutarse la función

biomaInfito = Bioma "desierto" madera mesasInfinitas

mesasInfinitas = mesa:mesasInfinitas

--en el caso del biomaInfinito te tira un error ya que este no es capaz de mostrar las mesasInfinitas

biomacasiInfito = Bioma "desierto" madera mesasCasiInfinitas

mesasCasiInfinitas = take 100 $ mesa:mesasInfinitas

--en el caso del biomaCasiInfinito este se puede mostrar ya que la lista es infinita pero tiene una cota
--superior en 100
--esto se produce gracias al lazy evaluation en vez de interar infinitamente itera hasta llegar a los 100 
--independientemente del valor que le demos al take sea 100 o 1000000, mientras que sea finito se puede mostrar