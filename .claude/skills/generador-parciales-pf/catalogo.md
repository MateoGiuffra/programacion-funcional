# Catálogo de dominios y mecánica para inventar nuevos

## Dominios ya usados (NO reutilizar tal cual)

| dominio | ADT (resumen) | forma | esquemas pedidos | demo |
|---|---|---|---|---|
| ThreeT (2018s1) | `Leaf a \| Branch a T T T` | árbol ternario | fold | `sizeTT = sumTT . mapTT (const 1)`, `sum . leavesTT = sumTT`, `maximum . leavesTT = maxTT` |
| La Tortuga (2021s1) | `Go \| Turn \| GrabPen \| TCommand :#: TCommand`; `compileT :: TCommand -> Turtle -> (LineAssembly, Turtle)` | DSL con secuencia infija y estado hilado | (no relevado) | (no relevado) |
| MultiSet (2021s2) | `EmptyMS \| AddMS \| RemoveMS \| UnionMS \| MapMS (a->a)` | lenguaje de expresiones | fold + rec | `evalMSE . simpMSE = evalMSE` (3 lemas por función auxiliar) |
| Nim (2023s1 R1) | `Nim = Empty \| Heap Int Nim`; `GameTree = Nil \| Node (Move, GameTree) GameTree` | lista + árbol hijo/hermano | fold + rec (ambos) | `toGT . toAG = id` |
| Animaciones | `Espera \| Mov \| Sec \| Par` | DSL secuencia/paralelo | fold + rec | `duracion . alargar k = (k*) . duracion` |
| Spaceship | `Module Component S S \| Plug` | binario con datos | fold | `components (replace f s) = map f (components s)` |
| PrefixT | `Nil \| Node a T T T` | ternario de búsqueda | fold | `uncurry couple . decouple = id` (AB/Tree/TipTree) |
| Tipado simple (S2 2025) | `Exp` (6 constr., con funciones) + `Cmd` + `State` | expresiones + imperativo | fold + rec | `typecheck = tvalue . flip evalExp env` (solo Var y RelOp) |
| Calabozos (Recu 2c2025) | `Salida \| Celda r \| Pasillo Int C \| Bifurcacion C g C` | camino/bifurcación, 2 parámetros de tipo | fold + rec | `cantCeldas . appDup (liberarMuchos . mapa) = const 0` (solo Celda y Pasillo) |
| Incidente en el Núcleo (2026-c1) | `Red` con Terminal/Servidor/Firewall/Switch | acumulador bloqueante + bifurcación dinámica | fold | (parcial real actual; sus forks en parciales/ia no cuentan como evidencia) |

Observaciones de estilo: los ADTs reales mezclan datos con funciones, parámetros de tipo, y a veces un segundo tipo auxiliar (Pen/Turtle, State, Line/LineAssembly, Path/Instr).

## Dominios disponibles (sin usar)

Sistemas de riego, subte/transporte, cadenas de suministro, colonia espacial, permisos/ACL, autómata de videojuego, protocolo de red, árbol genealógico, circuito eléctrico, delivery, cadena alimenticia, facturación con descuentos encadenados, receta/cocina con pasos, compilador de planillas (celdas con fórmulas), editor de texto con undo/redo (comandos), playlist con efectos, cinta de montaje en fábrica, torneo de eliminatorias, cultivos y estaciones, biblioteca con préstamos, mazo de cartas con reglas, mensajería con reenvíos, semáforos/ciudad, inventario de mochila RPG.

## Mecánica para inventar un dominio nuevo (6 pasos)

1. **Elegir forma** (aridad recursiva fija): hoja / unario / binario / ternario / DSL secuencia-paralelo / lenguaje de expresiones.
2. **Asignar rol por constructor** (mezclar al menos 3 roles distintos):
   - caso base con dato (`Celda r`, `Leaf a`) y/o caso base vacío (`Salida`, `Plug`, `Nil`);
   - unario que **modifica/anota** (`Pasillo Int`, `AddMS x`, `Go d`);
   - unario que **transforma** con una función (`MapMS f`, `TextAritOp f`);
   - binario que **combina en serie** (`Sec`, `:#:`) o **en paralelo** (`Par`, `UnionMS`);
   - binario que **bifurca con dato en el medio** (`Bifurcacion c g c`, `Module c s s`);
   - nodo con **predicado o función de decisión** (`Firewall (Ataque -> Bool)`).
3. **Definir una semántica evaluable** (qué significa un valor: lista, entero, Maybe, función de estado). Esa es la función `eval`/`run` que aparece en la demo.
4. **Definir una transformación que preserve la semántica** (`simp`, `normaliza`, `alargar`, `replace`, `optimizar`). La demo típica: `eval . transformacion = eval` o `eval . transformacion k = (k op) . eval`.
5. **Derivar 4-8 funciones de ej. 1** mezclando: contar/sumar (`size`), aplanar (`leaves`/`mapa`), buscar (`Maybe`), transformar (`map`/`cambio`), una que necesite auxiliar con parámetro extra o tupla, una con `Maybe`/error.
6. **Elegir la propiedad de la demo** entre: (a) `eval . simp = eval`; (b) roundtrip entre dos representaciones; (c) conmutación `f . map-like g = h . f`; (d) `length`/`size` vs `map`; (e) relación con listas (`f x = foldr ... (toList x)`).

## Plantillas de demostración recurrentes

- **Conmutación con map**: `components (replace f sp) = map f (components sp)`. Lemas de lista usados: `map f (xs ++ ys) = map f xs ++ map f ys`.
- **Roundtrip**: `g . f = id`; casos: constructor base y cada recursivo; HI en cada subestructura; cierre con `id`.
- **eval . simp = eval**: un lema por función auxiliar `simpX` (análisis por casos del patrón), HI en subestructuras, uso de lemas de lista (`++`, `map`, `quitar`).
- **Con extensionalidad + (.)**: `(f . g) x = f (g x)`, luego `sea e cualquiera`. Con función de dos argumentos (`flip`, `appDup`, `uncurry`): desplegar su definición primero.
- **Con acumulador/arg extra** (`occursWith x g`): enunciar la propiedad generalizada como lema (ej. LEMA con `g` genérico), probarlo por inducción, y derivar el caso original instanciando `g = id`.
- **Guiada**: "desarrollar únicamente los casos X e Y" (se usa en `recu` y en parciales largos).

## Ejemplos de propiedades verosímiles por nivel (inspiración, adaptar al ADT nuevo)

- facil: `size = sum . map (const 1) . toList`; `length (toList (mapT f t)) = length (toList t)`.
- medio: `toList (mapT f t) = map f (toList t)`; `eval (simp e) = eval e` con una sola regla de simplificación.
- parcial: `eval . simp = eval` con 3 reglas y 2 lemas; `cantX . liberar = ...`; roundtrip con dos representaciones.
- recu: propiedad generalizada con acumulador (`aux x g`), con lema auxiliar no obvio; composición de tres funciones.

## Notas de rúbrica por ejercicio (para el archivo de soluciones)

- Recursión explícita: casos base y recursivos correctos, tipo correcto, uso de ejemplo; descuento chico por no usar la auxiliar sugerida si la solución igual es correcta.
- fold/rec: tipo correcto (un parámetro por constructor, funciones con la aridad del constructor; en `rec` cada hijo recursivo trae el valor y el hijo original), implementación estructural.
- Reescritura: ninguna recursión explícita fuera de los esquemas; las auxiliares con tupla se expresan como el resultado del fold.
- Demostración: extensionalidad correcta (3), casos y HI/TI bien planteados (7), cada paso justificado con su ecuación (resto), lemas enunciados y usados correctamente, `VALE ESTE CASO`. Una demo mal cerrada pero bien estructurada no puntúa 0.
