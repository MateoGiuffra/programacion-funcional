-- definiciones
curry :: ((a, b) -> c) -> a -> b -> c
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) = f x y

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)

flip :: (b -> a -> c) -> a -> b -> c
flip f x y = (f y) x

swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

-- definiciones

data Shape = Circle Float | Rect Float Float
  deriving (Show)

construyeShNormal :: (Float -> Shape) -> Shape
construyeShNormal c = c 1.0
-- uncurry Rect :: (Float, Float) -> Shape ✅
--  construyeShNormal (flip Rect 5.0) :: Shape ✅
-- por def de construyeShNormal, c <- (flip Rect 5.0)
-- (flip Rect 5.0) 1.0
-- por def de flip, f <- Rect, x <- 5.0, y <- 1.0
-- (Rect 1.0) 5.0
-- por lo tanto el tipo es Shape

-- compose (uncurry Rect) swap :: (Float, Float) -> Shape ✅
{-
justificacion:

###############1###############
uncurry         :: (a -> b -> c) -> (a, b) -> c
Rect            :: Float -> Float -> Shape
-------------------------------
(uncurry Rect)  :: ??

Float -> Float -> Shape
(a -> b -> c
 -----> a = Float
 -----> b = Float
 -----> c = Shape

uncurry         :: (Float -> Float -> Shape) -> (Float, Float) -> Shape
Rect            :: Float -> Float -> Shape
-------------------------------
(uncurry Rect)  :: (Float, Float) -> Shape
###############1###############

###############2###############
compose         :: (e -> f) -> (d -> e) -> d -> f
(uncurry Rect)  :: (Float, Float) -> Shape
-------------------------------
compose (uncurry Rect) :: ???

 -----> e = (Float, Float)
 -----> f = Shape

compose         :: ((Float, Float) -> Shape) -> (d -> (Float, Float)) -> d -> Shape
(uncurry Rect)  :: (Float, Float) -> Shape
-------------------------------
compose (uncurry Rect) :: (d -> (Float, Float)) -> d -> Shape
###############2###############

###############3###############
compose (uncurry Rect) :: (d -> (Float, Float)) -> d -> Shape
swap  :: (x, y) -> (y, x)
-------------------------------
compose (uncurry Rect) swap :: ??

(x, y) -> (y, x)
(d -> (Float, Float))

d = (x, y)
(y, x) = (Float, Float)
por lo tanto
y = Float
x = Float

d = (Float, Float)

compose (uncurry Rect) :: ((Float, Float) -> (Float, Float)) ->(Float, Float) -> Shape
swap  :: (x, y) -> (y, x)
-------------------------------
compose (uncurry Rect) swap :: (Float, Float) -> Shape

###############3###############

-}

-- uncurry Cucurucho ::  (Gusto, Gusto) -> Helado
-- uncurry Rect swap :: No tipa
{-
Rompe porque uncurry Rect espera una tupla y swap es una funcion
-}
-- compose uncurry Pote :: Gusto -> (Gusto, Gusto) -> Helado ✅
{-
###############1###############
compose :: (b -> c) -> (a -> b) -> a -> c
uncurry :: (d -> e -> f) -> (d, e) -> f
compose uncurry ::

(d -> e -> f) -> ((d, e) -> f)
(b -> c)

 -----> b = (d -> e -> f)
 -----> c = ((d, e) -> f)

compose :: ((d -> e -> f) -> ((d, e) -> f)) -> (a -> (d -> e -> f)) -> a -> ((d, e) -> f)

uncurry :: (d -> e -> f) -> (d, e) -> f
compose uncurry :: (a -> d -> e -> f) -> a -> (d, e) -> f

###############1###############

###############2###############
compose uncurry       :: (a -> d -> e -> f) -> a -> (d, e) -> f
Pote                  :: Gusto -> Gusto -> Gusto -> Helado
---------------------------------------------------------------
compose uncurry Pote  :: ??

Gusto -> Gusto -> Gusto -> Helado
(a    -> d    -> e      -> f)
 -----> a = Gusto
 -----> d = Gusto
 -----> e = Gusto
 -----> f = Helado

compose uncurry       :: (Gusto -> Gusto -> Gusto -> Helado) -> Gusto -> (Gusto, Gusto) -> Helado
Pote                  :: Gusto -> Gusto -> Gusto -> Helado
---------------------------------------------------------------
compose uncurry Pote  :: Gusto -> (Gusto, Gusto) -> Helado 

###############2###############
-}

-- compose Just :: (a -> b) -> a -> Maybe b  ✅
-- compose uncurry (Pote Chocolate) :: No tipa ✅
{-
###############1###############
compose           :: (b -> c) -> (a -> b) -> a -> c
uncurry           :: (d -> e -> f) -> (d, e) -> f
-------------------------------
compose uncurry   :: ???

(b -> c)
(d -> e -> f) -> ((d, e) -> f)

 --------> b = (d -> e -> f)
 --------> c = ((d, e) -> f)

compose           :: ((d -> e -> f) -> ((d, e) -> f)) -> (a -> (d -> e -> f)) -> a -> ((d, e) -> f)
uncurry           :: (d -> e -> f) -> (d, e) -> f
-------------------------------
compose uncurry   :: (a -> d -> e -> f) -> a -> (d, e) -> f
###############1###############

###############2###############
compose uncurry                   :: (a -> d -> e -> f) -> a -> (d, e) -> f
(Pote Chocolate)                  :: Gusto -> Gusto -> Helado
-------------------------------
compose uncurry (Pote Chocolate)  :: ???

(a -> d -> (e -> f))
Gusto -> Gusto -> Helado

a = Gusto
d = Gusto
e -> f = Helado

Helado es una expresion atomica, no una funcion. Por lo tanto, error de tipo.
###############2###############
-}
