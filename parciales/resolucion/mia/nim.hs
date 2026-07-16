data Nim
  = Empty -- juego vacío
  | Heap Int Nim -- pila con n fichas (n>0)
  deriving (Show)

type Move = (Int, Int) -- jugada: de la fila i remover k fichas

data GameTree
  = Nil -- árbol vacío
  | Node
      (Move, GameTree) -- (jugada, hijos - jugadas del contrincante)
      GameTree -- hermanos (otras jugadas propias)
  deriving (Show)

-- 1
-- game
foldGame :: b -> ((Move, b) -> b -> b) -> GameTree -> b
foldGame n nd (Nil) = n
foldGame n nd (Node (m, jhija) jhermana) = nd (m, foldGame n nd jhija) (foldGame n nd jhermana)

recGame :: b -> (GameTree -> (Move, b) -> GameTree -> b -> b) -> GameTree -> b
recGame n nd (Nil) = n
recGame n nd (Node (m, jhija) jhermana) = nd jhija (m, recGame n nd jhija) jhermana (recGame n nd jhermana)

-- nim
foldNim :: b -> (Int -> b -> b) -> Nim -> b
foldNim e h (Empty) = e
foldNim e h (Heap n nim) = h n (foldNim e h nim)

recNim :: b -> (Int -> Nim -> b -> b) -> Nim -> b
recNim e h (Empty) = e
recNim e h (Heap n nim) = h n nim (recNim e h nim)

-- 2
heaps :: Nim -> Int
heaps = foldNim 0 (\n rs -> rs + 1)

chips :: Nim -> Int
chips = foldNim 0 (+)

maxHeap:: Nim -> Int
maxHeap = recNim (error "no puede haber maximo en una pila vacia")
                 (\n nim rs -> if rs > n then rs else n)

alongside :: Nim -> Nim -> Nim
alongside nim1 nim2 = foldNim id (\n rs nim2 -> Heap ((cantFichas nim2) + n) (rs nim2)) nim1 nim2

cantFichas :: Nim -> Int
cantFichas Empty      = 0
cantFichas (Heap n _) = n


gameHeight :: GameTree -> Int
gameHeight = foldGame 0 (max . (+1) . snd)
                            
-- branches :: GameTree -> [[Move]]
-- branches =  foldGame [] 
--                     (\(m, rhija) rhermana -> map ([m] :) (rhija ++ rhermana))

-- [
--     [(0,1), (0,1), (1,1)],
--     [(0,1), (1,1), (0,1)],
--     [(0,2), (1,1)],
--     [(1,1), (0,1), (0,1)]
--     [(0,1), (0,2)]
-- ]

-- arbol de la Figura 2: Nim de 2 pilas con 2 y 1 fichas respectivamente
fig2 :: GameTree
fig2 = Node ((0,1), rama_01)
       (Node ((0,2), rama_02)
       (Node ((1,1), rama_11) Nil))
  where
    rama_01 = Node ((0,1), Node ((1,1), Nil) Nil)
              (Node ((1,1), Node ((0,1), Nil) Nil) Nil)
    rama_02 = Node ((1,1), Nil) Nil
    rama_11 = Node ((0,1), Node ((0,1), Nil) Nil)
              (Node ((0,2), Nil) Nil)