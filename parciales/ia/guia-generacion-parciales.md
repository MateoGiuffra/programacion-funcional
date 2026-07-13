# Programación Funcional (UNQ) — cómo son los parciales y cómo generar más para practicar

> Documento de referencia para futuras sesiones de Claude en este repo. Objetivo: poder
> generar nuevos `.md` de práctica (parciales inventados) con una variedad rica de dominios,
> pero con el mismo nivel de exigencia y el mismo formato que usa la cátedra.

## Fuente de este análisis

Curso: Programación Funcional, Universidad Nacional de Quilmes (UNQ) — confirmado por el
header del parcial de ThreeT.

Se cruzaron **7 parciales viejos, independientes entre sí** (de cuatrimestres distintos,
ninguno derivado de otro) contra el parcial real del cuatrimestre actual:

- `parciales/viejos/PF_2021s2_P1-MultiSetLanguage().pdf`
- `parciales/viejos/PF-PrefixT.pdf`
- `parciales/viejos/PF-Spaceship.pdf`
- `parciales/viejos/PF_2018s1-Three-Tree-1.pdf`
- `parciales/viejos/PF_2021s1_P1-LaTortuga-Dominio.pdf`
- `parciales/viejos/PF_2023s1_R1-Nim.pdf`
- `parciales/viejos/Parcial - Animacion.pdf`
- `parciales/2026-c1/Programación Funcional - Parcial - Incidente en el Núcleo.pdf` (el real de este cuatrimestre)

**Ojo con la autorreferencia:** `parciales/ia/parcial-fuga-en-la-estacion-demeter.md` es un
fork deliberado de "Incidente en el Núcleo" (mismos roles de constructor, renombrados). Es
útil para practicar ESE parcial puntual, pero no cuenta como fuente independiente para
confirmar un patrón general — compararlo contra su propio original es circular. La lista de
arriba (los 7 parciales viejos) es la única evidencia válida de "qué se repite en la
materia".

## Estructura genérica confirmada (se repite en los 7 parciales viejos independientes)

1. **El tipo de datos**: un ADT recursivo con 2-5 constructores. A veces con narrativa
   temática (naves espaciales, tortuga, Nim, hackeo de una red), a veces puramente
   estructural/matemático sin historia (MultiSet, ThreeT, PrefixT). La narrativa **no es
   requisito**, es solo frecuente.
2. **Ejercicio de recursión explícita**: entre 3 y 8 funciones sobre el tipo dado. Casi
   siempre se especifican con **ejemplos concretos de invocación** (`f x = y`), no con specs
   formales en prosa matemática — los ejemplos funcionan como tests. Suele haber AYUDAs que
   sugieren funciones auxiliares (a veces con el tipo ya dado), y a veces se avisa
   explícitamente que una función no sale por recursión estructural pura y hace falta una
   auxiliar con un tipo más rico para poder resolverla (p.ej. threading de un acumulador
   extra, o devolver una tupla en vez de un solo valor para propagar dos cosas a la vez).
3. **Ejercicio de esquema(s) de recursión**: siempre piden tipo + implementación del
   catamorfismo/fold estructural del tipo dado (`fold<Tipo>`). El esquema de **recursión
   primitiva** (paramorfismo, `rec<Tipo>`, donde cada rama recursiva recibe también la
   subestructura original sin reducir) aparece en más o menos la mitad de los parciales
   viejos — **no es universal**, hay que decidirlo caso a caso.
4. **Ejercicio de reescritura sin recursión explícita**: reimplementar las funciones del
   ejercicio 1 usando solo los esquemas anteriores (y funciones ya definidas del enunciado).
5. **Al menos una demostración por inducción estructural**, siempre presente, sobre una
   propiedad que relaciona dos funciones del enunciado. Es muy frecuente que tenga forma de
   "una transformación no cambia el resultado de evaluar" (`f . g = f`) o de roundtrip
   (`g . f = id`). El formato de la demostración es constante en todos los parciales — ver
   más abajo.

El orden y la numeración exacta de estos 5 bloques varía entre parciales (a veces la
demostración es el ejercicio 2, a veces el último), pero cuando un bloque aparece, siempre
respeta esta forma.

## Formato fijo de las demostraciones (así se escriben en esta cátedra)

- Se reduce la propiedad por **principio de extensionalidad** a una igualdad puntual sobre
  una variable universal, y si hay `(.)` de por medio se lo destrata por su definición.
- Se enumeran los **casos de inducción estructural**, uno por constructor, con formato
  `casoBase)`, `casoInductivo1)`, etc. Cada caso inductivo declara antes de desarrollar su
  **HI** (hipótesis inductiva, entre `¡ ... !`) y su **TI** (tesis inductiva, entre `¿ ... ?`).
  Si el constructor tiene más de una posición recursiva, hay HI1, HI2, etc.
- Después, en una sección de desarrollo separada, cada caso se prueba con **LI** (lado
  izquierdo) y **LD** (lado derecho): cadenas de igualdades (`=`) donde cada paso se justifica
  con un comentario que nombra qué ecuación de qué definición se aplicó (p.ej.
  `--nombreFuncion.2`, `-- HI`, `-- LEMA-nombre`).
- Cuando aparece una igualdad intermedia no trivial, se la separa como su propio **lema con
  nombre**, se enuncia con `¿...?` y se prueba aparte con su propio LI/LD.
- Cada caso que cierra termina con una frase tipo `VALE ESTE CASO`.
- Es común que el enunciado dé como ayuda explícita **qué caso NO desarrollar** (por tedioso
  o análogo a otro) y/o un lema auxiliar ya enunciado para usar sin probar.

## Guía para generar nuevos parciales de práctica (`.md` en esta carpeta)

**Restricción dura, confirmada por el usuario:** los tipos recursivos NO pueden tener un
campo de tipo `[T]` (una lista del propio tipo recursivo) en ningún constructor — eso son
"árboles generales" (rose trees) y no entran en el temario de esta materia. Todo constructor
recursivo debe tener una cantidad **fija** de posiciones recursivas del mismo tipo (una,
dos, tres...), como en todos los parciales viejos relevados (`ThreeT` tiene 3 hijos fijos,
`Red`/`Conducto` tienen como máximo 2, `PrefixT` tiene 3, `Spaceship` tiene 2, etc.). Antes
de fijar un ADT nuevo, revisar que ningún constructor use `[NombreDelTipo]`.

Cuando se pida generar un parcial nuevo para practicar:

1. **Elegir un dominio narrativo distinto cada vez** para variedad rica. Evitar reciclar el
   mismo dominio (naves, hackeo, tuberías...) de una sesión a otra salvo que se pida
   explícitamente practicar ESE parcial puntual. Ideas de dominios no usados todavía en este
   repo: sistemas de riego, redes de transporte/subte, cadenas de suministro, colonias
   espaciales, sistemas de permisos/ACL, autómatas de un videojuego, protocolos de red,
   árboles genealógicos, circuitos eléctricos, rutas de delivery, ecosistemas/cadenas
   alimenticias, sistemas de facturación con descuentos encadenados, etc.
2. **Variar también la forma estructural del ADT**, no solo el disfraz narrativo. No todos
   los parciales viejos son "camino con bloqueo y bifurcación" (eso es específico de
   Incidente en el Núcleo) — hay árboles binarios/ternarios (ThreeT, PrefixT), DSLs de
   secuenciación con paralelismo (Animaciones), lenguajes de expresiones con union/map
   (MultiSet), árboles de juego con dos tipos de rama con semántica distinta (Nim), etc. Al
   generar un parcial nuevo, elegir a propósito una forma distinta a la de los últimos
   generados en esta carpeta.
3. **Ejercicio 1** con 3-6 funciones de recursión explícita, cada una con 2-4 ejemplos
   concretos de invocación como en los parciales reales (no specs formales). Si alguna función
   no sale por recursión estructural pura, dar la pista de la auxiliar con tipo más rico, como
   hacen los parciales reales.
4. **Ejercicio de esquemas**: pedir siempre el estructural; pedir el primitivo solo si alguna
   función del ejercicio 1 realmente lo necesita (si ninguna lo necesita, no pedirlo — no es
   obligatorio, sería relleno artificial).
5. **Ejercicio de reescritura** de las funciones del ejercicio 1 usando los esquemas.
6. **Al menos una demostración** de una propiedad de composición de dos funciones del
   enunciado, siguiendo el formato fijo de arriba. Si conviene, dar como ayuda qué caso NO
   desarrollar y/o un lema auxiliar.
7. **Validar los ejemplos antes de publicarlos**: implementar mentalmente (o en un `.hs` de
   scratch) las funciones definidas y correr cada ejemplo del enunciado para confirmar que son
   internamente consistentes, incluyendo la propiedad del ejercicio de demostración chequeada
   numéricamente contra varios casos. El parcial de Animaciones original tenía justamente dos
   inconsistencias de este tipo en sus datos de ejemplo (ver nota al final de
   `parcial-animaciones-corregido.md`) — ese es el tipo de error a evitar.
8. **Calibrar la dificultad** contra el parcial real de este cuatrimestre (Incidente en el
   Núcleo): resoluble por una persona que curse la materia en el tiempo de un parcial
   (~2-3 horas), con funciones auxiliares centradas en threading de estado/acumulador a
   través de la estructura vía `Maybe`, tuplas, o listas — no trivial, pero tampoco un
   ejercicio de investigación.
9. Guardar el resultado como `.md` nuevo en `parciales/ia/`, con nombre descriptivo del
   dominio elegido, y dejar (como en `parcial-fuga-en-la-estacion-demeter.md`) una nota final
   breve aclarando de qué parcial/estructura se inspiró y qué validación se hizo.
