-- La parte comentada es con los parentesis invisibles puestos

suma :: Int -> Int -> Int
suma x y = x + y

apply :: (a -> b) -> a -> b
apply f x = f x

const :: a -> b -> a
const x y = x

twice :: (a -> a) -> a -> a
twice f x = f (f x)

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

subst :: (a -> b -> c) -> (a -> b) -> a -> c
subst f g x = f x (g x)

-- sumo doble que faltó en el pizarron
doble :: Int -> Int
doble x = x + x

{-
suma :: Int -> (Int -> Int)
(suma x) y = x + y

apply :: (a -> b) -> (a -> b)
(apply f) x = f x

const :: a -> (b -> a)
(const x) y = x

twice :: (a -> a) -> (a -> a)
(twice f) x = f (f x)

compose :: (b -> c) -> ((a -> b) -> (a -> c))
((compose f) g) x = f (g x)

flip :: (b -> (a -> c)) -> (a -> (b -> c))
((flip f) x) y = (f y) x

subst :: (a -> (b -> c)) -> ((a -> b) -> (a -> c))
((subst f) g) x = (f x) (g x)
-}
-- 2) Para cada una de las siguientes expresiones:
-- i)   (suma . doble) 2  :: Int -> Int
-- ii)  doble . (suma 2)  :: Int -> Int
-- iii) (doble . doble) 2 :: Int

-- Tareas:
-- a) Agregar todos los paréntesis necesarios para que la expresión tenga tipo. ✅
-- b) Dar el tipo de la expresión. ✅
-- c) Escribir la misma expresión con máxima cantidad de paréntesis invisibles. ✅
-- d) Dar una expresión semántica equivalente. ✅

{-
compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)


compose doble suma 2 :: ??
###############1###############
compose doble           :: (a -> Int) -> a -> Int
suma 2                  :: Int -> Int
-------------------------------
compose doble suma 2    :: Int -> Int
###############1###############


# 1
compose :: (b -> c) -> ((a -> b) -> a -> c)
doble  :: Int -> Int
---------------------------------------
compose doble :: ??

 ----> b = Int
 ----> c = Int

compose :: (Int -> Int) -> (a -> Int) -> a -> Int
doble  :: Int -> Int
compose doble ::  (a -> Int) -> a -> Int

# 2
compose doble :: (a -> Int) -> a -> Int
suma 2 :: Int -> Int
-------------------------------------------
compose doble (suma 2) :: ??

 ---> a   = Int 
 ---> Int = Int


compose doble ::  (Int -> Int) -> Int -> Int
suma 2 :: Int -> Int
-------------------------------------------
compose doble (suma 2) :: Int -> Int


d)
(suma . doble) 2  = (+4)
doble . (suma 2)  = (*2) . (+2) 
(doble . doble) 2 = twice doble 2
-}
