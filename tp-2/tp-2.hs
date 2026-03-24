doble :: Int -> Int
doble x = x + x

cuadruple :: Int -> Int
cuadruple x = 4 * x

apply f = g
    where g x = f x


first :: (a,b) -> a
first (a,b) = a

uflip :: ((b,a) -> c) -> (a,b) -> c
uflip f p = f (swap p)

swap :: (a,b) -> (b,a)
swap (x, y) = (y, x)

twice :: (a -> a) -> (a -> a)
twice f = g 
    where g x = f (f x)


-- ej 3:
const :: a -> (b -> a)
const x y = x

appDup:: ((a,a) -> b) -> a -> b
-- appDup f x = f(x,x)
appDup f = g
    where g x = f (x, x)

appFork :: (a -> b, a -> c) -> a -> (b,c)
-- appFork (f, g) x = (f x, g x)
appFork (f, g) = h
    where h x = (f x, g x)


appPar :: (a -> c, b -> d ) -> (a, b) -> (c, d)
appPar (f, g) (x, y) = (f x, g y)

appDist :: (a -> b) -> (a, a) -> (b, b)
appDist f (x, y) = (f x, f y)


flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

subst :: (a -> (b -> c)) -> (a -> b) -> a -> c
subst f g x = (f x) (g x)


-- I. (a -> b, c -> d) -> ((a, c) -> (b, d)) = appPar
-- II. ((a, a) -> b) -> (a -> b)  = appDup
-- III. (a -> (b -> c)) -> (b -> (a -> c)) = flip
-- IV. (a -> b) -> ((a, a) -> (b, b)) = appDist
-- V. (a -> b, a -> c) -> (a -> (b, c)) = appFork
-- VI. (a -> (b -> c)) -> ((a -> b) -> (a -> c)) = subst
-- VII. a -> (b -> a) = constconst :: a -> (b -> a)
const x y = x

appDup:: ((a,a) -> b) -> a -> b
-- appDup f x = f(x,x)
appDup f = g
    where g x = f (x, x)

appFork :: (a -> b, a -> c) -> a -> (b,c)
-- appFork (f, g) x = (f x, g x)
appFork (f, g) = h
    where h x = (f x, g x)


appPar :: (a -> c, b -> d ) -> (a, b) -> (c, d)
appPar (f, g) (x, y) = (f x, g y)

appDist :: (a -> b) -> (a, a) -> (b, b)
appDist f (x, y) = (f x, f y)


flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

subst :: (a -> (b -> c)) -> (a -> b) -> a -> c
subst f g x = (f x) (g x)


-- I. (a -> b, c -> d) -> ((a, c) -> (b, d)) = appPar
-- II. ((a, a) -> b) -> (a -> b)  = appDup
-- III. (a -> (b -> c)) -> (b -> (a -> c)) = flip
-- IV. (a -> b) -> ((a, a) -> (b, b)) = appDist
-- V. (a -> b, a -> c) -> (a -> (b, c)) = appFork
-- VI. (a -> (b -> c)) -> ((a -> b) -> (a -> c)) = subst
-- VII. a -> (b -> a) = const

{-
Ejercicio 4) Para cada una de las siguientes expresiones decidir si poseen tipo. Si es
así indicar cuál es.
a. 1 && 2 == 2  :: Error, no posee tipo. 1 no es un booleano valido en haskell.
b. 1 + if 3 < 5 then 3 else 5 :: Int
c. let par = (True, 4) 
	in (if first par then first par else second par) :: Error, no se puede tipar. El then devuelve un Bool y el else un Int
d. (doble doble) 5 :: Error, doble espera un Int y no una función. No tiene tipo.
e. doble (doble 5) :: Int
f. twice first :: No posee tipo.First es de tipo (a, b) -> a y twice es de tipo (t -> t) -> (t -> t).
Espera que first pueda recibir lo mismo que devuelve, pero no es el caso.
g. (twice doble) doble :: No posee tipo. Doble espera un Int, no una funcion. 
h. (twice twice) first :: No posee tipo. Misma razon que el punto F.
i. apply apply :: (a -> b) -> (a -> b)

-}


{-

Ejercicio 5) Dar dos ejemplos de expresiones que tengan cada uno de los siguientes tipos:
a. Bool: 
esCinco :: Int -> Bool
esCinco x = x == 5

esPar :: Int -> Bool
esPar x = x `mod` 2 == 0 

b. (Int, Int)
doblePar :: Int -> Int -> (Int, Int)
doblePar x, y:: (doble x, doble y)

crearPar :: Int -> Int -> (Int, Int)
crearPar x, y:: (x, y)

c. Char -> Int
unoSiEsLaPrimerLetraDelAbecedario :: Char -> Int
unoSiEsLaPrimerLetraDelAbecedario "A" = 1
unoSiEsLaPrimerLetraDelAbecedario _ = 0

unoSiEsLaUltimaLetraDelAbecedario :: Char -> Int
unoSiEsLaUltimaLetraDelAbecedario "Z" = 1
unoSiEsLaUltimaLetraDelAbecedario _ = 0


d. (Int, Char) -> Bool
hacer

e. (Int -> Int) -> Int

sumarPar :: (Int -> Int) -> Int
sumarPar (x,y) = x + y

restarPar :: (Int -> Int) -> Int
restarPar (x,y) = x - y


f. (Bool -> Bool, Int)
(/x -> x, 1) :: (Bool -> Bool, Int)
(not, 42) :: (Bool -> Bool, Int)

g. a -> Bool
esNulo :: a -> Bool 
esNulo [] = True
esNulo 0 = True
esNulo _ = False

esLista :: a -> Bool
esLista [] = True
esLista (x:xs) = True
esLista _ = False

-}