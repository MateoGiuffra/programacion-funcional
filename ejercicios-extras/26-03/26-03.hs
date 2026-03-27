-- Ejercicios de la clase 26/03/2026. Repasamos lo visto en las secciónes 1 y 2.

-- definiciones
doble :: Int -> Int
doble x = x + x

id :: a -> a
id x = x

suma :: Int -> Int -> Int
suma x = g
  where
    g y = x + y

apply :: (a -> b) -> a -> b
apply f = g
  where
    g x = f x

const :: a -> b -> a
const x = g
  where
    g y = x

twice :: (a -> a) -> (a -> a)
twice f = g
  where
    g x = f (f x)

compose :: (b -> c) -> (a -> b) -> (a -> c)
compose f = h
  where
    h g = k
      where
        k x = f (g x)

flip :: (b -> a -> c) -> a -> b -> c
flip f = g
  where
    g x = h
      where
        h y = (f y) x

subst :: (a -> b -> c) -> (a -> b) -> a -> c
subst f = h
  where
    h g = k
      where
        k x = (f x) (g x)

-- definiciones

{--
1) Dar el valor de las siguientes expresiones:
   a) (\f -> f 2 + f 4) id  :: Int
   b) (\f -> f 2 + f 4) doble :: Int
   c) (\f -> f 2 + f 4) (suma 17) :: Int
   d) (\f -> f 2 + f 4) (const 21) :: Int

a)
por red beta, f <- id
-> id 2 + id 4
por def de id, x = 2
-> 2 + id 4
por def de id, x = 4
-> 2 + 4
por arit.
-> 6 :: Int

b)
por red beta, f <- doble
-> doble 2 + doble 4
por def de doble, donde x = 2
-> (2 + 2) + doble 4
por def de doble, donde x = 4
-> (2 + 2) + (4 + 4)
por arit.
-> 12 :: Int

c)
por red beta, f <- (suma 17)
-> (suma 17) 2 + (suma 17) 4
por def de suma, x <- 17
-> (g 2) + (suma 17) 4
por def de g, y <- 2
-> (17 + 2) + (suma 17) 4
por def de suma, x <- 17
-> (17 + 2) + (g 4)
por def de g, y <- 4
-> (17 + 2) + (17 + 4)
por arit.
19 + 21
40 :: Int

d)
(\f -> f 2 + f 4) (const 21)
por red beta, f <- (const 21)
-> (const 21) 2 + (const 21) 4
por def de const, x <- 21
-> g 2 + (const 21) 4
por def de g, y <- 2
-> 2 + (const 21) 4
por def de const, x <- 21
-> 2 + g 4
por def de g, y <- 4
-> 2 + 4
por arit
-> 6 :: Int

2) Mostrar la reducción de:
   a) (suma 2) 3
   b) ((subst const) suma) 17
   c) ((subst const) twice) doble

a) (suma 2) 3
por def de suma x <- 2
-> g 3
por def de g, y <- 3
-> 2 + 3
por arit
-> 5 :: Int

(suma 2) 3 :: Int

b) ((subst const) suma) 17
por de subst, f <- const
-> (h suma) 17
por def de h, g <- suma
-> k 17
por de k, x <- 17
-> (const 17) (suma 17)
por def de const, x <- 17
-> g (suma 17)
por def de g, y <- (suma 17)
-> 17 :: Int

((subst const) suma) 17 :: Int

c) ((subst const) twice) doble
por de subst, f <- const
-> (h twice) doble
por def de h, g <- twice
-> k doble
por def de k, donde x <- doble
-> (const doble) (twice doble)
por def de const, x <- doble
-> g (twice doble)
por def de g, y <- (twice doble), donde g (twice doble) = doble
-> doble :: Int -> Int

((subst const) twice) doble :: Int -> Int

3) A partir de las reducciones anteriores, concluir expresiones equivalentes para:
   a) ((subst const) suma) = id = (\x -> x)
   b) \f -> (subst const) f = \f -> id f

4) Dar expresiones equivalentes que NO nombren a las funciones definidas:
   a) id = \x -> x
   b) const = \x -> \y -> x
   c) flip = \f -> \x -> \y -> (f y) x

5) Completar la definición de la función yTambien de forma tal que para todos b1 y b2:
   (yTambien b1) b2 = b1 && b2

   yTambien :: Bool -> Bool -> Bool
   yTambien b = \b2 -> if b then b2
                            else False

6) Mostrar la reducción de:
   ((subst (flip apply)) suma) 17
   por def de subst, donde f <- (flip apply)
   -> ((subst h) suma) 17
   por def de h, gS <- suma
   -> k 17
   por def de k, x <- 17
   -> ((flip apply) 17) suma 17
   por def de flip, fP <- apply, donde f de flip es fP
   -> (g 17) suma 17
   por def de g, x <- 17
   -> h suma 17
   por def de h, y <- suma 17
   -> (apply suma 17) 17
   por def de apply, fA <- suma
   -> (g 17) 17
   por def de g, x <- 17
   -> suma 17 17
   por def de suma, x <- 17, donde g de suma es gS
   -> gS 17
   por def de gS, y <- 17
   -> 17 + 17
   por arit.
   -> 34 :: Int

   ((subst (flip apply)) suma) 17 :: Int

7) A partir de la reducción anterior, dar una expresión equivalente para:
   (subst (flip apply)) suma = doble 17 = suma 17 17

8) Dar los tipos para TODAS las funciones definidas en los ejercicios anteriores.

--}