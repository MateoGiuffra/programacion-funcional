# Programación Funcional: Currificación y Combinadores

## Ejercicios del pizarrón

### 1) Pasajes a notación en francés (aplicación prefija)

Reescribir las siguientes expresiones:

1. `
suma x = g
  where g y = x + y`

2. `
apply f = g
  where g x = f x`

3. `
const x = g
  where g y = x`

4. `
twice f = g
  where g y = f (f y)`

5. `
compose f = h 
    where h g = k 
            where k x = f (g x)`
 
6. `
flip f = g
  where g x = h
            where h y = (f y) x`


7. `
subst f = h
  where h g = k
            where k x = (f x) (g x)`


Tareas:

1. Escribir cada expresión con todos los paréntesis visibles (explicitar la asociación).
2. Escribir cada expresión con la máxima cantidad de paréntesis invisibles (aprovechando la asociación a izquierda).

### 2) Composición de funciones

Para cada una de las siguientes expresiones:

1. `suma . doble 2`
2. `doble . suma 2`
3. `doble . doble 2`

Tareas:

1. Agregar todos los paréntesis necesarios para que la expresión tenga tipo.
2. Dar el tipo de la expresión.
3. Escribir la misma expresión con la máxima cantidad de paréntesis invisibles.
4. Dar una expresión semántica equivalente.
