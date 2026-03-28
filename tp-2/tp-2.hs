doble :: Int -> Int
doble x = x + x

cuadruple :: Int -> Int
cuadruple x = 4 * x

apply :: (a -> b) -> a -> b
apply f = g
  where
    g x = f x

first :: (a, b) -> a
first (a, b) = a

uflip :: ((b, a) -> c) -> (a, b) -> c
uflip f p = f (swap p)

swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

twice :: (a -> a) -> (a -> a)
twice f = g
  where
    g x = f (f x)

{-
Ejercicio 2:
a. apply first

apply 		:: (a -> b) -> a ->  b
first 		:: (c,d) -> c
-----------------------------------
apply first ::

(a 		-> b)
	=
(c,d) 	-> c

 -------> b = c
 -------> a = (c, d) = (b, d)

apply 		:: ((b, d) -> b) -> (b, d) ->  b
first 		:: (b,d) -> b
-----------------------------------
apply first :: (b, d) ->  b

b. first (swap, uflip)

first		  		:: (a, b) -> a
(swap, uflip) 		:: ((c, d) -> (d, c), ((f,e) -> g) -> (e,f) -> g)
-------------------------------------
first (swap, uflip) ::

(a, b)
 =
((c, d) -> (d, c), ((f,e) -> g) -> (e,f) -> g)

--------> a = (c, d) -> (d, c)
--------> b = ((f, e) -> g) -> (e,f) -> g

first		  		:: ((c, d) -> (d, c), ((f, e) -> g) -> (e,f) -> g) -> (c, d) -> (d, c)
(swap, uflip) 		:: ((c, d) -> (d, c), ((f,e) -> g) -> (e,f) -> g)
-------------------------------------
first (swap, uflip) :: (c, d) -> (d, c)

c. twice doble

twice		::  (a -> a) -> (a -> a)
doble		::  Int -> Int
-----------------------------
twice doble ::

Int -> Int
(a -> a)
 -------> a = Int

twice		::  (Int -> Int) -> (Int -> Int)
doble		::  Int -> Int
-----------------------------
twice doble :: Int -> Int

d. twice twice
twice :: (a -> a) -> (a -> a)
twice :: (a2 -> a2) -> (a2 -> a2)
---------------------
twice twice ::

(a 			-> 		a)
(a2 -> a2) 	-> (a2 -> a2)

(a2 -> a2) = a

twice :: ((a2 -> a2) -> (a2 -> a2)) -> ((a2 -> a2) -> (a2 -> a2))
twice :: (a2 -> a2) -> (a2 -> a2)
---------------------
twice twice :: (a2 -> a2) -> a2 -> a2

e. twice uflip

twice 		:: (a -> a) -> (a -> a)
uflip 		:: ((c,b) -> d) -> (b,c) -> d
---------------------------------------------------
twice uflip :: ????

(a 			  -> 		a)
((c,b) -> d) -> (b,c) -> d

a = (c,b) -> d
a = (b,c) -> d
como a es igual a (c, b) y (b, c) entonces b = c.
para renombrar la igualdad entre b y c voy a usar la letra e
a

twice 		:: (((e,e) -> d) -> ((e,e) -> d)) -> (((e,e) -> d) -> ((e,e) -> d))
uflip 		:: ((e,e) -> d) -> (e,e) -> d
---------------------------------------------------
twice uflip :: ((e,e) -> d) -> (e,e) -> d

f. twice swap

twice		:: (a -> a) -> a -> a
swap		:: (b,c) -> (c,b)
----------------------------------
twice swap  :: ???

(a 		-> 	a)
(b,c) 	-> (c,b)
como a es igual a (c, b) y (b, c) entonces b = c.
para renombrar la igualdad entre b y c voy a usar la letra e

twice		:: ((e,e) -> (e,e)) -> (e,e) -> (e,e)
swap		:: (e,e) -> (e,e)
----------------------------------
twice swap  :: (e,e) -> (e,e)

g. uflip swap

uflip	   :: ((b, a) -> c) -> (a, b) -> c
swap	   :: (d, e) -> (e, d)
---------------------------
uflip swap :: ????

((b, a) -> c)

(d, e) -> (e, d)

(b, a) = (d, e)
----> b = d
----> a = e
c = (e, d)
----> c = (e, d)

uflip	   :: ((d, e) -> (e, d)) -> (e, d) -> (e, d)
swap	   :: (d, e) -> (e, d)
---------------------------
uflip swap :: (e, d) -> (e, d)

h. (twice twice) swap :: (a, a) -> (a, a)
El tipo seria (a, a) -> (a, a) porque como vimos en los puntos
f, c, d y e, donde tenemos twice f, siendo f cualquier funcion,
el tipo resultante de la expresion twice f es el tipo de f.

En conclusion, el tipo de la expresion twice twice va a ser de tipo twice,
y el tipo de la expresion de twice swap es el tipo desarollado en el
punto f.

-}

-- ej 3:
const :: a -> (b -> a)
const x y = x

appDup :: ((a, a) -> b) -> a -> b
-- appDup f x = f(x,x)
appDup f = g
  where
    g x = f (x, x)

appDist :: (a -> b) -> (a, a) -> (b, b)
appDist f (x, y) = (f x, f y)

appFork :: (a -> b, a -> c) -> a -> (b, c)
-- appFork (f, g) x = (f x, g x)
appFork (f, g) = h
  where
    h x = (f x, g x)

appPar :: (a -> c, b -> d) -> (a, b) -> (c, d)
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

a. appFork (id, id) 

appFork = (\x -> \y -> \z -> (x z, y z))
-> en este caso, x = y = id
appFork = (\id -> \id -> \z -> (id z , id z))
por def de id, x = z en ambas instancias
(z, z)

b. \f -> appDup (appDist f) 

c. appDup id 
appDup = \f -> \x -> f (x, x)
appDup = \id -> \x -> id (x, x)
-> por def de id, xId = (x, x)
(x, x)

d. appDup appFork  
e. flip (appDup const) 
f. const (appDup id)

Equivalencias: 
appFork (id, id) <-> appDup id

-}
