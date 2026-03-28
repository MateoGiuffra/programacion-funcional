-- DEFINICIONES -- DEFINICIONES -- DEFINICIONES -- DEFINICIONES
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

doble :: Int -> Int
doble = (* 2)

fst :: (a, b) -> a
fst (x, y) = x

snd :: (a, b) -> b
snd (x, y) = y

-- DEFINICIONES -- DEFINICIONES -- DEFINICIONES -- DEFINICIONES

-- ej1
curry :: ((a, b) -> c) -> a -> b -> c
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) = f x y

-- ej 2 y 3
-- a. apply f = g
--   where g x = f x
apply :: (a -> b) -> a -> b
apply f x = f x

-- b. twice f = g
--   where g x = f (f x)
twice :: (a -> a) -> a -> a
twice f x = f (f x)

-- c. id = \x -> x
id :: a -> a
id x = x

-- d. flip f = g
--   where g x = h
--         h y = (f y) x
flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

-- e. uflip f = g
--   where g p = f (swap p)
uflip :: ((b, a) -> c) -> (a, b) -> c
uflip f p = f (swap p)

-- f. const = \x -> (\y -> x)
const :: a -> b -> a
const x y = x

-- g. compose = \f -> (\g -> (\x -> f (g x)))
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

{-

-- ej 4
Regla de aplicación:
f   :: A -> B
e   :: A
f e :: B

a. apply apply apply
((apply apply) apply)
def de apply: f x = f x, donde f = apply
-> \apply -> \x -> apply x
por red beta
-> (\x -> apply x) apply
por def de apply, donde x (que seria la funcion f) es el ultimo apply
-> (\apply -> apply apply)
por red beta
-> apply

el resultado de aplicar apply 3 veces consecutivas nos da apply,
cuyo tipado es = (a -> b) -> a -> b
por lo tanto
apply apply apply :: (a -> b) -> a -> b

b. twice doble 2
((twice doble) 2)

twice       :: (Int -> Int) -> (Int -> Int)
doble       :: (Int -> Int)
---------------------------
twice doble :: (Int -> Int)         (twice doble)   :: Int -> Int
                                    2               :: Int
                                    ------------------------------
                                    (twice doble) 2 :: Int

c. twice twice twice swap
(((twice twice) twice) swap)
twice       :: (a1 -> a1) -> (a1 -> a1)
twice       :: (a2 -> a2) -> (a2 -> a2)
---------------------
twice twice :: B

 ---------> a1 = (a2 -> a2)

twice       :: ((a2 -> a2) -> (a2 -> a2)) -> ((a2 -> a2) -> (a2 -> a2))
twice       :: (a2 -> a2) -> (a2 -> a2)
---------------------
twice twice :: (a2 -> a2) -> (a2 -> a2)     twice twice       :: (a2 -> a2) -> (a2 -> a2)
                                            twice             :: (a3 -> a3) -> (a3 -> a3)
                                            ---------------------
                                            (twice twice) twice :: B'

                                             ---------> a2 = (a3 -> a3)

                                            twice twice       :: ((a3 -> a3) -> (a3 -> a3)) -> ((a3 -> a3) -> (a3 -> a3))
                                            twice             :: (a3 -> a3) -> (a3 -> a3)
                                            ---------------------
                                            (twice twice) twice :: (a3 -> a3) -> (a3 -> a3)     (twice twice) twice         :: (a3 -> a3) -> (a3 -> a3)
                                                                                                swap                        :: (b, c) -> (c, b)
                                                                                                -------------------------------------
                                                                                                ((twice twice) twice) swap  :: B''

                                                                                                 ---------> (a3 -> a3) = (b, c)
                                                                                                 --------->  (a3 -> a3) = (c, b)
                                                                                                 ---------> esto es posible solamente si b = c.
                                                                                                 ---------> Renombro la igualdad usando la letra d. b = c = d.

                                                                                                (twice twice) twice         :: ((d,d) -> (d,d)) -> ((d,d) -> (d,d))
                                                                                                swap                        :: (d, d) -> (d, d)
                                                                                                -------------------------------------
                                                                                                ((twice twice) twice) swap  :: (d,d) -> (d,d)

d. flip twice 1 doble
(((flip twice) 1) doble)
flip        :: (b -> a -> c) -> a -> b -> c
twice       :: (d -> d) -> (d -> d)
-------------------------------
flip twice  ::
(b       -> a -> c)
         =
(d -> d) -> (d -> d)
 --------> b        = (d -> d)
 --------> (a -> c) = (d -> d)
 --------> esto implica que a = d, c = d

flip        :: ((d -> d) -> d -> d) -> d -> (d -> d) -> d
twice       :: (d -> d) -> (d -> d)
-----------------------------------------------------------
flip twice  :: d -> (d -> d) -> d

(flip twice)    :: d -> (d -> d) -> d
1               :: Int
----------------------------------------
(flip twice) 1  ::

 ---------> d = Int

(flip twice)    :: Int -> ((Int -> Int) -> Int)
1               :: Int
----------------------------------------
(flip twice) 1  :: (Int -> Int) -> Int

 --------->

(flip twice) 1          ::  (Int -> Int) -> Int
doble                   ::  Int -> Int
-------------------------------------------------------
((flip twice) 1) doble  :: Int

Ejercicio 5

a. appDup f x = f (x, x)
b. appFork (f, g) x = (f x, g x)
c. appPar​ ​(f, g) (x, y) = (f x, g y)
d. appDist f (x, y) = (f x, f y)
e. subst f g x = (f x) (g x)

Ejercicio 6

a. compose (fst snd)
compose
fst snd
-------------------
compose (fst snd)

fst     :: (a, b) -> a
snd     :: (c, d) -> d
---------------------
fst snd :: Error

(a, b) != (c, d) -> d

fst espera una tupla, pero snd es de tipo funcion que devuelve un valor.
En este caso habria error.

variante: compose fst snd

b. ((uncurry curry) snd)
uncurry       :: (a -> b -> c) -> ((a,b) -> c)
curry         :: ((d,e) -> f) -> (d -> e -> f)
----------------------------------------
uncurry curry ::

 primera vez
(a           -> (b -> c))
              =
((d,e) -> f) -> (d -> e -> f)
 segunda vez
(b      -> c)
    =
(d      -> (e -> f))

 ---------> a = (d, e) -> f
 ---------> b = d
 ---------> c = e -> f

uncurry       :: (((d, e) -> f) -> d -> (e -> f)) -> (((d, e) -> f,d) -> (e -> f))
curry         :: ((d,e) -> f) -> (d -> e -> f)
----------------------------------------
uncurry curry :: ((d, e) -> f, d) -> (e -> f)

uncurry curry       :: ((d, e) -> f, d) -> (e -> f)
snd                 :: (x, y) -> y
---------------------------------
(uncurry curry) snd :: Error

(uncurry curry) espera una tupla: ((d, e) -> f, d)
y snd es una funcion: (x, y) -> y. Incompatibilidad de tipos.

c. (apply id) ((id apply) apply)

-------------------------1--------------------------
apply    :: (a -> b) -> (a -> b)
id       :: x -> x
--------------------
apply id ::

a -> b
x -> x
--------> a = b = x

apply    :: (x -> x) -> (x -> x)
id       :: x -> x
--------------------
apply id :: x -> x
--------------------------1-------------------------

--------------------------2-------------------------
id         ::  x2 -> x2
apply      ::  (a1 -> b1) -> (a1 -> b1)
----------------
(id apply) ::

-----> x2 = (a1 -> b1) -> (a1 -> b1)

id         ::  ((a1 -> b1) -> (a1 -> b1)) -> ((a1 -> b1) -> (a1 -> b1))
apply      ::  (a1 -> b1) -> (a1 -> b1)
----------------
(id apply) :: (a1 -> b1) -> (a1 -> b1)
---------------------------2------------------------

---------------------------3------------------------
(id apply)       :: (a1 -> b1) -> (a1 -> b1)
apply            :: (a2 -> b2) -> (a2 -> b2)
-----------------------
(id apply) apply ::

-------> (a1 -> b1) = (a2 -> b2) -> (a2 -> b2)

(id apply)       :: ((a2 -> b2) -> (a2 -> b2)) -> ((a2 -> b2) -> (a2 -> b2))
apply            :: (a2 -> b2) -> (a2 -> b2)
-----------------------
(id apply) apply ::  ((a2 -> b2) -> (a2 -> b2))
--------------------------3-------------------------

--------------------------4-------------------------
apply id                      :: x -> x
((id apply) apply)            :: (a2 -> b2) -> (a2 -> b2))
-----------------------------------
(apply id) ((id apply) apply) ::

-----> x = (a2 -> b2) -> (a2 -> b2))

apply id                      :: (a2 -> b2) -> (a2 -> b2)) -> (a2 -> b2) -> (a2 -> b2))
((id apply) apply)            :: (a2 -> b2) -> (a2 -> b2))
-----------------------------------
(apply id) ((id apply) apply) :: (a2 -> b2) -> (a2 -> b2))
---------------------------4------------------------

d. compose (compose doble doble)

# 1

compose :: (b -> c) -> ((a -> b) -> (a -> c))
doble   :: Int -> Int
-----------------
compose doble ::

-----------> (b -> c) = Int -> Int
-----------> c = Int
-----------> b = Int

compose :: (Int -> Int) -> ((a -> Int) -> (a -> Int))
doble   :: Int -> Int
-----------------
compose doble :: (a -> Int) -> (a -> Int)

# 1

# 2
(compose doble) ::  (a -> Int) -> (a -> Int)
doble  :: Int -> Int
---------------------
(compose doble doble)

(a -> Int)
 =
Int -> Int

(compose doble) ::  (a -> Int) -> (a -> Int)
doble  :: Int -> Int
---------------------
(compose doble doble) ::

Int -> Int
(a -> Int)
------> a = Int

(compose doble) ::  (Int -> Int) -> (Int -> Int)
doble  :: Int -> Int
---------------------
(compose doble doble) :: (Int -> Int)

# 2

# 3
compose    :: (b2 -> c2) -> ((a2 -> b2) -> (a2 -> c2))
(compose doble doble) :: Int -> Int
---------------------
compose (compose doble doble)

(b2 -> c2)
Int -> Int
b2 = Int
c2 = Int

compose    :: (Int -> Int) -> ((a2 -> Int) -> (a2 -> Int))
(compose doble doble) :: Int -> Int
---------------------
compose (compose doble doble) :: (a2 -> Int) -> (a2 -> Int)

# 3

e. (compose compose) doble doble

-}
-- Ejercicio 7)
-- Dada la siguiente definición, indicar cómo podría reescribirse usando
-- compose​ y ​id​:
many :: Int -> (a -> a) -> a -> a
many 0 f x = Main.id x
many n f x = compose f Main.id (many (n - 1) (compose f Main.id) x)

{-
Ejercicio 8

a. (Int -> Int) -> Int -> Int
curried: Es una función que toma una funcion que recibe y devuelve un entero, y devuelve una
funcion que toma un entero y devuelve un entero.
non-curried: Es una funcion que toma una funcion de entero en entero y un entero, y devuelve un entero.

b. (a -> b -> c) -> (a -> b) -> c
curried: Es una función que toma una función (que toma un 'a' y un 'b' y devuelve un 'c') y devuelve
una función que toma una función (que toma un 'a' y devuelve un 'b') y devuelve un valor de tipo 'c'.
non-curried: Es una funcion que toma dos funciones y devuelve un valor c.

c. (a -> b, c -> d) -> (a, c) -> (b, d)
curried: Es una función que toma una tupla de funciones (donde la primera es de 'a' en 'b' y la
segunda de 'c' en 'd') y devuelve una función que toma una tupla de valores (de tipo 'a' y 'c')
y devuelve una tupla de valores (de tipo 'b' y 'd').
non-curried: Es una funcion que recibe una tupla de funciones y una tupla de valores (un a y un c)
y devuelve una tupla de tipo (b, d).

d. ((a, a) -> b) -> a -> b
curried: Es una función que toma una funcion que toma una tupla de tipo ('a', 'a') y devuelve
un valor de tipo 'b', y devuelve una funcion que toma un valor de tipo 'a' y devuelve un valor de tipo 'b'
non-curriend: Es una funcion que recibe una funcion que toma una tupla de tipo (a, a) en b,
un valor a y devuelve un valor b.

e. (a -> b -> c) -> b -> a -> c
curried: Es una funcion que toma una funcion (que toma un a y devuelve una funcion que toma
un b y devuelve un c) y devuelve una funcion que toma un valor de tipo b y devuelve
una funcion que toma un valor de tipo a y devuelve un valor de tipo c.
non-curried: Es una funcion que toma una funcion (que toma los valores a y b, y devuelve c),
los valores b y a, y devuelve un valor c.

f. (a -> b) -> (a, a) -> (b, b)
curried: es una funcion que toma una funcion (que toma un a y devuelve un b) y devuelve
una funcion que toma una tupla de tipo (a,a) y devuelve una tupla de tipo (b,b)
noncurried: es una funcion que toma una funcion de tipo a en b, una tupla de tipo (a, a) y
devuelve una tupla de tipo (b, b)

g. (​a -> b, a -> c) -> a -> (b, c)
curried: Es una funcion que toma una tupla de funciones (donde la primera
es de a en b y la segunda de a en c) y devuelve una funcion que toma un a y devuelve
una tupla de tipo (b,c)
noncurried: Es una funcion que toma una tupla de funciones (donde la primera es de tipo
a en b, y la seguna de tipo a en c), un valor a y devuelve una tupla de tipo (b, c)

h. (a -> b -> c) -> (a -> b) -> a -> c
curried: es una funcion que recibe una funcion (que toma un valor a y devuelve una funcion
que toma un b y devuelve un c) y devuelve una funcion que toma una funcion de tipo a en b,
y devuelve una funcion que toma a y devuelve c.
noncurried: es una funcion que toma una funcion (que toma los valores a y b, y devuelve
un valor c), una funcion de tipo a en b, un valor a y devuelve c.

i. a -> b -> a
curried: Es una funcion que recibe un valor a y devuelve una funcion que toma un b y devuelve
un valor de tipo a.
noncurried: Es una funcion que toma los valores a y b, y devuelve a.

Ejercicio 9)Dar expresiones equivalentes a las funciones definidas a continuación
utilizando funciones como ​compose​, ​flip​, etc. (dadas en los ejercicios anteriores) y
sin utilizar lambas.
a. cuadruple x = doble (doble x)            = many 2 doble x
b. timesTwoPlusThree x = suma (doble x) 3   = compose suma doble 3
c. fourTimes f x = f (f (f (f x)))          = many 4 f x

Ejercicio 10
La seccion de operadores consiste en rodear un operador entre parentesis y poner uno de sus dos valores. Esto genera automaticamente una funcion
que aplica el operador entre el valor que ya pusiste y el que falta.
Esto permite hacer cosas como definir doble de esta manera:
- doble = (2*)

-}
