{-
b. demostrar la siguiente propiedad:
i. ea2ExpA . expA2ea = id
ii. expA2ea . ea2ExpA = id
iii. evalExpA . ea2ExpA = evalEA
iv. evalEA . expA2ea = evalExpA

Prop.: ¿(ea2ExpA . expA2ea) expa = id expa?
Dem.: por ppio de induccion estructural sobre la estructura de expa, se demuestra que
Sea expa :: ExpA

CB.
    expa = (Cte n)
    ¿(ea2ExpA . expA2ea) (Cte n) = id (Cte n)?

CI.
    HI) !(ea2ExpA . expA2ea) expa = id ea¡

    TI.1) ¿ea2ExpA . expA2ea (Suma e1 e2) = id (Suma e1 e2)?
    TI.2) ¿ea2ExpA . expA2ea (Prod e1 e2) = id (Prod e1 e2)?

Caso base:
    Lado izq:
        (ea2ExpA . expA2ea) (Cte n)
    =                               def (.)
        ea2ExpA (expA2ea (Cte n))
    =                               def expA2ea
        ea2ExpA (Const n)
    =                               def ea2ExpA
        (Cte n)

    Lado der:
        id (Cte n)
    =               def id
        (Cte n)

    Vale.

Caso Inductivo.1:
    Lado izq:
        (ea2ExpA . expA2ea) (Suma e1 e2)
    =                                   def (.)
        ea2ExpA (expA2ea (Suma e1 e2))
    =                                   def expA2ea,
        ea2ExpA ((BOp Mul (expA2ea a1) (expA2ea a2)))
    =                                   def ea2ExpA
        (Suma (ea2ExpA (expA2ea a1)) (ea2ExpA (expA2ea a2)))
    =                                   HI
        (Suma (id a1) (id a2))
    =                                   def id
        (Suma a1 a2)

    Lado der:
        id (Suma e1 e2)
    =                   def id
        (Suma e1 e2)

    Vale.

Caso Inductivo.2:
    Lado izq:
        (ea2ExpA . expA2ea) (Prod e1 e2)
    =                                   def (.)
        ea2ExpA (expA2ea (Prod e1 e2))
    =                                   def expA2ea,
        ea2ExpA ((BOp Sum (expA2ea a1) (expA2ea a2)))
    =                                   def ea2ExpA
        (Prod (ea2ExpA (expA2ea a1)) (ea2ExpA (expA2ea a2)))
    =                                   HI
        (Prod (id a1) (id a2))
    =                                   def id
        (Prod a1 a2)

    Lado der:
        id (Prod e1 e2)
    =                   def id
        (Prod e1 e2)

    Vale.

    La propiedad vale.

-}
