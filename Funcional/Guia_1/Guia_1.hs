module Guia_1 where
import Text.Show.Functions

-- 1
esMultiploDeTres :: Int -> Bool
esMultiploDeTres numero = ((mod numero 3) == 0)

--2
esMultiploDe :: Int -> Int -> Bool
esMultiploDe numero1 numero2 = ((mod numero2 numero1) == 0)

--3
-- Integral no es un tipo en sí mismo, sino una clase de tipos. 
-- por eso lo pongo como restriccion y no puedo hacerlo como arriba
cubo :: Num a => a -> a
cubo numero = (numero * numero * numero)

--4
area :: Num a => a -> a -> a
area base altura = (base * altura)

--5
esBisiesto :: Int -> Bool
esBisiesto anio = (((mod anio 400) == 0) || ( ((mod anio 4) == 0) && ((mod anio 100) /= 0) )  )

--6
celsiusToFahr :: Fractional a => a -> a
celsiusToFahr temp = ( temp * 9/5 + 32)

--7
fahrToCelsius :: Fractional a => a -> a
fahrToCelsius temp = ((temp - 32) * 5/9)

--8
haceFrio :: (Fractional a, Ord a) => a -> Bool
haceFrio temp = ((fahrToCelsius temp) < 8)

--9
mcm :: Integral a => a -> a -> a
mcm numero1 numero2 = ( div (numero1 * numero2) (gcd numero1 numero2))

--10
maxTriple :: (Num a, Ord a) => a -> a -> a -> a
maxTriple num1 num2 num3 = (max (max num1 num2) num3)

minTriple :: (Num a, Ord a) => a -> a -> a -> a
minTriple num1 num2 num3 = (min (min num1 num2) num3)

dispersion :: Integral a => a -> a -> a -> a
dispersion medicion1 medicion2 medicion3 = maxTriple medicion1 medicion2 medicion3 - minTriple medicion1 medicion2 medicion3

diasParejos :: Integral a => a -> a -> a -> Bool
diasParejos medicion1 medicion2 medicion3 = dispersion medicion1 medicion2 medicion3 < 30

diasLocos :: Integral a => a -> a -> a -> Bool
diasLocos medicion1 medicion2 medicion3 = dispersion medicion1 medicion2 medicion3 > 100

diasNormales :: Integral a => a -> a -> a -> Bool
diasNormales medicion1 medicion2 medicion3 = (not (diasLocos medicion1 medicion2 medicion3) && not (diasParejos medicion1 medicion2 medicion3))

-- Acá estaba probando cosas de composición
costoDeEstacionamiento :: Integer -> Integer
--costoDeEstacionamiento tiempo = ((50*). max 2) tiempo
costoDeEstacionamiento = (50*). max 2 








































