-- ################### import ExpA #######################
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

-- ################### import ExpA #######################

data EA = Const Int | BOp BinOp EA EA
  deriving (Show)

data BinOp = Sum | Mul
  deriving (Show)

-- i
evalEA :: EA -> Int
evalEA (Const n) = n
evalEA (BOp Sum e1 e2) = evalEA e1 + evalEA e2
evalEA (BOp Mul e1 e2) = evalEA e1 * evalEA e2

-- ii
ea2ExpA :: EA -> ExpA
-- que describe una expresión aritmética
-- representada con el tipo ExpA, cuya estructura y significado son los
-- mismos que la dada.
ea2ExpA (Const n) = (Cte n)
ea2ExpA (BOp Sum e1 e2) = (Suma (ea2ExpA e1) (ea2ExpA e2))
ea2ExpA (BOp Mul e1 e2) = (Prod (ea2ExpA e1) (ea2ExpA e2))

-- iii
expA2ea :: ExpA -> EA
-- que describe una expresión aritmética representada
-- con el tipo EA, cuya estructura y significado son
-- los mismos que la dada
expA2ea (Cte n) = (Const n)
expA2ea (Suma a1 a2) = (BOp Sum (expA2ea a1) (expA2ea a2))
expA2ea (Prod a1 a2) = (BOp Mul (expA2ea a1) (expA2ea a2))
