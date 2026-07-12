# Programación Funcional

## Parcial de práctica — La Brigada

> Este parcial es original (no es un fork de ningún enunciado real puntual). Fue generado
> siguiendo `guia-generacion-parciales.md` de esta misma carpeta, eligiendo a propósito un
> dominio y una forma estructural que no se repiten en el resto de los documentos de
> `parciales/ia/` ni en los parciales viejos reales.

En la cocina de alta cocina "Nébula" la brigada se organiza como un árbol de mando: la
Chef Ejecutiva lidera la cocina y puede mentorear a cualquier cantidad de cocineros de
estación, cada uno de los cuales puede a su vez mentorear a otros cocineros más jóvenes, y
así sucesivamente sin límite de profundidad ni de cantidad de mentoreados por persona. A
cada cocinero de la brigada (sin importar en qué nivel de la jerarquía esté) se le asigna un
presupuesto anual de estación propio, independiente de los presupuestos que gestionen
quienes le reportan. En esta evaluación se modela solamente esta estructura de mando y
algunas operaciones sobre ella.

```haskell
type Nombre = String
type Presupuesto = Float

data Brigada = Cocinero Nombre Presupuesto [Brigada]
```

## Ejercicios

1. Definir **por recursión explícita** las siguientes funciones:

   a. `cantidadCocineros :: Brigada -> Int`, que describe la cantidad total de cocineros en
      la brigada (contando a la Chef Ejecutiva).

      **AYUDA:** como `Brigada` contiene una lista de `Brigada` en vez de un número fijo de
      subárboles, no alcanza con pattern-matching directo sobre `Brigada`: hace falta una
      función auxiliar que recorra esa lista (recursión mutua entre `Brigada` y `[Brigada]`).

   b. `presupuestoTotal :: Brigada -> Presupuesto`, que describe la suma de los presupuestos
      de todos los cocineros de la brigada.

   c. `buscarCocinero :: Nombre -> Brigada -> Maybe Presupuesto`, que describe el presupuesto
      del cocinero con el nombre dado, o `Nothing` si nadie en la brigada tiene ese nombre.

      **AYUDA:** puede convenir una función auxiliar `Nombre -> [Brigada] -> Maybe Presupuesto`
      que busque en una lista de brigadas, devolviendo el primer resultado exitoso.

   d. `lineaDeMando :: Nombre -> Brigada -> Maybe [Nombre]`, que describe la lista de nombres
      desde la Chef Ejecutiva hasta el cocinero con el nombre dado (inclusive ambos extremos),
      o `Nothing` si nadie en la brigada tiene ese nombre.

   e. `ajustarPresupuestos :: Float -> Brigada -> Brigada`, que describe la brigada resultante
      de multiplicar el presupuesto de **cada** cocinero (en todos los niveles) por `(1 + k)`,
      siendo `k` el factor dado.

   **Ejemplos:** siendo

   ```haskell
   ezequiel  = Cocinero "Ezequiel"  2000 []
   valentina = Cocinero "Valentina" 3500 []
   martin    = Cocinero "Martín"    3000 [ezequiel]
   sofia     = Cocinero "Sofía"     5000 [martin, valentina]
   ```

   ```haskell
   cantidadCocineros sofia = 4
   presupuestoTotal sofia = 13500
   buscarCocinero "Ezequiel" sofia = Just 2000
   buscarCocinero "Renata" sofia = Nothing
   lineaDeMando "Ezequiel" sofia = Just ["Sofía", "Martín", "Ezequiel"]
   lineaDeMando "Valentina" sofia = Just ["Sofía", "Valentina"]
   lineaDeMando "Renata" sofia = Nothing
   ajustarPresupuestos 0.1 sofia
     = Cocinero "Sofía" 5500 [ Cocinero "Martín" 3300 [Cocinero "Ezequiel" 2200 []]
                             , Cocinero "Valentina" 3850 [] ]
   presupuestoTotal (ajustarPresupuestos 0.1 sofia) = 14850
   ```

2. Demostrar la siguiente propiedad: para todo `k`,

   `presupuestoTotal . ajustarPresupuestos k = (* (1+k)) . presupuestoTotal`

   **Ayuda:** al plantear la inducción estructural sobre `Brigada`, la hipótesis inductiva
   vale para **cada elemento por separado** de la lista de hijos del constructor `Cocinero`.
   **Ayuda 2:** puede ser necesaria la siguiente propiedad sobre listas: para toda lista de
   números `xs` y todo real `c`,

   `c * sum xs = sum (map (c*) xs)`

3. Dar los tipos y escribir los esquemas de recursión **estructural** y **primitiva** para
   `Brigada`.

4. Escribir versiones de **todas** las funciones recursivas del Ejercicio 1 utilizando
   esquemas, sin usar recursión explícita en ninguna función diferente de los esquemas.

---

## Nota de generación

Domino y forma elegidos a propósito para no repetir lo ya usado en esta carpeta:
`parcial-animaciones-corregido.md` es un DSL de secuenciación/paralelismo (`Sec`/`Par`) y
`parcial-fuga-en-la-estacion-demeter.md` es un camino con nodo-que-bloquea y
nodo-que-bifurca (fork de "Incidente en el Núcleo"). `Brigada` en cambio es un **árbol
general** (aridad variable vía lista de hijos, sin constructor de hoja separado — la lista
vacía ya representa "sin mentoreados"), una forma que no apareció completa en ningún
documento de esta carpeta ni en los parciales viejos relevados, aunque sí se insinúa en el
tipo auxiliar `AG a = NodeAG a [AG a]` del ejercicio 4 del parcial de Nim. Justamente por
tener listas de hijos, la recursión explícita del Ejercicio 1 obliga a recursión mutua
`Brigada` / `[Brigada]`, y la demostración del Ejercicio 2 obliga a razonar la hipótesis
inductiva puntualmente sobre cada elemento de una lista en vez de sobre un número fijo de
subárboles — algo que ninguno de los parciales de esta carpeta había ejercitado todavía.

Antes de dejar los ejemplos escritos, calculé a mano `cantidadCocineros`, `presupuestoTotal`,
`buscarCocinero`, `lineaDeMando` y `ajustarPresupuestos` sobre el árbol `sofia` (incluyendo
el caso `Nothing` con un nombre inexistente, "Renata") siguiendo exactamente las ecuaciones
de recursión explícita que resolvería el Ejercicio 1, y verifiqué la propiedad del Ejercicio
2 numéricamente sobre ese mismo árbol (`13500 * 1.1 = 14850`) antes de publicarlos, para
evitar el tipo de inconsistencia que hubo que corregir en `parcial-animaciones-corregido.md`.

Se pide el esquema de recursión **primitiva** en el Ejercicio 3 siguiendo la convención de
la mayoría de los parciales reales (se pide como ejercicio de comprensión del concepto en sí
mismo), aunque, a diferencia de "Incidente en el Núcleo", ninguna función del Ejercicio 1
lo necesita estrictamente para resolverse en el Ejercicio 4 — alcanza con el esquema
estructural.
