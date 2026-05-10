{-
Demostrar las siguientes propiedades

para todo 
doble n =(\x-> 2*x) n 

Sea un número m cualquiera, 

    Lazo izq: 
    doble m
    = (Def doble, x<-m) 
    2*m

    Lado der

    (\x->2*x) m
    = (Beta red, x<-m)
    2*m


b. compose doble doble = cuadruple

---- def ----
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)
---- def ----

para todo
compose doble doble n = cuadruple n

Sea un numero m cualquiera,

    Lado izq:
    cuadruple m
    = (Def cuadruple, x <- m)
    m * 4
    = (aritm.)
    m + m + m + m

    Lado der:
    compose doble doble
    = (Def compose, f <- doble)
    doble (g x)
    = (Def compose, g <- doble)
    doble (doble x)
    = (Def compose, x <- m)
    doble (doble m)
           -------
    = (Def doble, x <- m)
    doble (m + m)
    = (Def doble, x <- (m + m))
    (m + m) + (m + m)
    = (aritm.)
    m + m + m + m

    Vale.


-}


{-
curry suma' = suma
-}

curry   :: ((a, b) -> c) -> a -> b -> c
curry f a b = f (a, b)

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (a, b) = f a b

{-
ej 4
a.
curry fst = const

para todo x, y
    curry fst x y = const x y

siendo a, b unos valores cualquiera

    lado izq: 
    curry fst a b
    = (def curry, f <- fst, a <- a, b <- b)
    fst (a, b)
    = (def fst, x <- a)
    a

    lado der:
    const a b
    = (def const, x <- a)
    a

b.

--- def ---
flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x
--- def ---

uncurry (flip const) = snd

para todo (x, y)
    uncurry (flip const) (x, y) = snd (x, y)

siendo (a, b) un par cualquiera
    lado izq:
    uncurry (flip const) (a, b)
    = (def uncurry, <- flip const, (a, b) <- (a, b))
    flip const a b
    = (def flip, f <- const, x <- a, y <- b)
    const b a
    = (const, x <- b)
    b

    lado der:
    snd (a, b)
    = (def snd, y <- b)
    b
-}


