# Guía de parciales — Programación Funcional (UNQ)

## 0. Intuición antes de programar

Es un método que se entrena, no una chispa. Antes de escribir código:

1. **Precondición = pista de diseño.**
   - "Ordenadas y sin repetidos" no está de adorno: habilita algo más simple.
   - Preguntate: *¿qué chequeo me ahorro porque esto ya está garantizado?*
   - Ej.: sin la precondición necesitarías `elem` para no repetir; con ella, comparar las dos cabezas alcanza.
   - Una precondición "obvia y sin uso" es sospechosa: la estás dejando pasar.
2. **Las restricciones de complejidad son restricciones de diseño.**
   - "Un único recorrido" descarta soluciones antes de pensar la lógica.
   - Si tu idea usa `elem` en cada paso, o ordena y después limpia duplicados, ya sabés que no es la pedida.
3. **Catálogo de patrones: reconocé, no inventes.**
   - "Combinar dos listas ordenadas" = el `merge` de mergesort.
   - Quedate con el patrón pelado: "dos punteros, comparo cabezas, avanzo la que corresponda".
4. **Simulá a mano un caso chico** antes de tipear.
   - Mezclá dos mazos ordenados en papel: vas a mirar solo el tope de cada uno. Eso es el algoritmo.
   - Traducir lo que ya hacés intuitivamente es más fácil que razonarlo en abstracto.
5. **Escribí el invariante en una frase** antes de la recursión.
   - "En cada llamada, prometo que ___". Ej.: "todo lo emitido es menor a las dos cabezas actuales".
   - Si no completás la frase, no entendiste la estructura.
   - Es casi el mismo invariante que después usás para la demo por inducción.

## 1. Recordatorios generales

**Datos del enunciado**
- No confíes ciegamente en los ejemplos: pueden venir mal transcriptos. Auditalos sin tu implementación:
  - Si algo "se repite" con período `p`, posiciones congruentes módulo `p` **tienen** que dar lo mismo.
  - Un elemento no puede aparecer antes que el que lo precede en la estructura.
  - Contá duraciones, tamaños y pasos a mano con sumas simples.

**Chequeo final** (no hay ghci en el parcial: a ojo y a mano)
- **Aridad:** contá los argumentos de cada constructor contra su aridad (aridad 2 con un solo argumento es el error más común).
- **Paréntesis:** abiertos vs. cerrados, sobre todo en una llamada recursiva pasada como argumento: `f (g x) (h y)`.
- **`let`:** cada `let` lleva su `in`; no se encadenan dos `let` sin cerrar el primero.
- **Firmas:** para cada llamada, mirá la firma; los argumentos coinciden de izquierda a derecha.
- **Negación:** es `not`, no `!`.
- **Nombres:** en la demo, usá el nombre real de la variable del contexto, no el de otra definición.
- **HI:** ¿la usaste? ¿en qué paso? Si ningún caso inductivo la usa, revisá ese caso.
- **Casos:** ¿cubrís todos los constructores de la declaración `data`?
- **Ejemplos:** probá tu función contra los del enunciado, no solo contra tu intuición.
- **Restricciones:** ¿hay `elem` o recorrido extra donde pedían "único recorrido"? ¿recursión explícita donde pedían esquemas?

## 2. "Sin recursión explícita" / esquemas (`fold`, `rec`)

- La restricción es sobre **el tipo que recorrés en la función que escribís ahora**.
  - Seguís pudiendo llamar funciones ya definidas, aunque usen recursión: eso es aplicar, no recurrir.
- Si recorrés un tipo cuyo esquema no te pidieron en otro ejercicio, armalo igual: es prerrequisito implícito.
- **`fold` vs `rec`:**
  - `fold`: en cada campo recursivo te da solo el resultado ya procesado (`b`).
  - `rec`: además te da la subestructura original sin procesar.
  - Pista: "recorro todo y devuelvo un resumen" → `fold`. "Necesito el original, no solo su resultado" → `rec` (típico en funciones que simplifican o reconstruyen comparando contra el original).
- **Caso base compartido:** el esquema usa un único valor para el caso base.
  - Si el mismo constructor "vacío" significa cosas distintas según el campo donde aparece, la distinción se hace **a mano dentro del combinador**. El esquema no la resuelve solo.

## 3. Reconocer la forma del problema

Casi todo "definir función sobre tipo recursivo" es una de estas formas, cambie el dominio que cambie. Identificá cuál antes de escribir.

| Forma | Qué hacer |
| :---- | :---- |
| **Lista disfrazada** (base vacío + caso que agrega un elemento) | Suele ser `length`, `sum`, `maximum` con otro nombre. No inventes el algoritmo de cero. |
| **Dos ramas en simultáneo** (avanzan a la par) | Combinás elemento a elemento. Si una termina antes, la otra sigue sola. |
| **Dos ramas, una alimenta a la otra** (la salida de la primera es el punto de partida de la segunda) | Si la primera falla, la segunda ni se intenta: el resultado global es el fallo. |
| **Ramificación con solo dos campos recursivos** (conceptualmente N alternativas) | Un campo es "la continuación real", el otro "otra alternativa al mismo nivel": roles distintos. Lo que se propaga por uno no se propaga por el otro. |
| **Colapsar cadenas de constructores repetidos** | Recursá primero al hijo y **después** mirá si el resultado ya procesado matchea el mismo constructor. Así colapsás cadenas de largo arbitrario, no solo pares. |
| **Simplificar solo un caso puntual** | Detectalo con pattern matching de la forma exacta. **Nunca** evalúes con un valor de prueba inventado: puede dar un resultado incorrecto y silencioso. Mejor un fallo explícito. |
| **Fusionar dos secuencias ordenadas** | Dos punteros: comparás cabezas y avanzás **solo** la que ganó; la otra queda pendiente. Con orden y sin repetidos garantizados, nunca hace falta `elem`. Ver `compare` en §5. |
| **Contar pasos, tamaño o altura con ramificación** | Definí qué cuenta como unidad (¿el nodo de ramificación suma?). Aplicá cada incremento **solo** al lado que lo atraviesa; no "repartas" un incremento a ramas que no pasan por ahí. |

## 4. Estructura de una demostración

### Las 3 columnas
1. Signo `=`.
2. El paso (expresión).
3. La justificación (definición, HI o lema).

### Plantilla completa (en orden, con las frases exactas)

Reemplazar lo que está entre `<>`.

**"El enunciado"** = la propiedad que el parcial te pide demostrar. En toda esta plantilla el enunciado de ejemplo es:

```
¿ para todo f, g. (map f . map g) = map (f . g) ?
```

(`f` y `g` son funciones; la lista aparece recién cuando aplicás extensionalidad en el Paso 1.)

**Paso 0 — nombrar las variables "de afuera" (opcional)**

Idea: el enunciado de ejemplo habla de **tres** cosas: `f`, `g` y una lista. Solo sobre la lista hacés inducción; `f` y `g` son funciones cualesquiera que **no se tocan** en toda la demo. El Paso 0 es una línea que lo deja dicho:

```
Sea f y g funciones cualesquiera.
```

Eso es todo: no calcula nada, solo avisa "de acá en adelante `f` y `g` son nombres de funciones cualquiera, y no voy a hacer casos sobre ellas". 

Si tus demos no lo usan, **salteá este paso** y empezá en el Paso 1: la demo sale igual.

**Paso 1 — extensionalidad** (propiedad como igualdad de funciones point-free):

```
Por principio de extensionalidad, siendo xs una lista cualquiera, quiero ver que:
    ¿ (map f . map g) xs = map (f . g) xs ?
```

**Paso 2 — desarmar operadores punto-libre** (`.`, `flip`, etc.; uno por cada operador que quede aplicado):

```
por def. de compose, es equivalente decir:
    ¿ map f (map g xs) = map (f . g) xs ?
```

**Paso 3 — anunciar el tipo de demo.**

Estructural (sobre el tipo de dato):

```
por principio de induccion estructural sobre la estructura de xs
```

Análisis de casos sobre valores (un booleano, o qué constructor concreto tiene un `Value`):

```
por analisis de casos sobre b
```

**Paso 4 — planteo de TODOS los casos, sin desarrollar** (uno por constructor o por condición).

```
casoBase) siendo xs = []
    ¿ map f (map g []) = map (f . g) [] ?

casoInductivo) siendo x un elemento cualquiera y ys una lista cualquiera. xs = x : ys
    HI) ¡ map f (map g ys) = map (f . g) ys !
    TI) ¿ map f (map g (x : ys)) = map (f . g) (x : ys) ?
```

- Un solo `HI)` sin numerar si hay un solo campo recursivo; `HI1)` / `HI2)` si hay dos.
- En análisis de casos cada planteo lleva su condición en vez de un constructor:

```
c1) siendo n cualquiera. n = 0
c2) siendo n cualquiera. n /= 0
```

- Para "todo lo demás" escribí el complemento como disyunción de negaciones (`ó`), **nunca** conjunción. Ver "Demo por casos".

**Paso 5 — desarrollar cada caso, uno por uno.**

```
casoBase)
    LI: map f (map g [])
      = map f []            -- map.1
      = []                  -- map.1
    LD: map (f . g) []
      = []                  -- map.1
    Vale para este caso.
```

En un `casoInductivo` la justificación de algún paso es `HI`, `HI1 y HI2` o el nombre de un lema, en vez de `<funcion>.<n>`:

```
casoInductivo)
    LI: map f (map g (x : ys))
      = map f (g x : map g ys)          -- map.2
      = f (g x) : map f (map g ys)      -- map.2
      = f (g x) : map (f . g) ys        -- HI
    LD: map (f . g) (x : ys)
      = (f . g) x : map (f . g) ys      -- map.2
      = f (g x) : map (f . g) ys        -- def. de compose
    Vale para este caso.
```

**Paso 6 — cierre**, cuando todos los casos dieron bien:

```
La propiedad vale.
```

**Resultado final: la demo completa, de corrido** (los pasos 0 a 6 juntos; lo único que queda a la derecha es la justificación de cada paso):

```
¿ para todo f, g. (map f . map g) = map (f . g) ?

Sea f y g funciones cualesquiera.

Por principio de extensionalidad, siendo xs una lista cualquiera, quiero ver que:
    ¿ (map f . map g) xs = map (f . g) xs ?
por def. de compose, es equivalente decir:
    ¿ map f (map g xs) = map (f . g) xs ?

por principio de induccion estructural sobre la estructura de xs

casoBase) siendo xs = []
    ¿ map f (map g []) = map (f . g) [] ?

casoInductivo) siendo x un elemento cualquiera y ys una lista cualquiera. xs = x : ys
    HI) ¡ map f (map g ys) = map (f . g) ys !
    TI) ¿ map f (map g (x : ys)) = map (f . g) (x : ys) ?

casoBase)
    LI: map f (map g [])
      = map f []                        -- map.1
      = []                              -- map.1
    LD: map (f . g) []
      = []                              -- map.1
    Vale para este caso.

casoInductivo)
    LI: map f (map g (x : ys))
      = map f (g x : map g ys)          -- map.2
      = f (g x) : map f (map g ys)      -- map.2
      = f (g x) : map (f . g) ys        -- HI
    LD: map (f . g) (x : ys)
      = (f . g) x : map (f . g) ys      -- map.2
      = f (g x) : map (f . g) ys        -- def. de compose
    Vale para este caso.

La propiedad vale.
```

### Frases sueltas por situación

| Situación | Frase exacta |
| :---- | :---- |
| Nombrar variables de afuera (Paso 0, opcional) | `Sea <var1> y <var2> <tipo> cualquiera.` |
| Aplicar extensionalidad | `Por principio de extensionalidad, siendo <var> un/a <TIPO> cualquiera, quiero ver que:` |
| Desarmar `(.)` | `por def. de compose, es equivalente decir:` |
| Desarmar `flip` | `por def. de flip, es equivalente decir:` (o, como justificación de un paso: `flip`) |
| Anunciar inducción | `por principio de induccion estructural sobre la estructura de <var>` |
| Anunciar análisis de casos | `por analisis de casos sobre <var1>, <var2>, ...` |
| Caso base | `casoBase<N>) siendo <parámetros> cualquiera. <var> = <Constructor>` |
| Caso inductivo | `casoInductivo<N>) siendo <parámetros> cualquiera. <var> = <Constructor>` |
| Hipótesis inductiva | `HI<n>) ¡ <propiedad> !` |
| Tesis inductiva | `TI) ¿ <propiedad> ?` |
| Objetivo de un caso base | `¿ <propiedad> ?` (sin HI, va directo el objetivo) |
| Justificar por definición | `<funcion>.<n>` (nº de ecuación, contando desde la primera) |
| Justificar por HI | `HI` / `HI1` / `HI1 y HI2` |
| Justificar por lema | `<nombreDelLema>` |
| Cerrar un caso | `Vale para este caso.` (equivalente: `Para este caso vale.`) |
| Cerrar la demo | `La propiedad vale.` |
| Sub-caso en análisis de casos | `c<N>) siendo <parámetros> cualquiera. <var> = <forma concreta>` |
| Caso "todo lo demás" | `c<N>) <condición 1> ó <condición 2>` — **nunca "y"** |

### Extensionalidad: ¿sobre qué variable inducís?

Si la propiedad es una igualdad de funciones y además trae otra variable (ej. `f` en `(map f . map g) = map (f . g)`), hay **dos** variables:
- **La que ya está escrita (`f`, `g`):** se deja como está durante toda la demo. No inducís sobre ella.
- **La que aparece al aplicar extensionalidad (`xs`):** `h = k` significa "para todo `xs`, `h xs = k xs`". **Sobre esa** hacés inducción: los `casoBase` / `casoInductivo` son casos del tipo recursivo.

Antes de abrir casos, fijate cuál tiene el tipo recursivo: esa es la que se abre en casos.

### Usar la HI (o un lema)

- **Sustituí la expresión entera**, sin wrapper de más. Si la HI dice `f x = g x`, reemplazar `f x` te da `g x`, no algo envuelto alrededor de `g x`.
- **Alarma:** si un caso inductivo "cierra" sin usar la HI, algo está mal (falta abrir un caso, o se asume algo que depende de ella).
- **Lemas:** sacan una sub-demo que se repetiría en varios casos.
  - **Necesitan su propia demo**; no son gratis por enunciarlos.
  - Si la función del lema no es recursiva, no hace falta inducción: alcanza con abrir casos según sus ecuaciones.

### Demo por casos (no estructural)

Ejemplo: probar `leer (responder m1 m2) = leer m1 ++ leer m2` con

```haskell
responder Eliminado r = r              -- responder.1
responder o Eliminado = o              -- responder.2
responder o r         = Respuesta o r  -- responder.3
```

```
c1) m1 = Eliminado
c2) m1 /= Eliminado, m2 = Eliminado
c3) m1 /= Eliminado, m2 /= Eliminado
```

Tres reglas:
- **Exhaustivos:** el complemento de "A y B" es "no A **o** no B". Con "y" quedan afuera los mixtos (`m1 = Eliminado`, `m2 = Texto "a"`). Chequeá que ninguna combinación quede sin cubrir (ej. los dos `Eliminado`).
- **Sin valores concretos:** en c3 no escribas `m1 = Texto "a"` (probarías un ejemplo). Dejá `m1` y `m2` como variables con su condición.
- **Comodín:** en c3 la condición ya hace que `responder.1` y `.2` no apliquen, así que usás `responder.3` directo. No abras `m1` en sus constructores.

### Demo con `if` (caso general: casarte sobre la condición)

Si `f x = if <cond> then <e1> else <e2>` y tenés que desarrollar `f x` en una demo:
- La única forma de abrir el `if` es casar sobre `<cond>`: `c1) <cond> = True`, `c2) <cond> = False`.
- Una vez fijado el valor, el `if` pasa a ser la rama que corresponde (`<e1>` o `<e2>`) y seguís la cadena como siempre.
- Es exhaustivo por construcción: un `Bool` es `True` o `False`. Acá no hace falta cuidar AND/OR.

**Atajo:** solo aplica con un `if` anidado dentro de otro `if` **y** la `<cond>` de ambos niveles es **exactamente la misma expresión**. En vez de abrir los 4 casos (`b1`, `b2` en `True/True`, `True/False`, `False/True`, `False/False`), podés citar directamente:

```haskell
if b then (if b then x else y) else z   =   if b then x else z
```

<!-- TODO: completar la frase exacta de justificación que usás para el atajo (no se pudo inferir) -->

Si las condiciones **no** son la misma expresión, no aplica: abrí los casos combinados de `b1` / `b2` uno por uno.

## 5. Funciones que aparecen todo el tiempo

Verificadas con `runghc`.

### Orden superior y combinadores

| Función | Tipo | Para qué sirve / ejemplo |
| :---- | :---- | :---- |
| `flip` | `(a -> b -> c) -> b -> a -> c` | Invierte los dos primeros argumentos. Útil si tenés `f :: A -> B -> C` y necesitás `B -> C` con `A` ya fijo. `flip (-) 1 5 = 4` |
| `(.)` | `(b -> c) -> (a -> b) -> a -> c` | Compone sin nombrar el argumento intermedio. `(f . g) x = f (g x)` |
| `($)` | `(a -> b) -> a -> b` | Aplicación como operador; evita paréntesis. `f $ g $ h x = f (g (h x))` |
| `id` | `a -> a` | No hace nada. Placeholder cuando no importa la función (no siempre es seguro para "simular" un valor real, ver §3). |
| `const` | `a -> b -> a` | Ignora el 2.º argumento. `const 1 "x" = 1` |
| `flip const` | `a -> b -> b` | Ignora el 1.º. No tiene nombre propio: `flip const` o `\_ y -> y`. |
| `subtract` | `Num a => a -> a -> a` | `subtract n = \y -> y - n`. Existe porque `(- n)` **no** es una sección (se lee como el número `-n`). Para restar `n` en punto libre: `map (subtract 1) xs`. |
| `curry` | `((a,b) -> c) -> a -> b -> c` | Función sobre par -> función currificada. |
| `uncurry` | `(a -> b -> c) -> (a,b) -> c` | Inversa de `curry`. `uncurry (+) (1,2) = 3` |
| `twice` (no estándar) | `(a -> a) -> a -> a` | `twice f = f . f`; `twice f x = f (f x)`. Se define en la cátedra. |
| `compare` | `Ord a => a -> a -> Ordering` | Devuelve `LT`, `EQ` o `GT`. `compare 1 2 = LT`, `compare 2 2 = EQ`, `compare 3 2 = GT`. Con `data Ordering = LT \| EQ \| GT`. |

`compare`, uso típico: un `case` en vez de guards, p. ej. en el merge de dos listas ordenadas.

```haskell
merge (x:xs) (y:ys) = case compare x y of
  LT -> x : merge xs (y:ys)
  EQ -> x : merge xs ys
  GT -> y : merge (x:xs) ys
```

### Listas

| Función | Tipo | Para qué sirve / ejemplo |
| :---- | :---- | :---- |
| `map` | `(a -> b) -> [a] -> [b]` | Aplica una función a cada elemento, preservando la forma. |
| `filter` | `(a -> Bool) -> [a] -> [a]` | Se queda con los que cumplen el predicado. |
| `null` | `[a] -> Bool` | ¿Vacía? Sirve para distinguir a mano los dos sentidos de un caso base compartido en un fold (§2). |
| `(++)` | `[a] -> [a] -> [a]` | Concatena. Suele ser lo que hace por debajo la secuencia de dos sub-resultados. |
| `replicate` | `Int -> a -> [a]` | `n` copias del elemento: `replicate 2 'a' = "aa"`. Lista de `n` elementos, no un elemento que contiene `n` cosas. |
| `zip` | `[a] -> [b] -> [(a,b)]` | Empareja elemento a elemento. Se corta en la más corta (no acarrea el resto). |
| `zipWith` | `(a -> b -> c) -> [a] -> [b] -> [c]` | Como `zip` pero combinando con una función: `zipWith f xs ys = map (uncurry f) (zip xs ys)`. Mismo corte en la más corta (§3, "dos ramas en simultáneo"). |
| `lookup` | `Eq a => a -> [(a,b)] -> Maybe b` | Busca por clave. `lookup 2 [(1,"a"),(2,"b")] = Just "b"`; `lookup 3 [(1,"a")] = Nothing` |
| `find` | `Foldable t => (a -> Bool) -> t a -> Maybe a` | Primer elemento que cumple (de `Data.List`). `find even [1,3,4,5] = Just 4`; `find even [1,3] = Nothing` |

### Pares

| Función | Tipo | Para qué sirve / ejemplo |
| :---- | :---- | :---- |
| `uflip` (no estándar) | `(a -> b -> c) -> (a,b) -> c` | "flip sin currificar": `uflip f (x,y) = f y x`. Es `uncurry (flip f)`; fijate si tu cátedra lo define distinto. |

### Maybe / Either

`data Maybe a = Nothing | Just a` · `data Either a b = Left a | Right b`

| Función | Tipo | Para qué sirve / ejemplo |
| :---- | :---- | :---- |
| `Nothing` / `Just` | `Maybe a` / `a -> Maybe a` | Constructores: "no hay resultado" / "hay uno". |
| `maybe` | `b -> (a -> b) -> Maybe a -> b` | Destructor: evita el `case`. `maybe 0 (+1) Nothing = 0`; `maybe 0 (+1) (Just 2) = 3` |
| `fromMaybe` | `a -> Maybe a -> a` | Valor por defecto si es `Nothing`. `fromMaybe 0 Nothing = 0`; `fromMaybe 0 (Just 3) = 3` |
| `isJust` / `isNothing` | `Maybe a -> Bool` | Test de constructor. `isJust (Just 1) = True`; `isNothing (Just 1) = False` |
| `fromJust` | `Maybe a -> a` | Saca el valor. **Parcial: error si es `Nothing`.** Evitala; usá `fromMaybe` o `case`. |
| `catMaybes` | `[Maybe a] -> [a]` | Descarta los `Nothing`. `catMaybes [Just 1, Nothing, Just 3] = [1,3]` |
| `mapMaybe` | `(a -> Maybe b) -> [a] -> [b]` | `map` + descartar fallos. `mapMaybe (\x -> if x > 1 then Just (x*2) else Nothing) [1,2,3] = [4,6]` |
| `listToMaybe` | `[a] -> Maybe a` | Primer elemento, si hay. `listToMaybe [1,2,3] = Just 1`; `listToMaybe [] = Nothing` |
| `maybeToList` | `Maybe a -> [a]` | `maybeToList (Just 1) = [1]`; `maybeToList Nothing = []` |
| `fmap` / `(<$>)` | `(a -> b) -> Maybe a -> Maybe b` | Aplica `f` adentro del `Just`; `Nothing` pasa igual. `fmap (+1) (Just 1) = Just 2`; `(+1) <$> Nothing = Nothing` |
| `(>>=)` | `Maybe a -> (a -> Maybe b) -> Maybe b` | Encadena pasos que pueden fallar; el primer `Nothing` corta todo. `Just 4 >>= \x -> if x > 0 then Just (x-1) else Nothing = Just 3` |
| `do` sobre Maybe | — | Azúcar de `>>=`: `do { a <- Just 1; b <- Nothing; return (a+b) } = Nothing` |
| `(<\|>)` | `Maybe a -> Maybe a -> Maybe a` | De `Control.Applicative`. Primer `Just`. `Nothing <\|> Just 1 <\|> Just 2 = Just 1` |
| `either` | `(a -> c) -> (b -> c) -> Either a b -> c` | Como `maybe` pero para `Either`: una función u otra según el lado. `either length (+1) (Left "ab") = 2`; `either length (+1) (Right 1) = 2` |
| `Left` / `Right` | `a -> Either a b` / `b -> Either a b` | Constructores. Por convención `Left` = error (con información), `Right` = éxito. |

Imports: `Data.Maybe` (`fromMaybe`, `isJust`, `isNothing`, `fromJust`, `catMaybes`, `mapMaybe`, `listToMaybe`, `maybeToList`), `Data.List` (`find`), `Control.Applicative` (`<|>`). `maybe`, `either` y `lookup` vienen en el Prelude.

### Mini-receta: funciones que pueden fallar

1. **Si puede no haber resultado -> devolvé `Maybe`** (no `error`, no un valor "mágico").
2. **Propagar el fallo**, de menos a más compacto:
   - `case`:
     ```haskell
     g x = case f x of
       Nothing -> Nothing
       Just y  -> h y
     ```
   - `fmap` si el paso siguiente **no** falla: `fmap h (f x)`.
   - `>>=` si el paso siguiente **también** puede fallar: `f x >>= h`.
   - Varios pasos: `do { y <- f x; z <- h y; return (k z) }`.
3. **Cuándo un auxiliar que devuelva `Maybe`:** cuando una búsqueda o chequeo auxiliar puede fallar, y la función principal necesita distinguir "no encontré" de "encontré". Ej. (parcial de Acueductos): auxiliar `buscar :: ... -> Maybe X`, y la principal lo consume con `case`/`>>=`/`fromMaybe`.
4. **Alternativas:** `<|>` prueba la segunda opción solo si la primera es `Nothing`.
5. **Al combinar en un esquema** (`fold`/`rec`), recordá la forma "dos ramas, una alimenta a la otra" (§3): si la primera da `Nothing`, el global es `Nothing`.

## 6. Sintaxis que conviene tener fresca

**`let ... in`**
- Es una **expresión**: va donde pueda ir un valor (dentro de un `if`, como argumento, etc.).
- Todo `let` necesita su `in`. No se encadenan dos `let` sin cerrar el primero:
  ```haskell
  let a = 1 in let b = 2 in a + b
  ```
- Varias bindings del mismo `let` van alineadas en columna, sin `;` ni `,`: el layout las separa por indentación.

**`where`**
- **No** es una expresión: se pega después de una ecuación completa (función o patrón), no suelto en medio de otra expresión.
- Su scope cubre **todas** las guards y el cuerpo de esa ecuación: conviene si el mismo valor auxiliar se usa en varias guards.
- Cada ecuación tiene su propio `where`; no se comparte entre ecuaciones.

**`case ... of`**
- Es una **expresión**: a diferencia del matching por ecuaciones, sirve sobre cualquier valor intermedio sin nombrarlo como argumento.
- Los patrones se prueban de arriba hacia abajo; gana el primero que matchea.

**Guards (`|`)**
- Se evalúan de arriba hacia abajo; gana la primera que da `True`.
- Si ninguna matchea y no hay catch-all, error en ejecución. En vez de `otherwise` como última guard, podés cerrar con una ecuación aparte con comodín (`f _ = ...`) después de las guards, o con un patrón `_` si estás en un `case`.

**Lambda (`\x -> ...`)**
- Función anónima, útil para pasar un comportamiento "de una sola vez" (a `map`, `filter`, un campo de tipo función de un constructor).
- Varios argumentos: `\x y -> ...` es lo mismo que `\x -> \y -> ...`.

**Secciones**
- Aplicación parcial de un operador infijo, escribiendo un solo lado entre paréntesis: `(+ 1)`, `(2 *)`.
- Ojo con `-`: `(- n)` **no** es sección (se lee como `-n`). Para "restar `n`" usá `subtract n` (§5).

## Apéndice — plantilla de demo en inducción estructural

Tipo y funciones de ejemplo:

```haskell
data Lista = Vacia | Cons Int Lista

long :: Lista -> Int
long Vacia      = 0              -- long.1
long (Cons x r) = 1 + long r     -- long.2

dup :: Lista -> Lista
dup Vacia      = Vacia                    -- dup.1
dup (Cons x r) = Cons x (Cons x (dup r)) -- dup.2
```

Propiedad: `long . dup = (2 *) . long`

```
Por principio de extensionalidad, siendo l una Lista cualquiera, quiero ver que:
    ¿ (long . dup) l = ((2 *) . long) l ?

por def. de compose, es equivalente decir:
    ¿ long (dup l) = 2 * long l ?

por principio de induccion estructural sobre la estructura de l

casoBase) siendo l = Vacia
    ¿ long (dup Vacia) = 2 * long Vacia ?

casoInductivo) siendo x un Int cualquiera y r una Lista cualquiera. l = Cons x r
    HI) ¡ long (dup r) = 2 * long r !
    TI) ¿ long (dup (Cons x r)) = 2 * long (Cons x r) ? 

DEMO:

casoBase)
    LI: long (dup Vacia)
      = long Vacia          -- dup.1
      = 0                   -- long.1
    LD: 2 * long Vacia
      = 2 * 0               -- long.1
      = 0                   -- aritm.
    Vale para este caso.

casoInductivo)
    LI: long (dup (Cons x r))
      = long (Cons x (Cons x (dup r)))   -- dup.2
      = 1 + long (Cons x (dup r))        -- long.2
      = 1 + (1 + long (dup r))           -- long.2
      = 1 + (1 + 2 * long r)             -- HI
    LD: 2 * long (Cons x r)
      = 2 * (1 + long r)                 -- long.2
      = 2 + 2 * long r                   -- aritm.
      = 1 + (1 + 2 * long r)             -- aritm.
    Vale para este caso.

La propiedad vale.
```
