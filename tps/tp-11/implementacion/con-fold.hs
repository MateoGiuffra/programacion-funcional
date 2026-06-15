-- imports
import Prelude hiding (map, drop, elemAt, take, takeWhile, sum, filter, foldr, foldr1, zipWith, scanr, or, and, all, any, length, countBy)
twice :: (a -> a) -> (a -> a)
twice f = g
  where
    g x = f (f x)
-- imports

-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0


consSi :: (a -> Bool) -> a -> [a] -> [a]
consSi f x xs = if f x then x : xs else xs


-- auxs Pizza | Ingrediente
esQueso :: Ingrediente -> Bool
esQueso Queso = True
esQueso _     = False

duplicarAceitunas :: Ingrediente -> Ingrediente
duplicarAceitunas (Aceitunas n) = (Aceitunas (n * 2))
duplicarAceitunas x = x
-- auxs Pizza | Ingrediente

-- auxs


-- Ejercicio 1)  Definir las siguientes funciones utilizando recursión estructural explícita 
-- sobre Pizza: 

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



-- Ejercicio 3)  Definir,  
-- que expresa la definición de fold para la estructura de Pizza.                                    
pizzaProcesada :: (Ingrediente -> b -> b) -> b -> Pizza -> b
pizzaProcesada f z Prepizza = z
pizzaProcesada f z (Capa i p) = f i (pizzaProcesada f z p)


-- Ejercicio 4)  
-- Resolver todas las funciones de los puntos 1) y 2) utilizando la función pizzaProcesada.
cantidadCapasQueCumplen' :: (Ingrediente -> Bool) -> Pizza -> Int 
cantidadCapasQueCumplen' f p = pizzaProcesada (\i rs -> unoSi (f i) + rs) 0 p

conCapasTransformadas' :: (Ingrediente -> Ingrediente) -> Pizza -> Pizza 
conCapasTransformadas' f p = pizzaProcesada (\i rs -> (Capa (f i) rs)) Prepizza p

soloLasCapasQue' :: (Ingrediente -> Bool) -> Pizza -> Pizza
soloLasCapasQue' f p = pizzaProcesada (\i rs -> if (f i)
                                                  then (Capa i rs)
                                                  else rs) Prepizza p

aptaIntolerantesLactosa' :: Pizza -> Bool 
aptaIntolerantesLactosa' p = pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) 0 p == 0

cantidadDeQueso' :: Pizza -> Int 
cantidadDeQueso' p = pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) 0 p

conElDobleDeAceitunas' :: Pizza -> Pizza
conElDobleDeAceitunas' p = pizzaProcesada (\i rs -> Capa (duplicarAceitunas i) rs) Prepizza p


-- Ejercicio 5)  Resolver las siguientes funciones utilizando pizzaProcesada (si resulta 
-- demasiado complejo resolverlas, dar primero una definición por recursión estructural 
-- explícita, y usar la técnica de los “recuadros”): 
-- a.
cantidadAceitunas :: Pizza -> Int 
cantidadAceitunas p = pizzaProcesada (\i rs -> cantAceitunasIng i + rs) 0 p
-- b.
capasQueCumplen :: (Ingrediente -> Bool) -> Pizza -> [Ingrediente] 
capasQueCumplen f p = pizzaProcesada (\i rs -> (consSi f i rs)) [] p
-- c.
conDescripcionMejorada :: Pizza -> Pizza 
conDescripcionMejorada p = pizzaProcesada juntarAceitunas Prepizza p

juntarAceitunas :: Ingrediente -> Pizza -> Pizza
juntarAceitunas (Aceitunas n) (Capa (Aceitunas m) p) = Capa (Aceitunas (n + m)) p
juntarAceitunas i p = Capa i p

-- d.
-- que agrega las capas de la primera pizza sobre la segunda 
conCapasDe :: Pizza -> Pizza -> Pizza
conCapasDe p1 p2 = pizzaProcesada (\i rs -> Capa i rs) p1 p2
-- e.
primerasNCapas :: Int -> Pizza -> Pizza 
primerasNCapas = flip (pizzaProcesada pasoNCapas siemprePrepizza)

pasoNCapas :: Ingrediente -> (Int -> Pizza) -> Int -> Pizza
pasoNCapas i rs k = if k == 0 
                        then Prepizza 
                        else Capa i (rs (k - 1))

siemprePrepizza :: a -> Pizza
siemprePrepizza _ = Prepizza

{-
-> primerasNCapas 1 (Capa Queso Prepizza)
def primerasNCapas, n <- 1, p <- (Capa Queso Prepizza)
-> pizzaProcesada pasoNCapas siemprePrepizza (Capa Queso Prepizza) 1
def pizzaProcesada, f <- pasoNCapas, i <- Queso, z <- siemprePrepizza, p <- Prepizza
-> pasoNCapas Queso (pizzaProcesada pasoNCapas siemprePrepizza Prepizza) 1 
def pizzaProcesada, z <- siemprePrepizza
-> pasoNCapas Queso (siemprePrepizza) 1
def pasoNCapas, i <- Queso, rs <- siemprePrepizza, k <- 1
-> Capa Queso (siemprePrepizza (1 - 1))
def siemprePrepizza
-> Capa Queso Prepizza
-}

cantAceitunasIng :: Ingrediente -> Int
cantAceitunasIng (Aceitunas n) = n
cantAceitunasIng _ = 0

-- Ejercicio 9)  Definir las siguientes funciones utilizando solamente foldr en conjunto 
-- con algunos combinadores (como por ejemplo flip). Tener en cuenta utilizar la 
-- cantidad mínima necesaria de argumentos en las definiciones

--
-- reemplaza la recursion normal en listas recibiendo f, caso base y la lista.
foldr :: (a -> b -> b) -> b -> [a] -> b 
foldr f z [] = z 
foldr f z (x:xs) = f x (foldr f z xs)
--d.
-- cuando no siempre hago recursion hasta el final, o sea la corto antes (recursion primitiva)
recr :: b -> (a -> [a] -> b -> b) -> [a] -> b 
recr z f [] = z
recr z f (x: xs) = f x xs (recr z f xs)
--e.
-- cuando tengo que romper si llego a lista vacia, por ej maximum
foldr1 :: (a -> a -> a) -> [a] -> a 
foldr1 f [] = error "No puede ser lista vacia"
foldr1 f (x:xs) = f x (foldr1 f xs)
--


-- a.
sum :: [Int] -> Int 
sum xs = foldr (+) 0 xs

-- b.
length :: [a] -> Int 
length xs = foldr (\x rs -> 1 + rs) 0 xs
-- c.
map :: (a -> b) -> [a] -> [b] 
map f xs = foldr ((:) . f) [] xs
-- d.
filter :: (a -> Bool) -> [a] -> [a] 
filter f xs = foldr (consSi f) [] xs
-- e.
find :: (a -> Bool) -> [a] -> Maybe a 
-- find f xs = foldr (\x rs -> if f x then Just x else rs) Nothing xs
find f xs = recr Nothing (\x xs rs -> if f x then Just x else rs) xs

-- f.
any :: (a -> Bool) -> [a] -> Bool 
any f xs = foldr ((||) . f) False xs

-- g.
all :: (a -> Bool) -> [a] -> Bool 
all f xs = foldr ((&&) . f) True xs

-- h.
countBy :: (a -> Bool) -> [a] -> Int 
countBy f xs = foldr ((+) . (unoSi . f)) 0 xs

-- i.
partition :: (a -> Bool) -> [a] -> ([a], [a]) 
partition f xs = foldr (addInPartition f) ([], []) xs

addInPartition :: (a -> Bool) -> a -> ([a], [a]) -> ([a], [a]) 
addInPartition f x (rs1, rs2) = if f x 
                                   then ((x : rs1), rs2)
                                   else (rs1, (x : rs2))
-- -- j.
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c] 
zipWith f xs ys = foldr 
  (addInZipWith f) (\ys -> []) xs ys

addInZipWith :: (a -> b -> c) -> a -> ([b] -> [c]) -> [b] -> [c]
addInZipWith f x rs [] = []
addInZipWith f x rs (y:ys) = f x y : rs ys

-- -- k.
-- scanr :: (a -> b -> b) -> b -> [a] -> [b] 
-- -- l.
takeWhile :: (a -> Bool) -> [a] -> [a] 
takeWhile f xs = foldr (\x rs -> if f x then x : rs else []) [] xs

-- -- m.
take :: Int -> [a] -> [a] 
take n xs = foldr (\x rs n -> if n == 0 then rs n else x : rs (n-1)) (\_ -> [])  xs n
-- -- n.
drop :: Int -> [a] -> [a] 
drop n xs = foldr (\x rs n -> if n <= 0 then x : rs (n-1) else rs (n - 1)) (\_ -> []) xs n
-- -- o.
elemAt :: Int -> [a] -> a
elemAt n xs = foldr (\x rs n -> if n == 0 then x else rs (n - 1)) (error "no se encontro") xs n


-- Ejercicio 10)  Indicar cuáles de las siguientes expresiones tienen tipo, y para aquellas 
-- que lo tengan, decir cuál es ese tipo: 
{-
a.filter id :: [Bool] -> [Bool]
b.map (\x y z -> (x, y, z))

lamdba = (\x y z -> (x, y, z))

map :: (a -> b) -> [a] -> [b] 
lamdba:: c -> d -> e -> (c, d, e)
--------------------------------
map lamdba :: ???

(c -> (d -> (e -> (c, d, e))))
(a -> b)
a = c 
b = d -> e -> (c, d, e)

map :: (c -> d -> e -> (c, d, e)) -> [c] -> [d -> e -> (c, d, e)] 
lamdba:: c -> d -> e -> (c, d, e)
--------------------------------
map lamdba :: [c] -> [d -> e -> (c, d, e)] 
map lamdba :: [a] -> [b -> c -> (a, b, c)] 


c.map (+)

map :: (a -> b) -> [a] -> [b] 
(+) :: Int -> Int -> Int
--------------------------
map (+) :: ???

-- reemplazo de tipos de argumento
(a -> b) 
Int -> (Int -> Int)
a = Int
b = (Int -> Int)
-- reemplazo de tipos de argumento

map :: (Int -> Int -> Int) -> [Int] -> [Int -> Int] 
(+) :: Int -> Int -> Int
--------------------------
map (+) :: [Int] -> [Int -> Int] 


d.filter fst 

filter :: (a -> Bool) -> [a] -> [a] 
fst :: (b, c) -> b
----------------------
filter fst :: ???

-- reemplazo
(a -> Bool)
(b, c) -> b

a = (Bool, c)
Bool = b
-- reemplazo

filter :: ((Bool, c) -> Bool) -> [(Bool, c)] -> [(Bool, c)] 
fst :: (b, c) -> b
----------------------
filter fst :: [(Bool, c)] -> [(Bool, c)] 
filter fst :: [(Bool, b)] -> [(Bool, b)] 

e.filter (flip const (+)) 

-- planteo.1
filter :: (a -> Bool) -> [a] -> [a]
(flip const (+))  :: ??
-----------------------------
filter (flip const (+)) :: ??

-- planteo.2
flip const :: ??
(+) ::  ??
-------------------------
(flip const (+))  :: ??

-- planteo.3
flip  :: (a -> b -> c) -> b -> a -> c
const :: d -> e -> d   
-------------------
flip const :: ??

-- reemplazo-plateo.3
(a -> b -> c)
d -> e -> d
a = d
b = e
c = d

-- resolucion-planteo.3
flip  :: (d -> e -> d) -> e -> d -> d
const :: d -> e -> d   
-------------------
flip const :: e -> d -> d

-- resolucion-planteo.2
flip const :: e -> d -> d
(+) ::  Int -> Int -> Int
-------------------------
(flip const (+))  :: d -> d

-- resolucion-planteo.1
filter :: (a -> Bool) -> [a] -> [a]
(flip const (+))  :: d -> d
-----------------------------
filter (flip const (+)) :: ??

reemplazo-planteo.1
d -> d
a -> Bool
a = Bool = d 

filter :: (Bool -> Bool) -> [Bool] -> [Bool]
(flip const (+))  :: d -> d
-----------------------------
filter (flip const (+)) :: [Bool] -> [Bool]

f.map const 
map :: (a -> b) -> [a] -> [b]
const :: c -> d -> c
-----------------------------
map const :: ??

reemplazo
a -> b
c -> d -> c

a = c
b = d -> c

map :: (c -> d -> c) -> [c] -> [d -> c]
const :: c -> d -> c
-----------------------------
map const :: [c] -> [d -> c]
map const :: [a] -> [b -> a]

g.map twice 

map :: (a -> b) -> [a] -> [b] 
twice :: (c -> c) -> (c -> c)
--------------------------------
map twice :: ??

reemplazo
(a -> b)
(c -> c) -> (c -> c)
a = (c -> c) = b


map :: (c -> c -> c -> c) -> [c -> c] -> [c -> c] 
twice :: (c -> c) -> (c -> c)
--------------------------------
map twice :: [c -> c] -> [c -> c] 
map twice :: [a -> a] -> [a -> a] 


h.foldr twice 
foldr  :: (a -> b -> b) -> b -> [a] -> b
twice :: (c -> c) -> (c -> c)
------------------------------------------------------
foldr twice :: ?? 

reemplazo
(a       -> (b -> b))
(c -> c) -> (c -> c)

a = (c -> c) 
b = c 

foldr  :: ((c -> c) -> c -> c) -> c -> [c -> c] -> c
twice :: (c -> c) -> (c -> c)
------------------------------------------------------
foldr twice :: c -> [c -> c] -> c
foldr twice :: a -> [a -> a] -> a


i.zipWith fst 

zipWith :: (a -> b -> c) -> [a] -> [b] -> [c] 
fst     :: (d, e) -> d
--------------------------------------- 
zipWith fst :: ??

-- reemplazo
a = (d, e)
d = b -> c  -- d es una funcion!

-- entonces
a = (b -> c, e)

-- y fst queda:
fst :: (b -> c, e) -> (b -> c)  -- d reemplazado por b -> c

-- zipWith fst:
zipWith :: ((b->c, e) -> b -> c) -> [(b->c, e)] -> [b] -> [c]
fst     :: (b->c, e) -> (b->c)
---------------------------------------
zipWith fst :: [(b->c, e)] -> [b] -> [c]



j.foldr (\x r z -> (x, z) : r z) (const []) 

-- nombro por comodidad
lamdba = (\x r z -> (x, z) : r z)

-- definicion de tipos
lamdba :: a -> (b -> [(a, b)]) -> b -> [(a, b)]
const []) :: c -> [d] 

-- planteos:

planteo.1
foldr lamdba :: ??
(const []) :: c -> [d]
---------------------------------------------------------
foldr lamdba (const []) :: ??

planteo.2
foldr :: (a -> b -> b) -> b -> [a] -> b
lamdba :: a2 -> (b2 -> [(a2, b2)]) -> b2 -> [(a2, b2)]
---------------------------------------------------------
foldr lamdba :: ??

reemplazo-planteo.2
(a ->         b          ->       b)
a2 -> (b2 -> [(a2, b2)]) -> (b2 -> [(a2, b2)])

a = a2
b = (b2 -> [(a2, b2)])

resolucion-planteo.2
foldr  :: (a2 -> (b2 -> [(a2, b2)]) -> (b2 -> [(a2, b2)])) -> (b2 -> [(a2, b2)]) -> [a2] -> (b2 -> [(a2, b2)])
lamdba :: a2 -> (b2 -> [(a2, b2)]) -> b2 -> [(a2, b2)]
---------------------------------------------------------
foldr lamdba ::  (b2 -> [(a2, b2)]) -> [a2] -> b2 -> [(a2, b2)]

resolucion-planteo.1
foldr lamdba :: (b2 -> [(a2, b2)]) -> [a2] -> b2 -> [(a2, b2)]
(const []) :: c -> [d]
---------------------------------------------------------
foldr lamdba (const []) :: ??


(b2 -> [(a2, b2)])
c   -> d
c = b2
d = [(a2, b2)] -- aca [(a2, b2)] no pasa a ser d, se deja como esta porque en el sistema de tipos gana el tipo con mas detalle


resolucion-planteo.1
foldr lamdba :: (b2 -> [(a2, b2)]) -> [a2] -> b2 -> [(a2, b2)]
(const []) :: c -> [d] -- esto no se si lo puedo cambiar
---------------------------------------------------------
foldr lamdba (const []) :: [a2] -> b2 -> [(a2, b2)]

-}