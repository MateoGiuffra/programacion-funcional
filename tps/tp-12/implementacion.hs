-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi _ = 0


esCero :: ExpA -> Bool
esCero (Suma (Cte 0) _) = True
esCero (Suma _ (Cte 0)) = True
esCero (Cte 0) = True
esCero _ = False
-- auxs

-- tests
-- Casos Base (Constantes)
expCte1 :: ExpA
expCte1 = Cte 5

expCte2 :: ExpA
expCte2 = Cte 0

expCte3 :: ExpA
expCte3 = Cte (-10)

-- Operaciones Simples
expSumaSimple :: ExpA
expSumaSimple = Suma (Cte 0) (Cte 0)

expProdSimple :: ExpA
expProdSimple = Prod (Cte 4) (Cte 2)

-- Operaciones Combinadas (Árboles Pequeños)
expCombinada1 :: ExpA
expCombinada1 = Prod (Suma (Cte 5) (Cte 3)) (Cte 2)

expCombinada2 :: ExpA
expCombinada2 = Suma (Cte 5) (Prod (Cte 3) (Cte 2))

-- Casos Complejos y de Borde
expCompleja :: ExpA
expCompleja = Suma (Prod (Cte 2) (Cte 3)) (Prod (Cte 4) (Cte 5))

expNeutros :: ExpA
expNeutros = Prod (Suma (Cte 5) (Cte 0)) (Cte 1)

expAnidadaIzq :: ExpA
expAnidadaIzq = Suma (Suma (Suma (Cte 1) (Cte 2)) (Cte 3)) (Cte 4)
-- tests


data ExpA  = Cte Int 
            | Suma ExpA ExpA
            | Prod ExpA ExpA
    deriving (Show)

-- a.  Dar  el  tipo  y  definir  foldExpA,  que  expresa  el  esquema  de  recursión 
-- estructural para la estructura ExpA. 

foldExpA :: (Int -> b) -> (b -> b -> b) -> (b -> b -> b) -> ExpA -> b
foldExpA c s p (Cte n) = c n
foldExpA c s p (Suma n1 n2) = s (foldExpA c s p n1) (foldExpA c s p n2)
foldExpA c s p (Prod n1 n2) = p (foldExpA c s p n1) (foldExpA c s p n2)

-- b.  Resolver las siguientes funciones utilizando foldExpA: 
-- i.  que describe la cantidad de ceros explícitos en la expresión dada. 
cantidadDeCeros :: ExpA -> Int
cantidadDeCeros e = foldExpA (unoSi . (==0)) (+) (+) e
-- ii.
noTieneNegativosExplicitosExpA  ::  ExpA  ->  Bool
-- que describe si la expresión dada no tiene números negativos de manera explícita. 
noTieneNegativosExplicitosExpA e = foldExpA (<0) (&&) (&&) e
-- iii.
simplificarExpA'  ::  ExpA  ->  ExpA
-- que  describe  una  expresión con el mismo significado que la dada, pero que no tiene 
-- sumas del número 0 ni multiplicaciones por 1 o por 0. La resolución 
-- debe ser exclusivamente simbólica. 
simplificarExpA' e = foldExpA (Cte) ((simplificarSuma .) . Suma) ((simplificarProd .) . Prod) e


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
-- auxs


-- iv.  
evalExpA' :: ExpA -> Int
-- que describe el número que resulta de evaluar la cuenta representada por la expresión aritmética dada. 
evalExpA' e = foldExpA id (+) (*) e

-- -- v.
showExpA  ::  ExpA  ->  String
-- que  describe  el  string  sin espacios y con paréntesis correspondiente a la expresión dada. 
showExpA e = foldExpA show (\s1 s2 -> "(" ++ s1 ++ "+" ++ s2 ++ ") ") (\s1 s2 -> "(" ++ s1 ++ "*" ++ s2 ++ ")") e