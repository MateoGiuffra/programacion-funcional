-- Ejercicio 1)  Definir las siguientes funciones utilizando recursión estructural explícita 
-- sobre Pizza: 

-- auxs
unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0
-- auxs


-- pizzas de testeo
pizzaVacia :: Pizza
pizzaVacia = Prepizza

pizzaSencilla :: Pizza
pizzaSencilla = Capa Queso (Capa Salsa Prepizza) -- salsa base, queso arriba

pizzaConJamonyAceitunas :: Pizza
pizzaConJamonyAceitunas = Capa (Aceitunas 5) (Capa Jamón (Capa Queso (Capa Salsa Prepizza)))

pizzaMultiQueso :: Pizza
pizzaMultiQueso = Capa Queso (Capa Queso (Capa Salsa Prepizza))

-- pizzaMultiQueso = Capa Salsa Prepizza)

pizzaAnchoas :: Pizza
pizzaAnchoas = Capa Anchoas (Capa Queso (Capa Salsa Prepizza))

pizzaSoloAceitunas :: Pizza
pizzaSoloAceitunas = Capa (Aceitunas 10) (Capa (Aceitunas 10) Prepizza)

-- alias de test conveniente
pizzaTest :: Pizza
pizzaTest = pizzaConJamonyAceitunas
-- pizzas de testeo


data Pizza = Prepizza | Capa Ingrediente Pizza
  deriving (Show)

data Ingrediente
  = Aceitunas Int
  | Anchoas
  | Cebolla
  | Jamón
  | Queso
  | Salsa
  deriving (Show)


-- a.
cantidadCapasQueCumplen :: (Ingrediente -> Bool) -> Pizza -> Int 
cantidadCapasQueCumplen f Prepizza   = 0
cantidadCapasQueCumplen f (Capa i p) = unoSi (f i) + cantidadCapasQueCumplen f p

-- b.
conCapasTransformadas :: (Ingrediente -> Ingrediente) -> Pizza -> Pizza 
conCapasTransformadas f Prepizza   = Prepizza
conCapasTransformadas f (Capa i p) = Capa (f i) (conCapasTransformadas f p)

-- c.
soloLasCapasQue :: (Ingrediente -> Bool) -> Pizza -> Pizza 
soloLasCapasQue f Prepizza = Prepizza
soloLasCapasQue f (Capa i p) = if f i 
                                then (Capa i (soloLasCapasQue f p))
                                else soloLasCapasQue f p


-- Ejercicio 2)  Definir  las  siguientes  funciones  utilizando  alguna  de  las  definiciones anteriores: 
-- a.

esQueso :: Ingrediente -> Bool
esQueso Queso = True
esQueso _     = False


sinLactosa :: Pizza -> Pizza 
sinLactosa p = soloLasCapasQue esQueso p

-- b.
aptaIntolerantesLactosa :: Pizza -> Bool 
aptaIntolerantesLactosa p = cantidadCapasQueCumplen esQueso p == 0
-- c.
cantidadDeQueso :: Pizza -> Int 
cantidadDeQueso p = cantidadCapasQueCumplen esQueso p
-- d.
conElDobleDeAceitunas :: Pizza -> Pizza
conElDobleDeAceitunas p = conCapasTransformadas 
                                (\i -> case i of
                                    (Aceitunas n) -> (Aceitunas (n * 2))
                                    x             -> x) p

-- Ejercicio 3)  Definir,  
-- que expresa la definición de fold para la estructura de Pizza.                                    
pizzaProcesada :: (Ingrediente -> b -> b) -> b -> Pizza -> b
pizzaProcesada f z Prepizza = z
pizzaProcesada f z (Capa i p) = f i (pizzaProcesada f z p)


-- Ejercicio 4)  
-- Resolver todas las funciones de los puntos 1) y 2) utilizando la función pizzaProcesada.
cantidadCapasQueCumplen' :: (Ingrediente -> Bool) -> Pizza -> Int 
cantidadCapasQueCumplen' f p = pizzaProcesada (\i rs -> unoSi (f i) + rs) 0 p


-- cantidadCapasQueCumplen' esQueso 0 (Capa Queso Prepizza)
-- -- def de cantidadCapasQueCumplen', f <- (\i -> unoSi (esQueso i) + rs), z <- 0, p <- (Capa Queso Prepizza)
-- (\i rs -> unoSi (esQueso i) + rs) Queso (pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) 0 Prepizza)
-- -- por beta red, i <- Queso, rs <- (pizzaProcesada esQueso 0 Prepizza)
-- (unoSi (esQueso Queso) + (pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) 0 Prepizza)) 
-- -- por def de esQueso
-- (unoSi True + (pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) + rs) 0 Prepizza)) 
-- -- def unoSi
-- (1 + (pizzaProcesada (\i rs -> unoSi (esQueso i) + rs) + rs) 0 Prepizza)
-- -- def pizzaProcesada, z <- 0
-- (1 + 0)
-- -- por arit
-- 1 
