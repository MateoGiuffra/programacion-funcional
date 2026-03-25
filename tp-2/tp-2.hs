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


appDist :: (a -> b) -> (a, a) -> (b, b)
appDist f (x, y) = (f x, f y)


appFork :: (a -> b, a -> c) -> a -> (b,c)
-- appFork (f, g) x = (f x, g x)
appFork (f, g) = h
    where h x = (f x, g x)


appPar :: (a -> c, b -> d ) -> (a, b) -> (c, d)
appPar (f, g) (x, y) = (f x, g y)


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




-- Ejercicio 5) Dar dos ejemplos de expresiones que tengan cada uno de los siguientes tipos:
-- a. Bool: 
esCinco :: Int -> Bool
esCinco x = x == 5

esPar :: Int -> Bool
esPar x = x `mod` 2 == 0 

-- b. (Int, Int)
doblePar :: Int -> Int -> (Int, Int)
doblePar x y = (doble x, doble y)

crearPar :: Int -> Int -> (Int, Int)
crearPar x y = (x, y)

-- c. Char -> Int
unoSiEsLaPrimerLetraDelAbecedario :: Char -> Int
unoSiEsLaPrimerLetraDelAbecedario 'a' = 1
unoSiEsLaPrimerLetraDelAbecedario _ = 0

unoSiEsLaUltimaLetraDelAbecedario :: Char -> Int
unoSiEsLaUltimaLetraDelAbecedario 'z' = 1
unoSiEsLaUltimaLetraDelAbecedario _ = 0


-- d. (Int, Char) -> Bool
-- hacer

-- e. (Int -> Int) -> Int
aplicarCero :: (Int -> Int) -> Int
aplicarCero f = f 0

aplicarNegativo :: (Int -> Int) -> Int
aplicarNegativo f = f (-5)

-- f. (Bool -> Bool, Int)
-- (/x -> x, 1) :: (Bool -> Bool, Int)
-- (not, 42) :: (Bool -> Bool, Int)

-- g. a -> Bool
siempreTrue :: a -> Bool
siempreTrue _ = True

siempreFalse :: a -> Bool
siempreFalse _ = False

{-

Ejercicio 6) Para cada una de las siguientes expresiones, decir a cuál función del
ejercicio 3 es equivalente. Ofrecer argumentos de por qué son equivalentes.
a. \p -> let (f, g) = p
	in \x -> (f x, g x)
appFork porque p es un par de funciones que se aplica a x. 


b. \f -> (\g -> (\x -> f x (g x))
subst porque recibe dos funciones, una f y otra g y su parametro x. Despues aplica f x que debe devolver una funcion que acepte el resultado de aplicarle g a x.


c. \f -> (\x -> (\y -> (f y) x)
flip 

d. \f -> (\px -> let (x, y) = px
	in (f x, f y))
appDist

e. \x -> (\y -> x)
const

f. \pf -> let (f, g) = pf
			in \px -> let (x, y) = p
						in (f x, g y)
appPar

g. \f -> (\x -> f (x, x))
appDup

-}

{-

Ejercicio 7) Encontrar cuales de estas expresiones son equivalentes entre sí.
Sugerencia: utilizar funciones anónimas es una forma interesante de encontrar
equivalencias entre expresiones que denotan funciones.

a. appFork (id,id)


appFork :: (a -> b, a -> c) -> a -> (b,c)
appFork (f, g) x = (f x, g x)
-- en lamdba:
\(f, g) -> \x -> (f x, g x)

por def de appFork, siendo f = g = id
-> \(id, id) -> \x -> (id x, id x)
por red. beta, siendo x = x
-> (id x, id x) 
por def de id, siendo x = x
-> (x, id x) 
por def de id, siendo x = x
-> (x, x) 


appFork (id, id) :: a -> (a, a)


b. \f -> appDup (appDist f)

appDup:: ((a,a) -> b) -> a -> b
appDup f x = f(x,x)
-- en lamdba:
appDub = \f -> \x -> f(x, x)

appDist :: (a -> b) -> (a, a) -> (b, b)
appDist f (x, y) = (f x, f y)
-- en lamdba:
appDist = \f -> \(x, y) -> (f x, f y)

\f -> appDup (appDist f)
por def de appDup, siendo f = (appDist f)
\f -> (\(appDist f) -> \x -> (appDist f) (x, x))
por red. beta, siendo x = x
\f -> \x -> appDist f (x, x)
por def de appDist, donde f = f, siendo x = x, y = x
\f -> \x -> (\f -> \(x, x) -> (f x, f x))
por red beta
\f -> \x -> (f x, f x)


appDup (appDist f) :: (a -> b) -> a -> (b, b)

c. appDup id
\id -> \x -> id(x, x)
por red beta
\x -> id(x, x)

appDup id :: a -> (a,a)

d. appDup appFork


appFork :: (a -> b, a -> c) -> a -> (b,c)
appFork (f, g) x = (f x, g x)
-- lamdba:
appFork = (\(f,g) -> \x -> (f x, g x))


appDup appFork
por def de addDup, siendo f = appFork
-> appFork (x,x)
x tiene q ser una funcion, por lo tanto f = g = x
-> (x x', x x') 
se le aplica la misma funcion a el mismo parametro, por lo tanto van a devolver lo mismo.
				recibe una funcion que recibe a que devuelve b. Recibimos a. Devolvemos el resultado de la funcion aplicada
appDup appFork :: 	(						a 			-> 	b)   -> a 				-> (b, b)
appDup appFork :: (a -> b) -> a -> (b, b)

Otra expliacion con lamdbas: 

appDup appFork
por def de addDup, siendo f = appFork
-> \appFork -> \x -> appFork(x, x)
por red. bet
-> \x -> appFork(x, x)
por def de appFork, siendo f = g = x
-> \x -> (\(x,x) -> \y -> (x y, x y))
por red. bet
-> \x -> \y -> (x y, x y)
necesita -> necesita -> devuelve
.. 		 -> 	.. 		-> 	.. 
(a -> b) -> a -> (b,b)


e. flip (appDup const)

-- definiciones
-- 1. Definiciones en lambda
flip   = \f -> \xF -> \yF -> (f yF) xF
appDup = \fA -> \xA -> fA (xA, xA)
const  = \c -> \c2 -> c

-> flip (appDup const)
por def. de appDup, siendo fA = const
-> flip (\const -> \xA -> const (xA, xA))
por red. beta, siendo xA = xA
-> flip (\xA -> const (xA, xA))
por def. de const, donde c = (xA, xA),
-> flip (\xA -> (\(xA, xA) -> \c2 -> (xA, xA)))
por red. beta
-> flip (\xA -> (\c2 -> (xA, xA)))
por def. de flip, siendo f = (\xA -> (\c2 -> (xA, xA)))
-> \(\xA -> (\c2 -> (xA, xA))) -> \xF -> \yF -> ((\xA -> (\c2 -> (xA, xA))) yF) xF 
por red. beta
-> \xF -> \yF -> ((\xA -> (\c2 -> (xA, xA))) yF) xF 
por red. beta
-> \xF -> \yF -> ((\c2 -> (yF, yF))) xF 
por red. beta, (\c2 -> (yF, yF)) es const, por lo tanto, consume a xF pero devuelve el par
-> \xF -> \yF -> (yF, yF) 
flip (appDup const) :: a -> b -> (b, b)



f. const (appDup id)
por def de appDup, siendo fA = id
const (\id -> \xA -> id (xA, xA))
Reducción beta de ID dentro de la tupla
-- x = (xA, xA)
const (\xA -> (xA, xA))
aplicamos const a (\xA -> (xA, xA))
\c2 -> (\xA -> (xA, xA))
const (appDup id) :: a -> (b -> (b, b))
-}


