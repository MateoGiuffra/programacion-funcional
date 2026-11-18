# Programación Funcional - Parcial Animaciones

> **Nota:** esta es una versión corregida del enunciado original. La única corrección
> es en los datos de ejemplo (`fsEJ` y `simEj`), que en la versión original eran
> inconsistentes con la propia definición de `ej`. El detalle de qué se cambió y por
> qué está al final del documento.

En esta evaluación se busca modelar animaciones de un juego. Para eso se trabajará sobre
una representación en el tipo de datos `Animacion`, dado por las siguientes declaraciones:

```haskell
data Accion a = Paso a | SaltoArriba a | SaltoAdelante a | Girar a

type Tiempo = Int     -- el instante en el que sucede un movimiento
type Duracion = Int   -- cantidad de tiempos que dura el movimiento

data Animacion a =
     Espera Duracion                       -- durante la duración dada no hay acciones
   | Mov Duracion (Accion a)               -- un cierto movimiento con una duración dada
   | Sec (Animacion a) (Animacion a)       -- secuencia (la 2da empieza al terminar la 1era)
   | Par (Animacion a) (Animacion a)       -- paralelo (arrancan juntas y dura lo que la más larga)
```

Por ejemplo, la animación en paralelo de un personaje que va caminando y vuelve saltando,
y otro que va saltando y vuelve caminando y luego esperan 1 segundo, se expresaría de la
siguiente forma:

```haskell
ej = Sec (Par (Sec (Sec (Espera 1) (Mov 3 (Paso "Bob")))
                    (Sec (Mov 1 (Girar "Bob")) (Mov 2 (SaltoAdelante "Bob"))))
              (Sec (Mov 2 (SaltoAdelante "Ana"))
                   (Sec (Mov 1 (Girar "Ana")) (Sec (Mov 3 (Paso "Ana")) (Espera 1)))))
         (Espera 1)
```

Además se utilizarán dos tipos adicionales para realizar conversiones de composiciones a
otros formatos. Estos tipos son (en ambos casos, los tiempos se cuentan desde 1):

```haskell
type Frame a = [Accion a]     -- acciones simultáneas en un tiempo específico
type Simulador a = Tiempo -> Frame a
-- función que da las acciones que ocurren en un tiempo dado
```

Por ejemplo, la animación del ejemplo, expresada como lista de acciones sería

```haskell
fsEJ =
  [ [SaltoAdelante "Ana"]
  , [Paso "Bob", SaltoAdelante "Ana"]
  , [Paso "Bob", Girar "Ana"]
  , [Paso "Bob", Paso "Ana"]
  , [Girar "Bob", Paso "Ana"]
  , [SaltoAdelante "Bob", Paso "Ana"]
  , [SaltoAdelante "Bob"]
  , []
  ]
```

y llamando `simEj` al simulador que expresa la misma animación del ejemplo repitiéndose
una y otra vez, valen las siguientes equivalencias:

```haskell
simEj 1  = [SaltoAdelante "Ana"]
simEj 2  = [Paso "Bob", SaltoAdelante "Ana"]
simEj 4  = [Paso "Bob", Paso "Ana"]
simEj 6  = [SaltoAdelante "Bob", Paso "Ana"]
simEj 7  = [SaltoAdelante "Bob"]
simEj 8  = []
simEj 9  = [SaltoAdelante "Ana"]
simEj 12 = [Paso "Bob", Paso "Ana"]
simEj 16 = []
```

## Ejercicios

1. Definir la siguiente función de forma tal que cada elemento de cada lista sea
   considerado exactamente una vez (o sea, debe realizar UN único recorrido sobre
   cada lista).

   a. `combinarSinDuplicados :: [Int] -> [Int] -> [Int]`, que dadas dos listas de
      números sin repetidos, ordenadas en forma creciente, describe una lista ordenada y
      sin repetidos que contiene los elementos de ambas listas.

      **AYUDA:** es IMPRESCINDIBLE tener en cuenta el orden de los elementos de las
      listas para poder cumplir con la exigencia de un único recorrido.

2. Definir las siguientes funciones utilizando recursión explícita sobre `Animacion`

   a. `duracion :: Animacion a -> Int`, que describe la duración total de la animación
      (considerando que las acciones en paralelo terminan cuando termina la más larga).

   b. `alargar :: Int -> Animacion a -> Animacion a`, que describe una animación
      donde la duración de cada acción está multiplicada por un factor con respecto a la
      duración original.

   c. `simular :: Animacion a -> [Frame a]`, que describe una lista con un frame por
      cada tiempo de la duración de la animación. Cada frame es una lista con las
      acciones que ocurren simultáneamente en el tiempo indicado (una lista vacía indica
      que el personaje está quieto).

      **AYUDA:** puede usarse sin definir la función `replicate :: Int -> a -> [a]`, que dado un
      número `n` y un elemento, devuelve una lista con `n` copias de ese elemento.

   d. `tiemposDeEspera :: Animacion a -> [Tiempo]`, que describe una lista de los
      tiempos de la animación donde no hay ninguna acción.

      **ATENCIÓN:** DEBE ser realizada por recursión explícita.

      **AYUDA 1:** puede servir utilizar la función del ejercicio 1, y también definir la función
      auxiliar `contarHasta :: Int -> [Int]`, que describe la lista de números desde 1 hasta el
      dado.

      **AYUDA 2:** al armar los tiempos de la secuencia, tener en cuenta que los tiempos de
      la 2da componente de la secuencia van DESPUÉS de los de la primera...

3. Demostrar la siguiente propiedad para las funciones del ejercicio 1:

   para todo `k >= 0`.
   `duracion . (alargar k) = (k*) . duracion`

4. Dar los tipos y escribir los esquemas de recursión estructural y primitiva para
   `Animacion`.

5. Escribir versiones de todas las funciones recursivas del ejercicio 2 utilizando
   esquemas, y sin utilizar recursión explícita en ninguna función diferente de los
   esquemas (excepto la del ejercicio 1).

6. Escribir las siguientes funciones utilizando esquemas, y sin utilizar recursión explícita
   en ninguna función diferente de los esquemas. Pueden utilizarse las funciones del
   ejercicio 4.

   a. `ciclar :: Animacion a -> Simulador a`, que dada una animación describe un
      simulador en el que la animación se repite infinitamente.

   b. `combinar :: [Animacion a] -> [Animacion a] -> Animacion a`, que dadas dos
      listas con la misma longitud, describe una `Animacion` que consiste en la secuencia
      tal que la animación de cada posición de una lista ocurre en simultáneo con la
      correspondiente en la otra lista.

   c. `mezclar :: [Simulador a] -> Duracion -> [Frame a]`, que describe una lista de
      Frames con la duración dada, donde en cada tiempo se observa la superposición de
      los simuladores en la lista de entrada.

---

## Nota de corrección

El enunciado original traía dos inconsistencias en los datos de ejemplo (no en los
ejercicios). Se detectan sin necesidad de código, solo con la aritmética de `Sec`/`Par`
y la duración de cada `Mov`:

- **Duración total de `ej`:** Bob = 1+3+1+2 = 7, Ana = 2+1+3+1 = 7, `Par` = máx(7,7) = 7,
  más el `Espera 1` final → duración total = **8**.

- **`fsEJ`, posiciones 3 y 4:** el original tenía `[Paso "Bob", Paso "Ana"]` en la
  posición 3 y `[Giro "Ana", Paso "Bob"]` en la posición 4. Pero en la cadena de Ana
  (`SaltoAdelante(2) → Girar(1) → Paso(3) → Espera(1)`), `Girar "Ana"` tiene que ocurrir
  *antes* que `Paso "Ana"` porque así lo define el `Sec` que las combina. Además,
  `Paso "Ana"` (duración 3) debe ocupar 3 posiciones **consecutivas**, cosa que no pasaba
  en el original (aparecía en las posiciones 3, 5 y 6, salteando la 4). Se corrigió
  intercambiando el contenido de las posiciones 3 y 4.

- **`simEj`, tiempos 6 y 8:** como la duración de `ej` es 8, `simEj` es periódico con
  período 8. Eso obliga a que `simEj 8 = simEj 16` (ambos son el mismo instante del
  ciclo). El original tenía `simEj 8 = [SaltoAdelante "Bob", Paso "Ana"]` y
  `simEj 16 = []`, que son distintos — contradicción directa con la propia definición de
  periodicidad. Se corrigió intercambiando los valores de `simEj 6` y `simEj 8`.

- Se corrigió además la ortografía `Giro` → `Girar` (el constructor del tipo `Accion` es
  `Girar`).
