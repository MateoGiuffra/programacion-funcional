data ThreeT a = Leaf a | Branch a (ThreeT a) (ThreeT a) (ThreeT a)
    deriving Show

sizeTT :: ThreeT a -> Int
sizeTT (Leaf x)          = 0
sizeTT (Branch t1 t2 t3) = 1 + sizeTT t1 + sizeTT t2 + sizeTT t3

sumTT :: ThreeT Int -> ThreeT Int
sumTT (Leaf x)          = x
sumTT (Branch t1 t2 t3) = sumTT t1 + sumTT t2 + sumTT t3

leavesTT :: ThreeT a -> [a]
leavesTT (Leaf x)          = [a]
leavesTT (Branch t1 t2 t3) = leavesTT t1 ++ leavesTT t2 ++ leavesTT t3

mapTT :: (a -> b) -> ThreeT a -> ThreeT b
mapTT f (Leaf x)          = (Leaf (f x))
mapTT f (Branch t1 t2 t3) = (Branch (mapTT t1) (mapTT t1) (mapTT t1))

maxTT :: Ord a => ThreeT a ->  a 
maxTT (Leaf x)          = a
maxTT (Branch t1 t2 t3) = maxTriple (maxTT t1) (maxTT t2) (maxTT t3)

maxTriple :: a -> a -> a -> a
maxTriple x y z = max x (max y z)

findTT :: Eq a => (a -> Bool) -> ThreeT (a,b) -> Maybe b
findTT f (Leaf (x, y))     = if f x then Just b else Nothing
findTT f (Branch t1 t2 t3) = findByJust (findTT f t1) (findTT f t2) (findTT f t3)

findByJust :: Maybe a -> Maybe a -> Maybe a -> Maybe a
findByJust x y z = if isJust x
                    then x
                    else if isJust y
                        then y
                        else z

isJust :: Maybe b -> Bool
isJust (Just _) = True
isJust _        = False

levelNTT :: Int -> ThreeT a -> [a]
levelNTT n (Leaf x)          = if n == 0 then [x] else []
levelNTT n (Branch t1 t2 t3) = levelNTT t1 ++ levelNTT t2 ++ levelNTT t3

listPerLevelTT :: ThreeT a -> [[a]]
listPerLevelTT (Leaf x)          = []
listPerLevelTT (Branch t1 t2 t3) = joinLevels (listPerLevelTT t1) (listPerLevelTT t2) (listPerLevelTT t3)  

joinLevels :: [[a]] -> [[a]] -> [[a]] -> [[a]]
joinLevels [] [] []                = [[]]
joinLevels [] (y: ys) (z: zs)      = y ++ z : joinLevels [] ys zs 
joinLevels (x: xs) [] (z: zs)      = x ++ z : joinLevels xs [] zs 
joinLevels (x: xs) (y: ys) []      = x ++ y : joinLevels xs ys [] 
joinLevels (x: xs) (y: ys) (z: zs) = x ++ y ++ z : joinLevels xs ys zs 

-- 2 
foldTT :: (a -> b) -> (b -> b -> b -> b) -> ThreeT a -> b
foldTT l b (Leaf x)          = l x
foldTT l b (Branch t1 t2 t3) = b (foldTT t1 l b)
                                 (foldTT t2 l b)
                                 (foldTT t3 l b)
-- 3
sizeTT' = foldTT (\_ -> 0) (\r1 r2 r3 -> r1 + r2 + r3)
sumTT' = foldTT id (\r1 r2 r3 -> r1 + r2 + r3)
leavesTT' = foldTT (\x -> [x]) (\r1 r2 r3 -> r1 ++ r2 ++ r3)
mapTT' f = foldTT (\x -> (Leaf (f x))) (\r1 r2 r3 -> Branch r1 r2 r3)
maxTT' = foldTT id (\r1 r2 r3 -> maxTriple r1 r2 r3)
findTT' f = foldTT (\x -> if f x then Just x else Nothing)
                   (\r1 r2 r3 -> findByJust r1 r2 r3)
levelNTT' n = foldTT (\x -> if n == 0 then [x] else [])
                     (\r1 r2 r3 -> r1 ++ r2 ++ r3)
listPerLevelTT' = foldTT (\_ -> []) joinLevels

-- 4
{-
sizeTT = sumTT . mapTT (const 1)
Prop.: ¿sizeTT t = (sumTT . mapTT) (const 1) t? 
Dem.: por ppio de induccion estructural sobre la estructura de t, se demuestr que:
Sea t :: ThreeT a

CB.
    t = (Leaf x)
    ¿sizeTT (Leaf x) = (sumTT . mapTT) (const 1) (Leaf x)? 

CI.
    HI) ¡sizeTT t = (sumTT . mapTT) (const 1) t!
    TI) ¿sizeTT (Branch t1 t2 t3) = (sumTT . mapTT) (const 1) (Branch t1 t2 t3)?

Caso base:
    Lado izq:
            sizeTT (Leaf x)
        =                   def sizeTT
            0
    Lado der:
            (sumTT . mapTT) (const 1) (Leaf x)
        =                                       def compose, f <- sumTT, g <- mapTT, x <- (const 1)
            sumTT (mapTT (const 1)) (Leaf x)
        =                                       def mapTT, f <- const 1, t <- Leaf x
            sumTT (Leaf (const 1 x)) (Leaf x)
        =                                       def const, x <- 1, y <- x
            sumTT (Leaf 1)
        =                                       def sum TT
            1

-}
