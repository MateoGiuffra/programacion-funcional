# Guía de parciales — Programación Funcional (UNQ)

## Resumen (leé solo esto si tenés apuro)

**Demo en 7 líneas:**
1. **Extensionalidad:** `f = g` pasa a `f xs = g xs`.
2. **Desarmá `(.)`** (y `flip`, etc.) con su frase.
3. **Inducción** sobre la variable de tipo recursivo (la que apareció en 1).
4. **Planteá TODOS los casos** sin desarrollar: `casoBase)`, `casoInductivo)` con `HI)` y `TI)`.
5. **Desarrollá** cada caso con `LI)` y `LD)`, una ecuación por paso y su justificación.
6. **HI en el paso clave:** si un inductivo cierra sin usarla, algo falla.
7. **Cierre:** `Vale para este caso.` en cada uno y `La propiedad vale.` al final.

**Código:** pensá primero (§0), reconocé la forma (§3), armá `fold`/`rec` (§2), chequeá sintaxis (§1).

## 0. Intuición antes de programar

- **Precondición = pista de diseño:** "ordenadas y sin repetidos" te ahorra un chequeo. Si parece "de adorno", la estás dejando pasar.
- **Complejidad = restricción de diseño:** "un único recorrido" descarta ideas antes de empezar.
- **Reconocé, no inventes:** casi todo es un patrón conocido (§3).
- **Simulá a mano un caso chico** antes de tipear.
- **Invariante en una frase** antes de la recursión: "en cada llamada, prometo que ___". Es casi la misma que usás en la demo.

## 1. Recordatorios generales

**Datos del enunciado:** los ejemplos pueden venir mal transcriptos. Auditalos sin tu implementación:
- Si algo se repite con período `p`, posiciones congruentes módulo `p` dan lo mismo.
- Un elemento no puede aparecer antes que el que lo precede.
- Contá duraciones, tamaños y pasos a mano.

**Chequeo final** (no hay ghci: a ojo), solo sintaxis y tipos:
- **Aridad:** argumentos de cada constructor vs. su aridad (aridad 2 con un argumento es el error más común).
- **Paréntesis:** sobre todo en llamadas pasadas como argumento: `f (g x) (h y)`.
- **`let`:** cada uno lleva su `in`.
- **Firmas:** los argumentos de cada llamada coinciden de izquierda a derecha.
- **Negación:** `not`, no `!`.

## 2. Cómo armar `fold` y `rec`

**Receta en 3 pasos:**
1. Un argumento por constructor, en el orden del `data`, y el valor recorrido al final.
2. En cada constructor, los campos recursivos pasan a ser `b`; los demás quedan igual y en su lugar. El resultado es `b`.
3. En `rec`, cada campo recursivo `e` pasa a ser **dos** argumentos adyacentes: el original `e` y su resultado `b` (con dos campos: `t1 (rec t1) t2 (rec t2)`).

- Siempre con signatura. Se usa en **punto libre** (*point-free*: definir una función **sin nombrar sus argumentos**, ej. `doble = map (*2)` en vez de `doble xs = map (*2) xs`), o sea `f = foldRed a b c d`. El caso base es `... -> b`.
- **`fold` te da solo `b`; `rec` te da además el original `e`.** Usá `rec` si necesitás volver a mirar la forma del hijo.

**Ejemplo y plantilla** (`incidente-en-el-nucleo.hs:223-236`), con `data Red = Terminal Potencia | Servidor Potencia Red | Firewall (Ataque -> Bool) Red | Switch (Ataque -> Dir) Red Red`. Muestra los tres casos: base (`Terminal`), un campo recursivo más campos no recursivos (`Servidor`, `Firewall`) y dos campos recursivos (`Switch`):

```haskell
foldRed :: (Potencia -> b) -> (Potencia -> b -> b) -> ((Ataque -> Bool) -> b -> b) -> ((Ataque -> Dir) -> b -> b -> b) -> Red -> b
foldRed t s fw sw (Terminal n)       = t n
foldRed t s fw sw (Servidor n r)     = s n (foldRed t s fw sw r)
foldRed t s fw sw (Firewall f r)     = fw f (foldRed t s fw sw r)
foldRed t s fw sw (Switch fsw ri rd) = sw fsw (foldRed t s fw sw ri) (foldRed t s fw sw rd)

recRed :: (Potencia -> b) -> (Potencia -> Red -> b -> b) -> ((Ataque -> Bool) -> Red -> b -> b) -> ((Ataque -> Dir) -> Red -> b -> Red -> b -> b) -> Red -> b
recRed t s fw sw (Terminal n)       = t n
recRed t s fw sw (Servidor n r)     = s n r (recRed t s fw sw r)
recRed t s fw sw (Firewall f r)     = fw f r (recRed t s fw sw r)
recRed t s fw sw (Switch fsw ri rd) = sw fsw ri (recRed t s fw sw ri) rd (recRed t s fw sw rd)

combinarFirewalls' = foldRed Terminal Servidor combinar Switch   -- :236
```

**Punto libre: no declares el argumento recorrido.** Evitá nombrar el valor sobre el que corre el fold:

```haskell
-- evitar
combinarFirewalls' firewall = foldRed Terminal Servidor combinar Switch firewall

-- así (incidente-en-el-nucleo.hs:236)
combinarFirewalls' = foldRed Terminal Servidor combinar Switch
```

**Si la función recibe un parámetro extra ANTES del valor recorrido** (`f :: a -> Red -> Red`), el fold devuelve una función que espera ese parámetro (`foldRed ... :: Red -> (a -> Red)`), así que el orden de los argumentos queda al revés. Se arregla con `flip`:

```haskell
f :: a -> Red -> Red
f = flip (foldRed ...)
```

Ej. real (`multiset.hs:345-355`): el parámetro extra es el predicado `f`; el esquema recibe `f` en cada combinador y lo reparte a los hijos:

```haskell
filterMSE' :: (a -> Bool) -> MSExp a -> MSExp a
filterMSE' = flip (foldMSExp
        (\f -> EmptyMS)
        (\y rs f -> if f y then AddMS y (rs f) else rs f)
        ...
        (\g rs f -> MapMS g (rs (f . g))))
```

Otro real: `primerasNCapas = flip (pizzaProcesada pasoNCapas siemprePrepizza)` (`tps/tp-11/implementacion/con-fold.hs:132`).

Con **dos o más** parámetros extra un solo `flip` no alcanza: `occursMESWith'` (`multiset.hs:336`) los deja como argumentos explícitos (`... ms x f`).

Uso real de `rec` (`nim.hs:41-43`):

```haskell
maxHeap = recNim (error "no puede haber maximo en una pila vacia")
                 (\n nim rs -> if rs > n then rs else n)
```

**Sin recursión explícita:** la restricción es sobre el tipo que recorrés **ahora**. Podés llamar funciones ya definidas, aunque sean recursivas. Si necesitás el esquema de otro tipo y no te lo pidieron, armalo igual.

**Caso base compartido:** el esquema tiene un solo valor para el caso base. Si el mismo constructor significa cosas distintas según el campo, distinguilo **a mano en el combinador**.
- Ej.: `Nil` de `GameTree` es base de hijos y de hermanos, con el mismo `0` (`nim.hs:53`: `gameHeight = foldGame 0 (max . (+1) . snd)`).
- A mano: `responder` trata `Eliminado` distinto como 1.º o 2.º argumento (`generados/003-mensajeria-parcial.hs:26-29`).

**Errores típicos:**
- Llamar sin pasar los esquemas: `foldRed t1` en vez de `foldRed t s fw sw t1`.
- Poner el árbol antes que los esquemas.
- Orden de argumentos distinto al de los constructores.
- Patrón con nombre repetido (sombra).

## 3. Reconocer la forma del problema

Identificá la forma antes de escribir. Ejemplos de parciales resueltos (`parciales/resolucion/mia/`):

| Forma | Qué hacer | Ejemplo |
| :---- | :---- | :---- |
| **Lista disfrazada** (base vacío + agrega un elemento) | Suele ser `length`, `sum`, `maximum` con otro nombre. | `nim.hs:36-39`: `heaps = foldNim 0 (\n rs -> rs + 1)` es `length`; `chips = foldNim 0 (+)` es `sum` |
| **Dos ramas en simultáneo** | Combinás elemento a elemento; si una termina antes, la otra sigue sola. | `animaciones.hs:62-65`: `unir (xs:xss) (ys:yss) = (xs ++ ys) : unir xss yss`, más los casos con una lista vacía |
| **Dos ramas, una alimenta a la otra** | Si la primera falla, la segunda ni se intenta. | `incidente-en-el-nucleo.hs:40-42`: `Just aIzq -> intensidadRestante aIzq ri`; `Nothing -> Nothing` |
| **Dos campos recursivos con roles distintos** | Uno es la continuación real, el otro "otra alternativa al mismo nivel". Lo que se propaga por uno no por el otro. | `nim.hs:8-13` (`Node (Move, GameTree) GameTree`: hijos vs. hermanos); `:54` el `+1` solo se aplica al hijo |
| **Colapsar cadenas de constructores repetidos** | Recursá primero al hijo y **después** mirá si el resultado matchea el mismo constructor. | `incidente-en-el-nucleo.hs:24,28`: `combinarFirewalls (Firewall f r) = combinar f (combinarFirewalls r)`; `combinar f (Firewall f2 r) = Firewall (\a -> f a && f2 a) r` |
| **Simplificar solo un caso puntual** | Pattern matching de la forma exacta. **Nunca** evalúes con un valor de prueba inventado. | `calabozos.hs:44-45`: `consBif Salida _ Salida = Salida`; `consBif ci g cd = Bifurcacion ci g cd` |
| **Fusionar dos secuencias ordenadas** | Dos punteros: comparás cabezas y avanzás **solo** la que ganó. Con orden y sin repetidos no hace falta `elem`. | Bloque de abajo (versión real con `if`: `animaciones.hs:27-35`) |
| **Contar pasos, tamaño o altura** | Definí qué es una unidad; aplicá el incremento **solo** al lado que lo atraviesa. | `animaciones.hs:40-41`: `Sec` suma (`d a1 + d a2`), `Par` toma `max` |

```haskell
merge (x:xs) (y:ys) = case compare x y of
  LT -> x : merge xs (y:ys)
  EQ -> x : merge xs ys
  GT -> y : merge (x:xs) ys
```

## 4. Estructura de una demostración

Tres columnas: `=`, el paso, la justificación.

### Los 7 pasos (frases en el acordeón de abajo)

0. *(Opcional)* Nombrar las variables de afuera. Ver "Frases".
1. **Extensionalidad**, y ahí aparece la variable sobre la que inducís.
2. **Desarmar** `(.)`, `flip`, etc., uno por cada operador aplicado.
3. **Anunciar** el tipo de demo: inducción estructural (sobre un tipo de dato) o análisis de casos (sobre valores, p. ej. si `m1` es `Eliminado` o no).
4. **Plantear TODOS los casos** sin desarrollar, con `HI)` y `TI)` en los inductivos.
5. **Desarrollar** cada caso con `LI)` y `LD)`; justificación `<funcion>.<n>`, `HI` o nombre de lema.
6. **Cerrar** cada caso y la demo.

**Paso 0 y "¿sobre qué inducís?" (lo mismo):** en `(map f . map g) = map (f . g)` hay tres cosas: `f`, `g` y la lista. `f` y `g` no se tocan en toda la demo y se declaran con `Sea f y g funciones cualesquiera.` (si no usás el Paso 0, saltealo). La que aparece **al aplicar extensionalidad** (`xs`) es la del tipo recursivo: sobre esa abrís casos.

- Un `HI)` si hay un campo recursivo; `HI1)` / `HI2)` si hay dos.
- Análisis de casos: cada planteo lleva su condición en vez de un constructor (`c1) n = 0`, `c2) n /= 0`).
- Para "todo lo demás": disyunción de negaciones (`ó`), **nunca** conjunción.

### Ejemplo completo: `long . dup = (2 *) . long`

```haskell
data Lista = Vacia | Cons Int Lista

long :: Lista -> Int
long Vacia      = 0              -- long.1
long (Cons x r) = 1 + long r     -- long.2

dup :: Lista -> Lista
dup Vacia      = Vacia                    -- dup.1
dup (Cons x r) = Cons x (Cons x (dup r)) -- dup.2
```

```
¿ long . dup = (2 *) . long ?

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

casoBase)
    LI) long (dup Vacia)
      = long Vacia          -- dup.1
      = 0                   -- long.1
    LD) 2 * long Vacia
      = 2 * 0               -- long.1
      = 0                   -- aritm.
    Vale para este caso.

casoInductivo)
    LI) long (dup (Cons x r))
      = long (Cons x (Cons x (dup r)))   -- dup.2
      = 1 + long (Cons x (dup r))        -- long.2
      = 1 + (1 + long (dup r))           -- long.2
      = 1 + (1 + 2 * long r)             -- HI
    LD) 2 * long (Cons x r)
      = 2 * (1 + long r)                 -- long.2
      = 2 + 2 * long r                   -- aritm.
      = 1 + (1 + 2 * long r)             -- aritm.
    Vale para este caso.

La propiedad vale.
```

### Frases (acordeón de consulta)

| Situación | Frase exacta |
| :---- | :---- |
| Variables de afuera (Paso 0) | `Sea <var1> y <var2> <tipo> cualquiera.` |
| Extensionalidad | `Por principio de extensionalidad, siendo <var> un/a <TIPO> cualquiera, quiero ver que:` |
| Desarmar `(.)` | `por def. de compose, es equivalente decir:` |
| Desarmar `flip` | `por def. de flip, es equivalente decir:` (o como justificación: `flip`) |
| Inducción | `por principio de induccion estructural sobre la estructura de <var>` |
| Análisis de casos | `por analisis de casos sobre <var1>, <var2>, ...` |
| Caso base / inductivo | `casoBase<N>) siendo <parámetros> cualquiera. <var> = <Constructor>` (igual con `casoInductivo<N>)`) |
| Hipótesis / tesis | `HI<n>) ¡ <propiedad> !` / `TI) ¿ <propiedad> ?` |
| Objetivo de un caso base | `¿ <propiedad> ?` (sin HI) |
| Lados | `LI)` / `LD)` |
| Justificar | `<funcion>.<n>` (ecuación, desde 1) · `HI` / `HI1 y HI2` · `<nombreDelLema>` |
| Cerrar caso / demo | `Vale para este caso.` (o `Para este caso vale.`) / `La propiedad vale.` |
| Sub-caso | `c<N>) siendo <parámetros> cualquiera. <var> = <forma concreta>` |
| "Todo lo demás" | `c<N>) <cond 1> ó <cond 2>` — **nunca "y"** |

### Usar la HI (o un lema)

- **Sustituí la expresión entera**, sin wrapper de más.
- **Alarma:** un caso inductivo que cierra sin HI está mal (falta abrir un caso o se asume algo).
- **Si hay más de una HI** (`HI1`, `HI2`), lo normal es usar **ambas en el mismo caso**, a veces en el mismo paso (`-- HI1 y HI2`). Ej.: `evalMSE (UnionMS e1 e2)` → `evalMSE (simpMSE e1) ++ evalMSE (simpMSE e2) = evalMSE e1 ++ evalMSE e2` (`PF_2021s2_P1-MultiSetLanguage`, caso `UnionMS`).
- Usá el nombre real de la variable del contexto, no el de otra definición.
- **Lemas:** sacan una sub-demo repetida. **Necesitan su propia demo**; si su función no es recursiva alcanza con abrir casos.
- **Un lema (afirmación general) NO usa la HI de la demo padre.** El lema vale para *cualquier* valor (`sean f y e cualesquiera`), y la HI solo habla de un subtérmino de ese caso: usarla sería suponer lo que todavía no probaste. Si el lema necesita inducción, tiene su **propia** HI. Si necesitás la HI para un paso, no es un lema: es un paso dentro del caso. Se ve en `LEMA-COMBINAR` (`incidente-en-el-nucleo.hs`: usa `combinar.2` y `intensidadRestante.3`, nada de la HI del padre) y en los lemas `evalMSE-simp*` del parcial de MultiSet.

### Demo por casos (no estructural)

Probar `leer (responder m1 m2) = leer m1 ++ leer m2` (`generados/003-mensajeria-parcial.hs:26-29`):

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

- **Exhaustivos:** el complemento de "A y B" es "no A **o** no B". Con "y" quedan afuera los mixtos.
- **Sin valores concretos:** en c3 no escribas `m1 = Texto "a"` (probarías un ejemplo).
- **Comodín:** en c3 `responder.1` y `.2` no aplican, usás `responder.3` directo sin abrir `m1`.

### Demo con `if`

Si `f x = if <cond> then <e1> else <e2>`, la única forma de abrir el `if` es casar sobre `<cond>`. Es exhaustivo por construcción (`True` o `False`, no hace falta cuidar AND/OR):

```
por analisis de casos sobre <cond>

caso1) <cond> = True
LI)
    f x
=                 def. f, ya que <cond> = True (entra por la rama del then)
    <e1>
=                 <siguiente justificación>
    ...

caso2) <cond> = False
LI)
    f x
=                 def. f, ya que <cond> = False (entra por la rama del else)
    <e2>
=                 <siguiente justificación>
    ...
```

- Ej. real (`incidente-en-el-nucleo.hs:35`): `if f a then intensidadRestante a r else Nothing`, con `caso1) f a = True` y `caso2) f a = False`.
- **Atajo (`if` anidado donde el `else` de los dos niveles es la misma expresión `e2`):** en vez de abrir los 4 casos de `b1`, `b2`, podés citar directamente:

```haskell
if b1 then (if b2 then e1 else e2) else e2  =  if (b1 && b2) then e1 else e2
```

- Si los `else` **no** son la misma expresión, el atajo no aplica: abrí los casos combinados de `b1` / `b2` uno por uno.

**Dos formas de resolverla.** Ejemplo (`004-demo-if`), con la propiedad `cantidad (mayores y xs) + cantidad (noMayores y xs) = cantidad xs`, donde `mayores y (Cons x xs) = if x > y then Cons x (mayores y xs) else mayores y xs` (y `noMayores` con el `if` al revés). En el `casoInductivo`, después de `mayores.2` y `noMayores.2`, aparecen **dos `if` con la misma condición** `x > y`:

**Forma A: casos adentro del `casoInductivo`** (la más directa; el `if` aparece una sola vez)

```
por analisis de casos sobre x > y

c1) x > y = True
c2) x > y = False

c1)
    cantidad (if x > y then Cons x (mayores y xs') else mayores y xs') + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
=                       def. if, ya que x > y = True
    cantidad (Cons x (mayores y xs')) + cantidad (noMayores y xs')
=                       cantidad.2
    (1 + cantidad (mayores y xs')) + cantidad (noMayores y xs')
=                       aritm (asociatividad de +)
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))
=                       HI
    1 + cantidad xs'
c2)   (igual, con def. if ya que x > y = False; `cantidad.2` deja `a + (1 + b)` y
       `aritm` usa conmutatividad y asociatividad para llegar a `1 + (a + b)`)
```

**Forma B: lema** (saca los casos de la cadena principal; vale si se reutiliza o querés una cadena corta)

```
En la cadena principal, tras noMayores.2:
    cantidad (if x > y ...) + cantidad (if x > y ...)
=                       LEMA-BOOL
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))
=                       HI
    1 + cantidad xs'

LEMA-BOOL)
    ¿ para todo x, y, xs'.
        cantidad (if x > y then Cons x (mayores y xs') else mayores y xs')
      + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
      = 1 + (cantidad (mayores y xs') + cantidad (noMayores y xs')) ?
Sean x, y, xs' cualesquiera.
por analisis de casos sobre x > y   (c1 y c2, igual que en la Forma A, y cada una
termina en el lado derecho del lema)
```

- **Regla en ambas:** el lado derecho lleva paréntesis (`1 + (a + b)`) para que la HI quede **literal**.
- **Un lema (afirmación general) no usa la HI de la demo padre.** La HI se usa en la cadena principal, no adentro del lema.
- Ejemplo completo de la Forma B: `parciales/resolucion/mia/004-demo-if-con-lema.hs`.

## 5. Funciones que aparecen todo el tiempo

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
| `compare` | `Ord a => a -> a -> Ordering` | `compare 1 2 = LT`; `compare 2 2 = EQ`; `compare 3 2 = GT`. Uso típico: el `case` de §3. |
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
| `null` | `[a] -> Bool` | ¿Vacía? Sirve para distinguir a mano un caso base compartido (§2). |
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

### Cómo se definen (por si no te acordás)

Verificadas con GHC. Las del Prelude se usan sin definir; esto es para entender qué hacen.

```haskell
-- listas
map f []     = []                                              -- map.1
map f (x:xs) = f x : map f xs                                  -- map.2
filter p []     = []                                           -- filter.1
filter p (x:xs) = if p x then x : filter p xs else filter p xs -- filter.2
foldr f z []     = z                                           -- foldr.1
foldr f z (x:xs) = f x (foldr f z xs)                          -- foldr.2
length []     = 0                                              -- length.1
length (_:xs) = 1 + length xs                                  -- length.2
sum []     = 0                                                 -- sum.1
sum (x:xs) = x + sum xs                                        -- sum.2
elem x []     = False                                          -- elem.1
elem x (y:ys) = x == y || elem x ys                            -- elem.2
[]     ++ ys = ys                                              -- (++).1
(x:xs) ++ ys = x : (xs ++ ys)                                  -- (++).2
concat []       = []                                           -- concat.1
concat (xs:xss) = xs ++ concat xss                             -- concat.2
any p []     = False                                           -- any.1
any p (x:xs) = p x || any p xs                                 -- any.2
all p []     = True                                            -- all.1
all p (x:xs) = p x && all p xs                                 -- all.2
zip []     _      = []                                         -- zip.1
zip _      []     = []                                         -- zip.2
zip (x:xs) (y:ys) = (x,y) : zip xs ys                          -- zip.3
zipWith f []     _      = []                                   -- zipWith.1
zipWith f _      []     = []                                   -- zipWith.2
zipWith f (x:xs) (y:ys) = f x y : zipWith f xs ys              -- zipWith.3
lookup k []         = Nothing                                  -- lookup.1
lookup k ((a,b):ps) = if k == a then Just b else lookup k ps   -- lookup.2
find p []     = Nothing                                        -- find.1
find p (x:xs) = if p x then Just x else find p xs              -- find.2

-- combinadores
(f . g) x      = f (g x)                                       -- (.).1
flip f x y     = f y x                                         -- flip.1
const x _      = x                                             -- const.1
id x           = x                                             -- id.1
curry f x y    = f (x, y)                                      -- curry.1
uncurry f (x,y) = f x y                                        -- uncurry.1
subtract n y   = y - n                                         -- subtract.1

-- Maybe / Either
maybe d f Nothing  = d                                         -- maybe.1
maybe d f (Just x) = f x                                       -- maybe.2
either f g (Left x)  = f x                                     -- either.1
either f g (Right y) = g y                                     -- either.2
fromMaybe d Nothing  = d                                       -- fromMaybe.1
fromMaybe d (Just x) = x                                       -- fromMaybe.2
isJust Nothing  = False                                        -- isJust.1
isJust (Just _) = True                                         -- isJust.2
isNothing Nothing  = True                                      -- isNothing.1
isNothing (Just _) = False                                     -- isNothing.2
catMaybes []             = []                                  -- catMaybes.1
catMaybes (Nothing : ms) = catMaybes ms                        -- catMaybes.2
catMaybes (Just x  : ms) = x : catMaybes ms                    -- catMaybes.3
mapMaybe f []     = []                                         -- mapMaybe.1
mapMaybe f (x:xs) = case f x of                                -- mapMaybe.2
                      Nothing -> mapMaybe f xs
                      Just y  -> y : mapMaybe f xs
listToMaybe []    = Nothing                                    -- listToMaybe.1
listToMaybe (x:_) = Just x                                     -- listToMaybe.2
maybeToList Nothing  = []                                      -- maybeToList.1
maybeToList (Just x) = [x]                                     -- maybeToList.2

-- fmap, (>>=) y (<|>) sobre Maybe
fmap f Nothing  = Nothing                                      -- fmap.1
fmap f (Just x) = Just (f x)                                   -- fmap.2
Nothing  >>= f = Nothing                                       -- (>>=).1
(Just x) >>= f = f x                                           -- (>>=).2
Nothing <|> r = r                                              -- (<|>).1
l       <|> _ = l                                              -- (<|>).2
```

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

## 6. Sintaxis que conviene tener fresca

- **`let ... in`:** es una **expresión**; todo `let` lleva su `in`. No se encadenan dos `let` sin cerrar el primero: `let a = 1 in let b = 2 in a + b`. Varias bindings van alineadas en columna, sin `;` ni `,`.
- **`where`:** **no** es expresión; va después de una ecuación completa. Su scope cubre **todas** las guards y el cuerpo de esa ecuación. Cada ecuación tiene su propio `where`.
- **`case ... of`:** es una **expresión**; sirve sobre cualquier valor intermedio. Gana el primer patrón que matchea.
- **Guards (`|`):** de arriba hacia abajo, gana la primera `True`. Sin catch-all hay error en ejecución: cerrá con una ecuación aparte con comodín (`f _ = ...`), o `_` en un `case`.
- **Lambda:** `\x y -> ...` es lo mismo que `\x -> \y -> ...`. Útil para pasar un comportamiento "de una sola vez".
- **Secciones:** aplicación parcial de un operador infijo: `(+ 1)`, `(2 *)`. `(- n)` no es sección (ver `subtract`, §5).
