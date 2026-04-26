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