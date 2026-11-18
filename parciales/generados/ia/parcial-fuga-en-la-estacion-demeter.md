# Programación Funcional

## Parcial - Fuga en la Estación Deméter

Año 2199. La estación orbital Deméter fue alcanzada por un enjambre de micrometeoritos y
perdió presión en buena parte de su red de conductos de ventilación, que en esta evaluación
se representará con el tipo de datos `Conducto`. Un equipo de robots de mantenimiento se
despliega para sellar las fugas y restaurar la presión antes de que se agote el oxígeno de
reserva. Cada tramo del sistema de conductos afecta de alguna manera al oxígeno de reserva
que porta el equipo. El objetivo final del equipo es **sellar todas las fugas** de la Deméter:
con cada una sellada se recupera presión en un sector de la estación, y sólo sellándolas todas
la estación vuelve a ser habitable. Las **fugas** son entonces el blanco de la misión; cada
sellado, cuando se completa, consume cierta cantidad de oxígeno de reserva antes de seguir
adelante o, en forma equivalente, reduce el oxígeno disponible. A lo largo del recorrido
aparecen **tanques**: puntos terminales donde el equipo repone o cede oxígeno, y luego de lo
cual concluye ese tramo del recorrido. Por otra parte, las **esclusas** son compuertas que
miden el oxígeno de reserva actual y cada una sólo se abre si se cumple un determinado
criterio; si no se cumple, la esclusa no se abre y ese tramo del recorrido queda inconcluso.
Las **bifurcaciones**, finalmente, son puntos donde el conducto se separa en dos ramas: el
equipo recorre ambas, pero el criterio de la bifurcación, evaluado sobre el oxígeno de reserva
actual, determina por cuál de las dos se entra primero (si no indica un lado con claridad, se
entra primero por la izquierda); el oxígeno de reserva al salir de la primera rama recorrida es
el oxígeno con el que se entra a la segunda. En esta evaluación se modelan solamente algunas
de las funciones necesarias.

```haskell
type Oxigeno = Int
type Reserva = Int

data Conducto = Tanque Oxigeno
              | Fuga Oxigeno Conducto
              | Esclusa (Reserva -> Bool) Conducto
              | Bifurcacion (Reserva -> Lado) Conducto Conducto

data Lado = Izquierda | Derecha | Recto
type Camino = [Lado]

addFst :: (Int -> Int) -> (Int, b) -> (Int, b)
addFst f (n, y) = (f n, y)
```

## Ejercicios

1. Definir **por recursión explícita** las siguientes funciones:

   a. `combinarEsclusas :: Conducto -> Conducto`, que describe el `Conducto` que resulta de
      colapsar toda cadena de `Esclusa` consecutivas en el `Conducto` dado, en una sola cuyo
      criterio combina los originales. **Ejemplos:**
      ```haskell
      combinarEsclusas (Tanque 5) = Tanque 5
      combinarEsclusas (Esclusa (const False) (Tanque 7)) = Esclusa (const False) (Tanque 7)
      combinarEsclusas (Esclusa (\r -> r > 10) (Esclusa (\r -> r < 15) (Tanque 4)))
        = Esclusa (\r -> r > 10 && r < 15) (Tanque 4)
      ```

   b. `oxigenoRestante :: Reserva -> Conducto -> Maybe Reserva`, que describe el oxígeno de
      reserva al completar el recorrido con una reserva inicial dada, o `Nothing` si una esclusa
      bloquea en algún punto. **Ejemplos:**
      ```haskell
      oxigenoRestante 20 (Tanque 15) = Just 5
      oxigenoRestante 100 (Fuga 10 (Tanque 3)) = Just 107
      oxigenoRestante 500 (Esclusa (const False) (Tanque 0)) = Nothing
      ```

   c. `pasosHastaFalla :: Reserva -> Conducto -> Maybe Int`, que describe la cantidad de nodos
      que el equipo alcanza a atravesar antes de quedar detenido por una esclusa que no se
      abre. Cada nodo atravesado cuenta como un paso (incluyendo tanques, fugas y
      bifurcaciones); la esclusa que bloquea no cuenta como paso. Describe `Nothing` si el
      recorrido se completa sin bloqueos. **Sugerencia:** puede ayudar definir una función
      auxiliar de tipo `Conducto -> Reserva -> (Int, Maybe Reserva)` que describa la cantidad
      de pasos junto con el oxígeno final, para propagar ambas cosas a través de la
      `Bifurcacion`. **Ejemplos:**
      ```haskell
      pasosHastaFalla r (Tanque 2) = Nothing
      pasosHastaFalla r (Fuga 3 (Esclusa (const False) (Fuga 9 (Tanque 6)))) = Just 1
      ```

   d. `caminosASellados :: Reserva -> Conducto -> [Camino]`, que describe los caminos hasta
      cada una de las fugas efectivamente selladas. En cada `Bifurcacion` se indica por qué
      lado terminó estando esa fuga (`Izquierda` o `Derecha`), y en cada `Fuga` o `Esclusa`
      atravesada antes de llegar a la fuga en cuestión se agrega el lado `Recto`, indicando
      que no hubo bifurcación sino que se avanzó derecho. **Ejemplos:** siendo
      ```haskell
      conductoCon lado = Bifurcacion (const lado) (Fuga 6 (Tanque 6))
                                      (Esclusa (\r -> r > 10) (Fuga 6 (Tanque 6)))
      ```
      ```haskell
      caminosASellados 15 (Tanque 12) = []
      caminosASellados 35 (Fuga 8 (Tanque 1)) = [[]]
      caminosASellados 15 (conductoCon Derecha) = [ [Derecha, Recto], [Izquierda] ]
      caminosASellados 15 (conductoCon Izquierda) = [ [Izquierda], [Derecha, Recto] ]
      caminosASellados 5  (conductoCon Izquierda) = [ [Izquierda] ]
      ```

2. Demostrar la siguiente propiedad: para todo `r`,

   `oxigenoRestante r . combinarEsclusas = oxigenoRestante r`

   **Ayuda:** en el desarrollo, NO desarrollar el caso `Bifurcacion`. **Ayuda 2:** puede ser
   necesaria la siguiente propiedad: para todo `b1, b2, e1, e2`,

   `if b1 then (if b2 then e1 else e2) else e2 = if (b1 && b2) then e1 else e2`

3. Dar los tipos y escribir los esquemas de recursión estructural y primitiva para `Conducto`.

4. Escribir versiones de **todas** las funciones recursivas del Ejercicio 1 utilizando
   esquemas, sin usar recursión explícita en ninguna función diferente de los esquemas.

---

## Nota

Este parcial fue generado siguiendo la estructura del de "Incidente en el Núcleo"
(narrativa temática → tipo con 4 constructores: caso base, caso que acumula, caso que
filtra/bloquea, caso que se bifurca con orden dinámico → 4 funciones por recursión explícita
→ demostración por inducción con ayuda sobre un caso a omitir → esquemas de recursión).

A diferencia de la vez anterior con `fsEJ`/`simEj`, acá no hubo enunciado previo para
auditar — los ejemplos de este documento son de mi autoría, así que antes de dejarlos
escritos implementé las cuatro funciones y los corrí en GHC contra cada ejemplo (incluyendo
la propiedad del ejercicio 2, chequeada numéricamente contra varios `Conducto` y varios
valores de `r`) para confirmar que todo es internamente consistente antes de mostrártelo.
