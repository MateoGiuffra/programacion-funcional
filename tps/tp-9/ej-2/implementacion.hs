-- IMPORTACIONES
data EA = Const Int | BOp BinOp EA EA
  deriving (Show)

data BinOp = Sum | Mul
  deriving (Show)

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
