-- Expresiones que representan predicados y operaciones entre los mismos 
data PredExp a = Pred (a -> Bool)
               | LOp LogicOp (PredExp a) (PredExp a)
               | Not (PredExp a)

data LogicOp = AND | OR


-- Expresiones que representan conjuntos y operaciones entre los mismos
data SetExp a = Empty
              | Unit a
              | Union (SetExp a) (SetExp a)


-- Auxiliares útiles:
liftB :: (Bool -> Bool) -> (a -> Bool) -> (a -> Bool)
liftB f p x = f (p x)

liftB2 :: (Bool -> Bool -> Bool) -> (a -> Bool) -> (a -> Bool) -> (a -> Bool)
liftB2 f p1 p2 x = f (p1 x) (p2 x)


-- Implementar con recursión explícita:
evalPE :: PredExp a -> a -> Bool 
evalPE (Pred f) x = f x
evalPE (LOp lo p1 p2) x = evalLO lo (evalPE p1 x) (evalPE p2 x)
evalPE (Not p) x = not (evalPE p x)

evalLO :: LogicOp -> Bool -> Bool -> Bool
evalLO AND = (&&) 
evalLO OR = (||) 

evalSE :: SetExp a -> a -> Bool 
evalSE (Empty)  x = False
evalSE (Unit x) x' = x == x'
evalSE (Union s1 s2) x = evalSE s1 x || evalSE s2 x

sExp2pExp:: SetExp a -> PredExp a
mapSE :: (a->b) -> SetExp a -> SetExp b
mapPE :: (a->b) -> PredExp b -> PredExp a


-- Definir e implementar:
-- foldPE y foldSE (junto a las versiones rec de ser necesario)

Definición de evalPE :: PredExp a -> (a -> Bool)

