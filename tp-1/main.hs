{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
import Debug.Trace (trace)

-- Definiciones
doble :: Int -> Int
doble x = x + x

cuadruple :: Int -> Int
cuadruple x = 4 * x

twice :: (a -> a) -> a -> a
twice f = g
  where
    g x = f (f x)

-- Ejercicio 1)

dividir :: (Integral a) => a -> a -> a
dividir dividendo divisor = (\x -> x `div` divisor) dividendo

multiplicar :: Int -> Int -> Int
multiplicar n m = (\x -> n * x) m

-- Respuestas:

-- 2 a elección
cuatro :: Int
cuatro = 4

-- ✔
restoQueDaCuatro :: Int
restoQueDaCuatro = 8 - 4

-- Dos con lambda
dividir16Por4 :: Integer
dividir16Por4 = dividir 16 4

-- ✔

dividir32Por8 :: Integer
dividir32Por8 = dividir 32 8

-- ✔

-- 3 con doble
dobleDeDos :: Int
dobleDeDos = doble (3 - 1)

-- ✔

dosPorDos :: Int
dosPorDos = doble (doble 2)

-- ✔

dobleDeLaMitadDeCuatro = doble (dividir 4 2)

-- ✔

-- 1 con cuadruple
cuadrupleDeUno :: Int
cuadrupleDeUno = cuadruple 1

-- ✔

{-
-- Ejercicio 2

doble (doble 2)
(doble 2) + (doble 2)
(2 + 2) + (doble 2)
4 + (doble 2)
4 + (2 + 2)
4 + 4
8

-}
{-
-- Ejercicio 3

cuadruple 2
Aplicativa:
    cuadruple 2
    4 * 2
    8
Normal:
    cuadruple 2
    4 * 2
    8

cuadruple (cuadruple 2)
Aplicativa:
    cuadruple (cuadruple 2)
    cuadruple * (4 * 2)
    cuadruple * 8
    4 * 8
    32
Normal:
    cuadruple (cuadruple 2)
    4 * (cuadruple 2)
    4 * (4 * 2)
    4 * 8
    32

-}

-- Ejercicio 4:
triple :: Int -> Int
triple n = n * 3

succ :: Int -> Int
succ n = n + 1

sumarDos :: Int -> Int
sumarDos n = n + 2

{-

-- Ejercicio 5

    twice succ x es igual a sumarDos x?
    Reduccion de twice:
    twice succ x
    succ (succ x)
    succ (x + 1)
    succ (x + 1)
    x + 1 + 1
    x + 2

    Reducción de sumarDos:
    sumarDos x
    x + 2

Como para cualquier valor de x,
ambas expresiones se reducen a x + 2,
por lo tanto se comprueba la igualdad:
twice succ = sumarDos
-}

{-

-- Ejercicio 6

-- Par 1: Atómica vs No Atómica (sin lambda)
triple :: Int -> Int
triple n = n * 3
-- Equivalente a: (* 3)

-- Par 2: Atómica vs No Atómica (sin lambda)
notFunction :: Bool -> Bool
notFunction = not
-- Equivalente a: (False ==)

-- Par 3: Atómica vs No Atómica (con lambda)
idFunction :: a -> a
idFunction = id
-- Equivalente a: \x -> x

-}

{-
Ejercicio 7
twice :: (a -> a) -> a -> a
twice f = g
  where
    g x = f (f x)

((twice twice) doble) 3

# g1 <- twice twice
# g1 x = twice (twice x) siendo f = twice
=> (twice (twice doble)) 3

# g2 <- twice (twice doble)
# g2 x = twice doble (twice doble x) siendo f = twice doble
=> twice doble (twice doble 3)

# g3 <- twice doble
# g3 x = doble (doble x) siendo f = doble
=> doble (doble (twice doble 3))

# evaluo el argumento porque ya lo necesito
=> doble (doble (doble (doble 3)))

=> doble (doble (doble (3 + 3)))
=> doble (doble (doble 6))
=> doble (doble (6 + 6))
=> doble (doble 12)
=> doble (12 + 12)
=> doble 24
=> 24 + 24
=> 48
-}

-- Debug para ver el ciclo de vida del primer `twice` (el externo)
dobleT :: Int -> Int
dobleT x = trace ("[doble] entra con x = " ++ show x) (x + x)

twiceInnerT :: (Int -> Int) -> Int -> Int
twiceInnerT f x =
  trace ("[segundo twice] entra con x = " ++ show x) $
    let y = trace "[segundo twice] aplica f por primera vez" (f x)
        z = trace "[segundo twice] aplica f por segunda vez" (f y)
     in trace ("[segundo twice] sale con resultado = " ++ show z) z

twiceOuterT :: ((Int -> Int) -> (Int -> Int)) -> (Int -> Int) -> (Int -> Int)
twiceOuterT f x =
  trace "[primer twice] entra: construye f (f x), donde f es el segundo twice" $
    let fx = trace "[primer twice] evalua primera aplicacion: f x" (f x)
        ffx = trace "[primer twice] evalua segunda aplicacion: f (f x)" (f fx)
     in trace "[primer twice] sale: devuelve la funcion final" ffx

debugPrimerTwice :: Int
debugPrimerTwice =
  trace "[main] arranca ((twice twice) doble) 3 con debug" $
    ((twiceOuterT twiceInnerT) dobleT) 3
-- yo uso ghci, me movi a la carpeta, puse :load main.hs print debugPrimerTwice para ver el resultado.

{-
Ejercicio 8

triple = \x -> x * 3
succ = \x -> x + 1
sumarDos = \x -> x + 2
twice = \f x -> f (f x)
twice twice = \x -> twice (twice x)

-}



-- Ejercicio 9

--a. 
f x = let (y,z) = (x,x) in y
f x = x

-- b. 
f2 (x,y) = let z = x + y
            in g (z,y)
                where g (a,b) = a - b
f2 (x, y) = (x + y) - y
-- c. 
f3 p = case p of 
        (x,y) -> x
f3 (x,y) = x
-- d. 
f4 = \p -> let (x,y) = p in y
f4Refactor (_, y) = y
