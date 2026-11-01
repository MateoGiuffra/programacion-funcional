data BST23 a =   Cero 
                | Dos Int Int (BST23 a) a  (BST23 a) 
                | Tres Int Int (BST23 a) a  (BST23 a) a  (BST23 a)

{- Invariantes de representación:
   En (Dos h n b1 x b2):
     - h es la altura del árbol
     - n es la cantidad de elementos del árbol
     - b1 y b2 tienen la misma altura
     - todos los elementos de b1 son menores a x
     - todos los elementos de b2 son mayores a x
     - b1 y b2 cumplen los invariantes
   En (Tres h n b1 x b2 y b3):
     - h es la altura del árbol
     - n es la cantidad de elementos del árbol
     - b1, b2 y b3 tienen la misma altura
     - x < y
     - todos los elementos de b1 son menores a x
     - todos los elementos de b2 son mayores a x y menores a y
     - todos los elementos de b3 son mayores a y
     - b1, b2 y b3 cumplen los invariantes
-}

fold23 :: b -> (Int -> Int -> a -> b -> b -> b) -> (Int -> Int -> a -> a ->  b -> b -> b -> b) -> BST23 a -> b
fold23 c d t Cero                      = c
fold23 c d t (Dos h n b1 x b2)         = d h n x (fold23 c d t b1) (fold23 c d t b2) 
fold23 c d t (Tres h n b1 x b2 y b3)   = t h n x y (fold23 c d t b1) (fold23 c d t b2) (fold23 c d t b3)

req23 :: b -> 
    (Int -> Int -> a -> BST23 a -> b -> BST23 a -> b -> b) -> 
    (Int -> Int -> a -> a -> BST23 a -> b BST23 a -> b BST23 a -> b -> b) -> BST23 a -> b
req23 c d t Cero                      = c
req23 c d t (Dos h n b1 x b2)         = d h n x b1 (req23 c d t b1) b2 (req23 c d t b2) 
req23 c d t (Tres h n b1 x b2 y b3)   = t h n x y b1 (req23 c d t b1) b2 (req23 c d t b2) b3 (fold23 c d t b3)

_maybe :: (a -> a -> a) -> a -> Maybe a -> Maybe a 
_maybe _ x Nothing  = Just x
_maybe f x (Just y) = Just (f x y)

_maybes :: (a -> a -> a) -> Maybe a -> Maybe a -> Maybe a 
_maybes f (Just x) (Just y) = Just (f x y)
_maybes f Nothing y         = y
_maybes f x Nothing         = x
_maybes f _ _               = Nothing

_maybeS :: (a -> a -> a) -> a ->  Maybe a -> Maybe a -> Maybe a 
_maybeS f x my mz = _maybe f x (_maybes f my mz)

verificarMisDatos :: Ord a => BST23 a -> (Bool, Int, Int, Maybe a, Maybe a)
verificarMisDatos = fold23 (True, 0, 0, Nothing, Nothing)
                            (\h n x r1 r2 -> 
                                let (b1, h1, n1, mMin1, mMax1) = r1    
                                    (b2, h2, n2, mMin2, mMax2) = r2 
                                    h' = 1 + max h1 h2
                                    n' = 1 + n1 + n2
                                    mMin = _maybeS min x mMin1 mMin2
                                    mMax = _maybeS max x mMax1 mMax2 
                                    b = b1 && b2 
                                        && h == h' && h1 == h2
                                        && n == n' 
                                        && _maybeCompare x (>) mMax1 
                                        && _maybeCompare x (<) mMin2
                                in
                                    (b, h', n', mMin, mMax)
                            )                            
                            (\h n x y r1 r2 r3 -> 
                                let (b1, h1, n1, mMin1, mMax1) = r1    
                                    (b2, h2, n2, mMin2, mMax2) = r2 
                                    (b3, h3, n3, mMin3, mMax3) = r3 
                                    h' = 1 + max h1 (max h2 h3)
                                    n' = 2 + n1 + n2 + n3
                                    mMin = _maybes min (_maybeS min x mMin1 mMin2) mMin3
                                    mMax = _maybes max (_maybeS max y mMax1 mMax2) mMax3
                                    b = b1 && b2 && b3 
                                        && h == h' && h1 == h2 && h2 == h3
                                        && n == n' 
                                        && x < y
                                        && _maybeCompare x (>) mMax1
                                        && _maybeCompare x (<) mMin2
                                        && _maybeCompare y (>) mMax2
                                        && _maybeCompare y (<) mMin3
                                in
                                    (b, h', n', mMin, mMax)
                            )


_maybeCompare :: a -> (a -> a -> Bool) -> Maybe a -> Bool
_maybeCompare x f Nothing = True
_maybeCompare x f (Just y) = x `f` y

-- datos :: [Int] -> Int -> [Int] -> [Maybe a] -> [Maybe a] -> [Bool] -> Int -> Int -> (Bool, Int, Int, Maybe a, Maybe a)
-- datos (h:hs) cantElem xs (mMin: mMins) (mMax: mMaxs) bs oH oN = let h' = 1 + foldr max h hs
--                                                                 n' = cantElem + foldr (+) 0 xs
--                                                                 b = all id bs && oH == h' && all (==h) hs oN == n' in
--                                                                 (b, h',  n', foldr (_maybes min) mMin mMins, foldr (_maybes max) mMax mMax)
-- let (b, h', n', mMin, mMax) = datos [h1, h2] 1 [n1, n2] [Just x, mMin1, mMin2] [Just x, mMax1, mMax2] [b1, b2] h n in 
    
insert :: a -> BST23 a -> BST23 a
insert = flip req23 (\e -> Dos 1 1 Cero e Cero)
                (\h n x b1 r1 b2 r2 e -> 
                    case compare x e of
                        LT -> if sonCero [b1, b2]
                                then Dos 1 1 Cero e Cero
                                else r1 
                        EQ -> Dos h n b1 x b2
                        GT -> if sonCero [b1, b2]
                                then Dos 1 1 Cero e Cero
                                else r2 
                )                
                (\h n x y b1 r1 b2 r2 b3 r3 e -> 
                    case compare x e of
                        LT -> if sonCero [b1, b2, b3]
                                then Dos 1 1 Cero e Cero
                                else r1 
                        EQ -> Tres h n b1 x b2 y b3
                        GT -> case compare y e of
                                LT -> if sonCero [b1, b2, b3]
                                        then Dos 1 1 Cero e Cero
                                        else r2
                                EQ ->  Tres h n b1 x b2 y b3
                                GT -> if sonCero [b1, b2, b3]
                                        then Dos 1 1 Cero e Cero
                                        else r3
                )

sonCero :: [BST23 a] -> Bool
sonCero = all esCero

esCero :: BST23 -> Bool
esCero Cero = True
esCero _    = False