---
name: generador-parciales-pf
description: Genera parciales NUEVOS y originales de Programación Funcional (UNQ, Haskell) con el formato de los parciales viejos (ADT, recursión explícita, fold/rec, reescritura con esquemas, demos por inducción). Usar cuando el usuario pida "generame un parcial", "otro parcial de práctica", "parcial fácil/difícil", "más demos", o un recuperatorio de práctica. Parametriza dificultad y énfasis en demostraciones; deja enunciado y soluciones en archivos separados en parciales/generados/.
---

# Generador de parciales de PF (UNQ)

Catálogo de dominios, plantillas de demo y rúbrica detallada: ver [catalogo.md](catalogo.md). Guía previa del repo (no contradecirla): `parciales/ia/guia-generacion-parciales.md`.

## 1. Parámetros (preguntar solo lo que falte; defaults entre paréntesis)

- `nivel`: `facil` | `medio` (default) | `parcial` (real) | `recu` (recuperatorio difícil). Ver sección 4.
- `enfasis`: `balanceado` (default) | `demos` (2-3 demos, lemas, extensionalidad) | `codigo`.
- `dominio`: nombre del catálogo, `nuevo` (inventar, default) o texto libre.
- `forma`: forma estructural del ADT (sección 3). Default: distinta de los últimos generados en `parciales/generados/`.
- Si el usuario dice "subí de a poco": mirar `parciales/generados/` y generar un nivel por encima del último (facil -> medio -> parcial -> recu), manteniendo énfasis en demos si lo pidió. El usuario está flojo en demostraciones: ante la duda, `enfasis=demos`.

## 2. Estructura del parcial (validada en 9 parciales viejos)

Bloques (orden variable; la demo a veces va 2do, a veces último):

1. **ADT** recursivo de 2-5 constructores, con narrativa temática o puramente estructural (la narrativa es opcional).
2. **Recursión explícita**: 3-8 funciones (según nivel), cada una con 2-4 ejemplos `f x = y` (funcionan como tests). AYUDAs: auxiliar sugerida (a veces con tipo), aviso de "no sale por recursión estructural pura, usar auxiliar con tipo más rico" (parámetro extra / tupla / `Maybe`).
3. **Esquemas**: tipo + implementación de `fold<Tipo>` (siempre). `rec<Tipo>` (primitiva) SOLO si alguna función del ej. 1 realmente lo necesita (aprox. la mitad de los parciales: MultiSet, Animaciones, Nim, Calabozos y Tipado lo piden; Spaceship, PrefixT, ThreeT no).
4. **Reescritura** sin recursión explícita (solo esquemas, foldr, map, etc. y funciones previas).
5. **Demostración(es)** por inducción estructural: propiedad que relaciona dos funciones del enunciado. Formas típicas: `f . g = f` (`evalMSE . simpMSE = evalMSE`), roundtrip `g . f = id` (`toGT . toAG = id`, `uncurry couple . decouple = id`), `f . map-like k = (k*) . f` (`duracion . alargar k = (k*) . duracion`), `f (g x) = map h (f x)` (`components (replace f s) = map f (components s)`), `sizeTT = sumTT . mapTT (const 1)`, `sum . leaves = sumTT`.
6. Opcional según nivel: ejercicio de listas (comprensión, un solo recorrido tipo `combinarSinDuplicados`), tipos de funciones/composición/evaluación (puntos extra), BONUS al final (`winning`, `evalCmd`).

Encabezado fijo (opcional pero típico): "Programación Funcional - Parcial - <Tema> - <cuatrimestre>", y aclaraciones: libro abierto, se pueden usar funciones/propiedades vistas en clase citando la referencia, lo demás se define o demuestra.

## 3. Restricciones duras del ADT

- PROHIBIDO un constructor con campo `[T]` donde `T` es el propio tipo (nada de árboles generales/rose trees). Aridad recursiva **fija**: 1, 2 o 3 posiciones del propio tipo directamente (ThreeT 3, PrefixT 3, Spaceship/Calabozo/Animacion 2). Antes de fijar el ADT, revisarlo. Un tipo auxiliar con `[...]` solo puede aparecer como tipo de salida/isomorfismo, nunca como forma central.
- Constructores pueden llevar funciones como datos (`MapMS (a->a)`, `AritOp (Int->Int->Int)`), datos no recursivos de varios tipos y parámetros de tipo (`Calabozo g r`).
- Variar la **forma**, no solo el disfraz: lista-con-nodos (1 rec), binario (2 rec), ternario (3 rec), DSL de secuencia/paralelo, lenguaje de expresiones con unión/map, camino con bloqueo/bifurcación, juego con dos ramas de semántica distinta, imperativo (Cmd + Exp), constructor infijo (`:#:`), tipo con dos parámetros.
- No reciclar el ADT de un parcial viejo con otro nombre; no citar un fork propio como evidencia independiente de un patrón.

## 4. Niveles

| nivel | ADT | ej. 1 | auxiliares | esquemas | demos | extras |
|---|---|---|---|---|---|---|
| facil | 2-3 constr., 1-2 rec | 3-4 fun. estructurales puras (size, sum, map, leaves) | ninguna | fold | 1 simple: casos triviales, sin lemas (tipo ThreeT 4a/4b) | ninguno |
| medio | 3-4 constr. | 4-5 fun., una con auxiliar/acumulador | 1 sugerida | fold (+rec si hace falta) | 1 con 1 lema, o 2 simples | 1 ej. de listas |
| parcial | 4-5 constr., 2 rec, datos con funciones | 5-6 fun., una devuelve tupla/Maybe | 1-2, algunas sin AYUDA | fold + rec | 1 con 2+ lemas (ayuda: "desarrollar solo los casos X e Y") | BONUS opcional |
| recu | idem + parámetro de tipo / dos tipos mutuamente usados | 6-8 fun., 2 con estado hilado/orden dinámico | sin AYUDA | fold + rec + reescritura de lo no trivial (ej. `ciclar`, `combinar`) | demo con lema no obvio o dos demos (una por extensionalidad con `.`, otra roundtrip) | BONUS + tipos/evaluación |

Calibración: `parcial` ~ 2-3 h resoluble; `recu` ~ más denso que el real, sin ser investigación.

## 5. Puntajes y aprobación (aproximación; los enunciados viejos NO traen puntajes)

Ningún parcial viejo declara puntaje; se usa una rúbrica propia por 100 pts y se aclara en la rúbrica del archivo de soluciones, marcada como "estimada":

- Ej. 1 recursión explícita: 30. Esquemas (tipo + implementación): 15. Reescritura: 20. Demostración(es): 30. BONUS/extras: 5 (se suma, no obligatorio).
- Con `enfasis=demos`: 20 / 10 / 15 / 50 / 5.
- Aprobación estimada: 60 pts, con el ej. de demostración "no en blanco" (una demo con estructura correcta HI/TI vale aunque falle un paso). Si el usuario conoce el criterio real de su cursada, usar ese.

## 6. Formato de demostración (obligatorio, convenciones del usuario)

- Enunciar la propiedad con `¿ ... ?`; si hay `(.)` o igualdad de funciones: **principio de extensionalidad** ("sea x un ... cualquiera") y desplegar `(.)`.
- Casos de **inducción estructural**: `casoBase)`, `casoInductivo1)`, ... uno por constructor, cada uno con **HI** (`¡ ... !`, HI1/HI2 si hay varias posiciones recursivas) y **TI** (`¿ ... ?`).
- Sección `DEMO:` aparte: cada caso con **LI** y **LD** como cadenas de `=`, justificando cada paso a la derecha (`-- foo.2`, `-- HI`, `-- LEMA-NOMBRE`, `-- def (.)`, `-- map.2`).
- Igualdades intermedias no triviales: **lema con nombre** (`LEMA-NOMBRE`), enunciado con `¿...?` y probado aparte con su LI/LD.
- Cada caso cerrado termina con `VALE ESTE CASO`.
- Numerar las ecuaciones de cada función (`f.1`, `f.2`) en el enunciado de soluciones para poder citarlas.
- En el enunciado se puede dar: caso(s) a NO desarrollar, y/o un lema ya enunciado para usar sin probar.

## 6b. Patrones recurrentes de enunciado

- Ejemplos tipo test: `f ej1 = ...` con un `ej1`, `ej2` definidos en el enunciado (usar 2-3 valores de ejemplo reutilizados por todas las funciones).
- "Describe ..." como verbo de spec (`que describe la cantidad de ...`).
- AYUDA / ATENCIÓN / OBSERVACIÓN en negrita o mayúsculas; AYUDA con tipo de auxiliar; ATENCIÓN "DEBE ser por recursión explícita".
- Función no estructural pura -> auxiliar con parámetro extra (`occursMSEWith x g`) o tupla (`(Int, Maybe Ataque)`).
- Ejercicio final de esquemas: "Dar los tipos y escribir los esquemas de recursión estructural y primitiva para <Tipo>".
- Reescritura: "sin recursión explícita en ninguna función diferente de los esquemas".
- Funciones sobre listas de ADTs (`largest :: [Spaceship] -> Spaceship`, `test`, `combinar`) para mezclar foldr con el fold propio.

## 6c. Formato "copiar y listo" del enunciado (obligatorio)

El usuario resuelve copiando bloques del `.md` a su `.hs`. Por eso el enunciado se arma con bloques ```haskell, uno por cosa, pegables en orden y sin edición:

1. **Primer bloque "Base para copiar"** (justo después del título/aclaraciones): imports necesarios (si hacen falta), `type`, todos los `data`, funciones ya dadas (auxiliares como `juntar`/`responder`, `fold`/`rec` si el enunciado los da, instancias manuales) y los valores de ejemplo (`ej1 = ...`). Debe compilar tal cual.
   - Todo `data` lleva `deriving (Show, Eq)` (agregar `Ord` etc. si algo lo usa). Si un constructor guarda una función (`a -> a`), NO se puede derivar `Show`/`Eq`: dar en la base una `instance Show T` manual (la función se muestra como `<fun>`) y no pedir `Eq`; los tests comparan con `show` o con una función observadora (`leer`, `items`).
   - Valores de ejemplo con anotación de tipo cuando el tipo sea polimórfico (`ej1 :: Torneo`).
2. **Un bloque ```haskell por cada cosa a implementar**: signatura + `nombre = undefined` (o `nombre arg1 arg2 = undefined` si ayuda a ver la aridad). Sin texto dentro del bloque; a lo sumo un comentario `--` corto (ej. `-- ayuda: usar mayorPrecioCon`). La descripción en prosa y los ejemplos `f x = y` van en el texto, fuera del bloque. Las auxiliares sugeridas (con tipo dado) también llevan su stub en bloque propio.
   - Esquemas (`fold`/`rec`) cuando el ejercicio es "dar el tipo": stub sin signatura (`foldT = undefined`), así compila y el tipo sigue siendo parte del ejercicio.
   - Reescrituras: stubs con nombre primado (`f' :: ...` / `f' = undefined`).
3. **Último bloque "Pruebas"**: los ejemplos del enunciado como expresiones ejecutables, con el resultado esperado en comentario. Formato: `main :: IO ()` con una lista o varias líneas `print (...)  -- esperado: ...`, o una lista de `(nombre, obtenido, esperado)` / `esperado == obtenido`. Debe poder correrse con `runghc` luego de resolver; con `undefined` solo falla en ejecución (no en compilación). Incluir también la comparación original vs reescritura (`f ej1 == f' ej1`) si hay reescritura.
4. **Demostraciones**: la prosa/instrucciones quedan en texto, pero cada propiedad se da en un bloque copiable (``` sin lenguaje o `haskell` con comentarios) con el enunciado `¿ ... ?`, los lemas dados (`LEN-APP: ...`) y la plantilla vacía si corresponde:
   ```
   -- ¿ P ? por inducción estructural sobre <Tipo>
   -- casoBase)       TI: ¿ ... ?
   -- casoInductivo)  HI: ¡ ... !   TI: ¿ ... ?
   -- DEMO:  LI: ...   LD: ...   VALE ESTE CASO
   ```
   Para demos sin casos obvios omitir la plantilla de casos (no spoilear), pero siempre el enunciado de la propiedad y los lemas dados.
5. Las soluciones (`-soluciones.md`) siguen usando los mismos nombres que los stubs (y primados en reescrituras), así se pueden pegar sobre los `undefined`.

Esqueleto del enunciado: título + aclaraciones -> bloque Base -> por cada ejercicio: prosa corta + ejemplos en texto + bloque(s) stub -> demos (prosa + bloque propiedad) -> bloque Pruebas.

## 7. Proceso de generación

1. Resolver parámetros (sección 1). Mirar `parciales/generados/` para no repetir dominio ni forma.
2. Elegir dominio (catalogo.md) o inventarlo con la mecánica de catalogo.md; fijar ADT y revisar sección 3.
3. Escribir las funciones del ej. 1 **y sus soluciones primero**, con ecuaciones numeradas.
4. Elegir la propiedad a demostrar entre las que realmente valgan (sección 8), escribir la demo completa y los lemas.
5. Derivar los ejemplos del enunciado EJECUTANDO el código (no a mano).
6. Redactar enunciado (formato de la sección 6c) y soluciones por separado y guardarlos (sección 9).
7. Verificar los dos modos de la checklist (stubs con `undefined` y soluciones pegadas) con archivos temporales fuera de `parciales/`.

## 8. Checklist de calidad (no entregar sin pasarlo)

- [ ] **Compila**: escribir un `.hs` scratch (en el scratchpad, no en el repo) con el ADT, todas las funciones, esquemas y reescrituras; compilar con `ghc`/`runghc` si está disponible. Si no hay GHC, revisar tipos a mano función por función.
- [ ] **Enunciado pegable compila (modo stubs)**: concatenar EN ORDEN todos los bloques ```haskell del enunciado (base + stubs + pruebas) en un `.hs` temporal en el scratchpad/temp (NUNCA en `parciales/`) y cargarlo con `ghc`/`runghci`: debe compilar sin errores de tipos con todo en `undefined` (sin duplicados ni nombres faltantes; `main` presente).
- [ ] **Soluciones pasan las pruebas (modo soluciones)**: en otro temporal, base + soluciones del `-soluciones.md` (reemplazando los stubs) + bloque de pruebas; ejecutar con `runghc` y confirmar que cada resultado coincide con el esperado del comentario y con los ejemplos de la prosa. Las reescrituras primadas dan igual que las explícitas.
- [ ] `deriving (Show, Eq)` en todos los `data` (o `instance Show` manual si hay campos función) y ningún `.hs` queda en `parciales/generados/`.
- [ ] **Ejemplos del enunciado verificados** ejecutándolos (o evaluándolos paso a paso), sin inconsistencias como las del parcial de Animaciones original.
- [ ] **La propiedad vale**: probarla con 3-5 valores concretos (a mano o con `quickCheck`/pruebas manuales en ghci) antes de demostrarla.
- [ ] **La demo es demostrable con lemas disponibles**: cada paso usa una ecuación de las funciones del enunciado, HI, o un lema del enunciado/enunciado en la solución; lemas de la biblioteca estándar usados (`map f (xs ++ ys)`, `sum (xs ++ ys)`, `length . map`, `map (f.g)`) son los vistos en clase y se citan. Nada de depender de propiedades no triviales de `Int` más allá de aritmética básica.
- [ ] Las funciones de la demo son totales y sin errores en los casos tocados (o la propiedad aclara la precondición, ej. "suponiendo expresión válida").
- [ ] Cantidad de casos de inducción = cantidad de constructores; HI por cada posición recursiva.
- [ ] Ningún constructor con `[Tipo]` recursivo; aridad recursiva fija.
- [ ] `fold`/`rec` tienen tipos que cierran (un argumento por constructor; `rec` recibe además la subestructura en cada posición recursiva).
- [ ] La reescritura usa solo esquemas: ninguna función fuera de `fold`/`rec` tiene recursión propia (salvo la excepción que el enunciado nombre).
- [ ] `rec` pedido solo si lo necesita alguna función.
- [ ] Dificultad acorde al `nivel`; ninguna función con solución ambigua (si hay dos semánticas razonables, fijarla con un ejemplo).
- [ ] Nombres y dominio no calcan un parcial viejo ni el de 2026-c1 (Incidente en el Núcleo) ni sus forks en `parciales/ia/`.

## 9. Salida

Carpeta destino: `parciales/generados/` (crearla si no existe). Dos archivos por parcial (solo .md), mismo prefijo:

- `parciales/generados/NNN-<dominio-kebab>-<nivel>.md` — **solo enunciado** en formato "copiar y listo" (sección 6c; sin soluciones, sin spoilers; puntajes sugeridos y aclaraciones de libro abierto al inicio).
- `parciales/generados/NNN-<dominio-kebab>-<nivel>-soluciones.md` — soluciones completas en Haskell con ecuaciones numeradas, demo en el formato HI/TI, LI/LD, rúbrica por ejercicio con puntaje (estimada), errores comunes y nota final: de qué forma/parcial se inspiró y qué validación se hizo (compilación, ejemplos, propiedad).

`NNN` = contador de 3 dígitos incremental según lo que haya en la carpeta (001, 002, ...). NO dejar archivos `.hs` en `parciales/generados/`: el usuario resuelve a mano; el `.hs` es solo para que el generador verifique (compilar y correr ejemplos) en el scratchpad/temp. La solución va únicamente dentro del `-soluciones.md`.

Tras guardar, reportar en 3-5 líneas: ruta de ambos archivos, dominio, forma del ADT, nivel y qué se demuestra. Respuesta corta, sin pegar el parcial en el chat. No agregar atribución a Claude en commits (no commitear salvo pedido).
