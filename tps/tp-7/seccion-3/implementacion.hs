data Dungeon a
  = Habitacion a
  | Pasaje (Maybe a) (Dungeon a)
  | Bifurcacion (Maybe a) (Dungeon a) (Dungeon a)
  deriving (Show)

--  Ej 1.
-- Caso base -> Si x :: a
--                  entonces Habitacion x está en Dungeon a.
-- Caso inductivo 1 -> Si x :: a
--                          m :: Maybe a,
--                              d :: Dungeon a, y están en Dungeon a
--                                  entonces (Pasaje m d) está en Dungeon a
-- Caso inductivo 2 -> Si x :: a
--                          m :: Maybe a,
--                              d1 :: Dungeon a,
--                                  d2 :: Dungeon a, y están en Dungeon a
--                                      entonces (Bifurcacion m d1 d2) está en Dungeon a
-- PREGUNTAR

-- Ej 2.
-- f :: Dungeon a -> b
-- f (Habitacion a) = ...
-- f (Pasaje m d) = ... f d ...
-- f (Bifurcacion m d1 d2) = ... f d1 ... f d2

-- Ej 3.
-- funciones auxiliares
esJust :: Maybe a -> Bool
esJust (Just _) = True
esJust _ = False

unoSiTrue :: Bool -> Int
unoSiTrue True = 1
unoSiTrue _ = 0

sonIguales :: (Eq a) => Maybe a -> a -> Bool
sonIguales (Just x) y = x == y
sonIguales _ _ = False

-- funciones auxiliares

-- dungeons de testeo
-- Dungeon simple: solo una habitación
d1 :: Dungeon Int
d1 = Habitacion 5

-- Dungeon lineal: una habitación seguida de pasajes
d2 :: Dungeon Int
d2 = Pasaje (Just 10) (Habitacion 20)

-- Dungeon lineal más largo
d3 :: Dungeon Int
d3 = Pasaje (Just 1) (Pasaje Nothing (Pasaje (Just 3) (Habitacion 4)))

-- Dungeon con una bifurcación simple
d4 :: Dungeon Int
d4 = Bifurcacion (Just 100) (Habitacion 200) (Habitacion 300)

-- Dungeon con bifurcaciones anidadas
d5 :: Dungeon Int
d5 =
  Bifurcacion
    Nothing
    (Pasaje (Just 1) (Habitacion 2))
    (Bifurcacion (Just 3) (Habitacion 4) (Habitacion 5))

-- Dungeon complejo para probar varias funciones
d6 :: Dungeon String
d6 =
  Bifurcacion
    (Just "sala")
    (Pasaje Nothing (Pasaje (Just "corredor") (Habitacion "puerta")))
    ( Bifurcacion
        (Just "sala2")
        (Habitacion "final1")
        (Pasaje (Just "pasillo") (Habitacion "final2"))
    )

-- Dungeon lleno de un elemento
d7 :: Dungeon Char
d7 =
  Bifurcacion
    (Just 'X')
    (Pasaje (Just 'X') (Habitacion 'X'))
    (Pasaje (Just 'X') (Habitacion 'X'))

-- Dungeon vacio
d8 :: Dungeon Char
d8 =
  Bifurcacion
    Nothing
    (Pasaje Nothing (Habitacion 'X'))
    (Pasaje Nothing (Habitacion 'X'))

-- dungeons de testeo

-- a. cantidadDeBifurcaciones​, que describe la cantidad de bifurcaciones de
-- un dungeon dado.
cantidadDeBifurcaciones :: Dungeon a -> Int
cantidadDeBifurcaciones (Habitacion _) = 0
cantidadDeBifurcaciones (Pasaje m d) = cantidadDeBifurcaciones d
cantidadDeBifurcaciones (Bifurcacion m d1 d2) = 1 + cantidadDeBifurcaciones d1 + cantidadDeBifurcaciones d2

-- b. cantidadDePuntosInteresantes​, que describe la cantidad de puntos
-- interesantes de un dungeon dado. Los puntos interesantes son los lugares
-- donde puede aparecer un elemento.

-- PREGUNTAR: como dice 'donde puede haber' no me interesa si es un Nothing o un Just por lo que entiendo. Actua como un contador
cantidadDePuntosInteresantes :: Dungeon a -> Int
cantidadDePuntosInteresantes (Habitacion a) = 1
cantidadDePuntosInteresantes (Pasaje m d) = 1 + cantidadDePuntosInteresantes d
cantidadDePuntosInteresantes (Bifurcacion m d1 d2) = 1 + cantidadDePuntosInteresantes d1 + cantidadDePuntosInteresantes d2

-- c. cantidadDePuntosVacios​, que describe la cantidad de puntos
-- interesantes del dungeon dado en las que no hay ningún elemento.
cantidadDePuntosVacios :: Dungeon a -> Int
cantidadDePuntosVacios (Habitacion a) = 1
cantidadDePuntosVacios (Pasaje m d) = unoSiTrue (not (esJust m))
cantidadDePuntosVacios (Bifurcacion m d1 d2) = unoSiTrue (not (esJust m)) + cantidadDePuntosVacios d1 + cantidadDePuntosVacios d2

-- d. cantidadDePuntosCon​, que dado un elemento y un dungeon, describe la
-- cantidad de puntos interesantes del dungeon en las que se encuentra el
-- elemento dado.
cantidadDePuntosCon :: (Eq a) => a -> Dungeon a -> Int
cantidadDePuntosCon e (Habitacion a) = unoSiTrue (a == e)
cantidadDePuntosCon e (Pasaje m d) = unoSiTrue (sonIguales m e) + cantidadDePuntosCon e d
cantidadDePuntosCon e (Bifurcacion m d1 d2) = unoSiTrue (sonIguales m e) + cantidadDePuntosCon e d1 + cantidadDePuntosCon e d2

-- e. esLineal​, que indica si no hay bifurcaciones en un dungeon dado.
esLineal :: Dungeon a -> Bool
esLineal (Habitacion _) = True
esLineal (Pasaje _ d) = True && esLineal d
esLineal (Bifurcacion _ _ _) = False

-- f. llenoDe​, que dado un elemento y un dungeon, indica si el elemento se
-- encuentra en todas las posiciones del dungeon.
llenoDe :: (Eq a) => a -> Dungeon a -> Bool
llenoDe e (Habitacion a) = a == e
llenoDe e (Pasaje m d) = sonIguales m e && llenoDe e d
llenoDe e (Bifurcacion m d1 d2) = sonIguales m e && llenoDe e d1 && llenoDe e d2
