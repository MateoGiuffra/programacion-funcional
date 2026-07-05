data BST23 a = 
            Cero    
        |   Dos Int Int (BST23 a) a (BST23 a)
        |   Tres Int Int (BST23 a) a (BST23 a) a (BST23 a)
        deriving Show
{-
Inv Rep:
* en t = Dos h n t1 x t2
    - h es la altura de t y n es el size de t
    - t1 y t2 tienen la misma altura
    - todos los elementos de t1 son < x
    - todos los elementos de t2 son > x
    - t1 y t2 cumplen este inv. representacion
* en t = Tres h n t1 x t2 y t3
    - h es la altura de t y n es el size de t
    - t1 t2 y t3 tienen la misma altura
    - todos los elementos de t1 son < x
    - todos los elementos de t2 son > x y < y
    - todos los elementos de t3 son > y
    - t1 t2 y t3 cumplen este inv. representacion
-}

-- dar el tipo de fold23 y rec23
fold23 :: b -> (Int -> Int -> b -> a -> b -> b) -> (Int -> Int -> b -> a -> b -> a -> b -> b) -> BST23 a -> b
fold23 c d t Cero = c
fold23 c d t (Dos n m t1 x t2) = d n m (fold23 c d t t1) x (fold23 c d t t2)
fold23 c d t (Tres n m t1 x t2 y t3) = t n m (fold23 c d t t1) x (fold23 c d t t2) y (fold23 c d t t3)

rec23 :: b -> (Int -> Int -> BST23 a -> b -> a -> BST23 a -> b -> b) -> (Int -> Int -> BST23 a -> b -> a -> BST23 a -> b -> a -> BST23 a -> b -> b) -> BST23 a -> b
rec23 c d t Cero = c
rec23 c d t (Dos n m t1 x t2) = d n m t1 (rec23 c d t t1) x t2 (rec23 c d t t2)
rec23 c d t (Tres n m t1 x t2 y t3) = t n m t1 (rec23 c d t t1) x t2 (rec23 c d t t2) y t3 (rec23 c d t t3)

-- definir las siguientes funciones sin usar recursion explicita
inOrder  :: BST23 a -> [a]
inOrder = fold23 [] (\n m r1 x r2 -> r1 ++ [x] ++ r2) (\n m r1 x r2 y r3 -> r1 ++ [x] ++ r2 ++ [y] ++ r3)


cantItem :: BST23 a -> Int -- sin usar inv. rep
cantItem = fold23 0 (\n m r1 x r2 -> 1 + r1 + r2) (\n m r1 x r2 y r3 -> 2 + r1 + r2 + r3)

altura   :: BST23 a -> Int -- sin usar inv. rep
altura = fold23 0 (\n m r1 x r2 -> 1 + (max r1 r2)) (\n m r1 x r2 y r3 -> 1 + (max r1 (max r2 r3)))

minElem  :: Eq a => Ord a => BST23 a -> a -- sin usar inv. rep
minElem = rec23 (error "El arbol es vacio") (\n m t1 r1 x t2 r2 -> mejorSegun [t1, t2] x r1 (<)) (\n m t1 r1 x t2 r2 y t3 r3 -> mejorSegun [t1, t2, t3] x r1 (<))
-- aca estoy usando la invariante

maxElem  :: Eq a => Ord a => BST23 a -> a -- sin usar inv. rep
maxElem = rec23 (error "El arbol es vacio") (\n m t1 r1 x t2 r2 -> mejorSegun [t1, t2] x r2 (>)) (\n m t1 r1 x t2 r2 y t3 r3 -> mejorSegun [t1, t2, t3] x r3 (>))
-- aca estoy usando la invariante

-- auxs
mejorSegun :: Eq a => Ord a => [BST23 a] -> a -> a -> (a -> a -> Bool) -> a
mejorSegun ts x r f = if sonCeros ts
                    then x
                    else if f x r
                        then x 
                        else r

esCero :: BST23 a -> Bool
esCero Cero = True
esCero _    = False

sonCeros :: [BST23 a] -> Bool
sonCeros xs = and xs esCero
-- auxs

-- (\n m t1 r1 x t2 r2 ->)
search :: Eq a => Ord a => a -> BST23 a -> a
search e = rec23 (error "El elemento no existe")
                    (\n m t1 r1 x t2 r2         -> if x == e 
                                                        then x 
                                                        else if e < x 
                                                            then r1
                                                            else r2)
                    (\n m t1 r1 x t2 r2 y t3 r3 -> if x == e 
                                                        then x 
                                                        else if e < x 
                                                            then r1 
                                                            else if e < y
                                                                then r2
                                                                else r3)
-- bonus
verificarMasDatos :: Eq a => Ord a => BST23 a -> (Bool, Int, Int, Maybe a, Maybe a)
-- que calcula una indicacion de que el arg cumple el inv. rep junto con la altura, el tamaño, el minimo y maxima elem del arg
verificarMasDatos Cero = (True, 0, 0, Nothing, Nothing)
verificarMasDatos b = let (h, n) = alturaYSize b in 
                            (h == altura b && n == cantItem b, h, n, Just (minElem b), Just (maxElem b)) 

alturaYSize ::  BST23 a -> (Int, Int)
alturaYSize (Dos n m t1 x t2) = (n, m) 
alturaYSize (Tres n m t1 x t2 y t3) = (n, m) 
alturaYSize _ = (0, 0)

-- bonus ++
insert :: Ord a => a -> BST23 a -> BST23 a
-- ayuda: usar y definir armar23DesdeDos armar23DesdeTres
