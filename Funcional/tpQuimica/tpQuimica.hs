import Guia_1
import Guia_2
import Guia_4
import Text.Show.Functions

-- data Sustancia = Sencilla {} | Compuesta {} 
data Sustancia = 
    Sencilla {
        nombreSencilla :: String,
        simboloQuimico :: String,
        numeroAtomico :: Int,
        grupo :: Grupo
    }
    |
    Compuesta {
        nombreCompuesto :: String,
        componentes :: [Componente],
        grupo :: Grupo
    } deriving(Show)


type Componente = (Sustancia, Int)
data Grupo = Metal | NoMetal | Halogeno | GasNoble deriving(Show, Eq)

--1
hidrogeno :: Sustancia
hidrogeno = Sencilla {
    nombreSencilla = "Hidrogeno",
    simboloQuimico = "H",
    numeroAtomico = 1,
    grupo = NoMetal
}

oxigeno :: Sustancia
oxigeno = Sencilla {
    nombreSencilla = "Oxigeno",
    simboloQuimico = "O",
    numeroAtomico = 8,
    grupo = NoMetal
}

agua  :: Sustancia
agua = Compuesta {
    nombreCompuesto = "Agua",
    componentes = [(hidrogeno, 2), (oxigeno,1)],
    grupo = NoMetal
}

oro :: Sustancia
oro = Sencilla {
    nombreSencilla = "Oro",
    simboloQuimico = "Au",
    numeroAtomico = 72,
    grupo = Metal
}
 
--2
data Criterio = Electricidad | Calor deriving(Show,Eq)

conduce :: Sustancia -> Criterio -> Bool
conduce (Sencilla _ _ _ Metal) _ = True
conduce (Compuesta _ _ Metal) _ = True

conduce (Sencilla _ _ _ GasNoble) Electricidad = True
conduce (Compuesta _ _ GasNoble) Electricidad = True

conduce (Compuesta _ _ Halogeno) Calor = True

conduce _ _ = False

--3
esVocal :: Char -> Bool
esVocal 'a' = True
esVocal 'e' = True
esVocal 'i' = True
esVocal 'o' = True
esVocal 'u' = True
esVocal _   = False

adaptarNombre :: String -> String
adaptarNombre nombre 
    | (not . esVocal . last) nombre = nombre ++ "uro"
    | otherwise =  adaptarNombre (init(nombre))

--4
combinarNombres :: String -> String -> String
combinarNombres nombre1 nombre2 = adaptarNombre(nombre1) ++ " de " ++ nombre2

--5
{-
Mezclar una serie de componentes entre sí. El resultado de dicha mezcla será un 
compuesto. Sus componentes serán los componentes mezclados. El nombre se forma 
de combinar los nombres de la sustancia de cada componente. La especie será, 
arbitrariamente, un no metal.
-}


mezclar :: [Componente] -> Sustancia
mezclar componentes = Compuesto (nombreDelCompuesto componentes) NoMetal componentes

nombreDelCompuesto :: [Componente] -> String
nombreDelCompuesto = nombreDeUniones . map (nombre . sustancia)

nombreDeUniones :: [String] -> String
nombreDeUniones [nombre] = nombre
nombreDeUniones (nombre1 : nombre2 : nombres) =
  nombreDeUniones (combinar nombre1 nombre2 : nombres)

{-
6. Obtener la fórmula de una sustancia:
    - para los elementos es su símbolo químico
    - para los compuestos es la concatenación de las representaciones de sus 
    componentes y se pone entre paréntesis
      * La representación de un componente depende de la cantidad de moléculas:
        - si tiene una, entonces solo es la fórmula de su sustancia
        - si tiene más, entonces es la fórmula de su sustancia y la cantidad
Por ejemplo, la fórmula del agua debería ser (H2O). ¡Recuerden que una sustancia
compuesta puede estar compuesta por otras sustancias compuestas!
-}

formula :: Sustancia -> String
formula (Elemento _ simboloQuimico _ _) = simboloQuimico
formula (Compuesto _ _ componentes) = concat (map representacion componentes)

representacion (Componente sustancia 1) = formula sustancia
representacion (Componente sustancia numero) = formula sustancia ++ show numero































