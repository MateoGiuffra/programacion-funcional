{-
Los multisets son una estructura de datos que permiten saber cuántas veces fue ingresado un
elemento. Para expresar sus operaciones, utilizaremos el lenguaje expresado por el tipo MSExp.
data MSExp a = EmptyMS
| AddMS a (MSExp a)           | RemoveMS a (MSExp a)
| UnionMS (MSExp a) (MSExp a) | MapMS (a -> a) (MSExp a)
Las operaciones pretenden expresar las correspondientes operaciones de multisets.
● EmptyMS representa el multisets sin elementos (todos los elementos sin ocurrencias).
● AddMS representa el agregado de una ocurrencia de un elemento dado.
● RemoveMS representa la eliminación de una ocurrencia de un elemento dado.
● UnionMS representa la suma de ocurrencias de cada multiset para cada uno de sus elementos.
● MapMS representa la transformación de los elementos del multiset dado.
1. Definir por recursión explícita las siguientes funciones
a. occursMSE :: a -> MSExp a -> Int, que describe la cantidad de ocurrencias del elemento
dado en el multiset.
AYUDA 1: como la función pedida NO se puede hacer por recursión estructural, considerar definir
como función auxiliar occursMESWith :: a -> (a->a) -> MSExp a -> Int por recursión
estructural e invocarla con los argumentos correspondientes
AYUDA 2: el número retornado NO puede ser negativo. O sea, los RemoveMS que no encuentran
un AddMS correspondiente no deben tener efecto
-}

data MSExp a = EmptyMS 
             | AddMS a (MSExp a) 
             | RemoveMS a (MSExp a) 
             | UnionMS (MSExp a) (MSExp a) 
             | MapMS (a -> a) (MSExp a)

instance (Show a) => Show (MSExp a) where
    show EmptyMS           = "EmptyMS"
    show (AddMS x xs)      = "AddMS " ++ show x ++ " (" ++ show xs ++ ")"
    show (RemoveMS x xs)   = "RemoveMS " ++ show x ++ " (" ++ show xs ++ ")"
    show (UnionMS xs ys)   = "UnionMS (" ++ show xs ++ ") (" ++ show ys ++ ")"
    show (MapMS _ xs)      = "MapMS <function> (" ++ show xs ++ ")"
unoSi :: Bool -> Int
unoSi True = 1
unoSi _    = 0

{-
plan EmptyMS           =
plan (AddMS y ms)      = plan ms
plan (RemoveMS y ms)   = plan ms
plan (UnionMS ms1 ms2) = (plan ms1) (plan ms2)  
plan (MapMS f ms)      = plan ms
-}

-- a
occursMSE :: Eq a => a -> MSExp a -> Int
occursMSE x ms = occursMESWith x id ms

occursMESWith :: Eq a => a -> (a -> a) -> MSExp a -> Int
occursMESWith x f EmptyMS           = 0
occursMESWith x f (AddMS y ms)      = unoSi (f y == x) + occursMESWith x f ms
occursMESWith x f (RemoveMS y ms)   = max 0 (occursMESWith x f ms - unoSi (x == f y))
occursMESWith x f (UnionMS ms1 ms2) = (occursMESWith x f ms1) + (occursMESWith x f ms2)
occursMESWith x f (MapMS g ms)      = occursMESWith x (f . g) ms

-- b
filterMSE :: (a -> Bool) -> MSExp a -> MSExp a
-- que describe el multiset resultante
-- de eliminar todas las ocurrencias de los elementos que no cumplen con el predicado dado.
-- AYUDA: tener en cuenta que en el caso de MapMS, el elemento que se debe analizar es el
-- procesado por la función dada en ese MapMS, y no el elemento sin procesar.
filterMSE f EmptyMS           = EmptyMS
filterMSE f (AddMS y ms)      = if f y
                                    then AddMS y (filterMSE f ms)
                                    else filterMSE f ms
filterMSE f (RemoveMS y ms)   = if f y
                                    then RemoveMS y (filterMSE f ms)
                                    else filterMSE f ms
filterMSE f (UnionMS ms1 ms2) = UnionMS (filterMSE f ms1)  (filterMSE f ms2)
filterMSE f (MapMS g ms)      = MapMS g (filterMSE (f . g) ms)


-- c
isValidMSE :: Eq a => MSExp a -> Bool
-- que indica si la expresión de multiset dada es válida. Una
-- expresión de multiset es inválida si tiene más RemoveMS que AddMS para un elemento
-- determinado; en el caso de una UnionMS, cada parte se considera por separado
isValidMSE ms = sonTodosPositivos (balance id ms)

sonTodosPositivos :: [(a, Int)] -> Bool
sonTodosPositivos [] = True
sonTodosPositivos ((v, c): ps) = c >= 0 && sonTodosPositivos ps

balance :: Eq a => (a -> a) -> MSExp a -> [(a, Int)]
balance f EmptyMS           = []
balance f (AddMS y ms)      = update (+1) (f y) (balance f ms)
balance f (RemoveMS y ms)   = update (subtract 1) (f y) (balance f ms)
balance f (UnionMS ms1 ms2) = (balance f ms1) ++ (balance f ms2)
balance f (MapMS g ms)      = balance (f . g) ms

update :: Eq a => (Int -> Int) -> a -> [(a, Int)] -> [(a, Int)]
update f x []      = [(x, f 0)]
update f x ((v, c): ps) = if v == x 
                            then (v, f c) : update f x ps
                            else (v, c) : update f x ps
-- d
evalMSE :: Eq a => MSExp a -> [a]
-- que describe la lista de todas las ocurrencias de los
-- elementos del multiset dado.
evalMSE EmptyMS           = []
evalMSE (AddMS y ms)      = y : evalMSE ms
evalMSE (RemoveMS y ms)   = quitar y (evalMSE ms)
evalMSE (UnionMS ms1 ms2) = (evalMSE ms1) ++ (evalMSE ms2)  
evalMSE (MapMS f ms)      = map f (evalMSE ms)

quitar :: Eq a => a -> [a] -> [a]
quitar _ [] = []
quitar e (x: xs) = if x == e then xs else x : quitar e xs
-- e
simpMSE :: Eq a => MSExp a -> MSExp a
-- que, suponiendo que recibe una expresión de multiset
-- válida y describe al multiset resultante de simplificar el dado, aplicando las siguientes reglas en
-- todos los lugares posibles:
simpMSE EmptyMS           = EmptyMS
simpMSE (AddMS y ms)      = AddMS y (simpMSE ms)
simpMSE (RemoveMS y ms)   = simpRemove y (simpMSE ms)
simpMSE (UnionMS ms1 ms2) = simpUnion (simpMSE ms1) (simpMSE ms2)  
simpMSE (MapMS f ms)      = simpMap f (simpMSE ms)

simpRemove :: Eq a => a -> MSExp a -> MSExp a
simpRemove y (AddMS x ms) = if y == x then ms else (RemoveMS y (AddMS x ms))
simpRemove y e            = RemoveMS y e 

simpUnion :: MSExp a ->  MSExp a -> MSExp a
simpUnion EmptyMS e  = e
simpUnion e  EmptyMS = e
simpUnion e1 e2      = UnionMS e1 e2

simpMap :: (a -> a) -> MSExp a -> MSExp a
simpMap f EmptyMS = EmptyMS
simpMap f e       = MapMS f e

-- -- ejemplos
-- vacio    = EmptyMS
-- agregar  = AddMS 1 vacio
-- remover  = AddMS 1 (RemoveMS 1 EmptyMS)

-- map     = MapMS (\a -> succ a) (MapMS (*2) AddMS 1 vacio)
-- valid   = AddMS 1 (Remove 1 (Remove 1 (MapMS succ (Add 0 Empty))))
-- invalid = Remove 1 (Remove 1 (Add 1 Empty))

-- union   = UnionsMS valid invalid
--             [(1, 1)] ++ [(1, -1)] -> [(1, 0), (1, -1)]


-- Demostrar la siguiente propiedad: evalMSE . simpMSE = evalMSE

-- por principio de extencionalidad, sea mse un multiset cualquiera.

-- ¿ para todo mse. (evalMSE . simpMSE) mse = evalMSE mse ?

-- por def. de compose, es equivalente a decir:

-- ¿ para todo mse. evalMSE (simpMSE mse) = evalMSE mse ?

-- por principio de inducción estructural sobre la estructura mse

-- dem:

-- casoBase) mse = EmptyMS ¿ evalMSE (simpMSE EmptyMS) = evalMSE EmptyMS ?

-- casoInductivo1) mse = (AddMS y ms)
-- HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
-- TI) ¿ evalMSE (simpMSE (AddMS y ms)) = evalMSE (AddMS y ms) ?

-- casoInductivo2) mse = (RemoveMS y ms)
-- HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
-- TI) ¿ evalMSE (simpMSE (RemoveMS y ms)) = evalMSE (RemoveMS y ms) ?

-- casoInductivo3) mse = (UnionMS ms1 ms2)
-- HI1) ¡ evalMSE (simpMSE ms1) = evalMSE ms1 !
-- HI2) ¡ evalMSE (simpMSE ms2) = evalMSE ms2 !
-- TI) ¿ evalMSE (simpMSE (UnionMS ms1 ms2)) = evalMSE (UnionMS ms1 ms2) ?

-- casoInductivo4) mse = (MapMS f ms)
-- HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
-- TI) ¿ evalMSE (simpMSE (MapMS f ms)) = evalMSE (MapMS f ms) ?

-- Demuestro: 

-- casoBase)
-- LI) evalMSE (simpMSE EmptyMS)
-- =                                   --simpMSE.1
--     evalMSE EmptyMS

-- LD) evalMSE EmptyMS

-- VALE ESTE caso

-- casoInductivo1)
-- LI)     evalMSE (simpMSE (AddMS y ms))
-- =                                           -- simpMSE.2
--         evalMSE AddMS y (simpMSE ms)
-- =                                           -- evalMSE.2
--         y : evalMSE (simpMSE ms)
-- =                                           -- HI
--         y : evalMSE ms

-- LD)     evalMSE (AddMS y ms)
-- =                                           -- evalMSE.2
--         y : evalMSE ms

-- VALE ESTE caso

-- casoInductivo2)
-- LI)     evalMSE (simpMSE (RemoveMS y ms))
-- =                                               -- simpMSE.3
--         evalMSE (simpRemove y (simpMSE ms))
-- =                                               -- Lema.1
--         quitar y (evalMSE (simpMSE ms))
-- =                                               -- HI
--         quitar y (evalMSE ms)

-- LD)     evalMSE (RemoveMS y ms)
-- =
--         quitar y (evalMSE ms)


-- casoInductivo3)
-- LI)     evalMSE (simpMSE (UnionMS ms1 ms2))
-- =                                                       --simpMSE.4
--         evalMSE (simpUnion (simpMSE ms1) (simpMSE ms2))
-- =                                                       -- LEMA.2
--         evalMSE (simpMSE ms1) ++ evalMSE (simpMSE ms2)
-- =                                                       -- HI1 y HI2
--         evalMSE ms1 ++ evalMSE ms2

-- LD)     evalMSE (UnionMS ms1 ms2)
-- =                                                       -- evalMSE.4
--         evalMSE e1 ++ evalMSE e2
-- =

-- VALe ESTE caso

-- LEMA.2
-- evalMSE (simpUnion m1 m2) = evalMSE m1 ++ evalMSE m2

-- sea m1, m2, dos multisets cualquiera, quiero ver que:
--     ¿evalMSE (simpUnion m1 m2) = evalMSE m1 ++ evalMSE m2?

-- por analisis de casos sobre m1' y m2':
--     c1, m1 = EmptyMS, m2
--         ¿evalMSE (simpUnion EmptyMS m2) = evalMSE EmptyMS ++ evalMSE m2?
--     c2, m1 != EmptyMS, m2 = EmptyMS
--         ¿evalMSE (simpUnion m1 EmptyMS) = evalMSE m1 ++ evalMSE EmptyMS?
--     c3, m1 != EmptyMS, m2 != EmptyMS
--         ¿evalMSE (simpUnion m1 m2) = evalMSE m1 ++ evalMSE m2?


-- c1)
-- LI)     evalMSE (simpUnion EmptyMS m2)
-- =                                               -- simpUnion.1
--         evalMSE m2

-- LD)     evalMSE EmptyMS ++ evalMSE m2
-- =                                               --evalMSE.1
--         [] ++ evalMSE m2
-- =                                               -- ++
--         evalMSE m2

-- VALE ESTE CASO

-- c3) 
-- LI) evalMSE (simpUnion m1 m2)
-- =                                       --simpUnion.3
--     evalMSE (UnionMs m1 m2)
-- =                                       --evalMSE.4
--     evalMSE m1 ++ evalMSE m2

-- LD) evalMSE m1 ++ evalMSE m2

-- VALE ESTE CASO


-- LEMA.1
-- evalMSE (simpRemove y ms) = quitar y (evalMSE ms)

-- sea ms un multiset cualquiera, quiero ver que:
--         ¿evalMSE (simpRemove y ms) = quitar y (evalMSE ms)?
        
-- por analisis de caso sobre ms:
--         c1: ms = AddMS x ms2
--                 ¿ evalMSE (simpRemove y (AddMS x ms2)) = quitar y (evalMSE (AddMS x ms2)) ?
--         c2: ms != AddMS x ms2
--                 ¿ evalMSE (simpRemove y ms) = quitar y (evalMSE ms) ?

-- c1)
-- LI) evalMSE (simpRemove y (AddMS x ms2))
-- =                                                simpRemove.1
--    evalMSE (if y == x 
--                 then ms
--                 else (RemoveMS y (AddMS x ms2)))
-- =                                               por prop. del if                           
--    (if y == x 
--         then evalMSE ms
--         else evalMSE ((RemoveMS y (AddMS x ms2))))
-- =                                               evalMSE.3
--    (if y == x 
--         then evalMSE ms
--         else evalMSE (quitar y (evalMSE (AddMS x ms2))))
-- =                                               evalMSE.2
--    (if y == x 
--         then evalMSE ms
--         else evalMSE (quitar y (x : evalMSE ms2)))

-- LD) quitar y (evalMSE (AddMS x ms2))
-- =                                       evalMSE.2 
--     quitar y (x : evalMSE ms2)
-- =                                       quitar.2
--     if x == y
--         then evalMSE ms2
--         else x : quitar y (x : evalMSE ms2)             
-- incompleto

-- resumen de demos
-- funciones de matter matching -> demostrar por analisis de casos
-- funciones con if -> demostrar con subcasos sobre if. 

foldMSExp :: b -> (a -> b -> b) -> (a -> b -> b) -> (b -> b -> b) -> ((a -> a) -> b -> b) -> MSExp a -> b
foldMSExp b a r u m EmptyMS           = b
foldMSExp b a r u m (AddMS y ms)      = a y (foldMSExp b a r u m ms)
foldMSExp b a r u m (RemoveMS y ms)   = r y (foldMSExp b a r u m ms)
foldMSExp b a r u m (UnionMS ms1 ms2) = u (foldMSExp b a r u m ms1) (foldMSExp b a r u m ms2)  
foldMSExp b a r u m (MapMS f ms)      = m f (foldMSExp b a r u m ms)


recMSExp :: b -> (a -> MSExp a -> b -> b) -> (a -> MSExp a -> b -> b) -> (MSExp a -> b -> MSExp a -> b -> b) -> ((a -> a) -> MSExp a -> b -> b) -> MSExp a -> b
recMSExp b a r u m EmptyMS           = b
recMSExp b a r u m (AddMS y ms)      = a y ms (recMSExp b a r u m ms)
recMSExp b a r u m (RemoveMS y ms)   = r y ms (recMSExp b a r u m ms)
recMSExp b a r u m (UnionMS ms1 ms2) = u ms1 (recMSExp b a r u m ms1) ms2 (recMSExp b a r u m ms2)  
recMSExp b a r u m (MapMS f ms)      = m f ms (recMSExp b a r u m ms)

occursMESWith' :: Eq a => a -> (a -> a) -> MSExp a -> Int
occursMESWith' x f ms = foldMSExp
        (\x f -> 0)
        (\y rs x f -> unoSi (f y == x) + rs x f)
        (\y rs x f -> max 0 (rs x f - unoSi (f y == x)))
        (\rs1 rs2 x f -> rs1 x f + rs2 x f)
        (\g rs x f -> rs x (f . g))
        ms x f

filterMSE' :: (a -> Bool) -> MSExp a -> MSExp a
filterMSE' = flip (foldMSExp
        (\f -> EmptyMS)
        (\y rs f -> if f y
                        then AddMS y (rs f)
                        else rs f)
        (\y rs f -> if f y
                        then RemoveMS y (rs f)
                        else rs f)
        (\rs1 rs2 f -> UnionMS (rs1 f) (rs2 f))
        (\g rs f    -> MapMS g (rs (f . g))))

balance' :: Eq a => (a -> a) -> MSExp a -> [(a, Int)]
balance' = flip (foldMSExp (\f -> [])
                          (\y rs f -> update (+1) (f y) (rs f))
                          (\y rs f -> update (subtract 1) (f y) (rs f))
                          (\rs1 rs2 f -> rs1 f ++ rs2 f)
                          (\g rs f -> rs (f . g)))

evalMSE' :: Eq a => MSExp a -> [a]
evalMSE' = foldMSExp []
                    (\y rs -> y : rs)
                    (\y rs -> quitar y rs)
                    (\rs1 rs2 -> rs1 ++ rs2)
                    (\f rs -> map f rs)

simpMSE' :: Eq a => MSExp a -> MSExp a
simpMSE' = foldMSExp EmptyMS
                   (\y rs -> AddMS y rs)
                   (\y rs -> simpRemove y rs)
                   (\rs1 rs2 -> simpUnion rs1 rs2)
                   (\f rs -> simpMap f rs)