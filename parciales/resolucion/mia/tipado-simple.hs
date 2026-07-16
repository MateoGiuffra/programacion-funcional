data TType = Number | Boolean | Text

type Variable = String

data Exp
  = LNum Int -- Literal numérico
  | LText String -- Literal de texto
  | Var Variable -- Variable de tipo texto
  | AritOp (Int -> Int -> Int) Exp Exp -- Operaciones aritméticas sobre números
  | RelOp (Int -> Int -> Bool) Exp Exp -- Operaciones relacionales sobre números
  | TextAritOp (String -> String) Exp -- Operaciones texto a texto
  | TextNumOp (String -> Int) Exp -- Operaciones texto a número

data Value = VInt Int | VBool Bool | VText String | TypeError

data Cmd
  = Skip -- statement que no hace nada
  | StoreInput Variable String -- recuerda texto literal en la variable dada
  | PrintVar Variable -- imprime el valor de una variable
  | Seq Cmd Cmd -- secuencia de comandos
  | If Exp Cmd Cmd -- alternativa entre dos comandos

data State = S (Variable -> String) [String]

--           memoria de variables stdout

-- INV_REP: La memoria de variables es una función total

baseEnv = const ""

envXHola = \s -> if s == "x" then "Hola" else ""

test = S baseEnv []
baseState = S baseEnv []

-- ej = TextAritOp upperCase (TextNumOp length (baseEnv (Var "pepe"))) ->  TypeError
-- ej = TextAritOp upperCase (TextAritOp lowerCase (Var "pepe")) -> VText String
-- ej = TextAritOp upperCase (int)
{-
template :: Exp -> (Variable -> String) -> Value
template (LNum n)            = 
template (LText s)           = 
template (Var v)             = 
template (AritOp fi e1 e2)   = (template e1) (template e2)
template (RelOp fib e1 e2)   = (template e1) (template e2)
template (TextAritOp fs e)   = (template e)
template (TextNumOp fsi e)   = (template e)

evalExp ej baseEnv
evalExp (TextAritOp fs e) f = ..
evalExp (Var v)           f = VText (f v)
(tvalue . flip evalExp env)
AritOp (+) (LNum 1) (LNum 1)
-}
typecheck :: Exp -> Maybe TType
typecheck (LNum n) = Just Number
typecheck (LText s) = Just Text
typecheck (Var v) = Just Text
typecheck (AritOp fi e1 e2) = typecheckAritOp (typecheck e1) (typecheck e2)
typecheck (RelOp fib e1 e2) = typecheckRelOp (typecheck e1) (typecheck e2)
typecheck (TextAritOp fs e) = typecheckTextAritOp (typecheck e)
typecheck (TextNumOp fsi e) = typecheckTextNumOp (typecheck e)

typecheckAritOp :: Maybe TType -> Maybe TType -> Maybe TType
typecheckAritOp (Just Number) (Just Number) = Just Number
typecheckAritOp _             _             = Nothing

typecheckRelOp :: Maybe TType -> Maybe TType -> Maybe TType
typecheckRelOp (Just Number) (Just Number) = Just Boolean
typecheckRelOp _             _             = Nothing

typecheckTextAritOp :: Maybe TType -> Maybe TType
typecheckTextAritOp (Just Text) = Just Text
typecheckTextAritOp _           = Nothing

typecheckTextNumOp :: Maybe TType -> Maybe TType
typecheckTextNumOp (Just Text) = Just Number
typecheckTextNumOp _           = Nothing

-- data Value = VInt Int | VBool Bool | VText String | TypeError
evalExp :: Exp -> (Variable -> String) -> Value
evalExp (LNum n) f          = VInt n
evalExp (LText s) f         = VText s
evalExp (Var v) f           = VText (f v)
evalExp (AritOp fi e1 e2) f = evalAritOp (evalExp e1 f) (evalExp e2 f) fi
evalExp (RelOp fib e1 e2) f = evalRelOp (evalExp e1 f) (evalExp e2 f) fib
evalExp (TextAritOp fs e) f = evalTextAritOp (evalExp e f) fs
evalExp (TextNumOp fsi e) f = evalNumOp (evalExp e f) fsi

evalAritOp :: Value -> Value -> (Int -> Int -> Int) -> Value
evalAritOp (VInt n) (VInt m) f = VInt (f n m)
evalAritOp _    _            f = TypeError

evalRelOp :: Value -> Value -> (Int -> Int -> Bool) -> Value
evalRelOp (VInt n) (VInt m) f = VBool (f n m)
evalRelOp _    _            f = TypeError

evalTextAritOp :: Value -> (String -> String) -> Value
evalTextAritOp (VText s) f = VText (f s)
evalTextAritOp _         f = TypeError

evalNumOp :: Value -> (String -> Int) -> Value
evalNumOp (VText s) f = VInt (f s)
evalNumOp _         f = TypeError

--  typecheck = tvalue . flip evalExp env
tvalue :: Value -> Maybe TType 
tvalue (VInt _)  = Just Number 
tvalue (VBool _) = Just Boolean 
tvalue (VText _) = Just Text 
tvalue TypeError = Nothing

-- Sea env :: Variable -> String una función cualquiera, fija y arbitraria (dado por el "para todo env" del enunciado).
-- Por principio de extensionalidad, siendo exp una Exp cualquiera, quiero demostrar que:
-- ¿ para toda exp. typecheck exp = (tvalue . flip evalExp env) exp ?

-- por def. de compose, es equivalente decir:
-- ¿ para toda exp. typecheck exp = tvalue (flip evalExp env exp) ?
-- por principio de induccion estructural sobre exp
-- planteo:
-- casoBase1) siendo n un número cualquiera. exp = LNum n
-- ¿ typecheck (LNum n) = tvalue (flip evalExp env (LNum n)) ?

-- casoBase2) siendo s una string cualquiera. exp = LText s
-- ¿ typecheck (LText s) = tvalue (flip evalExp env (LText s)) ?

-- casoBase3) siendo v una variable cualquiera. exp = Var v
-- ¿ typecheck (Var v) = tvalue (flip evalExp env (Var v)) ?

-- casoInductivo1) siendo fi :: (Int -> Int -> Int) cualquiera, e1, e2 unas expresiones cualquiera.
-- exp = AritOp fi e1 e2
-- HI1) ¡ typecheck e1 = tvalue (flip evalExp env e1) !
-- HI2) ¡ typecheck e2 = tvalue (flip evalExp env e2) !
-- TI) ¿ typecheck (AritOp fi e1 e2) = tvalue (flip evalExp env (AritOp fi e1 e2)) ?

-- casoInductivo2) siendo fib :: (Int -> Int -> Bool) cualquiera, e1, e2 unas expresiones cualquiera.
-- exp = RelOp fib e1 e2
-- HI1) ¡ typecheck e1 = tvalue (flip evalExp env e1) !
-- HI2) ¡ typecheck e2 = tvalue (flip evalExp env e2) !
-- TI) ¿ typecheck (RelOp fib e1 e2) = tvalue (flip evalExp env (RelOp fib e1 e2)) ?

-- casoInductivo3) siendo fs :: (String -> String) cualquiera, e una expresion cualquira.
-- exp = TextAritOp fs e
-- HI) ¡ typecheck e = tvalue (flip evalExp env e) !
-- TI) ¿ typecheck (TextAritOp fs e) = tvalue (flip evalExp env (TextAritOp fs e)) ?

-- casoInductivo4) siendo fsi :: (String -> Int) cualquiera, e una expresion cualquira.
-- exp = TextNumOp fsi e
-- HI) ¡ typecheck e = tvalue (flip evalExp env e) !
-- TI) ¿ typecheck (TextNumOp fsi e) = tvalue (flip evalExp env (TextNumOp fsi e)) ?


-- Demuestro:
-- casoBase3)
-- LI)
--     typecheck (Var v)
-- =                     typecheck.3
--     Just Text
-- LD)
--     tvalue (flip evalExp env (Var v))
-- =                                     flip
--     tvalue (evalExp (Var v) env)
-- =                                     evalExp.3
--     tvalue (VText (f v))
-- =                                     tvalue.3
--     Just Text
-- Para este caso vale.

-- casoInductivo2)
-- LI)
--     typecheck (RelOp fib e1 e2)
-- =                               typecheck.5
--     typecheckRelOp (typecheck e1) (typecheck e2)
-- =                               HI1 y HI2
--     typecheckRelOp (tvalue (evalExp e1 env)) (tvalue (evalExp e2 env))
-- =                               lema-typeRelOp
--     tvalue (evalRelOp (evalExp e1 env) (evalExp e2 env) fib) 

-- LD)
--     tvalue (flip evalExp env (RelOp fib e1 e2))
-- =                                               flip
--     tvalue (evalExp (RelOp fib e1 e2) env)
-- =                                               evalExp.5
--     tvalue (evalRelOp (evalExp e1 env) (evalExp e2 env) fib) 


-- Vale para este caso.


-- lema-typeRelOp
-- Sea v1 :: Value, v2 :: Value cualquiera, quiero ver que:
-- ¿ para todo v1, v2. typecheckRelOp (tvalue v1) (tvalue v2) = tvalue (evalRelOp v1 v2 fib) ? 
-- por analisis de casos sobre v1, v2
--     c1) siendo n, m unos números cualquiera. v1 = VInt n, v2 = VInt m
--       ¿ typecheckRelOp (tvalue (VInt n)) (tvalue (VInt m)) = tvalue (evalRelOp (VInt n) (VInt m) fib) ?
--     c2) v1 != VInt n ó v2 != VInt m
--       ¿ typecheckRelOp (tvalue v1) (tvalue v2) = tvalue (evalRelOp v1 v2 fib) ? 

-- c1)
-- LI)
--     typecheckRelOp (tvalue (VInt n)) (tvalue (VInt m))
-- =                                                     tvalue.1
--     typecheckRelOp (Just Number) (Just Number)
-- =                                                     typecheckRelOp.1
--     Just Boolean
-- LD)
--     tvalue (evalRelOp (VInt n) (VInt m) fib)
-- =                                                     evalRelOp.1
--     tvalue (VBool (fib n m))
-- =                                                     tvalue.2
--     Just Boolean
-- Vale para este caso.

-- c2)
-- LI)
--     typecheckRelOp (tvalue (VBool b1)) (tvalue (VBool b2))
-- =                                          tvalue.2
--     typecheckRelOp Nothing Nothing
-- =                                          typecheckRelOp.2
--     Nothing
-- LD)
--     tvalue (evalRelOp v1 v2 fib)
-- =                                          evalRelOp.2
--     tvalue (TypeError)
-- =                                          tvalue.4
--     Nothing
-- Vale para este caso.
-- La propiedad vale.


-- 4
foldExp :: (Int -> b) -> (String -> b) -> (Variable -> b) -> 
    ((Int -> Int -> Int) -> b -> b -> b) -> 
    ((Int -> Int -> Bool) -> b -> b -> b) -> 
    ((String -> String) -> b -> b) -> 
    ((String -> Int) -> b -> b) -> 
    Exp -> b
foldExp n t v a r ta tn (LNum x)            = n x
foldExp n t v a r ta tn (LText s)           = t s
foldExp n t v a r ta tn (Var var)           = v var
foldExp n t v a r ta tn (AritOp fi e1 e2)   = a fi (foldExp n t v a r ta tn e1) (foldExp n t v a r ta tn e2)
foldExp n t v a r ta tn (RelOp fib e1 e2)   = r fib (foldExp n t v a r ta tn e1) (foldExp n t v a r ta tn e2)
foldExp n t v a r ta tn (TextAritOp fs e)   = ta fs (foldExp n t v a r ta tn e)
foldExp n t v a r ta tn (TextNumOp fsi e)   = tn fsi (foldExp n t v a r ta tn e)

recExp :: (Int -> b) -> (String -> b) -> (Variable -> b) -> 
    ((Int -> Int -> Int) -> Exp -> b -> Exp -> b -> b) -> 
    ((Int -> Int -> Bool) -> Exp -> b -> Exp -> b -> b) -> 
    ((String -> String) -> Exp -> b -> b) -> 
    ((String -> Int) -> Exp -> b -> b) -> 
    Exp -> b
recExp n t v a r ta tn (LNum x)            = n x
recExp n t v a r ta tn (LText s)           = t s
recExp n t v a r ta tn (Var var)           = v var
recExp n t v a r ta tn (AritOp fi e1 e2)   = a fi  e1 (recExp n t v a r ta tn e1) e2 (recExp n t v a r ta tn e2)
recExp n t v a r ta tn (RelOp fib e1 e2)   = r fib e1 (recExp n t v a r ta tn e1) e2 (recExp n t v a r ta tn e2)
recExp n t v a r ta tn (TextAritOp fs e)   = ta fs  e (recExp n t v a r ta tn e)
recExp n t v a r ta tn (TextNumOp fsi e)   = tn fsi e (recExp n t v a r ta tn e)

-- 5
foldCmd :: b -> (Variable -> String -> b) -> (Variable -> b) -> (b -> b -> b) -> (Exp -> b -> b -> b) -> Cmd -> b
foldCmd s st pr sq i Skip                 = s
foldCmd s st pr sq i (StoreInput var str) = st var str 
foldCmd s st pr sq i (PrintVar var)       = pr var
foldCmd s st pr sq i (Seq c1 c2)          = sq (foldCmd s st pr sq i c1) (foldCmd s st pr sq i c2)
foldCmd s st pr sq i (If e c1 c2)         = i e (foldCmd s st pr sq i c1) (foldCmd s st pr sq i c2)

recCmd :: b -> (Variable -> String -> b) -> (Variable -> b) -> (Cmd -> b -> Cmd -> b -> b) -> (Exp -> Cmd -> b -> Cmd -> b -> b) -> Cmd -> b
recCmd s st pr sq i Skip                 = s
recCmd s st pr sq i (StoreInput var str) = st var str
recCmd s st pr sq i (PrintVar var)       = pr var
recCmd s st pr sq i (Seq c1 c2)          = sq c1 (recCmd s st pr sq i c1) c2 (recCmd s st pr sq i c2)
recCmd s st pr sq i (If e c1 c2)         = i e c1 (recCmd s st pr sq i c1) c2 (recCmd s st pr sq i c2)
              
-- explicita
simplifyCmd :: Cmd -> Cmd
simplifyCmd Skip                = Skip
simplifyCmd (StoreInput var s)  = StoreInput var s
simplifyCmd (PrintVar var)      = PrintVar var
simplifyCmd (Seq c1 c2)         = simplifySeq (simplifyCmd c1) (simplifyCmd c2)
simplifyCmd (If e c1 c2)        = simplifyIf e (simplifyCmd c1) (simplifyCmd c2)
-- explicita

simplifySeq :: Cmd -> Cmd -> Cmd
simplifySeq Skip c2 = c2
simplifySeq c1 Skip = c1
simplifySeq c1 c2   = Seq c1 c2

simplifyIf :: Exp -> Cmd -> Cmd -> Cmd
simplifyIf (RelOp fib (LNum n) (LNum m)) c1 c2 = if fib n m then c1 else c2
simplifyIf e c1 c2                             = If e c1 c2

-- implicita
simplifyCmd' :: Cmd -> Cmd
simplifyCmd' = foldCmd Skip StoreInput PrintVar simplifySeq simplifyIf
-- implicita