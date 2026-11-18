# Soluciones y rúbrica - 003 Mensajería (parcial, balanceado)

Código verificado con GHC (compilado, ejemplos ejecutados, reescrituras comparadas con las explícitas en 5 valores). Los nombres coinciden con los stubs del enunciado (reescrituras con prima); `responder` ya viene dada en la base del enunciado (se muestra acá solo como referencia). `Mensaje` tiene `instance Show` manual (campo función), sin `Eq`.

## Ej. 1 (30 pts, 5 c/u)

```haskell
cantidadLineas Eliminado       = 0                                    -- cl.1
cantidadLineas (Texto _)       = 1                                    -- cl.2
cantidadLineas (Reenvio _ m)   = cantidadLineas m                     -- cl.3
cantidadLineas (Edicion _ m)   = cantidadLineas m                     -- cl.4
cantidadLineas (Respuesta o r) = cantidadLineas o + cantidadLineas r  -- cl.5

leer Eliminado       = []                                       -- leer.1
leer (Texto s)       = [s]                                      -- leer.2
leer (Reenvio c m)   = map (("Fwd " ++ c ++ ": ") ++) (leer m)  -- leer.3
leer (Edicion f m)   = map f (leer m)                           -- leer.4
leer (Respuesta o r) = leer o ++ leer r                         -- leer.5

profundidadReenvios Eliminado       = 0                                                    -- pr.1
profundidadReenvios (Texto _)       = 0                                                    -- pr.2
profundidadReenvios (Reenvio _ m)   = 1 + profundidadReenvios m                            -- pr.3
profundidadReenvios (Edicion _ m)   = profundidadReenvios m                                -- pr.4
profundidadReenvios (Respuesta o r) = max (profundidadReenvios o) (profundidadReenvios r)  -- pr.5

primeraLinea Eliminado       = Nothing                                           -- pl.1
primeraLinea (Texto s)       = Just s                                            -- pl.2
primeraLinea (Reenvio c m)   = fmap (("Fwd " ++ c ++ ": ") ++) (primeraLinea m)  -- pl.3
primeraLinea (Edicion f m)   = fmap f (primeraLinea m)                           -- pl.4
primeraLinea (Respuesta o r) = case primeraLinea o of                            -- pl.5
                                 Nothing -> primeraLinea r
                                 x       -> x

citas Eliminado       = []                            -- citas.1
citas (Texto _)       = []                            -- citas.2
citas (Reenvio _ m)   = citas m                       -- citas.3
citas (Edicion _ m)   = citas m                       -- citas.4
citas (Respuesta o r) = leer o ++ citas o ++ citas r  -- citas.5

limpiar Eliminado       = Eliminado                          -- limpiar.1
limpiar (Texto s)       = Texto s                            -- limpiar.2
limpiar (Reenvio c m)   = Reenvio c (limpiar m)              -- limpiar.3
limpiar (Edicion f m)   = Edicion f (limpiar m)              -- limpiar.4
limpiar (Respuesta o r) = responder (limpiar o) (limpiar r)  -- limpiar.5

responder Eliminado r = r              -- responder.1
responder o Eliminado = o              -- responder.2
responder o r         = Respuesta o r  -- responder.3
```
Rúbrica: 5 c/u; en `primeraLinea` exigir `fmap` o equivalente (aplicar prefijo/edición a la rama recursiva) y primer `Just` del original antes que la respuesta; en `citas` la ecuación 5 debe usar `leer o` (descuento 2 si cita `o` sin leerlo o si omite `citas o`). `limpiar` sin `responder` pero correcto: sin descuento.

## Ej. 2 (15 pts)

```haskell
foldMensaje :: b -> (String -> b) -> (Contacto -> b -> b) -> ((String -> String) -> b -> b)
            -> (b -> b -> b) -> Mensaje -> b
foldMensaje e t rf ed rp = go
  where go Eliminado       = e
        go (Texto s)       = t s
        go (Reenvio c m)   = rf c (go m)
        go (Edicion f m)   = ed f (go m)
        go (Respuesta o r) = rp (go o) (go r)

recMensaje :: b -> (String -> b) -> (Contacto -> Mensaje -> b -> b)
           -> ((String -> String) -> Mensaje -> b -> b)
           -> (Mensaje -> Mensaje -> b -> b -> b) -> Mensaje -> b
recMensaje e t rf ed rp = go
  where go Eliminado       = e
        go (Texto s)       = t s
        go (Reenvio c m)   = rf c m (go m)
        go (Edicion f m)   = ed f m (go m)
        go (Respuesta o r) = rp o r (go o) (go r)
```
`foldMensaje`: tipo 3.5 + impl 3.5. `recMensaje`: tipo 4 (cada rama recursiva recibe además el mensaje original) + impl 4.

## Ej. 3 (20 pts)

```haskell
cantidadLineas'      = foldMensaje 0 (const 1) (\_ n -> n) (\_ n -> n) (+)
leer'                = foldMensaje [] (\s -> [s]) (\c ls -> map (("Fwd " ++ c ++ ": ") ++) ls)
                                   (\f ls -> map f ls) (++)
profundidadReenvios' = foldMensaje 0 (const 0) (\_ n -> 1 + n) (\_ n -> n) max
primeraLinea'        = foldMensaje Nothing Just (\c r -> fmap (("Fwd " ++ c ++ ": ") ++) r)
                                   (\f r -> fmap f r) (\ro rr -> case ro of Nothing -> rr; x -> x)
citas'               = recMensaje [] (const []) (\_ _ r -> r) (\_ _ r -> r)
                                  (\o _ ro rr -> leer o ++ ro ++ rr)
limpiar'             = foldMensaje Eliminado Texto Reenvio Edicion responder
```
Rúbrica: 3 pts por las cuatro primeras, 4 por `citas'` (exige `recMensaje`), 4 por `limpiar'` (ver que `responder` va en la posición de `Respuesta`).

## Ej. 4 (30 pts)

### 4a) `¿ cantidadLineas = length . leer ?` (12 pts)

Extensionalidad: sea `m` un mensaje cualquiera, `¿ cantidadLineas m = length (leer m) ?` (def (.)). Inducción estructural sobre `m`.

```
casoBase1) m = Eliminado   TI: ¿ cantidadLineas Eliminado = length (leer Eliminado) ?
casoBase2) m = Texto s     TI: ¿ cantidadLineas (Texto s) = length (leer (Texto s)) ?
casoInductivo1) m = Reenvio c n
  HI: ¡ cantidadLineas n = length (leer n) !
  TI: ¿ cantidadLineas (Reenvio c n) = length (leer (Reenvio c n)) ?
casoInductivo2) m = Edicion f n
  HI: ¡ cantidadLineas n = length (leer n) !
  TI: ¿ cantidadLineas (Edicion f n) = length (leer (Edicion f n)) ?
casoInductivo3) m = Respuesta o r
  HI1: ¡ cantidadLineas o = length (leer o) !
  HI2: ¡ cantidadLineas r = length (leer r) !
  TI:  ¿ cantidadLineas (Respuesta o r) = length (leer (Respuesta o r)) ?

DEMO:
casoBase1)
  LI: cantidadLineas Eliminado = 0                   -- cl.1
  LD: length (leer Eliminado) = length [] = 0        -- leer.1, length.1
  VALE ESTE CASO
casoBase2)
  LI: cantidadLineas (Texto s) = 1                   -- cl.2
  LD: length (leer (Texto s)) = length [s]           -- leer.2
    = 1 + length [] = 1 + 0 = 1                      -- length.2, length.1
  VALE ESTE CASO
casoInductivo1)
  LI: cantidadLineas (Reenvio c n) = cantidadLineas n          -- cl.3
    = length (leer n)                                          -- HI
  LD: length (leer (Reenvio c n))
    = length (map (("Fwd " ++ c ++ ": ") ++) (leer n))        -- leer.3
    = length (leer n)                                          -- LEN-MAP
  VALE ESTE CASO
casoInductivo2)
  LI: cantidadLineas (Edicion f n) = cantidadLineas n          -- cl.4
    = length (leer n)                                          -- HI
  LD: length (leer (Edicion f n)) = length (map f (leer n))    -- leer.4
    = length (leer n)                                          -- LEN-MAP
  VALE ESTE CASO
casoInductivo3)
  LI: cantidadLineas (Respuesta o r)
    = cantidadLineas o + cantidadLineas r                      -- cl.5
    = length (leer o) + length (leer r)                        -- HI1, HI2
  LD: length (leer (Respuesta o r)) = length (leer o ++ leer r)  -- leer.5
    = length (leer o) + length (leer r)                        -- LEN-APP
  VALE ESTE CASO
```
Rúbrica 4a: extensionalidad 2, casos/HI/TI 3, cinco casos 6 (1+1+1+1+2), citar lemas 1.

### 4b) `¿ leer . limpiar = leer ?` (18 pts)

**LEMA-RESPONDER**: `¿ leer (responder a b) = leer a ++ leer b ?` (para todo a, b; análisis de casos, ecuaciones de `responder` en orden). (6 pts)
```
caso1) a = Eliminado
  LI: leer (responder Eliminado b) = leer b            -- responder.1
  LD: leer Eliminado ++ leer b = [] ++ leer b          -- leer.1
    = leer b                                           -- ++.1
  VALE ESTE CASO
caso2) a distinto de Eliminado, b = Eliminado
  LI: leer (responder a Eliminado) = leer a            -- responder.2
  LD: leer a ++ leer Eliminado = leer a ++ []          -- leer.1
    = leer a                                           -- APP-NIL
  VALE ESTE CASO
caso3) a distinto de Eliminado, b distinto de Eliminado
  LI: leer (responder a b) = leer (Respuesta a b)      -- responder.3
    = leer a ++ leer b                                 -- leer.5
  LD: leer a ++ leer b
  VALE ESTE CASO
```

**Propiedad.** Extensionalidad: sea `m` cualquiera, `¿ leer (limpiar m) = leer m ?` (def (.)). Inducción estructural sobre `m`; se desarrollan Reenvio y Respuesta (los otros indicados).
```
casoBase1) m = Eliminado   TI: ¿ leer (limpiar Eliminado) = leer Eliminado ?     (análogo: limpiar.1)
casoBase2) m = Texto s     TI: ¿ leer (limpiar (Texto s)) = leer (Texto s) ?     (análogo: limpiar.2)
casoInductivo1) m = Reenvio c n
  HI: ¡ leer (limpiar n) = leer n !
  TI: ¿ leer (limpiar (Reenvio c n)) = leer (Reenvio c n) ?
casoInductivo2) m = Edicion f n                                                   (análogo a Reenvio, con limpiar.4 y leer.4)
  HI: ¡ leer (limpiar n) = leer n !
  TI: ¿ leer (limpiar (Edicion f n)) = leer (Edicion f n) ?
casoInductivo3) m = Respuesta o r
  HI1: ¡ leer (limpiar o) = leer o !
  HI2: ¡ leer (limpiar r) = leer r !
  TI:  ¿ leer (limpiar (Respuesta o r)) = leer (Respuesta o r) ?

DEMO:
casoInductivo1)
  LI: leer (limpiar (Reenvio c n))
    = leer (Reenvio c (limpiar n))                              -- limpiar.3
    = map (("Fwd " ++ c ++ ": ") ++) (leer (limpiar n))         -- leer.3
    = map (("Fwd " ++ c ++ ": ") ++) (leer n)                   -- HI
  LD: leer (Reenvio c n)
    = map (("Fwd " ++ c ++ ": ") ++) (leer n)                   -- leer.3
  VALE ESTE CASO
casoInductivo3)
  LI: leer (limpiar (Respuesta o r))
    = leer (responder (limpiar o) (limpiar r))                  -- limpiar.5
    = leer (limpiar o) ++ leer (limpiar r)                      -- LEMA-RESPONDER
    = leer o ++ leer r                                          -- HI1, HI2
  LD: leer (Respuesta o r)
    = leer o ++ leer r                                          -- leer.5
  VALE ESTE CASO
```
Rúbrica 4b: lema 6 (enunciado 1, tres casos 5), extensionalidad + (.) 2, casos/HI/TI 4 (HI1/HI2 en Respuesta), Reenvio 3, Respuesta 3. Si se hacen todos los casos, los triviales no suman más.

## Bonus (5 pts)
`foldMensaje [] (:[]) (const id) (const id) (++) (Respuesta (Texto "a") (Texto "b")) :: [String]` y vale `["a","b"]` (se instancia `b = [String]`, `(:[]) :: String -> [String]`).

## Errores comunes
- `primeraLinea`: aplicar `leer` y `head` (prohibido), o no aplicar el prefijo/edición a la primera línea.
- `citas`: olvidar `citas o`, o usar `citas o` en vez de `leer o` para el original; intentar `foldMensaje` (no alcanza: se necesita `o` sin reducir).
- `limpiar`: dejar `Respuesta Eliminado x` o aplicar `responder` sin limpiar antes los hijos.
- En el tipo de `recMensaje`, olvidar entregar el original junto con el resultado recursivo.
- Una sola HI en `Respuesta`; justificar `leer (responder ...)` con "por responder" sin lema.
- Pensar que `leer (responder a Eliminado) = leer a` es directo de `leer.5`: hace falta APP-NIL.

## Rúbrica (estimada)
Ej.1: 30 | Ej.2: 15 | Ej.3: 20 | Ej.4: 30 (4a 12, 4b 18) | Bonus: 5. Aprobación estimada: 60 pts con al menos una demo no en blanco.

## Nota de generación
Forma: DSL con casos base (vacío y con dato), dos unarios (uno con dato, otro con función como dato) y un binario (2 posiciones recursivas). Combina un `leer` de semántica de lista con `limpiar` que preserva la semántica (plantilla `eval . simp = eval`) y una conmutación con listas (`length . leer`). `recMensaje` se pide porque `citas` necesita el subárbol original. Dominio nuevo (mensajería con reenvíos del catálogo, sin usar). Validación: `.hs` compilado con GHC; todos los ejemplos del enunciado ejecutados (cantidadLineas, leer, profundidadReenvios, primeraLinea, citas, limpiar m4); ambas propiedades chequeadas sobre 5 valores; reescrituras con esquemas igualan a las explícitas; el bonus devuelve `["a","b"]`.
