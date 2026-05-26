-- ################### import ExpA #######################
data ExpA = Cte Int | Suma ExpA ExpA | Prod ExpA ExpA
  deriving (Show)

evalExpA :: ExpA -> Int
evalExpA (Cte n) = n
evalExpA (Suma a1 a2) = evalExpA a1 + evalExpA a2
evalExpA (Prod a1 a2) = evalExpA a1 * evalExpA a2

-- ii
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

-- iii
cantidadDeSumaCero :: ExpA -> Int
cantidadDeSumaCero (Cte n) = 0
cantidadDeSumaCero (Suma a1 a2) = unoSi (esCero a1 || esCero a2) + cantidadDeSumaCero a1 + cantidadDeSumaCero a2
cantidadDeSumaCero (Prod a1 a2) = cantidadDeSumaCero a1 + cantidadDeSumaCero a2

-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0

esCero :: ExpA -> Bool
esCero (Suma (Cte 0) _) = True
esCero (Suma _ (Cte 0)) = True
esCero (Cte 0) = True
esCero _ = False

-- ################### import ExpA #######################

data EA = Const Int | BOp BinOp EA EA
  deriving (Show)

data BinOp = Sum | Mul
  deriving (Show)

-- i
evalEA :: EA -> Int
evalEA (Const n) = n
evalEA (BOp Sum e1 e2) = evalEA e1 + evalEA e2
evalEA (BOp Mul e1 e2) = evalEA e1 * evalEA e2

-- ii
ea2ExpA :: EA -> ExpA
-- que describe una expresión aritmética
-- representada con el tipo ExpA, cuya estructura y significado son los
-- mismos que la dada.
ea2ExpA (Const n) = (Cte n)
ea2ExpA (BOp Sum e1 e2) = (Suma (ea2ExpA e1) (ea2ExpA e2))
ea2ExpA (BOp Mul e1 e2) = (Prod (ea2ExpA e1) (ea2ExpA e2))

-- iii
expA2ea :: ExpA -> EA
-- que describe una expresión aritmética representada
-- con el tipo EA, cuya estructura y significado son
-- los mismos que la dada
expA2ea (Cte n) = (Const n)
expA2ea (Suma a1 a2) = (BOp Sum (expA2ea a1) (expA2ea a2))
expA2ea (Prod a1 a2) = (BOp Mul (expA2ea a1) (expA2ea a2))

-- ejercicio 2
data Arbol a b = Hoja b | Nodo a (Arbol a b) (Arbol a b)
  deriving (Show)

-- i.
cantidadDeHojas :: Arbol a b -> Int
-- que describe la cantidad de hojas en el árbol dado.
cantidadDeHojas (Hoja y) = 1
cantidadDeHojas (Nodo x izq der) = cantidadDeHojas izq + cantidadDeHojas der

-- ii.
cantidadDeNodos :: Arbol a b -> Int
-- que describe la cantidad de nodos en el árbol dado.
cantidadDeNodos (Hoja y) = 0
cantidadDeNodos (Nodo x izq der) = 1 + cantidadDeNodos izq + cantidadDeNodos der

-- iii.
cantidadDeConstructores :: Arbol a b -> Int
-- que describe la cantidad de constructores en el árbol dado.
cantidadDeConstructores (Hoja y) = 1
cantidadDeConstructores (Nodo x izq der) = 1 + cantidadDeConstructores izq + cantidadDeConstructores der

-- iv.
ea2Arbol :: EA -> Arbol BinOp Int
-- que describe la
-- representación como elemento del tipo Arbol BinOp Int de la
-- expresión aritmética dada
ea2Arbol (Const n) = (Hoja n)
ea2Arbol (BOp Sum e1 e2) = (Nodo Sum (ea2Arbol e1) (ea2Arbol e2))
ea2Arbol (BOp Mul e1 e2) = (Nodo Mul (ea2Arbol e1) (ea2Arbol e2))

-- ejercicio 3
data Tree a = EmptyT | NodeT a (Tree a) (Tree a)
  deriving (Show)

-- i.
sumarT :: Tree Int -> Int
-- que describe el número resultante
-- de sumar todos los números en el árbol dado.
sumarT EmptyT = 0
sumarT (NodeT n izq der) = n + sumarT izq + sumarT der

-- ii.
sizeT :: Tree a -> Int
-- que describe la cantidad de elementos en el árbol dado.
sizeT EmptyT = 0
sizeT (NodeT n izq der) = 1 + sizeT izq + sizeT der

-- iii.
anyT :: (a -> Bool) -> Tree a -> Bool
-- que indica si en el
-- árbol dado hay al menos un elemento que cumple con el predicado
-- dado.
anyT validate EmptyT = False
anyT validate (NodeT n izq der) = validate n || anyT validate izq || anyT validate der

-- iv.
countT :: (a -> Bool) -> Tree a -> Int
-- que describe la cantidad de elementos en el árbol dado que cumplen con el predicado dado.
countT validate EmptyT = 0
countT validate (NodeT n izq der) = unoSi (validate n) + countT validate izq + countT validate der

-- v.
countLeaves :: Tree a -> Int
-- que describe la cantidad de hojas del árbol dado.
countLeaves EmptyT = 0
countLeaves (NodeT n izq der) =
  unoSi (isLeaves (NodeT n izq der))
    + countLeaves izq
    + countLeaves der

isLeaves :: Tree a -> Bool
isLeaves (NodeT _ EmptyT EmptyT) = True
isLeaves _ = False

-- vi.
heightT :: Tree a -> Int
-- que describe la altura del árbol dado.
heightT EmptyT = 0
heightT (NodeT n izq der) = 1 + (max (heightT izq) (heightT der))

-- vii.
inOrder :: Tree a -> [a]
-- que describe la lista in order con los elementos del árbol dado.
inOrder EmptyT = []
inOrder (NodeT n izq der) = n : (inOrder izq ++ inOrder der)

-- viii.
listPerLevel :: Tree a -> [[a]]
-- que describe la lista donde cada elemento es una lista con los elementos de un nivel del árbol dado.
listPerLevel EmptyT = []
listPerLevel (NodeT n izq der) = ([n] : listPerLevel izq) ++ ([n] : listPerLevel der)

-- revancha despues
-- ix.
-- mirrorT :: Tree a -> Tree a
-- -- que describe un árbol con los
-- -- mismos elemento que el árbol dado pero en orden inverso.

-- -- x.
-- levelN :: Int -> Tree a -> [a]
-- -- que describe la lista con los
-- -- elementos del nivel dado en el árbol dado.
-- -- xi.
-- ramaMasLarga :: Tree a -> [a]
-- -- que describe la lista con los
-- -- elementos de la rama más larga del árbol.
-- -- xii.
-- todosLosCaminos :: Tree a -> [[a]]

-- que describe la lista
-- con todos los caminos existentes en el árbol dado.

-- ################### VALORES DE PRUEBA ########################--------------------------------------------------------------------------------
-- 1. ÁRBOLES BÁSICOS Y VACÍOS
-- Ideales para probar los casos base de tus funciones recursivas.
--------------------------------------------------------------------------------

-- Árbol vacío
treeEmpty :: Tree Int
treeEmpty = EmptyT

-- Árbol hoja (solo la raíz)
treeLeaf :: Tree Int
treeLeaf = NodeT 5 EmptyT EmptyT

--------------------------------------------------------------------------------
-- 2. ÁRBOLES LINEALES O DEGENERADOS (ESTRUCTURA DE LISTA)
-- Útiles para verificar que tus funciones manejen correctamente desbalances extremos.
--------------------------------------------------------------------------------

-- Sesgado a la izquierda (todos los hijos a la izquierda)
treeLeftSkewed :: Tree Int
treeLeftSkewed = NodeT 10 (NodeT 5 (NodeT 2 EmptyT EmptyT) EmptyT) EmptyT

-- Sesgado a la derecha (todos los hijos a la derecha)
treeRightSkewed :: Tree Int
treeRightSkewed = NodeT 10 EmptyT (NodeT 20 EmptyT (NodeT 30 EmptyT EmptyT))

--------------------------------------------------------------------------------
-- 3. ÁRBOLES BALANCEADOS Y COMPLETOS
-- Estructuras estándar para validar el comportamiento general, alturas o recorridos.
--------------------------------------------------------------------------------

-- Árbol pequeño balanceado (Altura 2, 3 nodos)
treeSmall :: Tree Int
treeSmall = NodeT 10 (NodeT 5 EmptyT EmptyT) (NodeT 15 EmptyT EmptyT)

-- Árbol mediano completo (Altura 3, 7 nodos)
treeMedium :: Tree Int
treeMedium =
  NodeT
    10
    ( NodeT
        5
        (NodeT 2 EmptyT EmptyT)
        (NodeT 7 EmptyT EmptyT)
    )
    ( NodeT
        15
        (NodeT 12 EmptyT EmptyT)
        (NodeT 20 EmptyT EmptyT)
    )

--------------------------------------------------------------------------------
-- 4. ÁRBOLES CON CASOS DE BORDE ESPECÍFICOS
-- Para probar funciones que buscan duplicados, negativos o validaciones de orden.
--------------------------------------------------------------------------------

-- Árbol con valores duplicados y negativos
treeDuplicates :: Tree Int
treeDuplicates = NodeT 5 (NodeT (-3) (NodeT 5 EmptyT EmptyT) EmptyT) (NodeT (-3) EmptyT EmptyT)

-- Árbol desordenado (No es un BST, útil para probar funciones de validación)
treeUnordered :: Tree Int
treeUnordered = NodeT 10 (NodeT 20 EmptyT EmptyT) (NodeT 3 EmptyT EmptyT)

-- ################### VALORES DE PRUEBA ########################
