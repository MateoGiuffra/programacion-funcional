-- ej 4
data AppList a = Single a | Append (AppList a) (AppList a)
  deriving (Show)

-- i.
-- lenAL :: AppList a -> Int, que describe la cantidad de elementos de la lista.
lenAL :: AppList a -> Int
lenAL (Single x) = 0
lenAL (Append xs ys) = 1 + lenAL xs + lenAL ys

-- ii.
-- consAL :: a -> AppList a -> AppList a, que describe la lista resultante de agregar el elemento dado al principio de la lista dada.
consAL :: a -> AppList a -> AppList a
consAL x (Single y) = Append (Single x) (Single y)
consAL x (Append ys zs) = Append (consAL x ys) (consAL x zs)

-- iii.
-- headAL :: AppList a -> a, que describe el primer elemento de la lista dada.
headAL :: AppList a -> a
headAL (Single x) = x
headAL (Append xs ys) = headAL (Append xs ys)

-- iv.
-- tailAl :: AppList a -> AppList a, que describe la lista resultante de quitar el primer elemento de la lista dada.
tailAl :: AppList a -> AppList a
tailAl (Single x) = error "No existe lista vacia"
tailAl (Append xs ys) =
  if isSingle xs
    then ys
    else
      if isSingle ys
        then xs
        else Append (tailAl xs) (tailAl ys)

isSingle :: AppList a -> Bool
isSingle (Single x) = True
isSingle _ = False

sacarPrimerElemento :: AppList a -> AppList a
sacarPrimerElemento (Append (Single x) ys) = ys
sacarPrimerElemento (Append xs (Single x)) = xs
sacarPrimerElemento xs = xs

-- v.
-- snocAL :: AppList a -> a -> AppList a, que describe la lista resultante de agregar el elemento dado al final de la lista dada.
snocAL :: AppList a -> a -> AppList a
snocAL (Single x) y = Append (Single x) (Single y)
snocAL (Append xs ys) z = Append xs (snocAL ys z)

-- vi.
-- lastAL :: AppList a -> a, que describe el último elemento de la lista dada.
lastAL :: AppList a -> a
lastAL (Single x) = x
lastAL (Append xs ys) = lastAL ys

-- vii.
-- initAL :: AppList a -> AppList a, que describe la lista dada sin su último elemento.
initAL :: AppList a -> AppList a
initAL (Single x) = error "No existe lista vacia"
initAL (Append xs ys) = if isSingle ys then xs else (Append xs (initAL ys))

-- viii.
-- reverseAL :: AppList a -> AppList a, que describe la lista dada con sus elementos en orden inverso.
reverseAL :: AppList a -> AppList a
reverseAL (Single x) = Single x
reverseAL (Append xs ys) = (Append (reverseAL ys) (reverseAL xs))

-- ix.
-- elemAL :: Eq a => a -> AppList a -> Bool, que indica si el elemento dado se encuentra en la lista dada.
elemAL :: (Eq a) => a -> AppList a -> Bool
elemAL x (Single y) = x == y
elemAL x (Append ys zs) = elemAL x ys || elemAL x zs

-- x.
-- appendAL :: AppList a -> AppList a -> AppList a, que describe el resultado de agregar los elementos de la primera lista adelante de los elementos de la segunda.
-- NOTA: buscar la manera más eficiente de hacerlo.
appendAL :: AppList a -> AppList a -> AppList a
appendAL (Single x) ys = Append (Single x) ys
appendAL xs zs = Append xs zs

-- xi.
-- appListToList :: AppList a -> [a], que describe la representación lineal de la lista dada.
appListToList :: AppList a -> [a]
appListToList (Single x) = [x]
appListToList (Append xs ys) = appListToList xs ++ appListToList ys

-- =============================================================================
-- VALORES DE PRUEBA (CASOS DE PRUEBA)
-- =============================================================================

-- 1. Listas con un solo elemento (Casos base)
listaUnica1 :: AppList Int
listaUnica1 = Single 5

listaUnica2 :: AppList String
listaUnica2 = Single "hola"

-- 2. Listas con dos elementos
listaDos1 :: AppList Int
listaDos1 = Append (Single 10) (Single 20)

-- 3. Estructura balanceada (Forma de árbol simétrico)
-- Representa la lista lineal: [1, 2, 3, 4]
listaBalanceada :: AppList Int
listaBalanceada =
  Append
    (Append (Single 1) (Single 2))
    (Append (Single 3) (Single 4))

-- 4. Estructura cargada hacia la izquierda (Similar a un consAL sucesivo)
-- Representa la lista lineal: [10, 20, 30, 40]
listaIzquierda :: AppList Int
listaIzquierda = Append (Append (Append (Single 10) (Single 20)) (Single 30)) (Single 40)

-- 5. Estructura cargada hacia la derecha (Similar a un snocAL sucesivo)
-- Representa la lista lineal: [1, 2, 3, 4]
listaDerecha :: AppList Int
listaDerecha = Append (Single 1) (Append (Single 2) (Append (Single 3) (Single 4)))

-- 6. Lista más grande y mixta para pruebas generales
-- Representa la lista lineal: [5, 5, 10, 3, 7]
listaGrande :: AppList Int
listaGrande =
  Append
    (Append (Single 5) (Single 5))
    (Append (Single 10) (Append (Single 3) (Single 7)))