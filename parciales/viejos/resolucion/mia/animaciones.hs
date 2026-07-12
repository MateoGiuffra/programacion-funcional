{-# LANGUAGE StandaloneDeriving #-}

data Accion a = Paso a | SaltoArriba a | SaltoAdelante a | Girar a

type Tiempo = Int     -- el instante en el que sucede un movimiento
type Duracion = Int   -- cantidad de tiempos que dura el movimiento

data Animacion a =
     Espera Duracion                       -- durante la duración dada no hay acciones
   | Mov Duracion (Accion a)               -- un cierto movimiento con una duración dada
   | Sec (Animacion a) (Animacion a)       -- secuencia (la 2da empieza al terminar la 1era)
   | Par (Animacion a) (Animacion a)       -- paralelo (arrancan juntas y dura lo que la más larga)

type Frame a = [Accion a]     -- acciones simultáneas en un tiempo específico
type Simulador a = Tiempo -> Frame a
-- función que da las acciones que ocurren en un tiempo dado

deriving instance Show a => Show (Accion a)
deriving instance Show a => Show (Animacion a)

ej = Sec (Par (Sec (Sec (Espera 1) (Mov 3 (Paso "Bob")))
                    (Sec (Mov 1 (Girar "Bob")) (Mov 2 (SaltoAdelante "Bob"))))
              (Sec (Mov 2 (SaltoAdelante "Ana"))
                   (Sec (Mov 1 (Girar "Ana")) (Sec (Mov 3 (Paso "Ana")) (Espera 1)))))
         (Espera 1)

combinarSinDuplicados :: [Int] -> [Int] -> [Int]
combinarSinDuplicados []     []     = []
combinarSinDuplicados []     ys     = ys
combinarSinDuplicados xs     []     = xs
combinarSinDuplicados (x:xs) (y:ys) = if x > y 
                                        then x : combinarSinDuplicados xs (y:ys)
                                        else if x < y 
                                                then y : combinarSinDuplicados (x:xs) ys
                                                else x : combinarSinDuplicados xs ys

duracion :: Animacion a -> Int
duracion (Espera n)  = n
duracion (Mov n ac)  = n
duracion (Sec a1 a2) = (duracion a1) + (duracion a2)
duracion (Par a1 a2) = max (duracion a1) (duracion a2)

alargar :: Int -> Animacion a -> Animacion a
alargar fac (Espera n)  = Espera (n * fac)
alargar fac (Mov n ac)  = Mov (n * fac) ac
alargar fac (Sec a1 a2) = Sec (alargar fac a1) (alargar fac a2)
alargar fac (Par a1 a2) = Par (alargar fac a1) (alargar fac a2)

-- replicate :: Int -> a -> [a]
-- replicate n x = error "impl"

simular :: Animacion a -> [Frame a]
simular (Espera n)  = [[]]
simular (Mov n ac)  = replicate n [ac]
simular (Sec a1 a2) = (simular a1) ++ (simular a2)
simular (Par a1 a2) = unir (simular a1) (simular a2)
-- [[SaltoAdelante "Bob"], [SaltoAdelante "Bob"], [SaltoAdelante "Bob"]]
-- [[Paso "Ana"]] 
-- ->[[SaltoAdelante "Bob", [Paso "Ana"]], [SaltoAdelante "Bob"], [SaltoAdelante "Bob"]]

unir :: [[a]] -> [[a]] -> [[a]]
unir [] [] = []
unir xss [] = xss
unir [] yss = yss
unir (xs: xss) (ys: yss) = (xs ++ ys) : unir xss yss

-- ej = [
--   [SaltoAdelante "Ana"],
--   [Paso "Bob", SaltoAdelante "Ana"],
--   [Paso "Bob", Girar "Ana"],
--   [Paso "Bob", Paso "Ana"],
--   [Girar "Bob", Paso "Ana"],
--   [SaltoAdelante "Bob", Paso "Ana"],
--   [SaltoAdelante "Bob"],
--   []
-- ]
-- animacion = Sec (Mov 3 (SaltoAdelante "Bob")) (Mov 1 (Paso "Ana"))
-- ej2 = [[SaltoAdelante "Bob"], [SaltoAdelante "Bob"], [SaltoAdelante "Bob"], [Paso "Ana"]]

tiemposDeEspera :: Animacion a -> [Tiempo]
tiemposDeEspera (Espera n)  = [n]
tiemposDeEspera (Mov n ac)  = []
tiemposDeEspera (Sec a1 a2) = (tiemposDeEspera a1) ++ (tiemposDeEspera a2)
tiemposDeEspera (Par a1 a2) = unirTiempo (tiemposDeEspera a1) (tiemposDeEspera a2)

unirTiempo :: [Tiempo] -> [Tiempo] -> [Tiempo]
unirTiempo [] [] = []
unirTiempo xs [] = xs
unirTiempo [] ys = ys
unirTiempo (x: xs) (y: ys) = max x y : unirTiempo xs ys
 
--     [1]  [1] -> [1]
--     [1]  [3] -> [3]
--     [1, 1]  [3, 1] -> [3, 1]
-- Par ((Espera 1) (Espera 1)) -> [1]
-- Sec ((Espera 1) (Espera 1)) -> [1, 1]


-- DEMO
-- para todo k >= 0. 
--     duracion . (alargar k) = (k*) . duracion
-- por principio de extensionalidad, siendo a una animacion cualquiera, quiero ver que:
-- ¿ (duracion . (alargar k)) a = ((k*) . duracion) a ? 

-- por def. de compose, es equivalente a decir:

-- ¿ duracion (alargar k a) =  k * (duracion a) ? 

-- casoBase1)
-- siendo n un numero cualquiera >= 0
-- a = Espera n
-- ¿ duracion (alargar k (Espera n)) =  k * (duracion (Espera n)) ? 

-- casoBase2)
-- siendo n un numero cualqueira >= 0 y ac una accion cualquiera
-- a = Mov n ac
-- ¿ duracion (alargar k (Mov n ac)) =  k * (duracion (Mov n ac)) ? 

-- casoInductivo1)
-- siendo a1, a2 una animacion cualquiera
-- a = Sec a1 a2
-- HI1) ¡ duracion (alargar k a1) =  k * (duracion a1) !
-- HI2) ¡ duracion (alargar k a2) =  k * (duracion a2) !
-- TI)  ¿ duracion (alargar k (Sec a1 a2)) =  k * (duracion (Sec a1 a2)) ?

-- casoInductivo2)
-- siendo a1, a2 una animacion cualquiera
-- a = Par a1 a2
-- HI1) ¡ duracion (alargar k a1) =  k * (duracion a1) !
-- HI2) ¡ duracion (alargar k a2) =  k * (duracion a2) !
-- TI)  ¿ duracion (alargar k (Par a1 a2)) =  k * (duracion (Par a1 a2)) ?
{-
-- Demuestro:
-- casoBase1)
-- LI)
     duracion (alargar k (Espera n))
=                                    alargar.1
     duracion (Espera (n * k))
=                                    duracion.1
     n * k
-- LD)
     k * (duracion (Espera n))
=                                    duracion.1
     k * n
=                                    por arit.
     n * k
Vale para este caso.

-- casoBase2)
-- LI)
     duracion (alargar k (Mov n ac))
=                                       alargar.2
     duracion (Mov (n * k) ac)
=                                       duracion.2
     n * k
-- LD)
     k * (duracion (Mov n ac))
=                                       duracion.2
     k * n
=                                       por aritm.
     n * k
Vale para este caso.

-- casoInductivo1)
--LI)
     duracion (alargar k (Sec a1 a2))
=                                       alargar.3
     duracion (Sec (alargar k a1) (alargar k a2))
=                                       duracion.3
     (duracion (alargar k a1)) + (duracion ((alargar k a2)))
=                                       HI1 y HI2
     (k * (duracion a1)) + (k * (duracion a2))
--LD)
     k * (duracion (Sec a1 a2))
=                                  duracion.3
     k * (duracion a1 + duracion a2)
=                                  por distributiva de la multiplicacion
     (k * (duracion a1)) + (k * (duracion a2))
Para este caso vale.

-- casoInductivo2)
--LI)
     duracion (alargar k (Par a1 a2))
=                                       alargar.4
     duracion (Par (alargar k a1) (alargar k a2))
=                                       duracion.4
     max (duracion (alargar k a1)) (duracion (alargar k a2))
=                                       H1 y H2
     max (k * (duracion a1)) (k * (duracion a2))

--LD)
     k * (duracion (Par a1 a2))
=                                  duracion.4
     k * (max (duracion a1) (duracion a2))
=                                  por distributiva de la multiplicacion
     max (k * (duracion a1)) (k * (duracion a2))

Vale para este caso.
-}

-- 4
foldA :: (Duracion -> b) -> (Duracion -> Accion a -> b) -> (b -> b -> b) -> (b -> b -> b) -> Animacion a -> b
foldA e m s p (Espera n)  = e n
foldA e m s p (Mov n ac)  = m n ac
foldA e m s p (Sec a1 a2) = s (foldA e m s p a1) (foldA e m s p a2)
foldA e m s p (Par a1 a2) = p (foldA e m s p a1) (foldA e m s p a2)

recA :: (Duracion -> b) -> (Duracion -> Accion a -> b) -> (Animacion a -> b -> Animacion a -> b -> b) -> (Animacion a -> b -> Animacion a -> b -> b) -> Animacion a -> b
recA e m s p (Espera n)  = e n
recA e m s p (Mov n ac)  = m n ac
recA e m s p (Sec a1 a2) = s a1 (recA e m s p a1) a2 (recA e m s p a2)
recA e m s p (Par a1 a2) = p a1 (recA e m s p a1) a2 (recA e m s p a2)

-- 5
duracion' :: Animacion a -> Int
duracion' = foldA id const (+) max

alargar' :: Int -> Animacion a -> Animacion a
alargar' fac a = foldA 
                    (\n fac -> Espera (n * fac))
                    (\n ac fac -> Mov (n * fac) ac)
                    (\rs1 rs2 fac -> Sec (rs1 fac) (rs2 fac))
                    (\rs1 rs2 fac -> Par (rs1 fac) (rs2 fac))
                    a fac

simular' :: Animacion a -> [Frame a]
simular' = foldA 
               (\n -> [[]])
               (\n ac -> replicate n [ac])
               (\rs1 rs2 -> rs1 ++ rs2)
               unir

tiemposDeEspera' :: Animacion a -> [Tiempo]
tiemposDeEspera' = foldA 
                      (\n -> [n])
                      (\n ac -> [])
                      (\rs1 rs2 -> rs1 ++ rs2)
                      unirTiempo

-- 6
-- pendiente
