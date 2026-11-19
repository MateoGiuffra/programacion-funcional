# 01 - Tips e implementación (Programación Funcional, UNQ)

## Resumen

**Código:** pensá primero (§0), reconocé la forma (§3), armá `fold`/`rec` (§2), chequeá (§1 y §4).
Funciones de uso frecuente: ver documento 03. Demostraciones: ver documento 02.

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

## 4. Sintaxis que conviene tener fresca

- **`let ... in`:** es una **expresión**; todo `let` lleva su `in`. No se encadenan dos `let` sin cerrar el primero: `let a = 1 in let b = 2 in a + b`. Varias bindings van alineadas en columna, sin `;` ni `,`.
- **`where`:** **no** es expresión; va después de una ecuación completa. Su scope cubre **todas** las guards y el cuerpo de esa ecuación. Cada ecuación tiene su propio `where`.
- **`case ... of`:** es una **expresión**; sirve sobre cualquier valor intermedio. Gana el primer patrón que matchea.
- **Guards (`|`):** de arriba hacia abajo, gana la primera `True`. Sin catch-all hay error en ejecución: cerrá con una ecuación aparte con comodín (`f _ = ...`), o `_` en un `case`.
- **Lambda:** `\x y -> ...` es lo mismo que `\x -> \y -> ...`. Útil para pasar un comportamiento "de una sola vez".
- **Secciones:** aplicación parcial de un operador infijo: `(+ 1)`, `(2 *)`. `(- n)` no es sección (ver `subtract`, documento 03 Funciones típicas).
