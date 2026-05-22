data Gusto = Chocolate | DulceDeLeche | Frutilla | Sambayon
  deriving (Show)

data Helado
  = Vasito Gusto
  | Cucurucho Gusto Gusto
  | Pote Gusto Gusto Gusto
  deriving (Show)

data Shape = Circle Float | Rect Float Float

data Par a = DosCosas a a

data AVeces a = Nada | AcaEsta a

esVasito :: Helado -> Bool
esVasito (Vasito _) = True
esVasito _ = False

cuadrado n = Rect n n

shapeNormal c = c 1.0

-- chocoHelate :: (Gusto -> a) -> a
chocoHelate c = c Chocolate

-- string2gusto :: String -> Gusto
string2gusto "DulceDeLeche" = DulceDeLeche
string2gusto "Chocolate" = Chocolate
string2gusto "Frutilla" = Frutilla

-- armarHeladoCon :: (String -> Gusto) -> Helado
armarHeladoCon sg = Vasito (sg "Chocolate")

-- ### 1. Dar el tipo de:
cuadrado :: Float -> Shape
shapeNormal :: (Float -> a) -> a
chocoHelate :: (Gusto -> a) -> a
string2gusto :: String -> Gusto
armarHeladoCon :: (String -> Gusto) -> Helado
{-
-- ### 2. Dar el tipo y reducir:
shapeNormal Circle :: Shape
shapeNormal cuadrado :: Shape
shapeNormal Rect :: Float -> Shape
shapeNormal Rect 2 :: Shape
shapeNormal (Rect 2) :: Shape
Rect 2 :: Float -> Shape
chocoHelate Vasito :: Helado
chocoHelate Cucurucho :: Gusto -> Healdo
chocoHelate Cucurucho Sambayon :: Helado
chocoHelate (Cucurucho Sambayon) :: Helado

chocoHelate (flip Cucurucho Sambayon) :: Helado

    chocoHelate (flip Cucurucho Sambayon)
por def chocoHelate, c <- (flip Cucurucho Sambayon)
    flip Cucurucho Sambayon Chocolate
->flip, f <- Cucurucho
    Cucurucho y x
->flip, x <- Sambayon
    Cucurucho y Sambayon
->flip, y <- Chocolate
    Cucurucho Chocolate Sambayon

  chocoHelate (\g     Cucurucho g Sambayon) :: Helado
->chocoHelate, c <- (\g -> Cucurucho g Sambayon)
  (\g -> Cucurucho g Sambayon) Chocolate
-> red beta, g <- Chocolate
  Cucurucho Chocolate Sambayon

  chocoHelate (chocoHelate Cucurucho) :: Helado
-> chocoHelate, c <- (chocoHelate Cucurucho)
  (chocoHelate Cucurucho) Chocolate
-> chocoHelate, c <- Cucurucho
  Cucurucho Chocolate Chocolate

  chocoHelate Pote :: Gusto -> Gusto -> Helado
-> chocoHelate, c <- Pote
  Pote Chocolate

  chocoHelate Pote DulceDeLeche :: Gusto -> Helado
-> chocoHelate, c <- Pote
  Pote Chocolate DulceDeLeche

  armarHeladoCon string2gusto :: Helado
-> armarHeladoCon, sg <- string2gusto
  Vasito (string2gusto "Chocolate")

  armarHeladoCon error :: Helado
-> armarHeladoCon, sg <- error
  Vasito (error "Chocolate")

  esVasito (armarHeladoCon error) :: Bool
-> (armarHeladoCon error), sg <- error
  esVasito Vasito (error "Chocolate")
-> esVasito Vasito (error "Chocolate")
  True

-}

{-
### 3. Dar algunos elementos de los siguientes tipos:
a) `Par Bool`
 - DosCosas True
 - DosCosas False
b) `Par Helado`
 - DosCosas (Pote Chocolate)
c) `Par (Gusto -> Helado)`
 - DosCosas (Cucurucho Chocolate)
 - DosCosas (Pote Chocolate Chocolate)
-}

-- ### 4. Dar el tipo de:
-- DosCosas (Cucurucho DDL) :: Par (Gusto -> Helado)

esCuadrado :: Shape -> Bool
esCuadrado (Circle _) = False
esCuadrado (Rect n m) = n == m

armaCuadradoAlRecibir :: Float -> (Float -> Shape) -> Bool
armaCuadradoAlRecibir n f = esCuadrado (f n)

armaCuadradoDeTamañoCuandoReciba :: Float -> Float -> (Float -> Shape) -> Bool
armaCuadradoDeTamañoCuandoReciba n m f =
  let shape = f m
   in esCuadrado shape && esShapeDelMismoTamaño n shape

-- funcion aux
esShapeDelMismoTamaño :: Float -> Shape -> Bool
esShapeDelMismoTamaño n (Circle x) = n == x
esShapeDelMismoTamaño n (Rect x y) = n == x && n == y

siempreArmaCuadrado :: (Float -> Float -> Shape) -> Float -> Float -> Bool
siempreArmaCuadrado f x y =
  let shape = f x y
   in esCuadrado shape

-- 5) d)
siempreArmaCuadrado_ :: (Float -> Shape) -> Bool
siempreArmaCuadrado_ f = esCuadrado (f 1.0)

-- Verifica si la función dada arma un cuadrado de cualquier tamaño cuando recibe cualquier otro número

-- Para comprender si está está función hace lo esperado aplicar la función definida a:
-- cuadrado
-- Rect 2
-- shapeNormal Rect
-- \n -> if n < 10
-- Then cuadrado (n-1)
-- Else Circle n
