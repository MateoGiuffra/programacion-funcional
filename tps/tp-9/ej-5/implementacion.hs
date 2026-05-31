-- Ejercicio 5
-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi _ = 0

data QuadTree a
  = LeafQ a
  | NodeQ (QuadTree a) (QuadTree a) (QuadTree a) (QuadTree a)
  deriving (Show, Eq)

data Color = RGB Int Int Int
  deriving (Show, Eq)

type Image = QuadTree Color

{-
    TEMPLATE

f :: QuadTree a -> a
f (LeafQ x) = 0
f (NodeQ q1 q2 q3 q4) = f q1  f q2  f q3 f q4

    TEMPLATE
-}

max4 :: Int -> Int -> Int -> Int -> Int
max4 x y z a = max (max a z) (max x y)

-- i.
-- heightQT :: QuadTree a -> Int, que describe la altura del árbol dado.
heightQT :: QuadTree a -> Int
heightQT (LeafQ x) = 0
heightQT (NodeQ q1 q2 q3 q4) = 1 + max4 (heightQT q1) (heightQT q2) (heightQT q3) (heightQT q4)

-- ii.
-- countLeavesQT :: QuadTree a -> Int, que describe la cantidad de hojas del árbol dado.
countLeavesQT :: QuadTree a -> Int
countLeavesQT (LeafQ x) = 0
countLeavesQT (NodeQ q1 q2 q3 q4) = unoSi (areLeaves q1 q2 q3 q4) + countLeavesQT q1 + countLeavesQT q2 + countLeavesQT q3 + countLeavesQT q4

areLeaves :: QuadTree a -> QuadTree a -> QuadTree a -> QuadTree a -> Bool
areLeaves q1 q2 q3 q4 = isLeave q1 && isLeave q2 && isLeave q3 && isLeave q4

isLeave :: QuadTree a -> Bool
isLeave (LeafQ _) = True
isLeave _ = False

-- iii.
-- sizeQT :: QuadTree a -> Int, que describe la cantidad de constructores del árbol dado.
sizeQT :: QuadTree a -> Int
sizeQT (LeafQ x) = 0
sizeQT (NodeQ q1 q2 q3 q4) = 1 + heightQT q1 + heightQT q2 + heightQT q3 + heightQT q4

-- iv.
-- compress :: QuadTree a -> QuadTree a, que describe el árbol resultante de transformar en hoja todos aquellos nodos para los que se cumpla que todas sus hojas tengan el mismo valor.
compress :: (Eq a) => QuadTree a -> QuadTree a
compress (LeafQ x) = (LeafQ x)
compress (NodeQ q1 q2 q3 q4) =
  if areEquals (compress q1) (compress q2) (compress q3) (compress q4)
    then q1
    else (NodeQ (compress q1) (compress q2) (compress q3) (compress q4))

areEquals :: (Eq a) => QuadTree a -> QuadTree a -> QuadTree a -> QuadTree a -> Bool
areEquals (LeafQ x1) (LeafQ x2) (LeafQ x3) (LeafQ x4) = x1 == x2 && x2 == x3 && x3 == x4
areEquals _ _ _ _ = False

-- v.
-- uncompress :: QuadTree a -> QuadTree a
-- que describe el árbol resultante de transformar en nodo (manteniendo el dato de la hoja correspondiente) todas aquellas hojas que no se encuentren en el nivel de la altura del árbol.
uncompress :: QuadTree a -> QuadTree a
uncompress (LeafQ x) = (NodeQ (LeafQ x) (LeafQ x) (LeafQ x) (LeafQ x))
uncompress (NodeQ q1 q2 q3 q4) =
  if areLeaves q1 q2 q3 q4
    then (NodeQ q1 q2 q3 q4)
    else (NodeQ (uncompress q1) (uncompress q2) (uncompress q3) (uncompress q4))

-- no creo que sea asi pero bueno, lo dejamos estar

-- vi.
-- render :: Image -> Int -> Image, que describe la imagen dada en el tamaño dado.
-- Precondición: el tamaño dado es potencia de 4 y es mayor o igual a la altura del árbol dado elevado a la 4ta potencia.
render :: Image -> Int -> Image
render (LeafQ x) height =
  if 1 == height
    then (LeafQ x)
    else
      ( NodeQ
          (render (LeafQ x) (div height 4))
          (render (LeafQ x) (div height 4))
          (render (LeafQ x) (div height 4))
          (render (LeafQ x) (div height 4))
      )
render (NodeQ q1 q2 q3 q4) height =
  if 1 == height
    then (NodeQ q1 q2 q3 q4)
    else
      ( NodeQ
          (render q1 (div height 4))
          (render q2 (div height 4))
          (render q3 (div height 4))
          (render q4 (div height 4))
      )

-- =============================================================================
-- VALORES DE PRUEBA (CASOS DE PRUEBA)
-- =============================================================================

-- Paleta de colores básica para pruebas de Image
rojo :: Color
rojo = RGB 255 0 0

azul :: Color
azul = RGB 0 0 255

blanco :: Color
blanco = RGB 255 255 255

-- 1. Casos base (Hojas individuales)
hojaSimple :: QuadTree Int
hojaSimple = LeafQ 42

imagenRoja :: Image
imagenRoja = LeafQ rojo

-- 2. Árbol plano de altura 1 (Un nodo con 4 hojas idénticas - Ideal para probar compress)
arbolIdentico :: QuadTree Int
arbolIdentico = NodeQ (LeafQ 7) (LeafQ 7) (LeafQ 7) (LeafQ 7)

arbolRepetido :: QuadTree Int
arbolRepetido = (NodeQ (LeafQ 1) (NodeQ (LeafQ 7) (LeafQ 7) (LeafQ 7) (LeafQ 7)) (LeafQ 2) (NodeQ (LeafQ 4) (LeafQ 4) (LeafQ 4) ((NodeQ (LeafQ 4) (LeafQ 4) (LeafQ 4) (LeafQ 4)))))

imagenBlancaCompleta :: Image
imagenBlancaCompleta = NodeQ (LeafQ blanco) (LeafQ blanco) (LeafQ blanco) (LeafQ blanco)

-- 3. Árbol de altura 1 con valores distintos
arbolVariado :: QuadTree Int
arbolVariado = NodeQ (LeafQ 1) (LeafQ 2) (LeafQ 3) (LeafQ 4)

-- 4. Estructura asimétrica desbalanceada (Ideal para probar heightQT y uncompress)
-- Contiene un subárbol anidado solo en la primera rama
arbolAsimetrico :: QuadTree Int
arbolAsimetrico =
  NodeQ
    (NodeQ (LeafQ 10) (LeafQ 10) (LeafQ 10) (LeafQ 10))
    (LeafQ 5)
    (LeafQ 5)
    (LeafQ 5)

-- 5. Imagen mixta compleja de altura 2
-- Representa un cuadrante superior izquierdo con un patrón de tablero y el resto liso
imagenCompleja :: Image
imagenCompleja =
  NodeQ
    (NodeQ (LeafQ rojo) (LeafQ azul) (LeafQ azul) (LeafQ rojo)) -- q1
    (LeafQ azul) -- q2
    (LeafQ rojo) -- q3
    (LeafQ azul) -- q4