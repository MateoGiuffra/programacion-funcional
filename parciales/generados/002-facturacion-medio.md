# Programación Funcional - Parcial de práctica - Facturación con descuentos y recargos - nivel medio (énfasis demostraciones)

Libro abierto. Se pueden usar funciones y propiedades vistas en clase citando su origen; lo demás se define o se demuestra. Puntaje sugerido (100): Ej.1 = 20, Ej.2 = 10, Ej.3 = 15, Ej.4 (demostraciones) = 50, Ej.5 = 5 (bonus).

## Base para copiar

Una cuenta es una expresión que describe cómo se arma un total. Copiar este bloque primero; compila tal cual.

```haskell
data Cuenta = Nada                  -- cuenta vacía
            | Item Int              -- un ítem con su precio
            | Junto Cuenta Cuenta   -- dos cuentas sumadas
            | Escala Int Cuenta     -- todos los ítems se multiplican por un factor (recargo/cantidad)
            deriving (Show, Eq)

c1, c2, c3 :: Cuenta
c1 = Junto (Item 100) (Escala 2 (Junto (Item 30) Nada))
c2 = Escala 3 (Escala 2 (Item 5))
c3 = Junto Nada (Junto (Escala 4 Nada) Nada)

-- función ya dada (no hay que implementarla)
juntar :: Cuenta -> Cuenta -> Cuenta
juntar Nada y = y          -- juntar.1
juntar x Nada = x          -- juntar.2
juntar x y    = Junto x y  -- juntar.3
```

## Ejercicio 1 - Recursión explícita

1. `eval`, que describe el total a pagar (`Nada` vale 0; `Escala k` multiplica por `k` el total de su subcuenta).
   - `eval c1 = 160`, `eval c2 = 30`, `eval c3 = 0`

```haskell
eval :: Cuenta -> Int
eval = undefined
```

2. `cantItems`, que describe la cantidad de `Item` que aparecen.
   - `cantItems c1 = 2`, `cantItems c2 = 1`, `cantItems c3 = 0`

```haskell
cantItems :: Cuenta -> Int
cantItems = undefined
```

3. `items`, que describe los precios finales de cada ítem, de izquierda a derecha, ya multiplicados por los factores de los `Escala` que lo contienen.
   - `items c1 = [100,60]`, `items c2 = [30]`, `items c3 = []`

```haskell
items :: Cuenta -> [Int]
items = undefined
```

4. `mayorPrecio`, que describe el mayor precio final de un ítem (el mismo que aparece en `items`), o 0 si no hay ítems. Suponer precios y factores no negativos.
   - `mayorPrecio c1 = 100`, `mayorPrecio c2 = 30`, `mayorPrecio c3 = 0`

```haskell
mayorPrecio :: Cuenta -> Int
mayorPrecio = undefined
```

5. `simp`, que quita todos los `Nada` que sean un operando directo de un `Junto` (no toca el resto de la estructura: un `Escala k Nada` queda igual).
   - `simp c1 = Junto (Item 100) (Escala 2 (Item 30))`
   - `simp c3 = Escala 4 Nada`
   - `simp (Junto Nada (Item 3)) = Item 3`

```haskell
simp :: Cuenta -> Cuenta
simp = undefined
```

## Ejercicio 2 - Esquema de recursión

Dar el tipo y la definición de `foldCuenta` (agregar la signatura). El orden de los argumentos sigue el orden de los constructores.

```haskell
foldCuenta = undefined
```

## Ejercicio 3 - Reescritura

Redefinir las cinco funciones del Ejercicio 1 sin recursión explícita, usando `foldCuenta` y funciones ya definidas.

```haskell
eval' :: Cuenta -> Int
eval' = undefined

cantItems' :: Cuenta -> Int
cantItems' = undefined

items' :: Cuenta -> [Int]
items' = undefined

mayorPrecio' :: Cuenta -> Int
mayorPrecio' = undefined

simp' :: Cuenta -> Cuenta
simp' = undefined
```

## Ejercicio 4 - Demostraciones

Por inducción estructural, con extensionalidad cuando corresponda, casos, HI/TI y justificando cada paso.

**4a)** Se pide enunciar y demostrar los lemas auxiliares que necesite.

```
-- 4a) por inducción estructural sobre Cuenta
¿ eval . simp = eval ?
```

**4b)** Se pueden usar, sin demostrar, los lemas de la biblioteca.

```
-- 4b) por inducción estructural sobre Cuenta
¿ eval = sum . items ?
-- se pueden usar:
-- SUM-APP: sum (xs ++ ys) = sum xs + sum ys
-- SUM-MAP: sum (map (k*) xs) = k * sum xs
```

Plantilla de casos (completar; la cantidad de casos y de HI depende del constructor):

```
casoBase1)
  TI: ¿ ... ?
casoInductivo1)
  HI1: ¡ ... !
  TI:  ¿ ... ?

DEMO:
casoBase1)
  LI: ...
  LD: ...
  VALE ESTE CASO
```

## Ejercicio 5 - Listas (bonus, 5 pts)

1. `totalesPositivos`, con lista por comprensión: los totales (`eval`) mayores que 0, en orden.
   - `totalesPositivos [c1, c2, c3, Nada, Junto c1 c2] = [160,30,190]`

```haskell
totalesPositivos :: [Cuenta] -> [Int]
totalesPositivos = undefined
```

2. `mayorTotal`, con `foldr`, el mayor total de la lista (0 si es vacía).
   - `mayorTotal [c1, c2, c3, Nada, Junto c1 c2] = 190`, `mayorTotal [] = 0`

```haskell
mayorTotal :: [Cuenta] -> Int
mayorTotal = undefined
```

## Pruebas

Pegar al final, una vez resueltos los ejercicios. Se ejecuta con `runghc`; cada línea indica el resultado esperado.

```haskell
main :: IO ()
main = do
  print (map eval [c1, c2, c3])                 -- [160,30,0]
  print (map cantItems [c1, c2, c3])            -- [2,1,0]
  print (map items [c1, c2, c3])                -- [[100,60],[30],[]]
  print (map mayorPrecio [c1, c2, c3])          -- [100,30,0]
  print (simp c1)                               -- Junto (Item 100) (Escala 2 (Item 30))
  print (simp c3)                               -- Escala 4 Nada
  print (simp (Junto Nada (Item 3)))            -- Item 3
  print (totalesPositivos [c1, c2, c3, Nada, Junto c1 c2])  -- [160,30,190]
  print (mayorTotal [c1, c2, c3, Nada, Junto c1 c2])        -- 190
  print (mayorTotal [])                         -- 0
  -- reescrituras = definiciones explícitas
  print (all (\c -> eval' c == eval c
                 && cantItems' c == cantItems c
                 && items' c == items c
                 && mayorPrecio' c == mayorPrecio c
                 && simp' c == simp c) [c1, c2, c3, Nada, Junto c1 c2])  -- True
  -- propiedades 4a y 4b sobre ejemplos
  print (all (\c -> eval (simp c) == eval c && eval c == sum (items c)) [c1, c2, c3])  -- True
```
