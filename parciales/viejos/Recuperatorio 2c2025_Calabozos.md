Programación Funcional

Calabozos
El siguiente parcial modela una forma simplificada de calabozos que consisten en celdas
ubicadas al final de diferentes pasillos y bifurcaciones, con la excepción de que algunos
pasillos conducen a una salida. Para modelarlo se utilizan los siguientes tipos:

data Calabozo g r = Salida
   | Celda r

| Pasillo Int (Calabozo g r)
| Bifurcacion (Calabozo g r) g (Calabozo g r)

donde el tipo Calabozo g r utiliza el tipo g para representar la información de los guardias, y
un tipo r para representar la información de los presos (o reos). Por otra parte, los pasillos
tienen el dato de la longitud del pasillo. Además se cuenta con algunos tipos para modelar
los caminos dentro del calabozo, que pueden ayudar a los guardias a moverse por el
mismo.

data Instr = Izq | Der | PasilloDe Int
type Path = [Instr]

Así, un ejemplo de calabozo y sus caminos sería

ej1 = Bifurcacion

(Pasillo 5 (Celda "A"))
1
(Pasillo 7 (Bifurcacion (Celda "B")

2
(Pasillo 9 (Celda "C"))))

pathAlA = [Izq, PasilloDe 5] -- para llegar al preso "A"
pathAlB = [Der, PasilloDe 7, Izq] -- para llegar al preso "B"
pathAlC = [Der, PasilloDe 7, Der, PasilloDe 9] -- para llegar al preso "C"

ej2 = Bifurcacion (Pasillo 5 (Pasillo 4 Salida))

1
(Pasillo 12 Salida)

EJERCICIOS

1. Definir por recursión explícita las siguientes funciones

a. distASalida :: Calabozo g r -> Maybe Int que describe la distancia a la salida más
cercana. Describe Nothing si no hay ningún camino con salida. Ejemplos:
distASalida ej1 = Nothing
distASalida ej2 = Just 9
distASalida Salida = Just 0

AYUDA: Es útil construir funciones auxiliares agregar y elegir entre elementos de tipo
Maybe.
b. normaliza :: Calabozo g r -> Calabozo g r que describe el resultado de eliminar toda
aplicación de una bifurcación que inmediatamente tiene 2 salidas (el guardia de esa
bifurcación se retira). Ejemplos:

normSalidas (Bifurcacion (Salida 1 Salida)) = Salida
normSalidas (Bifurcacion Salida
1
Bifuracación Salida 2 Salida)) = Salida

normSalidas ej1 = ej1
OBSERVACIÓN: observar que en el resultado no debe quedar NINGUNA bifurcación con
dos salidas.

c. cambioDeGuardia:: (g -> g') -> (r -> r) -> Calabozo g r -> Calabozo g' r que describe el
resultado de cambiar los guardias según indica la primera función, y atender a los presos
según indica la segunda. Ejemplos:
cambioDeGuardia show ((\s->s++" ' ") ej1 =

Bifurcacion

(Pasillo 5 (Celda "A'"))
"1"
(Pasillo 7 (Bifurcacion (Celda "B'")

"2"
(Pasillo 9 (Celda "C' "))))

d. mapa :: Calabozo g r -> [Path] que describe los caminos a todas las celdas y los presos
que hay en cada una. Ejemplos:
mapa ej1 = [pathAlA, pathAlB, pathAlC]
mapa (Celda "A") = [[]]

e. liberarPreso :: Path -> Calabozo g r -> Calabozo g r que describe el resultado de liberar
al preso que se encuentra en el final del camino dado, suponiendo que el camino conduce a
una celda (si no es así, se debe fallar). Al liberar a un preso, su celda se vuelve una salida.
liberarPreso [Izq, PasilloDe 1] ej1 = error "El camino es invalido"
liberarPreso pathAlB ej1 =

Bifurcacion

(Pasillo 5 (Celda "A"))
1
(Pasillo 7 (Bifurcacion (Salida)

2
(Pasillo 9 (Celda "C"))))

2. Demostrar la siguiente propiedad

¿ cantCeldas . appDup (liberarMuchos . mapa) = const 0 ?

dadas las siguientes definiciones.

appDup f x = f x x

liberarMuchos []        cz = cz
liberarMuchos (p:ps) cz = liberarPreso p (liberarMuchos ps cz)

cantCeldas Salida                       = 0
cantCeldas (Celda r)                   = 1
cantCeldas (Pasillo n cz)             = cantCeldas cz
cantCeldas (Bifurcacion c1 g c2) = cantCeldas c1 + cantCeldas c2

AYUDA: Desarrollar únicamente los casos Celda y Pasillo.

3. Dar los tipos y escribir los esquemas de recursión estructural y primitiva para Calabozo.

4. Escribir versiones de las funciones del ejercicio 1 sin utilizar recursión explícita en
ninguna función salvo los esquemas.

