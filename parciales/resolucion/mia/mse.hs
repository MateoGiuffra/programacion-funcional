data MSExp a = EmptyMS | 
               AddMS a (MSExp a) | RemoveMS a (MSExp a) | 
               UnionMS (MSExp a) (MSExp a) | MapMS (a -> a) (MSExp a)
instance (Show a) => Show (MSExp a) where
    show EmptyMS         = "EmptyMS"
    show (AddMS x xs)    = "AddMS " ++ show x ++ " (" ++ show xs ++ ")"
    show (RemoveMS x xs) = "RemoveMS " ++ show x ++ " (" ++ show xs ++ ")"
    show (UnionMS xs ys) = "UnionMS (" ++ show xs ++ ") (" ++ show ys ++ ")"
    show (MapMS _ xs)    = "MapMS <function> (" ++ show xs ++ ")"
-- auxs
unoSi True  = 1
unoSi _     = 0
-- auxs

-- vars
fullset = RemoveMS 1 (AddMS 1 EmptyMS) 
fullset2 = AddMS 1 (RemoveMS 1 EmptyMS) 
fullset3 = AddMS 1 (RemoveMS 1 (MapMS (+1) EmptyMS)) 
-- vars

occursMSE :: Eq a => a -> MSExp a -> Int
occursMSE e EmptyMS           = 0
occursMSE e (AddMS a ms)      = unoSi (e == a) + occursMSE e ms
occursMSE e (UnionMS ms1 ms2) = occursMSE e ms1 + occursMSE e ms2
-- occursMSE e (MapMS f ms)      = unoSi (e == f a) occursMSE e ms
occursMSE e (RemoveMS a ms)   = let rs = occursMSE e ms in 
                                    if rs > 0 && e == a
                                        then rs - 1
                                        else rs
 