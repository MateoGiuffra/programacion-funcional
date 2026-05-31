{-
a.  para todo xs. para todo ys.      length (xs ++ ys) = length xs + length ys

Prop.: pregunta del enunciado
Demo.: por ppio de induccion estructural sobre la estructura a demostrar, es equivalente demostrar que

Sea uno o varios nombres de variables distintas a la pregunta :: tipo de la var

CB. asignacion de caso base en las vars de arriba
    reemplazas las vars...
    ¿length ([] ++ []) = length [] + length []?

CI. asignacion de la estructura abierta en las vars de arriba
    HI) cambias los signos de pregunta por signos de exclamacion de la pregunta inicial
    reemplazas las vars...
    TI) ¿length ((z: zs) ++ (a: as)) = length (z: zs) + length (a: as)?

Dem. caso base)
    Lado izq:
        ...
    Lado der:
        ...

    Vale o no vale

Dem. caso inductivo)
    Lado izq:
        ...
    Lado der:
        ...

    Vale o no vale

-}