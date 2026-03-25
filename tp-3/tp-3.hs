-- DEFINICIONES -- DEFINICIONES -- DEFINICIONES -- DEFINICIONES
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

doble :: Int -> Int
doble = (* 2)

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

c. twice twice twice swap
(((twice twice) twice) swap)

d. flip twice 1 doble
(((flip twice) 1) doble)



-}