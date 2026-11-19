# 02 - Demostraciones (Programación Funcional, UNQ)

## Resumen: demo en 7 líneas

1. **Extensionalidad:** `f = g` pasa a `f xs = g xs`.
2. **Desarmá `(.)`** (y `flip`, etc.) con su frase.
3. **Inducción** sobre la variable de tipo recursivo (la que apareció en 1).
4. **Planteá TODOS los casos** sin desarrollar: `casoBase)`, `casoInductivo)` con `HI)` y `TI)`.
5. **Desarrollá** cada caso con `LI)` y `LD)`, una ecuación por paso y su justificación.
6. **HI en el paso clave:** si un inductivo cierra sin usarla, algo falla.
7. **Cierre:** `Vale para este caso.` en cada uno y `La propiedad vale.` al final.

## Estructura de una demostración

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
