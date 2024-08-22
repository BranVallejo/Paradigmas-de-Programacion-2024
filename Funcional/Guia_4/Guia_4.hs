import Guia_1
import Guia_2
import Text.Show.Functions
--Herramientas
triple :: Int -> Int
triple = (3 *)

cubo :: Num a => a -> a
cubo numero = (numero * numero * numero)


--1
sumarLista :: (Num a) => [a] -> a
sumarLista a = sum a

--2 a
frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

--promedioFrecuenciaCardiaca :: (Num a, Fractional b) => [a] -> b
--promedioFrecuenciaCardiaca a = (sumarLista a) / (length a)
--promedioFrecuenciaCardiaca a = ( (sumarLista a/) .  fromIntegral (length a)) Si hago :r con este no problem

--2 b
minutoANumeroDeMuestra :: Int -> Int
minutoANumeroDeMuestra = (flip div 10)

frecuenciaCardiacaMinuto :: Int -> Int
--frecuenciaCardiacaMinuto a = frecuenciaCardiaca !! minutoANumeroDeMuestra a
frecuenciaCardiacaMinuto = ( (frecuenciaCardiaca !!) . minutoANumeroDeMuestra )  -- Mejor respuesta

--2 c
frecuenciasHastaMomento :: Int -> [Int]
--frecuenciasHastaMomento a = take ((minutoANumeroDeMuestra a)+1) frecuenciaCardiaca
--le sumo uno porque el 1er valor de take no arranca a contar desde 0, sino desde 1
frecuenciasHastaMomento = ( flip take frecuenciaCardiaca . (+1) . minutoANumeroDeMuestra) -- Mejor respuesta

--3
esCapicua :: [String] -> Bool
esCapicua a = ((concat a ==) . reverse . concat ) $ a --Mejor solución ???


--Orden superior
--1 tiene tuplas
--2
mejor :: (Int -> Int) -> (Int -> Int) -> Int -> Int
--mejor func1 func2 c = max (func1 c) (func2 c)
mejor func1 func2 c = ( (max (func1 c)) . func2 ) $ c 


--3
--Tuplas

--4
--Tuplas


--Orden superior + Tuplas

esMultiploDeV2 :: Int -> Int -> Bool
esMultiploDeV2 num1 num2 = ( (0 ==) . mod num2 ) $ num1


esMultiploDeAlguno :: Int -> [Int] -> Bool 
esMultiploDeAlguno num lista = any ( `esMultiploDeV2` num) lista

--2
promLista :: [Float] -> Float
promLista lista = (sumarLista lista / (fromIntegral (length lista)) )

--Funciona
promedios :: [[Float]] -> [Float]
promedios lista = map promLista lista


--3
filtrarAprobadas :: [Float] -> [Float]
filtrarAprobadas lista = filter ( > 4) lista

promediosSinAplazos :: [[Float]] -> [Float]
promediosSinAplazos lista =( (promedios) . (map filtrarAprobadas) )lista


--4
mejoresNotas :: [[Int]] -> [Int]
mejoresNotas listaNotas = map maximum listaNotas

--5
aprobo :: [Int] -> Bool
aprobo notas = all ( > 5) notas


--6
aprobaron :: [[Int]] -> [[Int]]
aprobaron notas = filter aprobo notas


--7
divisores :: Int -> [Int]
divisores dividendo = filter ((0 ==) . mod dividendo) [1..dividendo]

--8
exists :: (Int -> Bool) -> [Int] -> Bool
exists funcion lista = any funcion lista

--9
hayAlgunNegativo :: [Int] -> a -> Bool
hayAlgunNegativo numeros _ = any ( > -1) numeros


--10
aplicarFunciones :: (Num a) => [(a -> a)] -> a -> [a]
aplicarFunciones funciones numero = map ($ numero) funciones

--Main> aplicarFunciones[(*4),even,abs] 8 da error. ¿Por qué? 
-- porque even es de tipo: even :: Num a => a -> Bool. Al devolver un bool no es
-- compatible con nuestra función que está hecha para usar funciones que
-- devuelvan numeros en una lista


--11
sumaF :: (Num a) => [(a -> a)] -> a -> a
sumaF funciones numero = (sumarLista . aplicarFunciones funciones) $ numero


--12
sumarHab :: Int -> [Int] -> [Int]
sumarHab habilidad jugadores = map (+habilidad) jugadores

subirHabilidad :: Int -> [Int] -> [Int]
subirHabilidad habilidad jugadores = map (\x -> min 12 x) (sumarHab habilidad jugadores)



--subirHabilidad :: Int -> [Int] -> [Int]
--subirHabilidad habilidad jugadores
--    | any (> 12) (sumarHab habilidad jugadores) = map (\x -> min 12 x) (sumarHab habilidad jugadores)
--    | otherwise = sumarHab habilidad jugadores

--13
flimitada :: (Int -> Int) -> Int -> Int
flimitada funcion habilidad
    | (funcion $ habilidad) > 12 = min 12 (funcion $ habilidad)
    | (funcion $ habilidad) < 0 = 0    
    | otherwise = funcion $ habilidad

--13 a)
cambiarHabilidad :: (Int -> Int) -> [Int] -> [Int]
cambiarHabilidad funcion habilidades = map (flimitada funcion) habilidades

--13 b)
subirMinimoA4 :: Int -> Int
subirMinimoA4 habilidad = max habilidad 4


--14
--takeWhile (a -> Bool) -> [a] -> [a]
-- recorre la lista y va agregando elementos a una lista, solo sí
-- dan true con la función que le diste. Cuando recibe el 1er false
-- corta y termina ahí, sin importar lo que haya más adelante.


--15
primerosPares :: (Integral a) => [a] -> [a]
primerosPares numeros = takeWhile even numeros

esDivisor :: Int -> Int -> Bool
esDivisor dividendo divisor  = elem divisor (divisores dividendo)

primerosDivisores :: Int -> [Int] -> [Int]
primerosDivisores dividendo numeros = takeWhile (esDivisor dividendo) numeros


noEsDivisor :: Int -> Int -> Bool
noEsDivisor dividendo divisor  = not (elem divisor (divisores dividendo))

primerosNoDivisores :: Int -> [Int] -> [Int]
primerosNoDivisores dividendo numeros = takeWhile (noEsDivisor dividendo) numeros


--16
balanceMesAMes :: [Int] -> [Int] -> [Int] 
balanceMesAMes ingresos gastos = zipWith (-) ingresos gastos
--preguntar sobre zipWith, la idea del ejercicio es que usemos 
--otra herramienta/concepto?. ZipWith es una gran ayuda.

huboMesMejorDe :: [Int] -> [Int] -> Int -> Bool
huboMesMejorDe ingresos gastos numero
    |any (\balanceMensual -> balanceMensual > numero) balance = True
    |otherwise = False
    where balance = balanceMesAMes ingresos gastos

--17 a)
crecimientoAnual :: Int -> Int
crecimientoAnual edad 
    | (1 <= edad && edad < 10) =  24 - (edad * 2)
    | (10 <= edad && edad < 16) = 4
    | (16 <= edad && edad < 18) = 2
    | (18 <= edad && edad < 20) = 1
    | otherwise = 0

-- b)
crecimientoEntreEdades :: Int -> Int -> Int
crecimientoEntreEdades edadInicial edadFinal = (sumarLista . map crecimientoAnual) [edadFinal-1, edadFinal-2.. edadInicial]

-- c)
alturasEnUnAnio :: Int -> [Int] -> [Int]
alturasEnUnAnio edad alturas = map (+ crecimientoAnual edad) $ alturas

-- d)
--Nombre horrible, se aceptan propuestas
sumarAlturaAEdadFutura :: Int -> Int -> Int -> Int
sumarAlturaAEdadFutura alturaActual edadInicial edadFinal = alturaActual + crecimientoEntreEdades edadInicial edadFinal

alturaEnEdades :: Int -> Int -> [Int] -> [Int]
alturaEnEdades alturaActual edad edades = map (sumarAlturaAEdadFutura alturaActual edad ) $ edades

--No está mal el último dato? a mi me da 162 y en el apunte 164
--pero: crecimientoEntreEdades 8 18 = 42 ==> 120 + 42 = 162
--además las 2 primeras me dan bien















































