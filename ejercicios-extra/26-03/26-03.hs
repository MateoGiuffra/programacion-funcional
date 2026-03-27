-- Ejercicios de la clase 26/03/2026. Repasamos lo visto en la sección 1 y 2.


-- definiciones
doble :: Num a => a -> a
doble x = x + x

id :: a -> a
id x = x

suma :: Num a => a -> a -> a
suma x = g
  where g y = x + y

apply :: (a -> b) -> a -> b
apply f = g
  where g x = f x

const :: a -> b -> a
const x = g
  where g y = x

twice :: (a -> a) -> (a -> a)
twice f = g
  where g x = f (f x)

compose :: (b -> c) -> (a -> b) -> (a -> c)
compose f = h
  where h g = k
          where k x = f (g x)

flip :: (b -> a -> c) -> a -> b -> c
flip f = g
    where g x = h
            where h y = (f y) x

subst :: (a -> b -> c) -> (a -> b) -> a -> c
subst f = h
    where h g = k
            where k x = (f x) (g x)

-- definiciones


{--
1) Dar el valor de las siguientes expresiones:
   a) (\f -> f 2 + f 4) id  :: Int
   b) (\f -> f 2 + f 4) doble :: Int
   c) (\f -> f 2 + f 4) (suma 17) :: Int
   d) (\f -> f 2 + f 4) (const 21)

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



2) Mostrar la reducción de:
   a) (suma 2) 3
   b) ((subst const) suma) 17
   c) ((subst const) twice) doble

3) A partir de las reducciones anteriores, concluir expresiones equivalentes para:
   a) ((subst const) suma)
   b) \f -> (subst const) f

4) Dar expresiones equivalentes que NO nombren a las funciones definidas:
   a) id
   b) const
   c) flip

5) Completar la definición de la función yTambien de forma tal que:
   yTambien b1 b2 = b1 && b2

   yTambien :: Bool -> Bool -> Bool
   yTambien b = \b2 -> if b then ??
                            else ??

6) Mostrar la reducción de:
   ((subst (flip apply)) suma) 17

7) A partir de la reducción anterior, dar una expresión equivalente para:
   (subst (flip apply)) suma

8) Dar los tipos para TODAS las funciones definidas en los ejercicios anteriores.
--}