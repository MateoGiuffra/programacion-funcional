-- ej 1
data N = Z | S N

evalN :: N -> Int
-- que describe el número representado por el elemento dado.
evalN Z = 0
evalN (S n) = 1 + evalN n

addN :: N -> N -> N
-- que describe la representación unaria de la
-- suma  de  los  números  representados  por  los  argumentos.  La
-- resolución  debe  ser  exclusivamente  simbólica
-- o sea SIN calcular cuáles son esos números.
addN Z n = n
addN (S n1) n2 = S (addN n1 n2)

prodN :: N -> N -> N
-- que describe la representación unaria del
-- producto  de  los  números  representados  por  los  argumentos.  La
-- resolución debe ser exclusivamente simbólica.
prodN n1 Z = Z
prodN Z n2 = Z
prodN n1 (S n2) = prodN (S n1) n2

int2N :: Int -> N
-- que describe la representación unaria del número dado usando el tipo N
int2N 0 = Z
int2N n = S (int2N (n - 1))

-- ej 2

type NU = [()]

data Unit = Unit

evalNU :: NU -> Int
evalNU [] = 0
evalNU (_ : xs) = 1 + evalNU xs

succNU :: NU -> NU
succNU xs = () : xs

-- o tambien => succNU xs = () : xs

addNU :: NU -> NU -> NU
addNU xs ys = xs ++ ys

nu2n :: NU -> N
nu2n xs = int2N (evalNU xs)

n2nu :: N -> NU
n2nu Z = []
n2nu (S n) = () : n2nu n

-- ej 3
type NBin = [DigBin]

-- implementacion del ejercicio 2 del tp 5
data DigBin = O | I

dbAsInt :: DigBin -> Int
--  que dado un símbolo que representa un
-- dígito binario lo transforma en su significado como número.
dbAsInt O = 0
dbAsInt I = 1

dbAsBool :: DigBin -> Bool
--  que dado un símbolo que representa un
-- dígito binario lo transforma en su significado como booleano.
dbAsBool x = dbAsInt x == 1

dbOfBool :: Bool -> DigBin
--  que dado un booleano lo transforma en el
-- símbolo que representa a ese booleano.
dbOfBool True = I
dbOfBool False = O

negDB :: DigBin -> DigBin
--  que dado un dígito binario lo transforma en el otro.
negDB O = I
negDB I = O
-- implementacion del ejercicio 2 del tp 5


evalNB :: NBin -> Int
evalNB []      = 0
evalNB (x: xs) = dbAsInt x + evalNB xs 
-- No creo que sea esta la definicion porque no cumple con la implentacion real de una cadena binaria a la inversa.
-- ejemplo:
-- [I, O, I, O] = 5
--  1  0  4  0  = 5