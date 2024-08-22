module Guia_2 where
import Text.Show.Functions

--1
siguiente :: Integer -> Integer
siguiente = (1 +)

--2
mitad :: Fractional a => a -> a
mitad = (/ 2)

--3
inversa :: Fractional a => a -> a
inversa = (1 /)

--4
triple :: Int -> Int
triple = (3 *)

--5
esNumeroPositivo :: Int -> Bool
esNumeroPositivo =  (> 0)

--Composición
--8
inversaRaizCuadrada :: Floating a => a -> a
inversaRaizCuadrada = ( inversa . sqrt ) 

--9
incrementMCuadradoN :: Int -> Int -> Int
incrementMCuadradoN m n = ((n +) . (^2) ) m

--10
esResultadoPar :: Int -> Int -> Bool
esResultadoPar base potencia = (even . (^ potencia))base













