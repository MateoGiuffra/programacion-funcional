# 03 - Funciones típicas (Programación Funcional, UNQ)

## Funciones que aparecen todo el tiempo

Verificadas con `runghc`.

### Orden superior y combinadores

| Función | Tipo | Ejemplo |
| :---- | :---- | :---- |
| `flip` | `(a -> b -> c) -> b -> a -> c` | Invierte los dos primeros argumentos. `flip (-) 1 5 = 4` |
| `(.)` | `(b -> c) -> (a -> b) -> a -> c` | `(f . g) x = f (g x)` |
| `($)` | `(a -> b) -> a -> b` | Evita paréntesis. `f $ g $ h x = f (g (h x))` |
| `id` | `a -> a` | No hace nada. |
| `const` | `a -> b -> a` | `const 1 "x" = 1` |
| `flip const` | `a -> b -> b` | Ignora el 1.º (`\_ y -> y`). |
| `subtract` | `Num a => a -> a -> a` | `subtract 1 5 = 4`; `map (subtract 1) xs`. Existe porque `(- n)` **no** es sección (se lee `-n`). |
| `curry` / `uncurry` | `((a,b) -> c) -> a -> b -> c` / inversa | `uncurry (+) (1,2) = 3` |
| `twice` (cátedra) | `(a -> a) -> a -> a` | `twice f x = f (f x)` |
| `compare` | `Ord a => a -> a -> Ordering` | `compare 1 2 = LT`; `compare 2 2 = EQ`; `compare 3 2 = GT`. Uso típico: el `case` de la forma «fusionar secuencias» (documento 01, §3). |
| `max` / `min` | `Ord a => a -> a -> a` | `max 1 2 = 2`; `min 1 2 = 1` |

### Listas

| Función | Tipo | Ejemplo |
| :---- | :---- | :---- |
| `map` | `(a -> b) -> [a] -> [b]` | Aplica a cada elemento. |
| `filter` | `(a -> Bool) -> [a] -> [a]` | Se queda con los que cumplen. |
| `foldr` | `(a -> b -> b) -> b -> [a] -> b` | `foldr (+) 0 [1,2,3] = 6` |
| `length` | `[a] -> Int` | `length "abc" = 3` |
| `sum` | `Num a => [a] -> a` | `sum [1,2,3] = 6` |
| `elem` | `Eq a => a -> [a] -> Bool` | `elem 2 [1,2,3] = True`; `elem 5 [1,2,3] = False` |
| `any` / `all` | `(a -> Bool) -> [a] -> Bool` | `any even [1,3,4] = True`; `all even [2,3] = False`; con `[]`: `any` da `False`, `all` da `True` |
| `concat` | `[[a]] -> [a]` | `concat [[1],[2,3]] = [1,2,3]` |
| `null` | `[a] -> Bool` | ¿Vacía? Sirve para distinguir a mano un caso base compartido (documento 01, §2). |
| `(++)` | `[a] -> [a] -> [a]` | Concatena. |
| `replicate` | `Int -> a -> [a]` | `replicate 2 'a' = "aa"` |
| `zip` | `[a] -> [b] -> [(a,b)]` | Se corta en la más corta. |
| `zipWith` | `(a -> b -> c) -> [a] -> [b] -> [c]` | `zipWith f xs ys = map (uncurry f) (zip xs ys)`; igual corte. |
| `lookup` | `Eq a => a -> [(a,b)] -> Maybe b` | `lookup 2 [(1,"a"),(2,"b")] = Just "b"`; `lookup 3 [(1,"a")] = Nothing` |
| `find` | `(a -> Bool) -> [a] -> Maybe a` | `Data.List`. `find even [1,3,4,5] = Just 4`; `find even [1,3] = Nothing` |

### Pares

| Función | Tipo | Ejemplo |
| :---- | :---- | :---- |
| `fst` / `snd` | `(a,b) -> a` / `(a,b) -> b` | `fst (1,'a') = 1`; `snd (1,'a') = 'a'` |
| `uflip` (cátedra) | `(a -> b -> c) -> (a,b) -> c` | `uflip f (x,y) = f y x` (`uncurry (flip f)`; mirá cómo lo define tu cátedra). |

### Maybe / Either

`data Maybe a = Nothing | Just a` · `data Either a b = Left a | Right b`

| Función | Tipo | Ejemplo |
| :---- | :---- | :---- |
| `maybe` | `b -> (a -> b) -> Maybe a -> b` | `maybe 0 (+1) Nothing = 0`; `maybe 0 (+1) (Just 2) = 3` |
| `fromMaybe` | `a -> Maybe a -> a` | `fromMaybe 0 Nothing = 0`; `fromMaybe 0 (Just 3) = 3` |
| `isJust` / `isNothing` | `Maybe a -> Bool` | `isJust (Just 1) = True`; `isNothing (Just 1) = False` |
| `fromJust` | `Maybe a -> a` | **Parcial: error con `Nothing`.** Evitala. |
| `catMaybes` | `[Maybe a] -> [a]` | `catMaybes [Just 1, Nothing, Just 3] = [1,3]` |
| `mapMaybe` | `(a -> Maybe b) -> [a] -> [b]` | `map` + descartar fallos. `mapMaybe (\x -> if x > 1 then Just (x*2) else Nothing) [1,2,3] = [4,6]` |
| `listToMaybe` / `maybeToList` | `[a] -> Maybe a` / `Maybe a -> [a]` | `listToMaybe [1,2,3] = Just 1`; `maybeToList (Just 1) = [1]` |
| `fmap` / `(<$>)` | `(a -> b) -> Maybe a -> Maybe b` | `fmap (+1) (Just 1) = Just 2`; `(+1) <$> Nothing = Nothing` |
| `(>>=)` | `Maybe a -> (a -> Maybe b) -> Maybe b` | El primer `Nothing` corta todo. `Just 4 >>= \x -> if x > 0 then Just (x-1) else Nothing = Just 3` |
| `do` sobre Maybe | — | `do { a <- Just 1; b <- Nothing; return (a+b) } = Nothing` |
| `(<\|>)` | `Maybe a -> Maybe a -> Maybe a` | `Control.Applicative`. Primer `Just`: `Nothing <\|> Just 1 <\|> Just 2 = Just 1` |
| `either` | `(a -> c) -> (b -> c) -> Either a b -> c` | `either length (+1) (Left "ab") = 2`; `either length (+1) (Right 1) = 2` |
| `Left` / `Right` | constructores | Por convención `Left` = error, `Right` = éxito. |

Imports: `Data.Maybe` (`fromMaybe`, `isJust`, `isNothing`, `fromJust`, `catMaybes`, `mapMaybe`, `listToMaybe`, `maybeToList`), `Data.List` (`find`), `Control.Applicative` (`<|>`). `maybe`, `either` y `lookup` vienen en el Prelude.

### Auxiliares sobre Maybe (no son del Prelude: se definen)

Útiles cuando un fold devuelve `Maybe` en cada rama y hay que juntar resultados (ej. `Confluencia`/`Switch`).

```haskell
-- combina dos Just con f; si alguno es Nothing, Nothing
combineM :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
combineM f (Just x) (Just y) = Just (f x y)
combineM _ _        _        = Nothing

-- todos del mismo tipo: si falta uno, devuelve el otro
combineM2 :: (a -> a -> a) -> Maybe a -> Maybe a -> Maybe a
combineM2 f (Just x) (Just y) = Just (f x y)
combineM2 f Nothing  y        = y
combineM2 f x        Nothing  = x
```

- `combineM (+) (Just 1) (Just 2) = Just 3`; `combineM (+) (Just 1) Nothing = Nothing`.
- `combineM2 (+) (Just 1) Nothing = Just 1`; `combineM2 (+) Nothing Nothing = Nothing`.
- Elegí `combineM` si **un fallo invalida todo**; `combineM2` si un `Nothing` solo significa "este lado no aporta".

### Mini-receta: funciones que pueden fallar

1. **Si puede no haber resultado, devolvé `Maybe`** (no `error`, no un valor "mágico").
2. **Propagar el fallo:** `case`; `fmap` si el paso siguiente no falla; `>>=` (o `do`) si también puede fallar.
3. **Alternativas:** `<|>` prueba la segunda solo si la primera es `Nothing`.

Ej. real (`generados/003-mensajeria-parcial.hs:61-72`):

```haskell
primeraLinea :: Mensaje -> Maybe String
primeraLinea Eliminado = Nothing
primeraLinea (Texto s) = Just s
primeraLinea (Reenvio c m) = case primeraLinea m of
                                Nothing -> Nothing
                                Just s -> Just (fwd c ++ s)
primeraLinea (Respuesta m1 m2) = case primeraLinea m1 of
                                        Nothing -> primeraLinea m2
                                        Just s  -> Just s
```
