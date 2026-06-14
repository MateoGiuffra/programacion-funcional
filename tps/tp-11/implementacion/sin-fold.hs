import Prelude hiding (map, filter, foldr, foldr1, zipWith, scanr, or, and, all, any, length, countBy)
-- Ejercicio 1)  Definir las siguientes funciones utilizando recursión estructural explícita 
-- sobre Pizza: 

-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0
-- auxs


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
pizzaSoloAceitunas = Capa (Aceitunas 10) (Capa (Aceitunas 10) (Capa (Aceitunas 10) (Capa (Aceitunas 10) Prepizza)))

pizzaVariada :: Pizza
pizzaVariada = (Capa Anchoas (Capa Queso (Capa Queso ( Capa (Aceitunas 10) (Capa (Aceitunas 10) (Capa Jamón Prepizza))))))

-- alias de test conveniente
pizzaTest :: Pizza
pizzaTest = pizzaConJamonyAceitunas
-- pizzas de testeo


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


-- a.
cantidadCapasQueCumplen :: (Ingrediente -> Bool) -> Pizza -> Int 
cantidadCapasQueCumplen f Prepizza   = 0
cantidadCapasQueCumplen f (Capa i p) = unoSi (f i) + cantidadCapasQueCumplen f p

-- b.
conCapasTransformadas :: (Ingrediente -> Ingrediente) -> Pizza -> Pizza 
conCapasTransformadas f Prepizza   = Prepizza
conCapasTransformadas f (Capa i p) = Capa (f i) (conCapasTransformadas f p)

-- c.
soloLasCapasQue :: (Ingrediente -> Bool) -> Pizza -> Pizza 
soloLasCapasQue f Prepizza = Prepizza
soloLasCapasQue f (Capa i p) = if f i 
                                then (Capa i (soloLasCapasQue f p))
                                else soloLasCapasQue f p


-- Ejercicio 2)  Definir  las  siguientes  funciones  utilizando  alguna  de  las  definiciones anteriores: 
-- a.

esQueso :: Ingrediente -> Bool
esQueso Queso = True
esQueso _     = False

duplicarAceitunas :: Ingrediente -> Ingrediente
duplicarAceitunas (Aceitunas n) = (Aceitunas (n * 2))
duplicarAceitunas x = x
 
sinLactosa :: Pizza -> Pizza 
sinLactosa p = soloLasCapasQue (not . esQueso) p

-- b.
aptaIntolerantesLactosa :: Pizza -> Bool 
aptaIntolerantesLactosa p = cantidadCapasQueCumplen esQueso p == 0
-- c.
cantidadDeQueso :: Pizza -> Int 
cantidadDeQueso p = cantidadCapasQueCumplen esQueso p
-- d.
conElDobleDeAceitunas :: Pizza -> Pizza
conElDobleDeAceitunas p = conCapasTransformadas duplicarAceitunas p



-- Ejercicio 7)  Definir  las  siguientes  funciones  de  esquemas  sobre  listas,  utilizando 
-- recursión estructural de forma explícita: 
--a.
map :: (a -> b) -> [a] -> [b] 
map f [] = []
map f (x:xs) = f x : map f xs
--b.
filter :: (a -> Bool) -> [a] -> [a] 
filter _ [] = []
filter f (x: xs) = consSi f x (filter f xs)
--c.
foldr :: (a -> b -> b) -> b -> [a] -> b 
foldr f z [] = z 
foldr f z (x:xs) = f x (foldr f z xs)
--d.
recr :: b -> (a -> [a] -> b -> b) -> [a] -> b 
recr z f [] = z
recr z f (x: xs) = f x xs (recr z f xs)
--e.
foldr1 :: (a -> a -> a) -> [a] -> a 
foldr1 f [] = error "No puede ser lista vacia"
foldr1 f (x:xs) = f x (foldr1 f xs)
--f.
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c] 
zipWith f [] _  = []
zipWith f _ []  = []
zipWith f (x:xs) (y:ys) = f x y : zipWith f xs ys
--g. (Desafío) 
scanr :: (a -> b -> b) -> b -> [a] -> [b] 
-- te devuelve una lista con todos los pasos intermedios que se calcularon durante la recursión.
-- foldr (+) 0 [1, 2, 3] -> 6
-- scanr (+) 0 [1, 2, 3] -> [6, 5, 3, 0]
-- primer elemento es el resultado,..., ultimo elemento es el caso base. 
scanr f z [] = [z]
scanr f z (x: xs) = f x z : (scanr f z xs)
    -- let (y: ys) =(scanr f z xs)  in f x y : ys
