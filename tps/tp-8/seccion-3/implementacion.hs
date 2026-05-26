data ExpA = Cte Int | Suma ExpA ExpA | Prod ExpA ExpA
  deriving (Show)

evalExpA :: ExpA -> Int
evalExpA (Cte n) = n
evalExpA (Suma a1 a2) = evalExpA a1 + evalExpA a2
evalExpA (Prod a1 a2) = evalExpA a1 * evalExpA a2

-- ii
simplificarExpA :: ExpA -> ExpA
simplificarExpA (Cte n) = (Cte n)
simplificarExpA (Suma a1 a2) = simplificarSuma (Suma (simplificarExpA a1) (simplificarExpA a2))
simplificarExpA (Prod a1 a2) = simplificarProd (Prod (simplificarExpA a1) (simplificarExpA a2))

-- auxs
simplificarSuma :: ExpA -> ExpA
simplificarSuma (Suma (Cte 0) a) = a
simplificarSuma (Suma a (Cte 0)) = a
simplificarSuma a = a

simplificarProd :: ExpA -> ExpA
simplificarProd (Prod (Cte 1) a) = a
simplificarProd (Prod a (Cte 1)) = a
simplificarProd (Prod _ (Cte 0)) = Cte 0
simplificarProd (Prod (Cte 0) _) = Cte 0
simplificarProd a = a

-- iii
cantidadDeSumaCero :: ExpA -> Int
cantidadDeSumaCero (Cte n) = 0
cantidadDeSumaCero (Suma a1 a2) = unoSi (esCero a1 || esCero a2) + cantidadDeSumaCero a1 + cantidadDeSumaCero a2
cantidadDeSumaCero (Prod a1 a2) = cantidadDeSumaCero a1 + cantidadDeSumaCero a2

-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0

esCero :: ExpA -> Bool
esCero (Suma (Cte 0) _) = True
esCero (Suma _ (Cte 0)) = True
esCero (Cte 0) = True
esCero _ = False

-- ej 2

-- ################################ import de N ################################
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

-- ################################ import de N ################################

data ExpS = CteS N | SumS ExpS ExpS | ProdS ExpS ExpS

-- i
evalES :: ExpS -> Int
evalES (CteS n) = evalN n
evalES (SumS e1 e2) = evalES e1 + evalES e2
evalES (ProdS e1 e2) = evalES e1 * evalES e2

-- ii
es2ExpA :: ExpS -> ExpA
es2ExpA (CteS n) = Cte (evalN n)
es2ExpA (SumS e1 e2) = Suma (es2ExpA e1) (es2ExpA e2)
es2ExpA (ProdS e1 e2) = Prod (es2ExpA e1) (es2ExpA e2)

-- iii
expA2es :: ExpA -> ExpS
expA2es (Cte n) = CteS (int2N n)
expA2es (Suma e1 e2) = SumS (expA2es e1) (expA2es e2)
expA2es (Prod e1 e2) = ProdS (expA2es e1) (expA2es e2)
