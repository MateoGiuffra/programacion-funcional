# Programación Funcional - Parcial de práctica - Mensajería con reenvíos y respuestas - nivel parcial (balanceado, 2 demostraciones)

Libro abierto. Se pueden usar funciones y propiedades vistas en clase citando su origen (`map`, `length`, `(++)`, `foldr`, etc.); lo demás se define o se demuestra. Puntaje sugerido (100): Ej.1 = 30, Ej.2 = 15, Ej.3 = 20, Ej.4 (demostraciones) = 30, Bonus = 5. Duración de referencia: 2 a 3 horas.

## Base para copiar

Un hilo de mensajería se describe así.
```haskell
type Contacto = String

data Mensaje = Eliminado                          -- mensaje borrado (no se ve nada)
             | Texto String                       -- una línea de texto
             | Reenvio Contacto Mensaje           -- reenviado a un contacto
             | Edicion (String -> String) Mensaje -- el cliente transforma cada línea al mostrarla
             | Respuesta Mensaje Mensaje          -- Respuesta original respuesta

instance Show Mensaje where
  show Eliminado       = "Eliminado"
  show (Texto s)       = "Texto " ++ show s
  show (Reenvio c m)   = "Reenvio " ++ show c ++ " (" ++ show m ++ ")"
  show (Edicion _ m)   = "Edicion <fun> (" ++ show m ++ ")"
  show (Respuesta o r) = "Respuesta (" ++ show o ++ ") (" ++ show r ++ ")"

m1, m2, m3, m4 :: Mensaje
m1 = Respuesta (Texto "hola") (Texto "que tal")
m2 = Reenvio "Ana" (Reenvio "Beto" (Texto "fiesta"))
m3 = Respuesta (Respuesta (Texto "a") (Edicion reverse (Texto "abc")))
               (Reenvio "Zoe" (Texto "b"))
m4 = Respuesta Eliminado (Respuesta (Texto "x") Eliminado)

-- función ya dada
responder :: Mensaje -> Mensaje -> Mensaje
responder Eliminado r = r              -- responder.1
responder o Eliminado = o              -- responder.2
responder o r         = Respuesta o r  -- responder.3
```

`leer` describe las líneas que se ven en pantalla, en orden: `Eliminado` no muestra nada; `Reenvio c m` antepone `"Fwd " ++ c ++ ": "` a cada línea de `m`; `Edicion f m` aplica `f` a cada línea de `m`; `Respuesta o r` muestra primero las líneas de `o` y luego las de `r`.

## Ejercicio 1 - Recursión explícita

Definir por recursión explícita:

1. `cantidadLineas`, que describe la cantidad de líneas que muestra el mensaje.
   - `cantidadLineas m1 = 2`, `cantidadLineas m3 = 3`, `cantidadLineas m4 = 1`, `cantidadLineas Eliminado = 0`

```haskell
cantidadLineas :: Mensaje -> Int
cantidadLineas = undefined
```

2. `leer`, según la descripción de arriba.
   - `leer m1 = ["hola","que tal"]`
   - `leer m2 = ["Fwd Ana: Fwd Beto: fiesta"]`
   - `leer m3 = ["a","cba","Fwd Zoe: b"]`
   - `leer m4 = ["x"]`

```haskell
leer :: Mensaje -> [String]
leer = undefined
```

3. `profundidadReenvios`, que describe la mayor cantidad de `Reenvio` anidados que hay que atravesar para llegar a un `Texto`.
   - `profundidadReenvios m2 = 2`, `profundidadReenvios m3 = 1`, `profundidadReenvios m1 = 0`

```haskell
profundidadReenvios :: Mensaje -> Int
profundidadReenvios = undefined
```

4. `primeraLinea`, que describe la primera línea que se muestra, si hay alguna. **Debe ser consistente con `leer`** (incluyendo prefijos y ediciones), pero **no** puede definirse usando `leer` ni `head`.
   - `primeraLinea m1 = Just "hola"`, `primeraLinea m2 = Just "Fwd Ana: Fwd Beto: fiesta"`, `primeraLinea m3 = Just "a"`, `primeraLinea m4 = Just "x"`, `primeraLinea Eliminado = Nothing`

```haskell
primeraLinea :: Mensaje -> Maybe String
primeraLinea = undefined
```

5. `citas`, que junta, para cada `Respuesta o r` que aparece en el mensaje (a cualquier profundidad), las líneas que muestra el original `o` (como las mostraría `leer o`), siguiendo el orden: primero las del original de esa respuesta, luego las citas dentro de `o`, luego las citas dentro de `r`.
   - `citas m1 = ["hola"]`, `citas m2 = []`, `citas m3 = ["a","cba","a"]`, `citas m4 = ["x"]`

```haskell
citas :: Mensaje -> [String]
citas = undefined
```

6. `limpiar`, que elimina los `Eliminado` que sean un operando directo de una `Respuesta` (si uno de los dos lados de una respuesta es `Eliminado` queda solo el otro). No modifica nada más.
   - `limpiar m4` es `Texto "x"`; `limpiar m1` es estructuralmente igual a `m1`.

```haskell
limpiar :: Mensaje -> Mensaje
limpiar = undefined
```

## Ejercicio 2 - Esquemas de recursión

Dar el tipo y la implementación de `foldMensaje` (recursión estructural) y de `recMensaje` (recursión primitiva) para `Mensaje` (agregar las signaturas).

```haskell
foldMensaje = undefined
```

```haskell
recMensaje = undefined
```

## Ejercicio 3 - Reescritura

Redefinir las seis funciones del Ejercicio 1 sin recursión explícita, usando `foldMensaje`, `recMensaje` y funciones ya definidas.

```haskell
cantidadLineas' :: Mensaje -> Int
cantidadLineas' = undefined

leer' :: Mensaje -> [String]
leer' = undefined

profundidadReenvios' :: Mensaje -> Int
profundidadReenvios' = undefined

primeraLinea' :: Mensaje -> Maybe String
primeraLinea' = undefined

citas' :: Mensaje -> [String]
citas' = undefined

limpiar' :: Mensaje -> Mensaje
limpiar' = undefined
```

## Ejercicio 4 - Demostraciones

Por inducción estructural, con casos, HI/TI, extensionalidad cuando corresponda, y justificando cada paso.

**4a)**

```
-- 4a) por inducción estructural sobre Mensaje
¿ cantidadLineas = length . leer ?
-- se pueden usar, sin demostrar:
-- LEN-APP: length (xs ++ ys) = length xs + length ys
-- LEN-MAP: length (map f xs) = length xs
```

**4b)**

```
-- 4b) por inducción estructural sobre Mensaje
¿ leer . limpiar = leer ?
-- se puede usar, sin demostrar:
-- APP-NIL: xs ++ [] = xs
```

Plantilla de casos (completar; un caso por constructor, una HI por cada posición recursiva):

```
casoBase1)
  TI: ¿ ... ?
casoInductivo1)
  HI: ¡ ... !
  TI: ¿ ... ?
casoInductivo3)
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

Dar el tipo y el valor de la siguiente expresión (una vez definido `foldMensaje`; consultar el tipo con `:t bonus`).

```haskell
bonus = foldMensaje [] (:[]) (const id) (const id) (++) (Respuesta (Texto "a") (Texto "b"))
```

## Pruebas

Pegar al final, una vez resueltos los ejercicios. Se ejecuta con `runghc`; cada línea indica el resultado esperado.

```haskell
main :: IO ()
main = do
  print (map cantidadLineas [m1, m3, m4, Eliminado])  -- [2,3,1,0]
  print (leer m1)                                     -- ["hola","que tal"]
  print (leer m2)                                     -- ["Fwd Ana: Fwd Beto: fiesta"]
  print (leer m3)                                     -- ["a","cba","Fwd Zoe: b"]
  print (leer m4)                                     -- ["x"]
  print (map profundidadReenvios [m2, m3, m1])        -- [2,1,0]
  print (map primeraLinea [m1, m2, m3, m4, Eliminado])
    -- [Just "hola",Just "Fwd Ana: Fwd Beto: fiesta",Just "a",Just "x",Nothing]
  print (map citas [m1, m2, m3, m4])                  -- [["hola"],[],["a","cba","a"],["x"]]
  print (limpiar m4)                                  -- Texto "x"
  print (show (limpiar m1) == show m1)                -- True
  print (bonus :: [String])                           -- ["a","b"]
  -- reescrituras = definiciones explícitas
  print (and [ cantidadLineas' m == cantidadLineas m
             && leer' m == leer m
             && profundidadReenvios' m == profundidadReenvios m
             && primeraLinea' m == primeraLinea m
             && citas' m == citas m
             && show (limpiar' m) == show (limpiar m)
             | m <- [m1, m2, m3, m4, Eliminado] ])    -- True
  -- propiedades 4a y 4b sobre ejemplos
  print (and [ cantidadLineas m == length (leer m)
             && leer (limpiar m) == leer m
             | m <- [m1, m2, m3, m4, Eliminado] ])    -- True
```
