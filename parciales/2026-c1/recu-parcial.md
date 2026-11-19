# Programación Funcional - Recuperatorio 2026-c1 - Acueductos

> Reconstruido de memoria a partir de `recu-parcial.hs`. Las precisiones marcadas como *(precisión)* fueron agregadas para que el enunciado sea consistente y compile; los ejemplos están verificados con GHC.

Libro abierto. Se pueden usar funciones y propiedades vistas en clase citando su origen (`map`, `fmap`, `(++)`, `maybe`, etc.); lo demás se define o se demuestra.

## Base para copiar

Un acueducto se arma a partir de vertientes (manantiales), filtros, confluencias y divergencias. Como `Filtro` guarda una función, `Acueducto` no puede derivar `Show` ni `Eq`: se da una instancia `Show` manual (la función se muestra como `<fun>`). Para comparar acueductos en las pruebas usar `show`. Copiar este bloque primero; compila tal cual.

```haskell
type Caudal = Int   -- no hace falta preocuparse por los negativos

data Acueducto = Vertiente Caudal                           -- manantial: caudal fijo
               | Filtro (Caudal -> Bool) Acueducto          -- si el caudal que le llega no pasa el filtro, queda en 0
               | Confluencia Acueducto Acueducto            -- los caudales se suman
               | Divergencia Acueducto Acueducto Acueducto  -- los caudales se suman

-- Tramos para recorrer un acueducto
data Tramo = Recto    -- de un Filtro hacia el acueducto que filtra
           | Ramal1   -- primer operando de una Confluencia / Divergencia
           | Ramal2   -- segundo operando
           | Ramal3   -- tercer operando (solo Divergencia)
  deriving (Show, Eq)

instance Show Acueducto where
  show (Vertiente c)       = "Vertiente " ++ show c
  show (Filtro _ a)        = "Filtro <fun> (" ++ show a ++ ")"
  show (Confluencia a b)   = "Confluencia (" ++ show a ++ ") (" ++ show b ++ ")"
  show (Divergencia a b c) = "Divergencia (" ++ show a ++ ") (" ++ show b ++ ") (" ++ show c ++ ")"

ejAc :: Acueducto
ejAc = Confluencia
        (Filtro (\c -> c < 10)
            (Filtro (\c -> c >= 0)
                (Confluencia
                    (Vertiente 6)
                    (Filtro (\c -> c < 4)
                        (Confluencia (Vertiente 2) (Vertiente 100))))))
        (Confluencia (Vertiente 5) (Vertiente 10))

ejSeco :: Acueducto
ejSeco = Filtro (> 50) (Vertiente 3)
```

El caudal que entrega un acueducto es: `Vertiente c` entrega `c`; `Filtro p a` entrega el caudal de `a` si ese caudal cumple `p`, y 0 si no; `Confluencia` y `Divergencia` entregan la suma de sus operandos. Por ejemplo, el caudal de `ejAc` es 21.

## Ejercicio 1 - Recursión explícita

Definir por recursión explícita las siguientes funciones.

> Las funciones de este ejercicio **no** pueden usarse entre sí; solo pueden usar auxiliares propias. Se recomienda definir auxiliares sobre `Maybe` y funciones que permitan conocer el estado del caudal después de aplicar un filtro: algunas no se pueden resolver de forma directa sin ellas.

1. `caudalFinal`, que describe el caudal que entrega el acueducto, pero sólo para el elemento más externo: si el acueducto es un `Filtro` y el caudal que le llega no pasa su filtro, el resultado es `Nothing`. Un filtro seco más adentro solo aporta caudal 0 a su acueducto.
   *(precisión)* Una `Vertiente`, una `Confluencia` o una `Divergencia` siempre dan `Just` de su caudal.
   - `caudalFinal ejAc = Just 21`
   - `caudalFinal ejSeco = Nothing`
   - `caudalFinal (Confluencia ejSeco (Vertiente 4)) = Just 4`

```haskell
caudalFinal :: Acueducto -> Maybe Caudal
caudalFinal = undefined
```

2. `maximoCaudal`, que describe el mayor caudal que podría entregar el acueducto: el que habría si todos los filtros dejaran pasar. `Confluencia` y `Divergencia` suman.
   *(precisión)* El ejemplo del archivo original (`maximoCaudal ejAc = 10`) no es consistente con esta definición; con ella el resultado es 123.
   - `maximoCaudal ejAc = 123`
   - `maximoCaudal ejSeco = 3`

```haskell
maximoCaudal :: Acueducto -> Caudal
maximoCaudal = undefined
```

3. `comprimirAcueducto`, que describe el acueducto resultante de convertir en `Divergencia` las `Confluencia` consecutivas, sin perder datos y priorizando la izquierda: si una `Confluencia` tiene como operando izquierdo (ya comprimido) otra `Confluencia`, se reemplaza por una `Divergencia` con los dos operandos de esa y el operando derecho; si no, y es el derecho el que es `Confluencia`, por una `Divergencia` con el operando izquierdo y los dos operandos de esa. El resto de la estructura se mantiene.
   - `show (comprimirAcueducto ejAc)` es `show (Divergencia (Filtro (\c -> c < 10) (Filtro (\c -> c >= 0) (Confluencia (Vertiente 6) (Filtro (\c -> c < 4) (Confluencia (Vertiente 2) (Vertiente 100)))))) (Vertiente 5) (Vertiente 10))`
   - `comprimirAcueducto (Confluencia (Confluencia (Vertiente 1) (Vertiente 2)) (Confluencia (Vertiente 3) (Vertiente 4)))` es `Divergencia (Vertiente 1) (Vertiente 2) (Confluencia (Vertiente 3) (Vertiente 4))`

```haskell
comprimirAcueducto :: Acueducto -> Acueducto
comprimirAcueducto = undefined
```

4. `caminoAlPrimerFiltroSeco`, que describe los tramos a recorrer desde la raíz hasta el primer filtro que seca, o `Nothing` si ningún filtro seca. El filtro que seca no cuenta como tramo (el camino termina al llegar a él). *(precisión)* El "primero" se busca en preorden: primero el elemento actual, después `Ramal1`, `Ramal2` y `Ramal3` en ese orden. Un filtro seca cuando el caudal que le llega no cumple su condición.
   - `caminoAlPrimerFiltroSeco ejAc = Just [Ramal1,Recto,Recto,Ramal2]`
   - `caminoAlPrimerFiltroSeco ejSeco = Just []`
   - `caminoAlPrimerFiltroSeco (Vertiente 3) = Nothing`

```haskell
caminoAlPrimerFiltroSeco :: Acueducto -> Maybe [Tramo]
caminoAlPrimerFiltroSeco = undefined
```

5. `nucleoRamificado`, que describe el acueducto sin filtros que resulta de dejar cada filtro que deja pasar su caudal por el acueducto que filtra, y reemplazar cada filtro que seca por `Vertiente 0`. *(precisión)* Este ejercicio decía "inventalo" en el original; esta es una definición propuesta.
   - `show (nucleoRamificado ejAc)` es `"Confluencia (Confluencia (Vertiente 6) (Vertiente 0)) (Confluencia (Vertiente 5) (Vertiente 10))"`

```haskell
nucleoRamificado :: Acueducto -> Acueducto
nucleoRamificado = undefined
```

## Ejercicio 2 - Demostración

Demostrar por inducción estructural, con casos, HI/TI, extensionalidad cuando corresponda y justificando cada paso. Se puede omitir el caso de `Divergencia`.

```
¿ maximoCaudal . comprimirAcueducto = maximoCaudal ?
```

Plantilla (completar):

```
PROP: ¿ maximoCaudal . comprimirAcueducto = maximoCaudal ?
DEM:
  ...
Caso base: e = Vertiente c)
  TI: ¿ ... ?
Caso ind. 1: e = Filtro p e')
  HI: ¡ ... !
  TI: ¿ ... ?
Caso ind. 2: e = Confluencia e1 e2)
  HI1: ¡ ... !
  HI2: ¡ ... !
  TI:  ¿ ... ?
(Caso ind. 3: e = Divergencia e1 e2 e3 - se puede omitir)
```

## Ejercicio 3 - Esquemas de recursión

Dar el tipo y la implementación de `foldAc` (recursión estructural) y de `recAc` (recursión primitiva) para `Acueducto` (agregar las signaturas).

```haskell
foldAc = undefined
```

```haskell
recAc = undefined
```

## Ejercicio 4 - Reescritura

Redefinir las cinco funciones del Ejercicio 1 sin recursión explícita, usando `foldAc`, `recAc` y funciones ya definidas.

```haskell
caudalFinal' :: Acueducto -> Maybe Caudal
caudalFinal' = undefined

maximoCaudal' :: Acueducto -> Caudal
maximoCaudal' = undefined

comprimirAcueducto' :: Acueducto -> Acueducto
comprimirAcueducto' = undefined

caminoAlPrimerFiltroSeco' :: Acueducto -> Maybe [Tramo]
caminoAlPrimerFiltroSeco' = undefined

nucleoRamificado' :: Acueducto -> Acueducto
nucleoRamificado' = undefined
```

## Pruebas

Pegar al final, una vez resueltos los ejercicios. Se ejecuta con `runghc`; cada línea indica el resultado esperado.

```haskell
main :: IO ()
main = do
  print (caudalFinal ejAc)                              -- Just 21
  print (caudalFinal ejSeco)                            -- Nothing
  print (caudalFinal (Confluencia ejSeco (Vertiente 4))) -- Just 4
  print (maximoCaudal ejAc)                             -- 123
  print (maximoCaudal ejSeco)                           -- 3
  print (comprimirAcueducto ejAc)
    -- Divergencia (Filtro <fun> (Filtro <fun> (Confluencia (Vertiente 6) (Filtro <fun> (Confluencia (Vertiente 2) (Vertiente 100)))))) (Vertiente 5) (Vertiente 10)
  print (comprimirAcueducto (Confluencia (Confluencia (Vertiente 1) (Vertiente 2)) (Confluencia (Vertiente 3) (Vertiente 4))))
    -- Divergencia (Vertiente 1) (Vertiente 2) (Confluencia (Vertiente 3) (Vertiente 4))
  print (caminoAlPrimerFiltroSeco ejAc)                 -- Just [Ramal1,Recto,Recto,Ramal2]
  print (caminoAlPrimerFiltroSeco ejSeco)               -- Just []
  print (caminoAlPrimerFiltroSeco (Vertiente 3))        -- Nothing
  print (nucleoRamificado ejAc)
    -- Confluencia (Confluencia (Vertiente 6) (Vertiente 0)) (Confluencia (Vertiente 5) (Vertiente 10))
  -- reescrituras = definiciones explícitas
  print (and [ caudalFinal' a == caudalFinal a
             && maximoCaudal' a == maximoCaudal a
             && show (comprimirAcueducto' a) == show (comprimirAcueducto a)
             && caminoAlPrimerFiltroSeco' a == caminoAlPrimerFiltroSeco a
             && show (nucleoRamificado' a) == show (nucleoRamificado a)
             | a <- [ejAc, ejSeco, Vertiente 3] ])      -- True
  -- propiedad del Ejercicio 2 sobre ejemplos
  print (and [ maximoCaudal (comprimirAcueducto a) == maximoCaudal a
             | a <- [ejAc, ejSeco, Vertiente 3] ])      -- True
```
