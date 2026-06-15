twice :: (a -> a) -> a -> a
twice f x = f (f x)

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

compose12 :: (d -> c) -> (a -> b -> d) -> a -> b -> c
compose12 f g x y = f (g x y)

{-
compose12 twice compose :: (b2 -> d) -> (d -> b2) -> d -> d
compose12 twice compose :: (a -> b) -> (b -> a) -> b -> b

compose12 twice :: (a -> b -> x -> x) -> a -> b -> x -> x
compose         :: (b2 -> c) -> (a2 -> b2) -> a2 -> c
------------------------------
compose12 twice compose :: ??

(a ->           b ->        x -> x)
(b2 -> c) -> (a2 -> b2) -> a2 -> c

 ----> a = b2 -> c
 ----> b = a2 -> b2
 ----> x = a2
 ----> x = c
 se puede concluir que c = a2 = x, renombro su igualdad como d, entonces:
 ----> a = b2 -> d
 ----> b = (d -> b2)
 ----> x = d
 ----> x = d

compose12 twice :: ((b2 -> d) -> (d -> b2) -> d -> d) -> (b2 -> d) -> (d -> b2) -> d -> d
compose         :: (b2 -> c) -> (a2 -> b2) -> a2 -> c
------------------------------------------------------------------------------------------
compose12 twice compose :: (b2 -> d) -> (d -> b2) -> d -> d

compose12   :: (d -> c) -> (a -> b-> d) -> a -> b -> c
twice       :: (x -> x) -> x -> x
---------------------------
compose12 twice :: ??

 (d      ->     c)
(x -> x) -> x -> x
 ----> d = x -> x
 ----> c = x -> x

compose12   :: ((x -> x) -> x -> x) -> (a -> b -> x -> x) -> a -> b -> x -> x
twice       :: (x -> x) -> x -> x
---------------------------
compose12 twice :: (a -> b -> x -> x) -> a -> b -> x -> x

-- parte 2
tengo que hacer una funcion anonima que tenga este tipo =>
(b -> a) -> (a -> b) -> a -> a
compose12 twice compose = ??

compose12 twice compose, por def de compose sabemos que f <- twice, g <- compose
-> (\x y z -> twice (compose x y) z)
renombramos variables para que quede más claro
-> (\f g x -> twice (compose f g) x)
entonces:

    compose12 twice compose = (\f g x -> twice (compose f g) x)

    Prop.: ¿compose12 twice compose = (\f g x -> twice (compose f g) x)?
    Dem. : Por el ppio. de ext., es equivalente demostrar que
        ¿Para todo 
            compose12 twice compose f g x = (\f g x -> twice (compose f g) x) ?

    Sea f' una funcion cualquiera,
    Sea g' una funcion cualquiera,
    Sea x' un valor cualquiera. Se vera que compose12 twice compose f' g' x' = (\f' g' x' -> twice (compose f' g') x')

    Lado izq
            compose12 twice compose f' g' x'
        =                                    (compose12, f <- twice, g <- compose, x <- f', y <- g')
            twice (compose f' g') x'

    Lado der
            (\f' g' x' -> twice (compose f' g') x')
        =                                     (beta reduccion)
            twice (compose f' g') x'

Vale la propiedad.

-}
mia = (\f g x -> twice (compose f g) x)

doble x = x * 2

triple :: Int -> Int
triple x = x * 3