import Prelude hiding (all, any, concat, elem, length, product, reverse, sum, unzip, zip, (++))

--
length :: [a] -> Int
length [] = 0
length (_ : xs) = 1 + length xs

sum :: [Int] -> Int
sum [] = 0
sum (x : xs) = x + sum xs

product :: [Int] -> Int
product [] = 1
product (x : xs) = x * product xs

concat :: [[a]] -> [a]
concat [] = []
concat (xs : xss) = xs ++ concat xss

elem :: (Eq a) => a -> [a] -> Bool
elem _ [] = True
elem e (x : xs) = x == e && elem e xs

all :: (a -> Bool) -> [a] -> Bool
all f [] = True
all f (x : xs) = f x && all f xs

any :: (a -> Bool) -> [a] -> Bool
any f [] = False
any f (x : xs) = f x || any f xs

unoSiTrue :: Bool -> Int
unoSiTrue True = 1
unoSiTrue _ = 0

count :: (a -> Bool) -> [a] -> Int
count f [] = 0
count f (x : xs) = unoSiTrue (f x) + count f xs

subset :: (Eq a) => [a] -> [a] -> Bool
subset [] _ = True
subset (y : ys) xs = elem y xs && subset ys xs

(++) :: [a] -> [a] -> [a]
(++) [] xs = xs
(++) (y : ys) xs = y : (++) ys xs

reverse :: [a] -> [a]
reverse [] = []
reverse (x : xs) = reverse xs ++ [x]

zip :: [a] -> [b] -> [(a, b)]
zip [] _ = []
zip _ [] = []
zip (y : ys) (x : xs) = (y, x) : zip ys xs

unzip :: [(a, b)] -> ([a], [b])
unzip [] = ([], [])
unzip ((a, b) : xs) = addInListPair (unzip xs) a b

addInListPair :: ([a], [b]) -> a -> b -> ([a], [b])
addInListPair (xs, ys) x y = (x: xs, y: ys)