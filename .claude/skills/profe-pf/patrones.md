# patrones.md - errores reales, cheatsheet, plantilla, diagnóstico

## 1. Errores recurrentes REALES del usuario (con archivo)

Cómo usar: cuando el usuario cometa uno, nombrarlo y dar la pista nivel 1 ("revisá el parsing de la composición"), no el arreglo.

### E1. Parsing de composición al desarmar
- `threet.hs` (sizeTT = sumTT . mapTT (const 1)): escribió `(sumTT . mapTT) (const 1) (Leaf x)` y expandió `sumTT (mapTT (const 1)) ...`. Mal: `mapTT (const 1)` ya es una función; la composición es `sumTT . (mapTT (const 1))`. Bien: `(sumTT . mapTT (const 1)) t = sumTT (mapTT (const 1) t)`.
- `calabozos.hs`: `cantCeldas . appDup (liberarMuchos . mapa) = const 0` lo pasó a `compose cantCeldas appDup (compose liberarMuchos mapa) c`. Mal: `compose` toma 2 args y `appDup (...)` es UN solo factor. Bien: `compose cantCeldas (appDup (liberarMuchos . mapa)) c = cantCeldas (appDup (liberarMuchos . mapa) c)`.
- Regla: en `f . g x`, `g x` es un factor. Contar los factores del `.` antes de expandir.

### E2. HI mal planteada o duplicada
- `ejercicios-extras/21-5` (objs . excavar): H1 y H2 son idénticas y están sobre `Habitacion os d1 d2`, no sobre `d1` y `d2`. Bien: `HI1) objs (excavar d1) = doblar (objs d1)`, `HI2) objs (excavar d2) = doblar (objs d2)`. La HI es sobre las subestructuras, nunca sobre el nodo entero.
- Ojo: el enunciado de ese ejercicio define `excavar ... (excavar d1) (excavar d1)` (¿typo?). Si la def usa `d1` dos veces, la propiedad no vale; revisar el enunciado antes de demostrar.
- Algunos casos base fijan todas las variables en base: `tp-7/seccion-2` (`xs = [], ys = [], zs = []`; `zs = [], as = []`). Mal: solo se abre la variable inducida; `ys`, `zs` quedan genéricas.
- Símbolos invertidos: en `tp-7/seccion-1` HI con `¿ ?`; en `tp-9/ej-1` `!(...)¡` y `!...¡` para HI. Convención: HI = `¡ ... !`, TI = `¿ ... ?`.

### E3. Sustitución incorrecta / variables que mutan en el medio
- `incidente-en-el-nucleo.hs`: planteo con `Servidor n r'` pero en el LI aparece `Servidor p (...)`, `i + p`; en otro caso `combinarFirewalls r` en vez de `r'`; en el lema aparece `a` en vez de `i`. Regla: copiar-pegar el planteo y no retipear.
- `threet.hs` (inducción): caso inductivo con `(Suma e1 e2)` pero luego `a1 a2`; `expA2ea (Suma ..)` expandido a `BOp Mul` (operador equivocado) y para Prod `BOp Sum`.
- `parcial-el-torneo.hs`: usa `k` y después `fac`; `k * p` y `p * k` mezclados; `ti`/`td` vs `t1`/`t2`.
- Chequeo rápido antes de cada `=`: "la expresión nueva ¿usa exactamente las variables del planteo?"

### E4. Aplicar HI/lema sobre algo más grande que la subexpresión
- `multiset.hs` Lema.1: tras `evalMSE.3` escribió `evalMSE (quitar y (evalMSE ...))`: dejó un `evalMSE` de más afuera. `evalMSE (RemoveMS y ms) = quitar y (evalMSE ms)` reemplaza TODO el lado izq por el derecho, sin envolver.
- Mover una función adentro de un `if` ("por prop. del if") sin lema ni caso sobre la condición. Hacer análisis de casos `y == x` True/False y listo.
- Aplicar la def de una función cuyo argumento no tiene forma de constructor (ej. aplicar `quitar.2` sobre `quitar y (x : ...)` sí, pero sobre `quitar y e` con `e` genérica no).

### E5. Demos incompletas
- `multiset.hs` ("incompleto"), `parcial-el-torneo.hs` ("pendiente"), `incidente-en-el-nucleo.hs` (cadena `=` vacía al final de casoInductivo1), `calabozos.hs` (queda en el primer paso), `tp-9/ej-5`, `tp-7/seccion-3/demos.hs` (vacío), `tp-10` (vacío), `tp-8/seccion-1` (varios incisos sin resolver).
- Causa probable: se traban en el paso intermedio y no abren un lema. Pista: "¿qué igualdad te gustaría tener acá? esa es tu lema".
- Hábito a instalar: si en 3 min no sale un caso, anotar la igualdad faltante como `LEMA-X`, seguir con los demás casos, y volver.

### E6. Falta el paso de asociatividad/aritmética
- `tp-7/seccion-2`: `1 + length zs + length as` pasa a `1 + length (zs ++ as)` por HI sin escribir `aritm.`/asoc. Detalle: `(1 + length zs) + length as` necesita asociatividad antes de usar HI. Escribir ese paso.
- En lado derecho, justificar siempre en la columna de comentario: nada de pasos mudos.

### E7. Redundancia de justificación
- "def HI" (tp-8): es solo `HI`. "def (.)" sí (es una def). Para `id`/`const`: `def id`, `def const`.
- Instanciar siempre la def con la sustitución (`def f, x <- ..., xs <- ...`) cuando la ecuación tiene variables; evita errores de E3.

### Lo que HACE bien (reforzar)
- Esqueleto completo en el parcial de Incidente y Animaciones (extensionalidad, HI/TI, LI/LD, lema separado).
- Detecta que hace falta un lema (LEMA-COMBINAR, LEMA.1/.2 en multiset) y plantea análisis de casos exhaustivo del lema.
- Etiqueta cada paso con `fun.N`.

## 2. Cheatsheet de definiciones (numeración = orden de ecuaciones)

```haskell
id x = x                       -- id
const x y = x                  -- const
flip f x y = f y x             -- flip
(f . g) x = f (g x)            -- compose  ((.) f g x = f (g x))
curry f x y = f (x, y)         -- curry
uncurry f (x, y) = f x y       -- uncurry
fst (x, y) = x ; snd (x, y) = y

map f []     = []                      -- map.1
map f (x:xs) = f x : map f xs          -- map.2
filter p []     = []                   -- filter.1
filter p (x:xs) = if p x then x : filter p xs else filter p xs  -- filter.2
foldr f z []     = z                   -- foldr.1
foldr f z (x:xs) = f x (foldr f z xs)  -- foldr.2
[] ++ ys     = ys                      -- ++.1
(x:xs) ++ ys = x : (xs ++ ys)          -- ++.2
length [] = 0 ; length (x:xs) = 1 + length xs
sum [] = 0 ; sum (x:xs) = x + sum xs
concat = foldr (++) []
reverse [] = [] ; reverse (x:xs) = reverse xs ++ [x]
elem e [] = False ; elem e (x:xs) = x == e || elem e xs
any p [] = False ; any p (x:xs) = p x || any p xs
all p [] = True  ; all p (x:xs) = p x && all p xs
zip [] _ = [] ; zip _ [] = [] ; zip (x:xs) (y:ys) = (x,y) : zip xs ys
```
Nota: las definiciones exactas (nº de ecuación) son las del enunciado/TP; si el enunciado trae otras, usar esas.

### Propiedades que suelen servir como lemas (probarlas si no las dan)
- `(xs ++ ys) ++ zs = xs ++ (ys ++ zs)`, `xs ++ [] = xs`
- `length (xs ++ ys) = length xs + length ys`
- `map f (xs ++ ys) = map f xs ++ map f ys`, `map (f . g) = map f . map g`, `map id = id`
- `sum (xs ++ ys) = sum xs + sum ys`; `reverse (xs ++ ys) = reverse ys ++ reverse xs`
- `foldr f z (xs ++ ys) = foldr f (foldr f z ys) xs`
- `f (a ++ b) = f a ++ f b` y `f (g x) = h (f x)` (lemas "de empuje") para funciones propias del parcial
- `if c then a else a = a`, `x + 0 = x`, `a * (b + c) = ...`, `max (k*a) (k*b) = k * max a b` (k >= 0)

### Estructuras del curso (aridad fija, sin `[T]`)
- Listas: `[]` / `x : xs` (1 recursivo).
- Árboles binarios (`Tree a = EmptyT | NodeT a (Tree a) (Tree a)`): 2 recursivos -> HI1/HI2.
- `ThreeT a = Leaf a | Branch (ThreeT a) (ThreeT a) (ThreeT a)`: 3 recursivos -> HI1/HI2/HI3.
- Expresiones: `ExpA = Cte Int | Suma ExpA ExpA | Prod ExpA ExpA`.
- `MSExp a = EmptyMS | AddMS a (MSExp a) | RemoveMS a (MSExp a) | UnionMS (MSExp a) (MSExp a) | MapMS (a->a) (MSExp a)`.
- Pizza/Planilla/Animacion/Red/Calabozo/Acueducto: leer el parcial. Un caso inductivo por constructor recursivo; un HI por cada campo recursivo.

### Esquemas (para reescrituras y demos que mencionan fold)
- `fold<T>`: un argumento por constructor; en cada campo recursivo ya viene el resultado `b`.
- `rec<T>`: igual, pero cada campo recursivo viene como `(sub-estructura, resultado)`.
- Una demo sobre función definida con `fold` se hace por el mismo método: la def de `fold.N` justifica los pasos, y `foldr/foldT/...` NO necesita inducción propia salvo que se pida.

## 3. Plantilla de demo (notación del usuario)

```
{-
PROPIEDAD: f . g = h        (enunciado literal)

Sea k :: ... cualquiera, fijo y arbitrario   -- solo si hay parámetro extra

por principio de extensionalidad, siendo x un/a T cualquiera, quiero ver que:
¿ para toda x. (f . g) x = h x ?

por def. de compose, es equivalente decir:
¿ para toda x. f (g x) = h x ?

por principio de inducción estructural sobre la estructura de x

casoBase) siendo <params> cualquiera. x = Base
¿ f (g Base) = h Base ?

casoInductivo1) siendo <params> cualquiera. x = Con a x'
HI) ¡ f (g x') = h x' !
TI) ¿ f (g (Con a x')) = h (Con a x') ?

casoInductivo2) siendo ... x = Con2 x1 x2
HI1) ¡ ... x1 ... !
HI2) ¡ ... x2 ... !
TI) ¿ ... ?

DEMO:

casoBase)
LI)     f (g Base)
=                                   -- g.1
        ...
LD)     h Base
=                                   -- h.1
        ...
VALE ESTE CASO

casoInductivo1)
LI)     f (g (Con a x'))
=                                   -- g.2
        f (G a (g x'))
=                                   -- LEMA-X
        H' a (f (g x'))
=                                   -- HI
        H' a (h x')
LD)     h (Con a x')
=                                   -- h.2
        H' a (h x')
VALE ESTE CASO

LEMA-X
¿ f (G a r) = H' a (f r) ?
(por análisis de casos / por inducción sobre r, con su propio LI/LD)

La propiedad vale.
-}
```
Variantes:
- Análisis de casos: `por análisis de casos sobre <var>`; `c1) <var> = ...`, `c2) <var> != ...` (complemento con "o"); si la función es un `if`, casos `cond = True` / `cond = False`.
- Cuando la prop. es puntual (`length (xs ++ ys) = ...`) se saltea extensionalidad y compose: fijar `ys` y inducir sobre `xs`.

## 3b. Estilo REAL del profe (PDF resuelto, MultiSets 2021s2: `evalMSE . simpMSE = evalMSE`)

Modelo corto para imitar/comparar (copiado de su resolución; la plantilla de la sección 3 es la notación del usuario, esto es lo que el docente muestra):

```
PROP: ¿ evalMSE . simpMSE = evalMSE ?
DEM: Por principio de extensionalidad, veremos que
       ¿ para todo e :: MSExp. (evalMSE . simpMSE) e = evalMSE e ?
     Por la definición de (.), es equivalente ver que
       ¿ para todo e :: MSExp. evalMSE (simpMSE e) = evalMSE e ?
     Sea e una MSExp. Por principio de inducción en la estructura de e.

Caso base: e=EmptyMS)
     TI) ¿ evalMSE (simpMSE e) = evalMSE e ?
Caso ind. 2: e=RemoveMS x e1)
     HI1) ¡ evalMSE (simpMSE e1) = evalMSE e1 !
     TI) ¿ evalMSE (simpMSE (RemoveMS x e1)) = evalMSE (RemoveMS x e1) ?
Caso ind. 3: e=UnionMS e1 e2)      -- HI1) y HI2) una por posición recursiva
   ...
(luego se desarrolla cada caso:)
Caso ind. 2)
     evalMSE (simpMSE (RemoveMS x e1))
=                  (por simpMSE.3)
     evalMSE (simpRemoveMS x (simpMSE e1))
=                  (por Lema evalMSE-simpRemoveMS)
     quitar x (evalMSE (simpMSE e1))
=                  (por HI)
     quitar x (evalMSE e1)
=                  (por evalMSE.3)
     evalMSE (RemoveMS x e1)

LEMA evalMSE-simpRemoveMS)
     ¿ evalMSE (simpRemoveMS x e) = quitar x (evalMSE e) ?
LEMA evalMSE-simpMapMS)
     ¿ evalMSE (simpMapMS f e) = map f (evalMSE e) ?
Dem: sean f y e, cualesquiera.
Caso 1: e = EmptyMS)       ¿ evalMSE (simpMapMS f EmptyMS) = map f (evalMSE EmptyMS) ?
Caso 2: e distinto de EmptyMS)   ¿ evalMSE (simpMapMS f e) = map f (evalMSE e) ?
```

Rasgos observados (el profe NO hace todo como el usuario):
- **Una sola cadena**, no LI/LD en paralelo: parte del lado izquierdo y termina en EXACTAMENTE el lado derecho del enunciado del caso (la última ecuación se usa "al revés", p. ej. `evalMSE.3` reconstruye `evalMSE (RemoveMS x e1)`). El usuario puede usar LI/LD paralelos (válido si ambos llegan a la misma expresión); lo que se exige es que no haya salto.
- **Formato del paso**: expresión / línea con `=` y `(por X)` / expresión. La justificación va en la línea del `=`, entre expresiones, no al costado. Etiquetas: `simpMSE.3`, `evalMSE.2`, `HI`, `HI1 y HI2`, `Lema <f>-<g>`. Un paso = una ecuación; ni `def (.)` ni aritmética ni "def HI". `(.)` se despliega UNA vez en el encabezado (extensionalidad), no como paso.
- **Sin subrayado**: en el PDF no hay `^^^` ni `[ ]`; la subexpresión se ve por la expresión completa copiada en cada paso. Subrayar es un extra pedagógico del usuario, no un requisito visible del profe.
- **Cada paso reescribe una sola subexpresión** y la expresión se copia completa y bien parentizada (ej. `evalMSE (simpUnionMS (simpMSE e1) (simpMSE e2))`).
- **Planteo primero**: todos los casos con su HI/TI (marcados `¡ ... !` / `¿ ... ?`; la HI se escribe como lo que se TIENE, la TI como lo que se quiere) antes de desarrollar ninguno. Nombres: `Caso base: e=EmptyMS)`, `Caso ind. 1: e=AddMS x e1)`; HI por posición recursiva (`HI1`, `HI2`), una sola se llama `HI` en los pasos. El `e` universal se introduce con "Sea e una MSExp." y los parámetros fijos (x, f) quedan genéricos.
- **Lemas por función auxiliar**: el parcial define un auxiliar por regla (`simpRemoveMS`, `simpUnionMS`, `simpMapMS`) y un lema por auxiliar, con forma `g (aux args) = <lado derecho de la ecuación de g para el constructor>` (ej. `evalMSE (simpUnionMS e1 e2) = evalMSE e1 ++ evalMSE e2`), de modo que luego de aplicarlo se pueda usar HI directo. Nombre `<f>-<aux>` y enunciado con `¿ ... ?`, con argumentos explícitos (no igualdad de funciones).
- **Lema = análisis de casos sobre la forma del argumento**, planteado antes de desarrollar: `Dem: sean f y e, cualesquiera.` / `Caso 1: e = EmptyMS)` / `Caso 2: e distinto de EmptyMS)` (disjuntos y exhaustivos, "distinto de" para el complemento de las ecuaciones solapadas). Si el auxiliar no es recursivo no hay inducción. En el PDF solo se dejan planteados, no desarrollados (es una "solución posible").
- **Funciones**: ecuaciones numeradas en orden por ejercicio y citadas `f.N`; un auxiliar por regla de simplificación (patrón "smart constructor"); auxiliares con parámetro extra para lo no estructural (`occursMSEWith x g` acumula `g . f` en `MapMS`); `delta :: Bool -> Int`; `let` para reusar el resultado recursivo. El enunciado de la demo es solo la propiedad: NO da lemas, hay que descubrirlos.
- Ojo: la "solución posible" tiene typos (`occursMESWith`, `filter` por `filterMSE`, `quitar`/`quitarSiHay`, `EmptyMSE`, `isValidMSE x`), y la reescritura con `fold`/`rec` (ej. 3 y 4) quedó vacía: sirve como estilo, no como fuente de código correcto.

## 3c. Checklist de corrección de demos (lo que el profe exige; usar al revisar las del usuario)

Revisar en este orden y señalar UN ítem fallado a la vez (pistas graduales):
1. [ ] **Enunciado** con `¿ ... ?`; si hay `(.)`/igualdad de funciones: extensionalidad ("para todo x ...") y desplegar `(.)` una vez. Compose bien parseado (E1).
2. [ ] **Variable de inducción** correcta; el tipo recursivo; parámetros fijos genéricos; casos base sin fijar otras variables.
3. [ ] **Casos planteados antes** de desarrollar: uno por constructor, ni uno más ni menos; HI por cada posición recursiva (sobre las subestructuras, no sobre el nodo; E2); TI con la variable sustituida en AMBOS lados.
4. [ ] **Notación**: HI `¡ ! `, TI `¿ ?`, lemas `¿ ?`; nombres de variables iguales al planteo (E3).
5. [ ] **Cada paso**: una sola ecuación, justificada y numerada (`f.N`, `HI`, `LEMA-X`); la ecuación aplica al lado izquierdo EXACTO de la subexpresión (argumento con forma de constructor); sin pasos mudos (asociatividad/aritmética escritos, E6); nada de "def HI" (E7).
6. [ ] **HI/lema solo sobre la subexpresión**, sin envolver de más ni dejar funciones sobrantes (E4); la HI aparece literal.
7. [ ] **Lemas**: enunciados con argumentos (no extensionalidad), por inducción o por casos exhaustivos y disjuntos (planteados primero); un lema por cada igualdad intermedia con función sin constructor visible; ningún lema falso; no usar propiedades no vistas (conmutatividad de `++`, etc.) sin enunciarlas/citarlas.
8. [ ] **Si hay `if`/`case`/guardas**: análisis de casos sobre la condición, no "evaluar".
9. [ ] **Cierre**: cada caso termina exactamente en la expresión objetivo (o LI y LD convergen), cada caso cerrado con `VALE ESTE CASO`, demo con `La propiedad vale.`; ningún caso vacío/inconcluso (E5). Un caso inductivo que no usa HI: sospechar.
10. [ ] **Criterio de nota**: estructura correcta (extensionalidad, casos, HI/TI) vale aunque falle un paso; un paso con propiedad inventada o HI mal planteada pesa más que un typo de variable.

## 4. Diagnóstico de nivel (según el repo)

- **Implementación: nivel alto/medio-alto.** Recursión explícita, esquemas fold/rec y reescritura con fold están hechos en ~10 parciales (Incidente, Animaciones, MultiSet, ThreeT, Nim, Torneo, Calabozos, Tipado simple). Algunos errores de detalle (patrones no exhaustivos, `isJust _ = False`, tipos de acumuladores en fold) pero el razonamiento es correcto.
- **Demos: nivel medio, método interiorizado pero ejecución frágil.** Conoce la notación (HI/TI, LI/LD, lemas) y plantea bien el esqueleto cuando hay tiempo (Incidente, Animaciones, MSE).
- **Fallas dominantes:** (1) parsing de composiciones al expandir `.`; (2) HI/TI con variables o subestructuras equivocadas y sustituciones inconsistentes; (3) aplicar HI/lema sobre algo más grande que la subexpresión; (4) dejar demos sin terminar (>= 6 archivos).
- **Cobertura de práctica:** hay muchas demos de listas (tp-7/8), pero tp-7 sec-3, tp-9 ej-5 y tp-10 están vacíos; ningún demo terminada sobre `foldr`/esquemas ni sobre `flip`/`curry`.
- **Plan 2 días:** día 1 = rehacer 5 demos cortas con listas (`length`/`++`/`map`/`reverse`/`any`) terminándolas todas; día 2 = 2 parciales viejos (propiedad `f . g = f`) cronometrados, con lemas. Una por una, con pistas graduales.
