-- visualizer
import Data.List (product, intercalate, transpose)

printTable :: Table String String -> IO ()
printTable [] = putStrLn "(tabla vacía)"
printTable t@(firstRow:_) = do
    let fields    = map fst firstRow
    let rows      = foldT [] (\r acc -> map snd r : acc) t
    let allRows   = fields : rows
    let colWidths = map (maximum . map length) (transpose allRows)
    let pad w s   = s ++ replicate (w - length s) ' '
    let fmtRow cs = "│ " ++ intercalate " │ " (zipWith pad colWidths cs) ++ " │"
    let sep tl h m tr = tl ++ intercalate m (map (\w -> replicate (w+2) h) colWidths) ++ tr
    putStrLn $ sep "┌" '─' "┬" "┐"
    putStrLn $ fmtRow fields
    putStrLn $ sep "├" '─' "┼" "┤"
    mapM_ (putStrLn . fmtRow) rows
    putStrLn $ sep "└" '─' "┴" "┘"
-- visualizer


-- auxs functions
consSi :: (a -> Bool) -> a -> [a] -> [a]
consSi f x xs = if f x then x : xs else xs


-- def
type Record f v = [(f,v)]
type Table f v = [ Record f v ]

-- test vars 
personas :: Table String String
personas =
  [ [("nombre","Graciela"), ("apellido","H"), ("edad","42"), ("genero","F"), ("salario","120")]
  , [("nombre","Alonso"),   ("apellido","Ch"),("edad","35"), ("genero","M"), ("salario","250")]
  , [("nombre","Adela"),    ("apellido","G"), ("edad","39"), ("genero","F"), ("salario","130")]
  , [("nombre","Fer"),      ("apellido","R"), ("edad","22"), ("genero","X"), ("salario","100")]
  , [("nombre","Felipe"),   ("apellido","W"), ("edad","50"), ("genero","M"), ("salario","280")]
  ]
-- test vars

-- folds
foldT :: b -> (Record f v -> b -> b) -> Table f v -> b
foldT z f [] = z
foldT z f (r: rs) = f r (foldT z f rs)

foldR :: b -> ((f, v) -> b -> b) -> Record f v -> b
foldR z f [] = z
foldR z f (p: ps) = f p (foldR z f ps)

recR ::  b -> ((f, v) -> Record f v -> b -> b) -> Record f v -> b
recR z f [] = z
recR z f (p: ps) = f p (p:ps) (recR z f ps)


-- impl
--a
select :: (Record f v -> Bool) -> Table f v -> Table f v
select f = foldT [] (consSi f)

-- b
project :: (f -> Bool) -> Table f v -> Table f v
project f = foldT [] (\r rs -> filterRecords f r : rs)

filterRecords :: (f -> Bool) -> Record f v -> Record f v
filterRecords f = foldR [] (\p rs -> if f (fst p) then p: rs else rs)

-- c
conjunct :: (a -> Bool) -> (a -> Bool) -> a -> Bool
-- que describe el predicado que da True solo cuando los 
-- dos predicados dados lo hacen. 
conjunct f1 f2 x = f1 x && f2 x

crossWith :: (a -> b -> c) -> [a] -> [b] -> [c]
-- que describe el resultado de aplicar una funcion a cada
-- elemento del producto cartesiano de las dos listas dadas
crossWith f xs ys = foldr (\x rs -> map (f x) ys ++ rs) [] xs

product :: Table f v -> Table f v -> Table f v
-- que describe la lista de registros resultante del producto cartesiano
-- combinado de las dos listas de registros dadas. Es decir, la unión
-- de los campos en los registros del producto cartesiano. 
product t1 t2 = crossWith (++) t1 t2

similar :: Eq f => Eq v =>  Record f v -> Record f v
similar = foldR [] (\x rs -> if any (areSimilar x) rs then rs else x : rs)

areSimilar :: Eq f => Eq v => (f, v) -> (f, v) -> Bool
areSimilar (f1, v1) (f2, v2) = f1 == f2 && v1 == v2