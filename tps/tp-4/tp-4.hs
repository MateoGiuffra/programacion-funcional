
-- DEFINICIONES DEFINICIONES DEFINICIONES DEFINICIONES DEFINICIONES

suma x y = x + y

esVocal c = c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'

esMinuscula c = c >= 'a' && c <= 'z'


-- DEFINICIONES DEFINICIONES DEFINICIONES DEFINICIONES DEFINICIONES

-- Ejercicio 1) Determinar si las siguientes funciones son parciales o totales. Justificar.

-- a.
udiv (x, y) = div x y
-- Parcial, si y = 0 el resultado es bottom.

-- b.
udivE (x, 0) = error "No puedo dividir por 0"
udivE (x, y) = div x y
-- Parcial, si y = 0 el resultado es bottom.

-- c.
udivH = uncurry div
-- Parcial, ya que div es parcial.

-- d.
succ x = x + 1
-- Total, definida para todos los valores de su dominio.

-- e.
succH = suma 1
-- Total, definida para todos los valores de su dominio.

-- f.
porLaMitad = flip div 2
-- Total, definida para todos los valores de su dominio.

-- g.
conDieresis 'u' = 'ü'
-- Parcial, si recibe otro char != "u" el resultado es bottom.

-- h.
conDieresisB 'u' = 'ü'
conDieresisB c = conDieresisB c
-- Parcial: Por la misma razon que el punto g y ademas si el char = c es loop inifinito. Resultado bottom.

-- i.
conTildePM 'a' = 'á'
conTildePM 'e' = 'é'
conTildePM 'i' = 'í'
conTildePM 'o' = 'ó'
conTildePM 'u' = 'ú'
-- Parcial: Definida solo para las vocales, el resto de chars dan como resultado bottom.

-- j.
conTildeE c =
  if esVocal c
    then conTildePM c
    else error "El valor recibido no es vocal"
-- Parcial: Definida solo para las vocales, el resto de chars dan como resultado bottom de un error personalizado. 


-- k.
conTilde c =
  if esVocal c && esMinuscula c
    then conTildePM c
    else c
-- Total, definida para todos los valores de su dominio.

-- Ejercicio 2) Para cada una de las funciones del ejercicio anterior, determinar si una o más de las otras es equivalente a ella.
-- conTildeE <-> conTildePM
-- conDieresisB <-> conDieresisB <-> conDieresis
-- succH <-> succ
-- udivE <-> udivH <-> udivH (si lo usas correctamente)


-- Ejercicio 3) Dada la siguiente definición para la función ​twice​,
-- twice = \f -> \x -> f (f x)
-- determinar cuántos y cuáles son los redexes en las siguientes expresiones.
-- a. twice doble --> 1 (twice doble)
-- b. twice doble 2 --> 1 (twice doble)
-- c. twice --> 1 (\f -> \x -> f (f x))

-- Ejercicio 4) Dada la siguiente definición para la función ​twice​,
-- twice f = g
--   where g x = f (f x)
-- determinar cuántos y cuáles son los redexes en las siguientes expresiones.
-- a. twice doble --> 1 (twice doble)
-- b. twice doble 2 --> 1 (twice doble)
-- twice doble 2        -->  1 
-- g 2                  -->  1 
-- doble (doble 2)      -->  2  
-- doble 2 + doble 2    -->  2  
-- (2 + 2) + (2 + 2)    -->  2
-- 4 + 4                -->  1
-- 8
-- total 7 redex

-- c. twice --> 0: ya es un valor (una funcion) 

-- Ejercicio 5) Dada la siguiente definición para la función ​twice​,
-- twice f x = f (f x)
-- determinar cuántos y cuáles son los redexes en las siguientes expresiones.
-- a. twice doble --> 0 
-- b. 
-- twice doble 2 --> 1: (twice doble)
-- def de twice, f <- doble, x <- 2
-- doble (doble 2) ---> 2:  doble (doble 2), doble 2
-- def de doble, x <- doble 2
-- doble 2 + doble 2 --->  2: doble 2, doble 2
-- def de doble, x <- 2, x' <- 2
-- (2 + 2) + (2 + 2) ---> 2: (2 + 2) + (2 + 2)
-- por arit
-- 4 + 4 ---> 1: 4 + 4
-- por arit
-- 8  ---> 0
-- c. twice --> 0: ya es un valor (una funcion)


{- Ejercicio 6) Para cada tipo a continuación, intentar dar dos expresiones que denoten
valores diferentes. Las expresiones deben ser diferentes de bottom, y en el caso de
ser funciones, una debe ser total y otra debe ser parcial. De no ser posible hacer
alguno de los casos, explicar por qué.
a. a
x :: a
x = error "error"
x = undefined
x = head []
x = x

todas devuelven bottom, no se puede.

b. Int -> a

y :: Int -> a
y n = error "error por un int"

estoy en la misma, tampoco puedo devolver a sin que sea bottom.


c. a -> b
transform :: a -> b
transform x = error "esto si es de tipo a -> b, pero sigue siendo un error"

En conclusion no se puede pasar de un tipo fijo, o directamente devolver un tipo polimorfico si no es bottom.

-}