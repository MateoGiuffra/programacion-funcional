# Soluciones y rúbrica - 001 Torneo (fácil, énfasis demos)

Código verificado con GHC (compilado y ejemplos ejecutados). Los nombres coinciden con los stubs del enunciado (reescrituras con prima); el enunciado pide agregar la signatura de `foldTorneo`.

## Ej. 1 (20 pts, ~4 c/u)

```haskell
cantJugadores Libre         = 0                                   -- cantJugadores.1
cantJugadores (Jugador _ _) = 1                                   -- cantJugadores.2
cantJugadores (Cruce a b)   = cantJugadores a + cantJugadores b   -- cantJugadores.3

puntajeTotal Libre         = 0                                    -- puntajeTotal.1
puntajeTotal (Jugador _ p) = p                                    -- puntajeTotal.2
puntajeTotal (Cruce a b)   = puntajeTotal a + puntajeTotal b      -- puntajeTotal.3

nombres Libre         = []                                        -- nombres.1
nombres (Jugador n _) = [n]                                       -- nombres.2
nombres (Cruce a b)   = nombres a ++ nombres b                    -- nombres.3

puntajes Libre         = []                                       -- puntajes.1
puntajes (Jugador _ p) = [p]                                      -- puntajes.2
puntajes (Cruce a b)   = puntajes a ++ puntajes b                 -- puntajes.3

escalar _ Libre         = Libre                                   -- escalar.1
escalar k (Jugador n p) = Jugador n (k * p)                       -- escalar.2
escalar k (Cruce a b)   = Cruce (escalar k a) (escalar k b)       -- escalar.3
```

## Ej. 2 (10 pts)

```haskell
foldTorneo :: b -> (Nombre -> Int -> b) -> (b -> b -> b) -> Torneo -> b
foldTorneo l j c Libre         = l
foldTorneo l j c (Jugador n p) = j n p
foldTorneo l j c (Cruce a b)   = c (foldTorneo l j c a) (foldTorneo l j c b)
```
Tipo 4, implementación 6. Sin `rec`: ninguna función lo necesita.

## Ej. 3 (15 pts, 3 c/u)

```haskell
cantJugadores' = foldTorneo 0 (\_ _ -> 1) (+)
puntajeTotal'  = foldTorneo 0 (\_ p -> p) (+)
nombres'       = foldTorneo [] (\n _ -> [n]) (++)
puntajes'      = foldTorneo [] (\_ p -> [p]) (++)
escalar' k     = foldTorneo Libre (\n p -> Jugador n (k * p)) Cruce
```

## Ej. 4 (50 pts, ~15 c/u)

Ecuaciones de lista usadas: `length.1: length [] = 0`, `length.2: length (x:xs) = 1 + length xs`, `sum.1: sum [] = 0`, `sum.2: sum (x:xs) = x + sum xs`, `map.1`, `map.2`. De ellas: `length [x] = 1`, `sum [x] = x`, `map f [x] = [f x]`, `[] ++ ys = ys`.

### 4a) `¿ cantJugadores = length . nombres ?`

Por extensionalidad, sea `t` un Torneo cualquiera; se prueba `¿ cantJugadores t = (length . nombres) t ?`, o sea (def (.)) `¿ cantJugadores t = length (nombres t) ?`. Inducción estructural sobre `t`.

```
casoBase1) t = Libre
  TI: ¿ cantJugadores Libre = length (nombres Libre) ?
casoBase2) t = Jugador n p
  TI: ¿ cantJugadores (Jugador n p) = length (nombres (Jugador n p)) ?
casoInductivo) t = Cruce a b
  HI1: ¡ cantJugadores a = length (nombres a) !
  HI2: ¡ cantJugadores b = length (nombres b) !
  TI:  ¿ cantJugadores (Cruce a b) = length (nombres (Cruce a b)) ?

DEMO:
casoBase1)
  LI: cantJugadores Libre
    = 0                         -- cantJugadores.1
  LD: length (nombres Libre)
    = length []                 -- nombres.1
    = 0                         -- length.1
  VALE ESTE CASO

casoBase2)
  LI: cantJugadores (Jugador n p)
    = 1                         -- cantJugadores.2
  LD: length (nombres (Jugador n p))
    = length [n]                -- nombres.2
    = 1 + length []             -- length.2
    = 1 + 0                     -- length.1
    = 1                         -- aritmética
  VALE ESTE CASO

casoInductivo)
  LI: cantJugadores (Cruce a b)
    = cantJugadores a + cantJugadores b            -- cantJugadores.3
    = length (nombres a) + length (nombres b)      -- HI1, HI2
  LD: length (nombres (Cruce a b))
    = length (nombres a ++ nombres b)              -- nombres.3
    = length (nombres a) + length (nombres b)      -- LEN-APP
  VALE ESTE CASO
```
Rúbrica: extensionalidad y desplegar `(.)` 3; casos/HI/TI 4; cada caso 2.5 (justificaciones), cierre 0.5.

### 4b) `¿ puntajeTotal = sum . puntajes ?`
Igual que 4a con `SUM-APP`. Casos:
```
casoBase1)  LI: puntajeTotal Libre = 0 (puntajeTotal.1)
            LD: sum (puntajes Libre) = sum [] (puntajes.1) = 0 (sum.1)             VALE ESTE CASO
casoBase2)  LI: puntajeTotal (Jugador n p) = p (puntajeTotal.2)
            LD: sum (puntajes (Jugador n p)) = sum [p] (puntajes.2)
                = p + sum [] (sum.2) = p + 0 (sum.1) = p (aritmética)              VALE ESTE CASO
casoInductivo) HI1: ¡ puntajeTotal a = sum (puntajes a) !   HI2 idem b
            LI: puntajeTotal (Cruce a b) = puntajeTotal a + puntajeTotal b (puntajeTotal.3)
                = sum (puntajes a) + sum (puntajes b) (HI1, HI2)
            LD: sum (puntajes (Cruce a b)) = sum (puntajes a ++ puntajes b) (puntajes.3)
                = sum (puntajes a) + sum (puntajes b) (SUM-APP)                    VALE ESTE CASO
```

### 4c) `¿ puntajes (escalar k t) = map (k*) (puntajes t) ?`
Sin extensionalidad (k y t fijos). Inducción sobre `t`, `k` cualquiera fijo.
```
casoBase1) TI: ¿ puntajes (escalar k Libre) = map (k*) (puntajes Libre) ?
casoBase2) TI: ¿ puntajes (escalar k (Jugador n p)) = map (k*) (puntajes (Jugador n p)) ?
casoInductivo) HI1: ¡ puntajes (escalar k a) = map (k*) (puntajes a) !   HI2 idem b
            TI: ¿ puntajes (escalar k (Cruce a b)) = map (k*) (puntajes (Cruce a b)) ?

DEMO:
casoBase1)
  LI: puntajes (escalar k Libre) = puntajes Libre   -- escalar.1
    = []                                            -- puntajes.1
  LD: map (k*) (puntajes Libre) = map (k*) []       -- puntajes.1
    = []                                            -- map.1
  VALE ESTE CASO
casoBase2)
  LI: puntajes (escalar k (Jugador n p)) = puntajes (Jugador n (k*p))   -- escalar.2
    = [k*p]                                         -- puntajes.2
  LD: map (k*) (puntajes (Jugador n p)) = map (k*) [p]                  -- puntajes.2
    = [k*p]                                         -- map.2 y map.1 (map f [x] = [f x])
  VALE ESTE CASO
casoInductivo)
  LI: puntajes (escalar k (Cruce a b))
    = puntajes (Cruce (escalar k a) (escalar k b))                      -- escalar.3
    = puntajes (escalar k a) ++ puntajes (escalar k b)                  -- puntajes.3
    = map (k*) (puntajes a) ++ map (k*) (puntajes b)                    -- HI1, HI2
  LD: map (k*) (puntajes (Cruce a b))
    = map (k*) (puntajes a ++ puntajes b)                               -- puntajes.3
    = map (k*) (puntajes a) ++ map (k*) (puntajes b)                    -- MAP-APP
  VALE ESTE CASO
```

### Bonus
Casos: Libre (`0 = k*0`: `puntajeTotal (escalar k Libre) = puntajeTotal Libre = 0 = k*0`), Jugador (`puntajeTotal (Jugador n (k*p)) = k*p = k * puntajeTotal (Jugador n p)`), Cruce (`= puntajeTotal (escalar k a) + puntajeTotal (escalar k b) = k*pt a + k*pt b` por HI, y `k*(pt a + pt b)` por distributividad). 5 pts.

## Errores comunes
- Olvidar el caso `Libre` o contarlo como jugador.
- Hacer extensionalidad en 4c (no hace falta) o NO hacerla en 4a/4b y dejar `.` sin desplegar.
- Escribir una sola HI en el caso `Cruce` (hay dos posiciones recursivas).
- Justificar con "por definición" sin nombrar la ecuación (`nombres.3`); descuento chico.
- `length [n] = 1`: justificar con `length.2` y `length.1`, no omitirlo.

## Rúbrica (estimada, 100 pts + 5 bonus; aprobación estimada 60 con demos no en blanco)
Ej.1: 20 | Ej.2: 10 | Ej.3: 15 | Ej.4: 50 | Bonus: 5. Una demo con estructura HI/TI correcta pero un paso mal justificado conserva ~60 % de su puntaje.

## Nota de generación
Forma: árbol binario con hojas de datos y hoja vacía (aridad recursiva 2), inspirado en Spaceship/ThreeT, con dominio nuevo (no estaba en el catálogo). Validación: `.hs` compilado con GHC; ejemplos del enunciado ejecutados; las tres propiedades (y el bonus) verificadas sobre 4 valores; demos usan solo ecuaciones del enunciado y `LEN-APP`/`SUM-APP`/`MAP-APP`.
