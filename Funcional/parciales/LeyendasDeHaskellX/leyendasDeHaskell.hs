import Text.Show.Functions

data Investigador = Investigador {
    nombre :: String,
    experiencia :: Float,
    pokemonCompaniero :: Pokemon,
    mochila :: [Item],
    pokemonsCapturados :: [Pokemon]
} deriving (Show)


data Pokemon = Pokemon {
    apodo :: String,
    descripcion :: String,
    nivel :: Float,
    puntosBase :: Float
} deriving (Show)

--
esRangoCielo :: Investigador -> Bool
esRangoCielo unInvestigador =   experiencia unInvestigador < 100

esRangoEstrella :: Investigador -> Bool
esRangoEstrella unInvestigador = experiencia unInvestigador >= 100 && experiencia unInvestigador < 500

esRangoConstelacion :: Investigador -> Bool
esRangoConstelacion unInvestigador = experiencia unInvestigador >= 500 && experiencia unInvestigador < 2000

esRangoGalaxia :: Investigador -> Bool
esRangoGalaxia unInvestigador = experiencia unInvestigador >= 2000

-- ###################
-- ######## 1 ########
-- ###################
akari :: Investigador
akari = Investigador {
    nombre = "Akari",
    experiencia = 1499,
    mochila = [],
    pokemonCompaniero = oshawott,
    pokemonsCapturados = []
}

oshawott :: Pokemon
oshawott = Pokemon {
    apodo = "Oshawott",
    descripcion = "Una nutria que pelea con el caparazón de su pecho.",
    nivel = 5,
    puntosBase = 3
}

-- ###################
-- ######## 2 ########
-- ###################
-- ###Funciones Básicas

type AfectarInvestigador = Investigador -> Investigador

modificarExperiencia ::(Float -> Float) ->  AfectarInvestigador
modificarExperiencia unaFuncion unInvestigador = unInvestigador {experiencia = unaFuncion $ experiencia unInvestigador}

modificarMochila :: ([Item] -> [Item]) -> AfectarInvestigador
modificarMochila unaFuncion unInvestigador = unInvestigador {mochila = unaFuncion $ mochila unInvestigador}

modificarPokecompa :: (Pokemon -> Pokemon) -> AfectarInvestigador
modificarPokecompa unaFuncion unInvestigador = unInvestigador {pokemonCompaniero = unaFuncion $ pokemonCompaniero unInvestigador}

agregarItemAMochila :: Item -> AfectarInvestigador
agregarItemAMochila unItem unInvestigador = unInvestigador {mochila = unItem : mochila unInvestigador}

agregarPokemon :: Pokemon -> AfectarInvestigador
agregarPokemon unPokemon unInvestigador = unInvestigador {pokemonsCapturados = unPokemon : pokemonsCapturados unInvestigador}

-- ########
type Actividad = Investigador -> Investigador
type Item = Investigador -> Investigador

bayas :: Item
bayas unInvestigador = modificarExperiencia ((2 **) . (+ 1)) $ unInvestigador

apricorns :: Item
apricorns = modificarExperiencia (* 1.5)

guijarros :: Item
guijarros = modificarExperiencia (* 2)

fragmentosDeHierro :: Float -> Item
fragmentosDeHierro cantDeFragmentos = modificarExperiencia ( / cantDeFragmentos)

obtenerUnItem :: Item -> Actividad
obtenerUnItem unItem =  unItem . agregarItemAMochila unItem

--
admirarElPaisaje :: Actividad
admirarElPaisaje = modificarMochila (drop 3) . modificarExperiencia (* 0.95)

--
capturarUnPokemon :: Pokemon -> Actividad
capturarUnPokemon unPokemon unInvestigador 
    | puntosBase unPokemon > 20 = consecuenciasDeCapturarPokemonOP unPokemon $ unInvestigador
    | otherwise = consecuenciasDeCapturar unPokemon unInvestigador

--    | puntosBase unPokemon > 20 = agregarPokemon unPokemon . consecuenciasDeCapturar unPokemon $ unInvestigador
consecuenciasDeCapturarPokemonOP :: Pokemon -> AfectarInvestigador
consecuenciasDeCapturarPokemonOP unPokemon unInvestigador = modificarPokecompa (const unPokemon) . agregarPokemon (pokemonCompaniero unInvestigador) . modificarExperiencia (+ puntosBase unPokemon )$ unInvestigador

consecuenciasDeCapturar :: Pokemon -> AfectarInvestigador
consecuenciasDeCapturar unPokemon = modificarExperiencia (+ puntosBase unPokemon ) . agregarPokemon unPokemon

--
combatirUnPokemon :: Pokemon -> Actividad
combatirUnPokemon unPokemonRival unInvestigador
    | combatePokemon unPokemonRival unInvestigador = modificarExperiencia ((puntosBase unPokemonRival * 0.5) +) $ unInvestigador
    | otherwise = unInvestigador

--Saber si nuestro compañero le gana a un poke rival
combatePokemon :: Pokemon -> Investigador -> Bool
combatePokemon unPokemonRival =   (nivel unPokemonRival <) . nivel . pokemonCompaniero

-- ###################
-- ######## 3 ########
-- ###################

type Expedicion = [Actividad]
type AfectarInvestigadores = [Investigador] -> [Investigador]

irDeExpedicion :: Expedicion -> AfectarInvestigador
irDeExpedicion unaExpedicion unInvestigador = foldl (flip($)) unInvestigador unaExpedicion

irnosDeExpedicion :: Expedicion -> AfectarInvestigadores
irnosDeExpedicion unaExpedicion = map (irDeExpedicion unaExpedicion) 

-- ###################
-- ######## 4 ########
-- ###################
type CondicionDeInvestigador = Investigador -> Bool

reporte :: (Investigador -> a) -> (Investigador -> Bool) -> Expedicion -> [Investigador] -> ([Investigador] -> [a])
reporte unDato unaCondicion unaExpedicion unosInvestigadores = map unDato . filter unaCondicion . irnosDeExpedicion unaExpedicion

--
reporteNombre :: Expedicion -> [Investigador] -> ([Investigador] -> [String]) 
reporteNombre unaExpedicion unosInvestigadores = reporte nombre condicionReporteNombre unaExpedicion unosInvestigadores  --Sobredelegacion????

condicionReporteNombre :: CondicionDeInvestigador
condicionReporteNombre = (3 <) . length . filter esAlfa . pokemonsCapturados

esAlfa :: Pokemon -> Bool
esAlfa unPokemon = (( "Alfa" ==) . take 4 . apodo $ unPokemon) || all (`elem` (apodo unPokemon)) "aeiou"

-- 
reporteExperiencia :: Expedicion -> [Investigador] -> ([Investigador] -> [Float]) 
reporteExperiencia unaExpedicion unosInvestigadores = reporte experiencia condicionReporteExperiencia unaExpedicion unosInvestigadores

condicionReporteExperiencia :: CondicionDeInvestigador
condicionReporteExperiencia = esRangoGalaxia --esto funciona o tengo que hacer? condicionReporteExperiencia unInvestigador = esRangoGalaxia unInvestigador

--
reportePokeCompa :: Expedicion -> [Investigador] -> ([Investigador] -> [Pokemon]) 
reportePokeCompa unaExpedicion unosInvestigadores = reporte pokemonCompaniero condicionReportePokeCompa unaExpedicion unosInvestigadores

condicionReportePokeCompa :: CondicionDeInvestigador
condicionReportePokeCompa = (10 <=) . nivel . pokemonCompaniero

--

reporteUltimos3 :: Expedicion -> [Investigador] -> ([Investigador] -> [[Pokemon]]) 
reporteUltimos3 unaExpedicion unosInvestigadores = take 3 . reverse .reporte pokemonsCapturados condicionReporteUltimos3 unaExpedicion unosInvestigadores

condicionReporteUltimos3 :: CondicionDeInvestigador
condicionReporteUltimos3 = all ((10 <=) . nivel) . pokemonsCapturados



-- ###################
-- ######## 5 ########
-- ###################
-- En el 1ro puede fallar si no tenemos mas de 3 pokemons alfa, ya que se quedaría buscandolos en una
-- lista infinita.
-- el 2  no se mete con datos infinitos, entonces pueden encontrar un resultado y cortar.
-- El pokemon compañero es solo 1 así que funcionaría ya que no se mete con datos infinitos, entonces pueden encontrar un resultado
-- y cortar.
-- El ultimo no ya que al tener una lista infinita nunca podría encontrar los últimos 3.

-- esta bien eso?
-- Conclusion mia: Solo no funcionan los que necesitan evaluar el todo para llegar una conclusión. Ya que se quedan
-- ciclando para siempre

-- PReguntar
-- Alfa doble de puntos

--Codigo que use para hacer el 4
{-
--(Investigador -> a)
reporteNombre2 :: Expedicion -> [Investigador] -> [String]
reporteNombre2 unaExpedicion = map nombre . filter condicionReporteNombre. irnosDeExpedicion unaExpedicion
-}