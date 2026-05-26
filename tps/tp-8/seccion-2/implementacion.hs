-- ej 1
data N = Z | S N
  deriving (Show)

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
prodN Z n = Z
prodN (S n1) n2 = addN (prodN n1 n2) n2

mult :: Int -> Int -> Int
-- tengo que sumar m, n veces
mult 0 m = 0
mult n m = mult (n - 1) m + m

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

-- INICIO de la implementacion del ejercicio 2 del tp 5
data DigBin = O | I
  deriving (Show)

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

-- FIN de la implementacion del ejercicio 2 del tp 5
type NBin = [DigBin]

-- deriving Show
evalNB :: NBin -> Int
-- que describe el número representado por el elemento dado.
evalNB [] = 0
evalNB (x : xs) = dbAsInt x + 2 * evalNB xs

-- ejemplo:
-- [I, O, I, O] = 5
--  1  0  4  0  = 5

normalizarNB :: NBin -> NBin
normalizarNB [] = []
normalizarNB (x : xs) =
  if hayCero xs
    then x : normalizarNB xs
    else normalizar x ++ normalizarNB xs

-- [I, O, O, O, O, O] -> [I]
-- [I, O, O, O, I, O] -> [I, O, O, O, I]
normalizar :: DigBin -> NBin
normalizar I = [I]
normalizar O = []

hayCero :: NBin -> Bool
hayCero [] = False
hayCero (x : xs) = esCero x || hayCero xs

esCero :: DigBin -> Bool
esCero O = True
esCero _ = False

succNB :: NBin -> NBin
-- que describe la representación binaria
-- normalizada  del resultado de sumarle uno al número representado
-- por el argumento. La resolución debe ser exclusivamente simbólica, y
-- no  debe  utilizar  normalizarNB.  Se  puede  suponer  como
-- precondición que el argumento está normalizado.
succNB bs = suma I bs

-- que  describe  la
-- representación  binaria  normalizada  de  la  suma  de  los  números
-- representados  por  los  argumentos.  La  resolución  debe  ser
-- exclusivamente simbólica (o sea, no usar ninguna forma de eval), y
-- no  debe  utilizar  normalizarNB.  Se  puede  suponer  como
-- precondición que los argumentos están normalizados

-- esta mal usada 'suma' aca
addNB :: NBin -> NBin -> NBin
addNB bs1 bs2 = addNBWithCarry bs1 bs2 O

addNBWithCarry :: NBin -> NBin -> DigBin -> NBin
addNBWithCarry [] bs carry = suma carry bs
addNBWithCarry bs [] carry = suma carry bs
addNBWithCarry (b1 : bs1) (b2 : bs2) carry =
  let [result, newCarry] = addTriple b1 b2 carry
   in result : addNBWithCarry bs1 bs2 newCarry

addTriple :: DigBin -> DigBin -> DigBin -> NBin
addTriple b1 b2 b3 = suma b1 (suma b2 [b3])

-- esta bien definida
suma :: DigBin -> NBin -> NBin
suma I [] = [I]
suma O [] = []
suma bin (b : bs) =
  if hayCarry bin b
    then O : suma bin bs
    else (I : bs)

hayCarry :: DigBin -> DigBin -> Bool
hayCarry I I = True
hayCarry _ _ = False

nb2n :: NBin -> N
-- que describe la representación unaria dada
-- por  el  tipo  N  correspondiente  al  número  representado  por  el
-- argumento.
-- nb2n bs = int2N (evalNB bs) -- la facil
nb2n [] = Z
nb2n (b : bs) = addN (db2n b) (prodN (S (S Z)) (nb2n bs))

-- evalNB :: NBin -> Int
-- -- que describe el número representado por el elemento dado.
-- evalNB [] = 0
-- evalNB (x : xs) = dbAsInt x + 2 * evalNB xs

db2n :: DigBin -> N
db2n O = Z
db2n I = S Z

n2db :: N -> DigBin
n2db Z = O
n2db (S Z) = I

n2nb :: N -> NBin
n2nb Z = []
-- n2nb n = int2db (mod (evalN n) 2) : n2nb (int2N (div (evalN n) 2)) -- parseando a int
n2nb n = n2db (modN n (S (S Z))) : n2nb (divN n (S (S Z)))

int2nb :: Int -> NBin
int2nb 0 = []
int2nb n = int2db (mod n 2) : int2nb (div n 2)

divN :: N -> N -> N
divN n1 n2 = divNaux n1 n2 Z

divNaux :: N -> N -> N -> N
divNaux _ Z _ = error "No se puede dividir por cero."
divNaux Z _ _ = Z
divNaux n1 n2 multiplicador =
  if evalN (prodN n2 (addN (S Z) multiplicador)) > evalN n1
    then multiplicador
    else divNaux n1 n2 (addN (S Z) multiplicador)

modN :: N -> N -> N
modN n1 n2 = subN n1 (prodN n2 (divN n1 n2))

subN :: N -> N -> N
subN n1 n2 = int2N (evalN n1 - evalN n2)

int2db :: Int -> DigBin
int2db 1 = I
int2db 0 = O
int2db _ = error "Los numeros permitidos son solo 1 y 0"

-- Divido al numero sucesivamente por 2 
-- hasta que el cociente sea 0.
-- El cociente se transforma en ese numero en cada vuelta

-- 5 -> [I, O, I]
{-
5 | 2
    1
  3 | 2
      1
    1 | 2
        0
      1

-}
-- [I, I]
-- +
-- [I, 0, I, I]
-- -----------
-- [0, 0, 0, I]

-- caso 2
-- [O, I, I]
-- +
-- [I, 0, I]
-- -----------
-- [0, 0, 0, I]

-- Variables de prueba
-- Para `N`
n0 :: N
n0 = Z

n1 :: N
n1 = S Z

n2 :: N
n2 = S (S Z)

n3 :: N
n3 = S (S (S Z))

-- Para `NU`
nu0 :: NU
nu0 = []

nu1 :: NU
nu1 = [()]

nu3 :: NU
nu3 = [(), (), ()]

-- Para `NBin`
nb0 :: NBin
nb0 = []

nb1 :: NBin
nb1 = [I] -- 1 (según tu representación)

nb2 :: NBin
nb2 = [I, O] -- 2

nb5 :: NBin
nb5 = [I, O, I] -- 5

-- Expresiones de prueba que usan las funciones definidas
test_evalN_n3 :: Int
test_evalN_n3 = evalN n3

test_addN_n2_n1 :: N
test_addN_n2_n1 = addN n2 n1

test_prodN_n2_n1 :: N
test_prodN_n2_n1 = prodN n2 n1

test_nu2n_nu3 :: N
test_nu2n_nu3 = nu2n nu3

test_n2nu_n2 :: NU
test_n2nu_n2 = n2nu n2

test_evalNB_nb5 :: Int
test_evalNB_nb5 = evalNB nb5