# Soluciones y rúbrica - 002 Facturación (medio, énfasis demos)

Código verificado con GHC (compilado, ejemplos y propiedades ejecutados). Los nombres coinciden con los stubs del enunciado (reescrituras con prima); `juntar` ya viene dada en la base del enunciado (se muestra acá solo como referencia). Los `data` derivan `Show, Eq`.

## Ej. 1 (20 pts)

```haskell
eval Nada         = 0                 -- eval.1
eval (Item n)     = n                 -- eval.2
eval (Junto a b)  = eval a + eval b   -- eval.3
eval (Escala k c) = k * eval c        -- eval.4

cantItems Nada         = 0                          -- cantItems.1
cantItems (Item _)     = 1                          -- cantItems.2
cantItems (Junto a b)  = cantItems a + cantItems b  -- cantItems.3
cantItems (Escala _ c) = cantItems c                -- cantItems.4

items Nada         = []                   -- items.1
items (Item n)     = [n]                  -- items.2
items (Junto a b)  = items a ++ items b   -- items.3
items (Escala k c) = map (k *) (items c)  -- items.4

mayorPrecio c = mayorPrecioCon 1 c

mayorPrecioCon :: Int -> Cuenta -> Int
mayorPrecioCon _ Nada         = 0                                              -- mpc.1
mayorPrecioCon f (Item n)     = f * n                                          -- mpc.2
mayorPrecioCon f (Junto a b)  = max (mayorPrecioCon f a) (mayorPrecioCon f b)  -- mpc.3
mayorPrecioCon f (Escala k c) = mayorPrecioCon (f * k) c                       -- mpc.4

simp Nada         = Nada                      -- simp.1
simp (Item n)     = Item n                    -- simp.2
simp (Junto a b)  = juntar (simp a) (simp b)  -- simp.3
simp (Escala k c) = Escala k (simp c)         -- simp.4

juntar Nada y = y          -- juntar.1
juntar x Nada = x          -- juntar.2
juntar x y    = Junto x y  -- juntar.3
```
Rúbrica: eval 3, cantItems 3, items 4, mayorPrecio 6 (la auxiliar con factor acumulado; descuento si usa `maximum (items c)` con `maximum []` sin cubrir el 0), simp+juntar 4. Equivalente válido: `mayorPrecio = maximum . (0:) . items` es correcta pero no es recursión explícita.

## Ej. 2 (10 pts)

```haskell
foldCuenta :: b -> (Int -> b) -> (b -> b -> b) -> (Int -> b -> b) -> Cuenta -> b
foldCuenta n i j e Nada         = n
foldCuenta n i j e (Item x)     = i x
foldCuenta n i j e (Junto a b)  = j (foldCuenta n i j e a) (foldCuenta n i j e b)
foldCuenta n i j e (Escala k c) = e k (foldCuenta n i j e c)
```
Tipo 4 (un parámetro por constructor; `Escala` recibe el `Int` y el resultado recursivo), implementación 6. No se pide `rec` (ninguna función necesita la subestructura original).

## Ej. 3 (15 pts, 3 c/u)

```haskell
eval'       = foldCuenta 0 id (+) (*)
cantItems'  = foldCuenta 0 (const 1) (+) (\_ r -> r)
items'      = foldCuenta [] (\x -> [x]) (++) (\k r -> map (k *) r)
mayorPrecio' c = foldCuenta (const 0) (\x f -> f * x) (\ra rb f -> max (ra f) (rb f))
                            (\k r f -> r (f * k)) c 1
simp'       = foldCuenta Nada Item juntar Escala
```

## Ej. 4 (50 pts)

### LEMA-JUNTAR: `¿ eval (juntar x y) = eval x + eval y ?` (para todo x, y)

Análisis por casos, tomando las ecuaciones de `juntar` en orden.
```
caso1) x = Nada
  LI: eval (juntar Nada y) = eval y            -- juntar.1
  LD: eval Nada + eval y = 0 + eval y          -- eval.1
    = eval y                                   -- aritmética
  VALE ESTE CASO
caso2) x distinto de Nada (Item, Junto o Escala), y = Nada
  LI: eval (juntar x Nada) = eval x            -- juntar.2
  LD: eval x + eval Nada = eval x + 0          -- eval.1
    = eval x                                   -- aritmética
  VALE ESTE CASO
caso3) x distinto de Nada, y distinto de Nada
  LI: eval (juntar x y) = eval (Junto x y)     -- juntar.3
    = eval x + eval y                          -- eval.3
  LD: eval x + eval y
  VALE ESTE CASO
```
Rúbrica del lema: 8 pts (enunciado 2, tres casos 6).

### 4a) `¿ eval . simp = eval ?`

Por extensionalidad, sea `c` una cuenta cualquiera: `¿ (eval . simp) c = eval c ?`, y por def (.) `¿ eval (simp c) = eval c ?`. Inducción estructural sobre `c`.

```
casoBase1) c = Nada
  TI: ¿ eval (simp Nada) = eval Nada ?
casoBase2) c = Item n
  TI: ¿ eval (simp (Item n)) = eval (Item n) ?
casoInductivo1) c = Junto a b
  HI1: ¡ eval (simp a) = eval a !
  HI2: ¡ eval (simp b) = eval b !
  TI:  ¿ eval (simp (Junto a b)) = eval (Junto a b) ?
casoInductivo2) c = Escala k d
  HI: ¡ eval (simp d) = eval d !
  TI: ¿ eval (simp (Escala k d)) = eval (Escala k d) ?

DEMO:
casoBase1)
  LI: eval (simp Nada) = eval Nada        -- simp.1
  LD: eval Nada
  VALE ESTE CASO
casoBase2)
  LI: eval (simp (Item n)) = eval (Item n)   -- simp.2
  LD: eval (Item n)
  VALE ESTE CASO
casoInductivo1)
  LI: eval (simp (Junto a b))
    = eval (juntar (simp a) (simp b))          -- simp.3
    = eval (simp a) + eval (simp b)            -- LEMA-JUNTAR
    = eval a + eval b                          -- HI1, HI2
  LD: eval (Junto a b)
    = eval a + eval b                          -- eval.3
  VALE ESTE CASO
casoInductivo2)
  LI: eval (simp (Escala k d))
    = eval (Escala k (simp d))                 -- simp.4
    = k * eval (simp d)                        -- eval.4
    = k * eval d                               -- HI
  LD: eval (Escala k d)
    = k * eval d                               -- eval.4
  VALE ESTE CASO
```
Rúbrica 4a (22 pts): extensionalidad + (.) 3, casos/HI/TI 6, casos 8 (base 1+1, Junto 3, Escala 3), uso correcto de LEMA-JUNTAR 5 (si no lo enuncia pero lo usa con justificación válida: 2; si lo prueba bien se suman los 8 de arriba).

### 4b) `¿ eval = sum . items ?`

Extensionalidad: `¿ eval c = sum (items c) ?`. Inducción estructural sobre `c`.
```
casoBase1) c = Nada      TI: ¿ eval Nada = sum (items Nada) ?
casoBase2) c = Item n    TI: ¿ eval (Item n) = sum (items (Item n)) ?
casoInductivo1) c = Junto a b
  HI1: ¡ eval a = sum (items a) !   HI2: ¡ eval b = sum (items b) !
  TI:  ¿ eval (Junto a b) = sum (items (Junto a b)) ?
casoInductivo2) c = Escala k d
  HI: ¡ eval d = sum (items d) !
  TI: ¿ eval (Escala k d) = sum (items (Escala k d)) ?

DEMO:
casoBase1)
  LI: eval Nada = 0                             -- eval.1
  LD: sum (items Nada) = sum [] = 0             -- items.1, sum.1
  VALE ESTE CASO
casoBase2)
  LI: eval (Item n) = n                         -- eval.2
  LD: sum (items (Item n)) = sum [n]            -- items.2
    = n + sum []                                -- sum.2
    = n + 0 = n                                 -- sum.1, aritmética
  VALE ESTE CASO
casoInductivo1)
  LI: eval (Junto a b) = eval a + eval b        -- eval.3
    = sum (items a) + sum (items b)             -- HI1, HI2
  LD: sum (items (Junto a b)) = sum (items a ++ items b)   -- items.3
    = sum (items a) + sum (items b)             -- SUM-APP
  VALE ESTE CASO
casoInductivo2)
  LI: eval (Escala k d) = k * eval d            -- eval.4
    = k * sum (items d)                         -- HI
  LD: sum (items (Escala k d)) = sum (map (k*) (items d))  -- items.4
    = k * sum (items d)                         -- SUM-MAP
  VALE ESTE CASO
```
Rúbrica 4b (20 pts): extensionalidad 3, casos/HI/TI 5, casos 10 (1+2+3.5+3.5), citar `SUM-APP`/`SUM-MAP` 2. Nota: el total de Ej.4 (22+20+8 del lema = 50).

## Ej. 5 (bonus, 5 pts)
```haskell
totalesPositivos cs = [ eval c | c <- cs, eval c > 0 ]
mayorTotal = foldr (\c r -> max (eval c) r) 0
```

## Errores comunes
- En 4a, no ver que `simp.3` produce `juntar (simp a) (simp b)`, no `Junto`; saltear LEMA-JUNTAR y escribir "por simp" para `eval (juntar ...)`.
- En el LEMA-JUNTAR, olvidar el caso `y = Nada` (con x no vacío) o la aritmética `eval x + 0`.
- Una sola HI en `Junto`.
- En `mayorPrecioCon`, multiplicar el factor al revés (`f` por el `Item` en vez de acumularlo en `Escala`) o reiniciar el factor.
- En 4b, usar `SUM-MAP` con la HI sin haber aplicado antes `items.4`.
- Esperar que `simp` elimine `Escala k Nada` (el enunciado aclara que no).

## Rúbrica (estimada)
Ej.1: 20 | Ej.2: 10 | Ej.3: 15 | Ej.4: 50 | Ej.5 bonus: 5. Aprobación estimada: 60 con demostración no en blanco.

## Nota de generación
Forma: lenguaje de expresiones (nulo, hoja con dato, binario, unario con dato), con `simp` que preserva `eval` (plantilla "eval . simp = eval" con una sola regla) y una segunda demo "relación con listas" (`eval = sum . items`). Dominio nuevo (facturación, listado en el catálogo sin usar). Validación: `.hs` compilado con GHC; todos los ejemplos del enunciado ejecutados (incluido `simp c1`, `simp c3`); `eval . simp = eval` y `eval = sum . items` chequeadas en 5 valores; reescrituras idénticas a las explícitas.
