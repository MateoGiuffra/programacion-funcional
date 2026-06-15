import Prelude hiding (mapM, Left, Right, Stright)
-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi _ = 0


esCero :: ExpA -> Bool
esCero (Suma (Cte 0) _) = True
esCero (Suma _ (Cte 0)) = True
esCero (Cte 0) = True
esCero _ = False

many :: Int -> (a -> a) -> a -> a 
many 0 f x = x 
many n f x = f (many (n-1) f x) 
-- auxs

-- tests
-- Casos Base (Constantes)
expCte1 :: ExpA
expCte1 = Cte 5

expCte2 :: ExpA
expCte2 = Cte 0

expCte3 :: ExpA
expCte3 = Cte (-10)

-- Operaciones Simples
expSumaSimple :: ExpA
expSumaSimple = Suma (Cte 0) (Cte 0)

expProdSimple :: ExpA
expProdSimple = Prod (Cte 4) (Cte 2)

-- Operaciones Combinadas (Árboles Pequeños)
expCombinada1 :: ExpA
expCombinada1 = Prod (Suma (Cte 5) (Cte 3)) (Cte 2)

expCombinada2 :: ExpA
expCombinada2 = Suma (Cte 5) (Prod (Cte 3) (Cte 2))

-- Casos Complejos y de Borde
expCompleja :: ExpA
expCompleja = Suma (Prod (Cte 2) (Cte 3)) (Prod (Cte 4) (Cte 5))

expNeutros :: ExpA
expNeutros = Prod (Suma (Cte 5) (Cte 0)) (Cte 1)

expAnidadaIzq :: ExpA
expAnidadaIzq = Suma (Suma (Suma (Cte 1) (Cte 2)) (Cte 3)) (Cte 4)
-- tests


data ExpA  = Cte Int 
            | Suma ExpA ExpA
            | Prod ExpA ExpA
    deriving (Show)

-- a.  Dar  el  tipo  y  definir  foldExpA,  que  expresa  el  esquema  de  recursión 
-- estructural para la estructura ExpA. 

foldExpA :: (Int -> b) -> (b -> b -> b) -> (b -> b -> b) -> ExpA -> b
foldExpA c s p (Cte n) = c n
foldExpA c s p (Suma n1 n2) = s (foldExpA c s p n1) (foldExpA c s p n2)
foldExpA c s p (Prod n1 n2) = p (foldExpA c s p n1) (foldExpA c s p n2)

-- b.  Resolver las siguientes funciones utilizando foldExpA: 
-- i.  que describe la cantidad de ceros explícitos en la expresión dada. 
cantidadDeCeros :: ExpA -> Int
cantidadDeCeros e = foldExpA (unoSi . (==0)) (+) (+) e
-- ii.
noTieneNegativosExplicitosExpA  ::  ExpA  ->  Bool
-- que describe si la expresión dada no tiene números negativos de manera explícita. 
noTieneNegativosExplicitosExpA e = foldExpA (<0) (&&) (&&) e
-- iii.
simplificarExpA'  ::  ExpA  ->  ExpA
-- que  describe  una  expresión con el mismo significado que la dada, pero que no tiene 
-- sumas del número 0 ni multiplicaciones por 1 o por 0. La resolución 
-- debe ser exclusivamente simbólica. 
simplificarExpA' e = foldExpA (Cte) ((simplificarSuma .) . Suma) ((simplificarProd .) . Prod) e


simplificarExpA :: ExpA -> ExpA
simplificarExpA (Cte n) = (Cte n)
simplificarExpA (Suma a1 a2) = simplificarSuma (Suma (simplificarExpA a1) (simplificarExpA a2))
simplificarExpA (Prod a1 a2) = simplificarProd (Prod (simplificarExpA a1) (simplificarExpA a2))

-- auxs
simplificarSuma :: ExpA -> ExpA
simplificarSuma (Suma (Cte 0) a) = a
simplificarSuma (Suma a (Cte 0)) = a
simplificarSuma a = a

simplificarProd :: ExpA -> ExpA
simplificarProd (Prod (Cte 1) a) = a
simplificarProd (Prod a (Cte 1)) = a
simplificarProd (Prod _ (Cte 0)) = Cte 0
simplificarProd (Prod (Cte 0) _) = Cte 0
simplificarProd a = a
-- auxs


-- iv.  
evalExpA' :: ExpA -> Int
-- que describe el número que resulta de evaluar la cuenta representada por la expresión aritmética dada. 
evalExpA' e = foldExpA id (+) (*) e

-- -- v.
showExpA  ::  ExpA  ->  String
-- que  describe  el  string  sin espacios y con paréntesis correspondiente a la expresión dada. 
showExpA e = foldExpA show (\s1 s2 -> "(" ++ s1 ++ "+" ++ s2 ++ ") ") (\s1 s2 -> "(" ++ s1 ++ "*" ++ s2 ++ ")") e

-- Ejercicio 2)  Dada la definición de EA: 
data EA = Const Int | BOp BinOp EA EA 
   deriving Show 
data BinOp = Sum | Mul
   deriving Show 

-- vars de testeo
ea1 :: EA
ea1 = Const 5

ea2 :: EA
ea2 = BOp Sum (Const 0) (Const 10)

ea3 :: EA
ea3 = BOp Mul (BOp Sum (Const 2) (Const 3)) (Const 4)

ea4 :: EA
ea4 = BOp Mul (Const 0) (BOp Sum (Const 5) (Const 5))
-- vars de testeo


-- a.  Dar el tipo y definir foldEA, que expresa el esquema de recursión estructural 
-- para la estructura EA. 
foldEA :: (Int -> b) -> (b -> b -> b) -> (b -> b -> b) -> EA -> b
foldEA c s m (Const n)        = c n
foldEA c s m (BOp Sum e1 e2)  = s (foldEA c s m e1) (foldEA c s m e2)
foldEA c s m (BOp Mul e1 e2)  = m (foldEA c s m e1) (foldEA c s m e2)

noTieneNegativosExplicitosEA  ::  EA  ->  Bool
-- que  describe si la expresión dada no tiene números negativos de manera 
-- explícita. 
noTieneNegativosExplicitosEA e = foldEA (>0) (&&) (&&) e

simplificarEA' :: EA -> EA
-- que describe una expresión con 
-- el  mismo  significado  que  la  dada
-- pero  que  no  tiene  sumas  del 
-- número 0 ni multiplicaciones por 1 o por 0. La resolución debe ser 
-- exclusivamente simbólica. 
simplificarEA' = foldEA 
   Const 
   ((simplificarSumEA .) . (BOp Sum))
   ((simplificarMulEA .) . (BOp Mul))


compose f g x = f (g x)

-- compose (compose simplificarSumEA) (BOp Sum) (Const 0) (Const 1) 
-- = 
-- ((simplificarSumEA `compose`) `compose` (BOp Sum)) (Const 0) (Const 1) 
-- ((simplificarSumEA .) . (BOp Sum)) (Const 0) (Const 1)

-- compose (compose simplificarSumEA) (BOp Sum) (Const 0) (Const 1) 
-- -- def compose.1, f <- compose simplificarSumEA, g <- BOp Sum, x <- Const 0
-- (compose simplificarSumEA) (BOp Sum (Const 0)) (Const 1)
-- -- def compose.2, f <- simplificarSumEA, g <- BOp Sum (Const 0), x <- (Const 1)
-- simplificarSumEA (BOp Sum (Const 0) (Const 1))


-- auxs
simplificarSumEA :: EA -> EA
simplificarSumEA (BOp Sum (Const 0) (Const n)) = Const n
simplificarSumEA (BOp Sum (Const n) (Const 0)) = Const n
simplificarSumEA e = e

simplificarMulEA :: EA -> EA
simplificarMulEA (BOp Mul (Const 1) a) = a
simplificarMulEA (BOp Mul a (Const 1)) = a
simplificarMulEA (BOp Mul _ (Const 0)) = Const 0
simplificarMulEA (BOp Mul (Const 0) _) = Const 0
simplificarMulEA e = e
-- auxs

evalEA'  :: EA -> Int
--  que describe el número que resulta de 
-- evaluar la cuenta representada por la expresión aritmética dada. 
evalEA' = foldEA id (+) (*)


-- showEA :: EA -> String
-- --  que describe el string sin espacios y 
-- con paréntesis correspondiente a la expresión dada.  

ea2ExpA' :: EA -> ExpA
--  que describe una expresión aritmética 
-- representada con el tipo ExpA
--  cuyo significado es el mismo que la dada. 
ea2ExpA' = foldEA Cte Suma Prod

-- ea2Arbol'  ::  EA  ->  ABTree  BinOp  Int
-- -- que  describe  la 
-- -- representación como elemento del tipo ABTree  BinOp Int de la 
-- expresión aritmética dada.


-- Ejercicio 3)  Dada la definición de Tree: 
data Tree a = EmptyT | NodeT a (Tree a) (Tree a) 
            deriving Show
-- a.  Dar el tipo y definir la función foldT, que expresa el esquema de recursión 
-- estructural para la estructura Tree
foldT :: b -> (a -> b -> b -> b) -> Tree a -> b 
foldT z f EmptyT = z
foldT z f (NodeT a ti td) = f a (foldT z f ti) (foldT z f td)

-- i.
mapT :: (a -> b) -> Tree a -> Tree b 
mapT f = foldT EmptyT (NodeT . f)

-- -- ii.
sumT :: Tree Int -> Int 
sumT = foldT 0 (\a ri rd -> a + ri + rd)

-- -- iii.
sizeT :: Tree a -> Int 
sizeT = foldT 0 (\a ri rd -> 1 + ri + rd)
-- -- iv.
heightT :: Tree a -> Int 
heightT = foldT 0 (\a ri rd -> 1 + (max ri rd))
-- -- v.
preOrder :: Tree a -> [a] 
preOrder = foldT [] (\a ri rd -> a : (ri ++ rd))
-- -- vi.
inOrder :: Tree a -> [a] 
inOrder = foldT [] (\a ri rd -> ri ++ [a] ++ rd)
-- -- vii.
postOrder :: Tree a -> [a] 
postOrder = foldT [] (\a ri rd -> ri ++ rd ++ [a])
-- viii.
mirrorT :: Tree a -> Tree a 
mirrorT = foldT EmptyT (\a ri rd -> NodeT a rd ri)
-- ix.
countByT :: (a -> Bool) -> Tree a -> Int 
countByT f = foldT 0 (\a ri rd -> unoSi (f a) + ri + rd)
-- x.
partitionT :: (a -> Bool) -> Tree a -> ([a], [a]) 
partitionT f = foldT ([], []) (\a ri rd -> addInPartition f a ri rd)

addInPartition :: (a -> Bool) -> a -> ([a], [a]) -> ([a], [a]) -> ([a], [a]) 
addInPartition f x (ri1, rd1) (ri2, rd2) = if f x 
                                             then ((x : ri1 ++ ri2), rd1 ++ rd2)
                                             else (ri1 ++ ri2, (x : rd1 ++ rd2))
-- -- xi.
zipWithT :: (a -> b-> c) -> Tree a -> Tree b -> Tree c
zipWithT f t1 t2 = foldT (\_ -> EmptyT) (zips f) t1 t2

zips :: (a -> b -> c) -> a -> (Tree b -> Tree c) -> (Tree b -> Tree c) -> Tree b -> Tree c
zips f x ri rd EmptyT          = EmptyT
zips f x ri rd (NodeT y ti td) = NodeT (f x y) (ri ti) (rd td)

-- arboles simples
t1 = NodeT 1 (NodeT 2 EmptyT EmptyT) (NodeT 3 EmptyT EmptyT)
t2 = NodeT 10 
      (NodeT 20 EmptyT EmptyT) 
      (NodeT 30 EmptyT 
         ((NodeT 20 EmptyT 
         ((NodeT 20 EmptyT EmptyT)))))

-- misma estructura, zipWithT (+) t1 t2 deberia dar:
-- NodeT 11 (NodeT 22 EmptyT EmptyT) (NodeT 33 EmptyT EmptyT)

-- xii.
caminoMasLargo :: Tree a -> [a]
caminoMasLargo = foldT [] (\a ri rd -> a : maxList ri rd)

maxList :: [a] -> [a] -> [a]
maxList xs ys = if length xs > length ys then xs else ys

-- xiii.
todosLosCaminos :: Tree a -> [[a]] 
todosLosCaminos = foldT [] (\a ri rd -> agregarEnTodosLosCaminos a (ri ++ rd))

agregarEnTodosLosCaminos :: a -> [[a]] -> [[a]]
agregarEnTodosLosCaminos e []     = [[e]]
agregarEnTodosLosCaminos e (x:xs) = (e : x) : agregarEnTodosLosCaminos e xs

-- xiv.
todosLosNiveles :: Tree a -> [[a]] 
todosLosNiveles = foldT [] (\a ri rd -> unirPorNivel a ri rd)

-- e lo agrego siempre, unirNiveles se encarga de ordenarlo donde va
unirPorNivel :: a -> [[a]] -> [[a]] -> [[a]]
unirPorNivel e ri rd = [e] : unirNiveles ri rd

-- recibe dos listas de listas, junta las izq con der por nivel (indice) 
unirNiveles :: [[a]] -> [[a]] -> [[a]]
unirNiveles [] [] = []
unirNiveles [] ys = ys
unirNiveles xs [] = xs
unirNiveles (x: xs) (y: ys) = (x ++ y) : unirNiveles xs ys



-- Ejercicio 4)  Dadas las siguientes definiciones para representar mapas con diferentes 
-- puntos de interés que pueden presentar objetos: 


data Dir = Left | Right | Straight 
            deriving (Show)
data Mapa a = Cofre [a]  
            | Nada (Mapa a)  
            | Bifurcacion [a] (Mapa a) (Mapa a) 
            deriving (Show)
-- a.  Dar el tipo y definir foldM y recM, que expresan los esquemas de recursión 
-- estructural y primitiva, respectivamente, para la estructura Mapa.
foldM :: ([a] -> b) -> (b -> b) -> ([a] -> b -> b -> b) -> (Mapa a) -> b
foldM c n b (Cofre xs) = c xs
foldM c n b (Nada m) = n (foldM c n b m)
foldM c n b (Bifurcacion xs m1 m2) = b xs (foldM c n b m1) (foldM c n b m2)

recM :: ([a] -> b) -> (Mapa a -> b -> b) -> ([a] -> Mapa a -> b -> Mapa a -> b -> b) -> Mapa a -> b
recM c n b (Cofre xs)             = c xs
recM c n b (Nada m)               = n m (recM c n b m)
recM c n b (Bifurcacion xs m1 m2) = b xs m1 (recM c n b m1) m2 (recM c n b m2)

-- vars de testeo
-- mapa simple, solo un cofre
m1 = Cofre [1,2,3]

-- nada que lleva a un cofre
m2 = Nada (Cofre [10,20])

-- bifurcacion simple
m3 = Bifurcacion [1] (Cofre [2,3]) (Cofre [4,5])

-- nada que lleva a una bifurcacion
m4 = Nada (Bifurcacion [1] (Cofre [2]) (Cofre [3]))

-- bifurcacion con nadas
m5 = Bifurcacion [1] (Nada (Cofre [2,3])) (Nada (Cofre [4,5]))

-- arbol mas profundo
m6 = Bifurcacion [1] 
         (Bifurcacion [2] 
            (Cofre [3])
            (Cofre [4])) 
         (Nada (Cofre [5]))
-- vars de testeo

objects  :: Mapa a -> [a]
-- que describe la lista de todos los objetos presentes en el mapa dado. 
objects = foldM id id (\xs rm1 rm2 -> xs ++ rm1 ++ rm2)

mapM :: (a -> b) -> Mapa a -> Mapa b
-- que transforma los objetos del mapa dado aplicando la función dada.
mapM f = foldM (Cofre . (map f)) (Nada . id) (\xs rm1 rm2 -> Bifurcacion (map f xs) rm1 rm2)

-- ii
has :: (a -> Bool) -> Mapa a -> Bool
-- que indica si existe 
-- algún objeto que cumpla con la condición dada en el mapa dado
has f = foldM (any f) (id) (\xs rm1 rm2 -> any f xs || rm1 || rm2) 

-- iv
hasObjectAt :: (a->Bool) -> Mapa a -> [Dir] -> Bool
-- que  indica  si  un  objeto  al  final  del  camino  dado  cumple  con  la 
-- condición dada en el mapa dado
hasObjectAt f = foldM (\xs dirs -> if null dirs then any f xs else False)
                      id
                      (hasObjectAtBif f)

hasObjectAtBif :: (a -> Bool) -> [a] -> ([Dir] -> Bool) -> ([Dir] -> Bool) -> [Dir] -> Bool
hasObjectAtBif f xs rm1 rm2 []      = any f xs
hasObjectAtBif f xs rm1 rm2 (d: ds) = case d of 
                                       Left  -> (rm1 ds)
                                       Right -> (rm2 ds)
                                       _     -> False
-- v
longestPath :: Mapa a -> [Dir]
-- que describe el camino más largo en el mapa dado
longestPath = foldM (const []) (Straight :) (\xs rm1 rm2 -> addDirToLongestPath rm1 rm2)

addDirToLongestPath :: [Dir] -> [Dir] -> [Dir]
addDirToLongestPath left right = if length left >= length right
                                          then Left : left
                                          else Right : right

objectsOfLongestPath  ::  Mapa  a  ->  [a]
-- que describe la lista con los objetos presentes en el camino más largo del mapa dado
objectsOfLongestPath = foldM id id (\xs rm1 rm2 -> addObjectsToLongestPath xs rm1 rm2)

addObjectsToLongestPath :: [a] -> [a] -> [a] -> [a]
addObjectsToLongestPath xs left right = if length left >= length right
                                          then xs ++ left
                                          else xs ++ right

allPaths :: Mapa  a  -> [[Dir]]
-- que describe la lista con  todos los caminos del mapa dado
allPaths = foldM (const []) ([Straight] :) (\xs rm1 rm2 -> joinPaths Left rm1 ++ joinPaths Right rm2)

joinPaths :: Dir -> [[Dir]] -> [[Dir]]
joinPaths dir []      = [[dir]]
joinPaths dir (x: xs) = (dir : x) : joinPaths dir xs

objectsPerLevel  ::  Mapa a -> [[a]]
-- que describe la lista con todos los objetos por niveles del mapa dado
objectsPerLevel = foldM (\xs -> [xs]) id joinObjecstPerLevel

joinObjecstPerLevel :: [a] -> [[a]] -> [[a]] -> [[a]]
joinObjecstPerLevel xs rm1 rm2 = xs : joinObjectsByLevel rm1 rm2

joinObjectsByLevel :: [[a]] -> [[a]] -> [[a]]
joinObjectsByLevel [] []     = []
joinObjectsByLevel [] (y:ys) = y : joinObjectsByLevel [] ys
joinObjectsByLevel (x:xs) [] = x : joinObjectsByLevel xs []
joinObjectsByLevel (x:xs) (y:ys) = (x ++ y) : joinObjectsByLevel xs ys
