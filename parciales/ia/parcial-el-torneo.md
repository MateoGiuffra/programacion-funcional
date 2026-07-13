# Programación Funcional

## Parcial de práctica — El Torneo

> Este parcial es original (no es un fork de ningún enunciado real puntual). Fue generado
> siguiendo `guia-generacion-parciales.md` de esta misma carpeta, con dominio y forma
> estructural distintos a los demás documentos de `parciales/ia/`. Una primera versión usaba
> un árbol general (`data Brigada = Cocinero Nombre Presupuesto [Brigada]`); el usuario
> aclaró que ese tipo de estructura no entra en el temario de la materia, así que esta
> versión usa en cambio un árbol binario de aridad fija.

Un torneo de eliminación simple se organiza en llaves: cada partido enfrenta a dos
contendientes (que pueden ser jugadores individuales o, a su vez, los ganadores de partidos
previos) y de cada partido avanza un único ganador. Modelamos un torneo completo, ya
disputado, con el tipo `Torneo`:

```haskell
type Nombre = String
type Puntaje = Int

data Torneo = Jugador Nombre Puntaje
            | Partido Torneo Torneo

data Dir = Izq | Der
type Ruta = [Dir]
```

Un `Jugador` es una llave ya resuelta hasta esa hoja, con el puntaje que obtuvo en su
partido más reciente. Un `Partido` enfrenta a los dos subtorneos dados (lo que haya
resultado de cada lado de la llave); si hay empate de puntaje entre los ganadores de ambos
lados, se considera ganador al de la izquierda.

## Ejercicios

1. Definir **por recursión explícita** las siguientes funciones:

   a. `cantidadJugadores :: Torneo -> Int`, que describe la cantidad de jugadores que
      participaron en el torneo (incluyendo los eliminados).

   b. `puntajeTotal :: Torneo -> Puntaje`, que describe la suma de los puntajes obtenidos por
      todos los jugadores del torneo (ganadores y eliminados).

   c. `ganador :: Torneo -> Nombre`, que describe el nombre del ganador del torneo.

      **AYUDA:** `ganador` sola no se puede resolver por recursión estructural directa: en
      cada `Partido` hace falta comparar los puntajes de los ganadores de ambos lados para
      saber cuál devolver, y ese puntaje se pierde si la función solo devuelve el `Nombre`.
      Conviene definir antes una función auxiliar `ganadorConPuntaje :: Torneo -> (Nombre,
      Puntaje)` por recursión estructural, e implementar `ganador` en términos de ella.

   d. `caminoHasta :: Nombre -> Torneo -> Maybe Ruta`, que describe el camino de `Izq`/`Der`
      desde la raíz del torneo hasta la hoja del jugador con el nombre dado, o `Nothing` si
      ningún jugador del torneo tiene ese nombre.

   e. `escalarPuntajes :: Int -> Torneo -> Torneo`, que describe el torneo resultante de
      multiplicar por el factor dado el puntaje de **todos** los jugadores (ganadores y
      eliminados).

   **Ejemplos:** siendo

   ```haskell
   semi1 = Partido (Jugador "Bruno" 30) (Jugador "Carla" 45)
   semi2 = Partido (Jugador "Diego" 20) (Jugador "Elena" 45)
   final = Partido semi1 semi2
   ```

   ```haskell
   cantidadJugadores final = 4
   puntajeTotal final = 140
   ganador final = "Carla"
   caminoHasta "Bruno" final = Just [Izq, Izq]
   caminoHasta "Elena" final = Just [Der, Der]
   caminoHasta "Renata" final = Nothing
   escalarPuntajes 2 final
     = Partido (Partido (Jugador "Bruno" 60) (Jugador "Carla" 90))
               (Partido (Jugador "Diego" 40) (Jugador "Elena" 90))
   ```

2. Demostrar la siguiente propiedad: para todo `k > 0`,

   `ganador . escalarPuntajes k = ganador`

   **Ayuda:** en el desarrollo, plantear primero (y demostrar aparte) el siguiente lema sobre
   `ganadorConPuntaje`: para todo `k > 0` y todo `t :: Torneo`, si `ganadorConPuntaje t =
   (n, p)` entonces `ganadorConPuntaje (escalarPuntajes k t) = (n, k*p)`.

3. Dar los tipos y escribir los esquemas de recursión **estructural** y **primitiva** para
   `Torneo`.

4. Escribir versiones de **todas** las funciones recursivas del Ejercicio 1 utilizando
   esquemas, sin usar recursión explícita en ninguna función diferente de los esquemas.

---

## Nota de generación

Dominio y forma elegidos para variar respecto al resto de la carpeta: `Torneo` es un árbol
**binario de aridad fija** (cada `Partido` tiene exactamente dos subtorneos, sin lista de
hijos), distinto del camino con bloqueo/bifurcación de Incidente/Deméter y del DSL de
secuenciación de Animaciones. El eje del parcial es el mismo truco que aparece en varios
parciales viejos (`ThreeT.findTT`, `Spaceship`, y el propio Incidente con `pasos`): una
función que "se ve" simple (`ganador :: Torneo -> Nombre`) en realidad no sale por recursión
estructural directa porque en el caso recursivo hace falta comparar información que la firma
de la función no expone, y hay que resolverlo con una auxiliar de tipo más rico
(`ganadorConPuntaje :: Torneo -> (Nombre, Puntaje)`).

Antes de dejar los ejemplos escritos, calculé a mano `cantidadJugadores`, `puntajeTotal`,
`ganador` (incluyendo el desempate a la izquierda en la final, donde Carla y Elena empatan
45 a 45), `caminoHasta` (incluyendo el caso `Nothing` con "Renata") y `escalarPuntajes` sobre
el árbol `final`, siguiendo las ecuaciones de recursión explícita que resolverían el
Ejercicio 1, y verifiqué que con `k=2` el ganador post-escalado seguía siendo "Carla" antes
de fijar la propiedad del Ejercicio 2.
