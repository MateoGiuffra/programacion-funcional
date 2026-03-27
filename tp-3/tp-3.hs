-- DEFINICIONES -- DEFINICIONES -- DEFINICIONES -- DEFINICIONES
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

doble :: Int -> Int
doble = (* 2)

fst :: (a,b) -> a
fst (x, y) = x 

snd :: (a,b) -> b
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


-----------> (b -> c) = Int
-----------> c = Int


compose :: Int -> ((a -> b) -> (a -> Int))
doble   :: Int -> Int
-----------------
compose doble :: (a -> b) -> (a -> Int)

# 1 



# 2
(compose doble)
doble 
---------------------
(compose doble doble)
# 2



# 3
compose 
(compose doble doble)
---------------------
compose (compose doble doble)
# 3

-}