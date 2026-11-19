# Programación Funcional - Parcial de práctica - Torneo de eliminación - nivel fácil (énfasis demostraciones)

Libro abierto. Se pueden usar funciones y propiedades vistas en clase (`length`, `sum`, `map`, `(++)` y sus lemas) citando de dónde salen; todo lo demás se define o se demuestra. Puntaje sugerido (100): Ej.1 = 20, Ej.2 = 10, Ej.3 = 15, Ej.4 = 50, Bonus = 5.

## Base para copiar

Un torneo de eliminación se representa con el siguiente tipo, más dos ejemplos que se reutilizan en todo el enunciado.
```haskell
type Nombre = String

data Torneo = Libre                  -- lugar vacío (pasa de ronda sin jugar)
            | Jugador Nombre Int     -- un jugador y su puntaje
            | Cruce Torneo Torneo    -- dos torneos cuyos ganadores se enfrentan
            deriving (Show, Eq)

ej1 :: Torneo
ej1 = Cruce (Cruce (Jugador "Ana" 10) (Jugador "Beto" 7))
            (Cruce Libre (Jugador "Cami" 4))

ej2 :: Torneo
ej2 = Cruce (Jugador "Dani" 5) Libre
```

## Ejercicio 1 - Recursión explícita

Definir, por recursión estructural explícita (una ecuación por constructor):

1. `cantJugadores`, que describe la cantidad de jugadores (los `Libre` no cuentan).
   - `cantJugadores ej1 = 3`, `cantJugadores ej2 = 1`, `cantJugadores Libre = 0`

```haskell
cantJugadores :: Torneo -> Int
cantJugadores = undefined
```

2. `puntajeTotal`, que describe la suma de los puntajes de todos los jugadores.
   - `puntajeTotal ej1 = 21`, `puntajeTotal ej2 = 5`

```haskell
puntajeTotal :: Torneo -> Int
puntajeTotal = undefined
```

3. `nombres`, que describe los nombres de los jugadores de izquierda a derecha.
   - `nombres ej1 = ["Ana","Beto","Cami"]`, `nombres ej2 = ["Dani"]`

```haskell
nombres :: Torneo -> [Nombre]
nombres = undefined
```

4. `puntajes`, que describe los puntajes de los jugadores de izquierda a derecha.
   - `puntajes ej1 = [10,7,4]`

```haskell
puntajes :: Torneo -> [Int]
puntajes = undefined
```

5. `escalar`, que multiplica por `k` el puntaje de cada jugador, sin tocar nada más.
   - `puntajes (escalar 3 ej1) = [30,21,12]`, `nombres (escalar 3 ej1) = ["Ana","Beto","Cami"]`

```haskell
escalar :: Int -> Torneo -> Torneo
escalar = undefined
```

## Ejercicio 2 - Esquema de recursión

Dar el tipo y la definición de `foldTorneo`, el esquema de recursión estructural para `Torneo` (agregar la signatura).

```haskell
foldTorneo = undefined
```

## Ejercicio 3 - Reescritura

Redefinir las cinco funciones del Ejercicio 1 usando únicamente `foldTorneo` (sin recursión explícita).

```haskell
cantJugadores' :: Torneo -> Int
cantJugadores' = undefined

puntajeTotal' :: Torneo -> Int
puntajeTotal' = undefined

nombres' :: Torneo -> [Nombre]
nombres' = undefined

puntajes' :: Torneo -> [Int]
puntajes' = undefined

escalar' :: Int -> Torneo -> Torneo
escalar' = undefined
```

## Ejercicio 4 - Demostraciones

Demostrar por inducción estructural sobre `Torneo`, indicando casos, HI, TI y justificando cada paso. Para cada propiedad hay que probar todos los casos; las igualdades sobre listas pueden justificarse con los lemas de la biblioteca vistos en clase. Para 4a y 4b, empezar por el principio de extensionalidad.

**4a)**

```
-- 4a) por inducción estructural sobre Torneo
¿ cantJugadores = length . nombres ?
-- se puede usar:
-- LEN-APP: length (xs ++ ys) = length xs + length ys
```

**4b)**

```
-- 4b) por inducción estructural sobre Torneo
¿ puntajeTotal = sum . puntajes ?
-- se puede usar:
-- SUM-APP: sum (xs ++ ys) = sum xs + sum ys
```

**4c)** para todo `k :: Int` y todo `t :: Torneo`:

```
-- 4c) por inducción estructural sobre t (k fijo)
¿ puntajes (escalar k t) = map (k*) (puntajes t) ?
-- se puede usar:
-- MAP-APP: map f (xs ++ ys) = map f xs ++ map f ys
```

Plantilla de casos (completar):

```
casoBase1)
  TI: ¿ ... ?
casoBase2)
  TI: ¿ ... ?
casoInductivo)
  HI1: ¡ ... !
  HI2: ¡ ... !
  TI:  ¿ ... ?

DEMO:
casoBase1)
  LI: ...
  LD: ...
  VALE ESTE CASO
```

## Bonus (5 pts)

Usar solamente la ecuación de distributividad `k * (a + b) = k * a + k * b` de los enteros.

```
¿ puntajeTotal (escalar k t) = k * puntajeTotal t ?
```

## Pruebas

Pegar al final, una vez resueltos los ejercicios. Se ejecuta con `runghc` y cada línea indica el resultado esperado.

```haskell
main :: IO ()
main = do
  print (cantJugadores ej1)            -- 3
  print (cantJugadores ej2)            -- 1
  print (cantJugadores Libre)          -- 0
  print (puntajeTotal ej1)             -- 21
  print (puntajeTotal ej2)             -- 5
  print (nombres ej1)                  -- ["Ana","Beto","Cami"]
  print (nombres ej2)                  -- ["Dani"]
  print (puntajes ej1)                 -- [10,7,4]
  print (puntajes (escalar 3 ej1))     -- [30,21,12]
  print (nombres (escalar 3 ej1))      -- ["Ana","Beto","Cami"]
  print (escalar 2 ej2)                -- Cruce (Jugador "Dani" 10) Libre
  -- reescrituras = definiciones explícitas
  print (all (\t -> cantJugadores' t == cantJugadores t
                 && puntajeTotal' t == puntajeTotal t
                 && nombres' t == nombres t
                 && puntajes' t == puntajes t
                 && escalar' 3 t == escalar 3 t) [ej1, ej2, Libre])  -- True
```
