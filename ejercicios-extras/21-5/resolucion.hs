-- Dadas las siguientes definiciones

data Objeto = Moneda | Pelusa

data Dungeon = Cueva | Habitacion [Objeto] Dungeon Dungeon

objs :: Dungeon -> [Objeto]
objs Cueva = []
objs (Habitacion os ti td) = os ++ objs ti ++ objs td

dobleObj :: Objeto -> [Objeto]
dobleObj Moneda = [Moneda, Moneda]
dobleObj o = [o]

doblar :: [Objeto] -> [Objeto]
doblar [] = []
doblar (o : os) = dobleObj o ++ doblar os

excavar Cueva = Cueva
excavar (Habitacion os d1 d2) = Habitacion (doblar os) (excavar d1) (excavar d1)

-- a) Definir objs
-- b) Demostrar: objs . excavar = doblar . objs

-- 2) Dar la funcion losAntecesoresDe :: a -> Tree a -> [a] que describe la lista de antecesores del elemento dado
-- dentro del arbol dado suponiendo que el elemento existe en el arbol.

-- Ej: losAntecesoresDe 7 arbol = [1, 3]
data Tree a = EmptyT | NodeT a (Tree a) (Tree a)

arbol :: Tree Int
arbol =
  NodeT
    1
    ( NodeT
        2
        (NodeT 4 EmptyT EmptyT)
        (NodeT 5 EmptyT EmptyT)
    )
    ( NodeT
        3
        (NodeT 6 EmptyT EmptyT)
        ( NodeT
            7
            (NodeT 8 EmptyT EmptyT)
            (NodeT 9 EmptyT EmptyT)
        )
    )

esRaiz :: (Eq a) => a -> Tree a -> Bool
esRaiz _ (EmptyT) = False
esRaiz x (NodeT e _ _) = e == x

losAntecesoresDe :: (Eq a) => a -> Tree a -> [a]
losAntecesoresDe _ EmptyT = []
losAntecesoresDe x (NodeT e ti td) =
  if esRaiz x ti || esRaiz x td
    then [e]
    else
      if perteneceLaRaiz ti (losAntecesoresDe x ti) || perteneceLaRaiz td (losAntecesoresDe x td)
        then e : (losAntecesoresDe x ti ++ losAntecesoresDe x td)
        else (losAntecesoresDe x ti ++ losAntecesoresDe x td)

perteneceLaRaiz :: (Eq a) => Tree a -> [a] -> Bool
perteneceLaRaiz EmptyT _ = False
perteneceLaRaiz (NodeT x _ _) xs = x `elem` xs