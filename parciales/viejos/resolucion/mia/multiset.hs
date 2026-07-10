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

data MSExp a = EmptyMS | AddMS a (MSExp a) | RemoveMS a (MSExp a) | 
UnionMS (MSExp a) (MSExp a) | MapMS (a -> a) (MSExp a)

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
occursMSE :: a -> MSExp a -> Int
occursMSE x EmptyMS           = 0 
occursMSE x (AddMS y ms)      = unoSi (x == y) + occursMSE x ms 
occursMSE x (RemoveMS y ms)   = max 0 (occursMSE x ms - unoSi (x == y))
occursMSE x (UnionMS ms1 ms2) = (occursMSE x ms1) + (occursMSE x ms2)
occursMSE x (MapMS f ms)      = occursMESWith x f ms 

occursMESWith :: a -> (a -> a) -> MSExp a -> Int
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
isValidMSE :: MSExp a -> Bool
-- que indica si la expresión de multiset dada es válida. Una
-- expresión de multiset es inválida si tiene más RemoveMS que AddMS para un elemento
-- determinado; en el caso de una UnionMS, cada parte se considera por separado
isValidMSE ms = sonTodosPositivos (balance id ms)

sonTodosPositivos :: [(a, Int)] -> Bool
sonTodosPositivos [] = True
sonTodosPositivos ((v, c): ps) = c >= 0 && sonTodosPositivos ps

balance :: (a -> a) -> MSExp a -> [(a, Int)]
balance f EmptyMS           = []
balance f (AddMS y ms)      = update (+1) (f y) (balance f ms)
balance f (RemoveMS y ms)   = update (-1) (f y) (balance f ms)
balance f (UnionMS ms1 ms2) = (balance f ms1) ++ (balance f ms2)
balance f (MapMS g ms)      = balance (f . g) ms

update :: (Int -> Int) -> a -> [(a, Int)] -> [(a, Int)]
update f x []      = [(x, f 0)]
update f x ((v, c): ps) = if v == x 
                            then (v, f c) : update f x ps
                            else (v, c) : update f x ps
-- d
evalMSE :: Eq a => MSExp a -> [a]
-- que describe la lista de todas las ocurrencias de los
-- elementos del multiset dado.
evalMSE EmptyMS           = []
evalMSE (AddMS y ms)      = y : evalMSE f ms
evalMSE (RemoveMS y ms)   = delete y (evalMSE f ms)
evalMSE (UnionMS ms1 ms2) = (evalMSE ms1) ++ (evalMSE ms2)  
evalMSE (MapMS f ms)      = map f (evalMSE ms)

delete :: Eq a => a -> [a] -> [a]
delete _ [] = []
delete e (x: xs) = if x == e then delete e xs else x : delete e xs
-- e
simpMSE :: MSExp a -> MSExp a
-- que, suponiendo que recibe una expresión de multiset
-- válida y describe al multiset resultante de simplificar el dado, aplicando las siguientes reglas en
-- todos los lugares posibles:
simpMSE EmptyMS           = EmptyMS
simpMSE (AddMS y ms)      = AddMS y (simpMSE ms)
simpMSE (RemoveMS y ms)   = simpRemove y (simpMSE ms)
simpMSE (UnionMS ms1 ms2) = simpUnion (simpMSE ms1) (simpMSE ms2)  
simpMSE (MapMS f ms)      = simpMap f (simpMSE ms)

simpRemove :: a -> MSExp a -> MSExp a
simpRemove y (AddMS x ms) = if y == x then ms else (RemoveMS y (AddMS x ms))
simpRemove y e = e 

simpUnion :: MSExp a ->  MSExp a -> MSExp a
simpUnion EmptyMS e  = e
simpUnion e  EmptyMS = e
simpUnion e1 e2      = UnionMS e1 e2

simpMap :: (a -> a) -> MSExp a -> MSExp a
simpMap f EmptyMS = EmptyMS
simpMap f e       = MapMS f e

-- ejemplos
vacio    = EmptyMS
agregar  = AddMS 1 vacio
remover  = AddMS 1 (RemoveMS 1 EmptyMS)

map     = MapMS (\a -> succ a) (MapMS (*2) AddMS 1 vacio)
valid   = AddMS 1 (Remove 1 (Remove 1 (MapMS succ (Add 0 Empty))))
invalid = Remove 1 (Remove 1 (Add 1 Empty))

union   = UnionsMS valid invalid
            [(1, 1)] ++ [(1, -1)] -> [(1, 0), (1, -1)]


Demostrar la siguiente propiedad: evalMSE . simpMSE = evalMSE

por principio de extencionalidad, sea mse un multiset cualquiera.

¿ para todo mse. (evalMSE . simpMSE) mse = evalMSE mse ?

por def. de compose, es equivalente a decir:

¿ para todo mse. evalMSE (simpMSE mse) = evalMSE mse ?

por principio de inducción estructural sobre la estructura mse

dem:

casoBase) mse = EmptyMS ¿ evalMSE (simpMSE EmptyMS) = evalMSE EmptyMS ?

casoInductivo1) mse = (AddMS y ms)
HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
TI) ¿ evalMSE (simpMSE (AddMS y ms)) = evalMSE (AddMS y ms) ?

casoInductivo2) mse = (RemoveMS y ms)
HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
TI) ¿ evalMSE (simpMSE (RemoveMS y ms)) = evalMSE (RemoveMS y ms) ?

casoInductivo3) mse = (UnionMS ms1 ms2)
HI1) ¡ evalMSE (simpMSE ms1) = evalMSE ms1 !
HI2) ¡ evalMSE (simpMSE ms2) = evalMSE ms2 !
TI) ¿ evalMSE (simpMSE (UnionMS ms1 ms2)) = evalMSE (UnionMS ms1 ms2) ?

casoInductivo4) mse = (MapMS f ms)
HI) ¡ evalMSE (simpMSE ms) = evalMSE ms !
TI) ¿ evalMSE (simpMSE (MapMS f ms)) = evalMSE (MapMS f ms) ?

Demuestro: 

casoBase)
LI) evalMSE (simpMSE EmptyMS)
=                                   --simpMSE.1
    evalMSE EmptyMS

LD) evalMSE EmptyMS

VALE ESTE caso

casoInductivo1)
LI)     evalMSE (simpMSE (AddMS y ms))
=                                           --simpMSE.2
        evalMSE AddMS y (simpMSE ms)
=                                           -- evalMSE.2
        y : evalMSE (simpMSE ms)
=                                           -- HI
        y : evalMSE ms

LD)     evalMSE (AddMS y ms)
=                                           -- evalMSE.2
        y : evalMSE ms

VALE ESTE caso

casoInductivo2)
LI)     evalMSE (simpMSE (RemoveMS y ms))
=                                               --simpMSE.3
        evalMSE (simpRemove y (simpMSE ms))
=                                               --Lema
        evalMSE (simpMSE ms)
=       
        evalMSE ms

LD)     evalMSE (RemoveMS y ms)
=                                               --evalMSE.3
        quitar y (evalMSE ms)

casoInductivo3)
LI)     evalMSE (simpMSE (UnionMS ms1 ms2))
=                                                      --simpMSE.4
        evalMSE (simpUnion (simpMSE ms1) (simpMSE ms2))
=                                                      -- LEMA
        evalMSE (simpMSE ms1) ++ evalMSE (simpMSE ms2)
=                                                       -- HI1 y HI2
        evalMSE ms1 ++ evalMSE ms2

LD)     evalMSE (UnionMS ms1 ms2)
=                                                      --evalMSE.4
        evalMSE e1 ++ evalMSE e2
=

VALe ESTE caso

