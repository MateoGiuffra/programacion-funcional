data Gusto = Chocolate | DulceDeLeche | Frutilla | Sambayon
  deriving (Show)

data Helado
  = Vasito Gusto
  | Cucurucho Gusto Gusto
  | Pote Gusto Gusto Gusto
  deriving (Show)

chocoHelate :: (Gusto -> a) -> a
chocoHelate consH = consH Chocolate

-- Vasito :: (Gusto -> Helado)
-- Chocolate :: Gusto
-- Cucurucho :: Gusto -> Gusto -> Helado
-- Sambayon :: Gusto
-- Pote :: Gusto -> Gusto -> Gusto -> Helado
-- chocoHelate :: (Gusto -> a) -> a
-- chocoHelate Vasito :: Helado
-- chocoHelate Cucurucho :: Gusto -> Helado
-- chocoHelate (Cucurucho Sambayon) :: Helado
-- chocoHelate (chocoHelate Cucurucho) :: Helado
-- chocoHelate (Vasito DulceDeLeche) :: Bottom
-- chocoHelate Pote :: Gusto -> Gusto -> Helado
-- chocoHelate (chocoHelate (Pote Frutilla)) :: Helado
{-
    justificacion
        -> chocoHelate (chocoHelate (Pote Frutilla))
        por def de chochoHelate, consH  <- chocoHelate (Pote Frutilla)
        -> chocoHelate (Pote Frutilla) Chocolate
        por def de chocoHelate, constH <- (Pote Frutilla) Chocolate
        -> (Pote Frutilla) Chocolate Chocolate
        por def de Pote, g1 <- Frutilla, g2 <- Chocolate, g3 <- Chocolate,
        por lo tanto, el tipo es Helado

    [DUDA]: Entiendo que (Pote Frutilla) Chocolate Chocolate es
    una expresion atomica en si. Pero me quedo un parentesis aca.
    Se que es equivalente a Pote Frutilla Chocolate Chocolate,
    pero si quisiera desglozarlo mas, como se que Pote Frutilla
    al final del dia es una funcion y como haskell funciona
    con currificacion, entonces Pote Frutilla
    devuelve una funcion que espera dos gustos cierto?
    Este paso habria que indicarlo?
-}

-- ej 2
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

-- ej 3
data DigDec = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | D8 | D9

ddAsInt :: DigDec -> Int
-- que dado un símbolo que representa un dígito decimal lo transforma en su significado como número.
ddAsInt D0 = 0
ddAsInt D1 = 1
ddAsInt D2 = 2
ddAsInt D3 = 3
ddAsInt D4 = 4
ddAsInt D5 = 5
ddAsInt D6 = 6
ddAsInt D7 = 7
ddAsInt D8 = 8
ddAsInt D9 = 9

ddOfInt :: Int -> DigDec
-- que dado un número entre 0 y 9 lo transforma en el símbolo que representa a ese dígito.
ddOfInt 0 = D0
ddOfInt 1 = D1
ddOfInt 2 = D2
ddOfInt 3 = D3
ddOfInt 4 = D4
ddOfInt 5 = D5
ddOfInt 6 = D6
ddOfInt 7 = D7
ddOfInt 8 = D8
ddOfInt 9 = D9
ddOfInt _ = error "Debe ser un numero entre 0 y 9"

nextDD :: DigDec -> DigDec
-- dado un dígito decimal lo transforma en el siguiente según el orden circular dado en la definición
nextDD D9 = D0
nextDD dd = ddOfInt (ddAsInt dd + 1)

prevDD :: DigDec -> DigDec
-- dado un dígito decimal lo transforma en el anterior según el orden circular dado en la definición
prevDD D0 = D9
prevDD dd = ddOfInt (ddAsInt dd - 1)

-- ej 4
data Medida = Mm Float | Cm Float | Inch Float | Foot Float
  deriving (Show)

asMm :: Medida -> Medida
asMm (Cm x) = Mm (x * 10)
asMm (Inch x) = Mm (x * 25.4)
asMm (Foot x) = Mm (x * 304.8)
asMm medida = medida

asCm :: Medida -> Medida
asCm (Mm x) = Cm (x * 0.1)
asCm (Inch x) = Cm (x * 2.54)
asCm (Foot x) = Cm (x * 30.48)
asCm medida = medida

asInch :: Medida -> Medida
asInch (Cm x) = Inch (x * 0.394)
asInch (Mm x) = Inch (x * 0.039)
asInch (Foot x) = Inch (x * 12)
asInch medida = medida

asFoot :: Medida -> Medida
asFoot (Cm x) = Foot (x * 0.033)
asFoot (Mm x) = Foot (x * 0.003)
asFoot (Inch x) = Foot (x * 0.083)
asFoot medida = medida

-- ej 5
-- definiciones
curry :: ((a, b) -> c) -> a -> b -> c
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) = f x y

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

-- definiciones

data Shape = Circle Float | Rect Float Float
  deriving (Show)

construyeShNormal :: (Float -> Shape) -> Shape
construyeShNormal c = c 1.0

-- uncurry Rect :: (Float, Float) -> Shape
--  construyeShNormal (flip Rect 5.0) :: Shape
-- por def de construyeShNormal, c <- (flip Rect 5.0)
-- (flip Rect 5.0) 1.0
-- por def de flip, f <- Rect, x <- 5.0, y <- 1.0
-- (Rect 1.0) 5.0
-- por lo tanto el tipo es Shape

-- compose (uncurry Rect) swap ::
{-
#################1#####################

uncurry :: (a -> b -> c) -> ((a, b) -> c)
Rect    :: Float -> Float -> Shape
------------------------------
uncurry Rect

(a -> b -> c)
Float -> Float -> Shape

 -----> a = Float
 -----> b = Float
 -----> c = Shape

uncurry :: (Float -> Float -> Shape) -> ((Float, Float) -> Shape)
Rect    :: Float -> Float -> Shape
----------------------------
uncurry Rect :: (Float, Float) -> Shape
#################1#####################

#################2#####################
compose :: (e -> f) -> (d -> e) -> d -> f
uncurry Rect :: (Float, Float) -> Shape
---------------------------
compose (uncurry Rect)

(e -> f)
(Float, Float) -> Shape

 ------> e = (Float, Float)
 ------> f = Shape


compose :: ((Float, Float) -> Shape) -> (d -> (Float, Float)) -> d -> Shape
uncurry Rect :: (Float, Float) -> Shape
---------------------------
compose (uncurry Rect) :: (d -> (Float, Float)) -> d -> Shape
#################2#####################


#################3#####################
compose (uncurry Rect) :: (d -> (Float, Float)) -> d -> Shape
swap :: (x, y) -> (y, x)
-------------------------------------------
compose (uncurry Rect) swap :: 

(d -> (Float, Float))
(x, y)

d = x
Float, Float = y


compose (uncurry Rect) :: (x -> y) -> x -> Shape
swap :: (x, y) -> (y, x)
-------------------------------------------
compose (uncurry Rect) swap :: 
#################3#####################






-}

-- uncurry Cucurucho ::
-- uncurry Rect swap ::
-- compose uncurry Pote ::
-- compose Just ::
-- compose uncurry (Pote Chocolate) ::