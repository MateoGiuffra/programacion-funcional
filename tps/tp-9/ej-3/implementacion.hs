-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0

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
listPerLevel (NodeT n izq der) = [n] : (fusionarNivel (listPerLevel izq) (listPerLevel der))

fusionarNivel :: [[a]] -> [[a]] -> [[a]]
fusionarNivel [] ys = ys
fusionarNivel xs [] = xs
fusionarNivel (x : xs) (y : ys) = (x ++ y) : (fusionarNivel xs ys)

-- ix.
mirrorT :: Tree a -> Tree a
-- que describe un árbol con los mismos elemento que el árbol dado pero en orden inverso.
mirrorT EmptyT = EmptyT
mirrorT (NodeT n izq der) = (NodeT n (mirrorT der) (mirrorT izq))

-- x.
levelN :: Int -> Tree a -> [a]
-- que describe la lista con los elementos del nivel dado en el árbol dado.
levelN n EmptyT = []
levelN n (NodeT x izq der) =
  if n == 0
    then [x]
    else
      (levelN (n - 1) izq)
        ++ (levelN (n - 1) der)

-- xi.
ramaMasLarga :: Tree a -> [a]
-- que describe la lista con los elementos de la rama más larga del árbol.
ramaMasLarga EmptyT = []
ramaMasLarga (NodeT x izq der) =
  if length (ramaMasLarga izq) > length (ramaMasLarga der)
    then x : ramaMasLarga izq
    else x : ramaMasLarga der

-- xii.
todosLosCaminos :: Tree a -> [[a]]
-- que describe la lista con todos los caminos existentes en el árbol dado.
todosLosCaminos EmptyT = []
todosLosCaminos (NodeT x izq der) = armarCamino (todosLosCaminos izq ++ todosLosCaminos der) x

armarCamino :: [[a]] -> a -> [[a]]
armarCamino [] y = [[y]]
armarCamino (x : xs) y = (y : x) : (armarCamino xs y)

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