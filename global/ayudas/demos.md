# Estructura de una demostración

Ver también: [índice](README.md) · [../demos-template.hs](../demos-template.hs) · [../demos-estructura.png](../demos-estructura.png)

---

## Las 3 columnas
```
    doble n
=                    def doble, x <- n
    2 * n
```
Columna 1: el signo `=`. Columna 2: el paso (expresión). Columna 3: la justificación (qué definición/HI/lema se aplicó). Ver `../demos-estructura.png`.

## Plantilla completa, en orden, con las frases exactas

Esto es lo que se escribe, en este orden, con estas palabras. Reemplazar lo que está entre
`< >`.

**Paso 0 — solo si la propiedad tiene un parámetro extra que NO es el tipo recursivo**
(algo tipo "para todo `k`, ..." o "para todo `env`, ..." al lado de una igualdad de
funciones). Fijalo antes de arrancar:
```
Sea <var> :: <tipo> un/a <qué es> cualquiera, fijo y arbitrario (dado por el "para todo <var>" del enunciado).
```

**Paso 1 — principio de extensionalidad** (cuando la propiedad está escrita como igualdad
de funciones, sin nombrar el argumento del tipo recursivo — point-free):
```
Por principio de extensionalidad, siendo <var> un/a <TIPO RECURSIVO> cualquiera, quiero ver que:
¿ para todo <var>. <LADO IZQUIERDO> <var> = <LADO DERECHO> <var> ?
```

**Paso 2 — desarmar operadores punto-libre si hace falta** (compose, flip, etc. — uno por
cada operador que quede aplicado):
```
por def. de compose, es equivalente decir:
¿ para todo <var>. <forma desarmada izquierda> = <forma desarmada derecha> ?
```

**Paso 3 — anunciar qué tipo de demo sigue.** Si es sobre la estructura de un tipo de dato:
```
por principio de induccion estructural sobre la estructura de <var>
```
Si es un análisis de casos sobre valores (no sobre un tipo recursivo — por ejemplo, sobre
qué constructor concreto puede tener un `Value`, o sobre `True`/`False` de un booleano):
```
por analisis de casos sobre <var1>, <var2>, ...
```

**Paso 4 — planteo de los casos** (uno por cada constructor del tipo, o uno por cada caso
del análisis). Primero se listan TODOS, sin desarrollar:
```
casoBase<N>) siendo <parámetros> un/a <tipo> cualquiera. <var> = <Constructor parámetros>
¿ <LADO IZQUIERDO sustituido> = <LADO DERECHO sustituido> ?

casoInductivo<N>) siendo <parámetros> cualquiera. <var> = <Constructor con sub-datos recursivos>
HI1) ¡ <la propiedad, para el primer sub-dato recursivo> !
HI2) ¡ <la propiedad, para el segundo sub-dato recursivo> !
TI) ¿ <LADO IZQUIERDO sustituido> = <LADO DERECHO sustituido> ?
```
(Un solo `HI)` sin numerar si el constructor tiene un solo campo recursivo; `HI1)`/`HI2)`
si tiene dos.)

Si es análisis de casos (no estructural), el planteo de cada caso lleva su propia condición
en vez de un constructor:
```
c<N>) siendo <parámetros> cualquiera. <var> = <forma concreta>
¿ <LADO IZQUIERDO sustituido> = <LADO DERECHO sustituido> ?
```
Para el caso "todo lo demás" (complemento de los anteriores), escribir la condición como
disyunción de negaciones, nunca conjunción — ver más abajo.

**Paso 5 — desarrollar cada caso, uno por uno:**
```
-- Demuestro:
casoBase<N>)
LI)
    <expresión inicial>
=                    <justificación>
    <expresión siguiente>
LD)
    <expresión inicial>
=                    <justificación>
    <expresión siguiente>
Vale para este caso.
```
Para un `casoInductivo`, la única diferencia es que en algún paso de la cadena la
justificación va a decir `HI`, `HI1`, `HI1 y HI2`, o el nombre de un lema, en vez de
`<funcion>.<n>`.

**Paso 6 — cierre final**, después de que todos los casos dieron bien:
```
La propiedad vale.
```

## Frases sueltas, por situación (tabla rápida)

| Situación | Frase exacta a escribir |
|---|---|
| Fijar el parámetro extra antes de extensionalidad | `Sea <var> :: <tipo> cualquiera, fijo y arbitrario (dado por el "para todo <var>" del enunciado).` |
| Aplicar extensionalidad | `Por principio de extensionalidad, siendo <var> un/a <TIPO> cualquiera, quiero ver que:` |
| Desarmar `(.)` | `por def. de compose, es equivalente decir:` |
| Desarmar `flip` | `por def. de flip, es equivalente decir:` (o como justificación de un solo paso: `flip`) |
| Anunciar inducción estructural | `por principio de induccion estructural sobre la estructura de <var>` |
| Anunciar análisis de casos | `por analisis de casos sobre <var1>, <var2>, ...` |
| Nombrar un caso base | `casoBase<N>) siendo <parámetros> cualquiera. <var> = <Constructor>` |
| Nombrar un caso inductivo | `casoInductivo<N>) siendo <parámetros> cualquiera. <var> = <Constructor>` |
| Hipótesis inductiva | `HI<n>) ¡ <propiedad> !` |
| Tesis inductiva | `TI) ¿ <propiedad> ?` |
| Objetivo de un caso base | `¿ <propiedad> ?` (sin HI, va directo el objetivo) |
| Justificar un paso por definición | `<funcion>.<n>` (número de la ecuación de esa función que usaste, contando desde la primera) |
| Justificar un paso por HI | `HI` / `HI1` / `HI1 y HI2` |
| Justificar un paso por un lema | `<nombreDelLema>` |
| Cerrar un caso que cierra bien | `Vale para este caso.` (equivalente: `Para este caso vale.`) |
| Cerrar toda la demostración | `La propiedad vale.` |
| Nombrar un sub-caso en análisis de casos | `c<N>) siendo <parámetros> cualquiera. <var> = <forma concreta>` |
| Plantear el caso "todo lo demás" | `c<N>) <condición 1> ó <condición 2>` — **nunca "y"** (ver abajo por qué) |

## Extensionalidad: dos cuantificadores, no uno
Cuando la propiedad viene dada como igualdad de funciones point-free con algún parámetro
extra de por medio (Paso 0 de la plantilla), hay **dos** variables en juego:
- La explícita (el parámetro extra): se queda **fija y arbitraria** durante toda la demo. No es sobre ella que inducís.
- La implícita, revelada por principio de extensionalidad: "`f = g`" significa "para todo `x`, `f x = g x`" — y es sobre **ese** `x` que hacés inducción estructural. Los `casoBase`/`casoInductivo` son casos del tipo recursivo, no del parámetro extra que quedó fijo.

Antes de arrancar a hacer casos, identificá cuál de las dos variables de la propiedad es la
que tiene el tipo recursivo (esa es sobre la que inducís) y cuál es la que se queda fija.

## Usar la HI (o un lema) correctamente
- **Sustituís toda la expresión**, no dejás nada de más alrededor. Si la HI dice `f x = g x`, reemplazar una ocurrencia de `f x` te da directamente `g x` — no un wrapper extra alrededor de `g x`.
- **Señal de alarma:** si un `casoInductivo` "cierra" sin haber usado la HI en ningún paso, algo está mal — probablemente falta abrir un caso, o se está asumiendo algo que en realidad depende de ella.
- **Lemas auxiliares** sirven para sacar de la demo principal una sub-demostración que se repetiría en varios casos. Pero el lema **necesita su propia demo** — no es gratis solo por enunciarlo. Si la función de la que depende el lema no es recursiva, el lema tampoco necesita inducción propia: alcanza con abrir los casos que correspondan a las ecuaciones de esa función.

## Demo por casos (no estructural)
- Los casos tienen que ser **conjuntamente exhaustivos**. Si un caso es "se cumple A y se cumple B", el complemento correcto es "no se cumple A **o** no se cumple B" (al menos una falla) — no "y" (las dos fallan), que deja afuera los casos mixtos.
- **No fijes un valor concreto cuando el caso pide "para todo x tal que..."**. Si tenés que probar algo para "cualquier par de valores que cumplan cierta condición negativa", no elijas un ejemplo particular — eso prueba una instancia, no el caso general. Si la función que estás usando tiene una cláusula comodín que no distingue entre formas, no necesitás abrir más sub-casos: la hipótesis del caso ya es exactamente la condición que dispara ese comodín, para cualquier forma concreta que tengan los valores.

## Demo con `if` (caso general: casarte sobre la condición)

Si una función está definida como `f x = if <cond> then <e1> else <e2>` y necesitás
desarrollar `f x` dentro de una demo, la única forma de "abrir" el `if` es casarte sobre el
valor de verdad de `<cond>`. No hay atajo por default — el atajo (más abajo) solo existe en
una situación particular.

```
por analisis de casos sobre <cond>

caso1) <cond> = True
LI)
    f x
=                    def. f, ya que <cond> = True (entra por la rama del then)
    <e1>
=                    <siguiente justificación>
    ...

caso2) <cond> = False
LI)
    f x
=                    def. f, ya que <cond> = False (entra por la rama del else)
    <e2>
=                    <siguiente justificación>
    ...
```

Una vez que fijaste el valor de verdad, el `if` deja de ser un `if` — se convierte
directamente en la rama que corresponde (`<e1>` o `<e2>`), y desde ahí seguís la cadena de
igualdades como con cualquier otra expresión. Es exhaustivo por construcción: un booleano
es `True` o `False`, no hay tercera opción, así que acá no hace falta preocuparse por
AND/OR como en un análisis de casos sobre un tipo con más de dos formas ("Demo por casos",
más arriba).

**Atajo — solo cuando tenés un `if` anidado adentro de otro `if`, y el `else` de ambos
niveles es exactamente la misma expresión repetida.** Ahí, en vez de abrir los 4 casos
posibles (`b1,b2` en True/True, True/False, False/True, False/False), podés citar
directamente:
```
if b1 then (if b2 then e1 else e2) else e2 = if (b1 && b2) then e1 else e2
```
Si el `else` de los dos niveles **no** es la misma expresión, el atajo no aplica — hay que
volver al caso general de arriba y abrir los casos de verdad (en este caso, potencialmente
los 4 combinados de `b1`/`b2`) uno por uno.
