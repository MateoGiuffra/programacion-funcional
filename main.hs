double :: Int -> Int
double x = x + x

twice :: (a -> a) -> (a -> a)
twice f = g 
    where g x = f (f x)

-- suma x = \y -> x + y
suma x y = x + y

succ = suma 1

swap (x, y) = (y, x)
sumPar (x,y) = x + y


-- uflip f = g where g p = f (swap p)


uflip f = \p -> f (swap p)

-- appDup f x = f(x,x)
appDup f = g where g x = f (x, x)

first :: (a,b) -> a
first (a,b) = a