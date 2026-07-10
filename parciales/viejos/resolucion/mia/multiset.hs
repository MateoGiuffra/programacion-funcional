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
evalMSE ms = evalMSEWith id ms

evalMSEWith :: Eq a => (a -> a) -> MSExp a -> [a]
evalMSEWith f EmptyMS           = []
evalMSEWith f (AddMS y ms)      = f y : evalMSEWith f ms
evalMSEWith f (RemoveMS y ms)   = delete (f y) (evalMSEWith f ms)
evalMSEWith f (UnionMS ms1 ms2) = (evalMSEWith f ms1) ++ (evalMSEWith f ms2)  
evalMSEWith f (MapMS g ms)      = evalMSEWith (f . g) ms

delete :: Eq a => a -> [a] -> [a]
delete _ [] = []
delete e (x: xs) = if x == e then delete xs else x : delete xs

-- e
simpMSE :: MSExp a -> MSExp a
-- que, suponiendo que recibe una expresión de multiset
-- válida y describe al multiset resultante de simplificar el dado, aplicando las siguientes reglas en
-- todos los lugares posibles:
simpMSE EmptyMS           = EmptyMS
simpMSE (AddMS y ms)      = AddMS y (simpMSE ms)
simpMSE (RemoveMS y ms)   = simpRemove simpMSE ms
simpMSE (UnionMS ms1 ms2) = simpUnion (simpMSE ms1) (simpMSE ms2)  
simpMSE (MapMS f ms)      = simpMap f (simpMSE ms)

simpRemove :: MSExp a -> MSExp a
simpRemove (RemoveMS y (AddMS x ms)) = if y == x then ms else (RemoveMS y (AddMS x ms))
simpRemove e = e

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




