double :: Int -> Int
double x = x + x

twice :: (a -> a) -> (a -> a)
twice f = g 
    where g x = f (f x)
