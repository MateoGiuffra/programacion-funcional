data Pizza = Prepizza | Capa Ingrediente Pizza
  deriving (Show)

data Ingrediente
  = Aceitunas Int
  | Anchoas
  | Cebolla
  | Jamón
  | Queso
  | Salsa
  deriving (Show)

-- Ej 1
-- REGLAS:
-- Base -> Prepizza esta en Pizza
-- Inductiva -> Si p esta en Pizza,
--                 entonces Capa Ingrediente p esta en Pizza

-- Ej 2.
-- f :: Pizza -> a
-- f Prepizza = ...
-- f (Capa i p) = ... f p ...

-- Ej 3
-- template
f :: Pizza -> a
f Prepizza = error "definir"
f (Capa i p) = f p

-- template

-- funciones auxiliares
tieneCapaDeAceitunas :: Pizza -> Bool
tieneCapaDeAceitunas (Capa (Aceitunas _) _) = True
tieneCapaDeAceitunas _ = False

-- funciones auxiliares

-- pizza de testeo
-- pizzas de testeo
pizzaVacia :: Pizza
pizzaVacia = Prepizza

pizzaSencilla :: Pizza
pizzaSencilla = Capa Queso (Capa Salsa Prepizza) -- salsa base, queso arriba

pizzaConJamonyAceitunas :: Pizza
pizzaConJamonyAceitunas = Capa (Aceitunas 5) (Capa Jamón (Capa Queso (Capa Salsa Prepizza)))

pizzaMultiQueso :: Pizza
pizzaMultiQueso = Capa Queso (Capa Queso (Capa Salsa Prepizza))

-- pizzaMultiQueso = Capa Salsa Prepizza)

pizzaAnchoas :: Pizza
pizzaAnchoas = Capa Anchoas (Capa Queso (Capa Salsa Prepizza))

pizzaSoloAceitunas :: Pizza
pizzaSoloAceitunas = Capa (Aceitunas 10) (Capa (Aceitunas 10) Prepizza)

-- alias de test conveniente
pizzaTest :: Pizza
pizzaTest = pizzaConJamonyAceitunas

-- pizzas de testeo

-- definiciones
cantidadDeCapas :: Pizza -> Int
cantidadDeCapas Prepizza = 0
cantidadDeCapas (Capa i p) = cantidadDeCapas p + 1

cantidadDeAceitunas :: Pizza -> Int
cantidadDeAceitunas Prepizza = 0
cantidadDeAceitunas (Capa (Aceitunas c) p) = c + cantidadDeAceitunas p
cantidadDeAceitunas (Capa _ p) = cantidadDeAceitunas p

duplicarAceitunas :: Pizza -> Pizza
duplicarAceitunas Prepizza = Prepizza
duplicarAceitunas (Capa (Aceitunas c) p) = Capa (Aceitunas (2 * c)) (duplicarAceitunas p)
duplicarAceitunas (Capa i p) = duplicarAceitunas p

sinLactosa :: Pizza -> Pizza
sinLactosa Prepizza = Prepizza
sinLactosa (Capa Queso p) = sinLactosa p
sinLactosa (Capa i p) = Capa i (sinLactosa p)

aptaIntolerantesLactosa :: Pizza -> Bool
aptaIntolerantesLactosa Prepizza = True
aptaIntolerantesLactosa (Capa Queso p) = False
aptaIntolerantesLactosa (Capa _ p) = aptaIntolerantesLactosa p

conDescripcionMejorada :: Pizza -> Pizza
conDescripcionMejorada Prepizza = Prepizza
conDescripcionMejorada (Capa (Aceitunas c) p) =
  if tieneCapaDeAceitunas p
    then conDescripcionMejorada p
    else Capa (Aceitunas c) (conDescripcionMejorada p)
conDescripcionMejorada (Capa i p) = Capa i (conDescripcionMejorada p)
