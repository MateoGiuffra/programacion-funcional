data Lista = Vacia | Cons Int Lista
  deriving (Show, Eq)

cantidad :: Lista -> Int
cantidad Vacia       = 0            -- cantidad.1
cantidad (Cons x xs) = 1 + cantidad xs     -- cantidad.2

mayores :: Int -> Lista -> Lista
mayores y Vacia       = Vacia                                        -- mayores.1
mayores y (Cons x xs) = if x > y then Cons x (mayores y xs) else mayores y xs    -- mayores.2

noMayores :: Int -> Lista -> Lista
noMayores y Vacia       = Vacia                                        -- noMayores.1
noMayores y (Cons x xs) = if x > y then noMayores y xs else Cons x (noMayores y xs)    -- noMayores.2

ej1, ej2, ej3 :: Lista
ej1 = Cons 5 (Cons 1 (Cons 8 (Cons 3 Vacia)))
ej2 = Cons 2 (Cons 2 Vacia)
ej3 = Vacia

{-
Sea y un numero cualquiera.
¿ para todo y, xs. cantidad (mayores y xs) + cantidad (noMayores y xs) = cantidad xs ?

Por ppio de induccion estructural sobre la estructura de xs, quiero ver que:

casoBase) xs = Vacia
    ¿ cantidad (mayores y Vacia) + cantidad (noMayores y Vacia) = cantidad Vacia ?

casoInductivo) xs = (Cons x xs')
    HI) ¡ cantidad (mayores y xs') + cantidad (noMayores y xs') = cantidad xs' !
    TI) ¿ cantidad (mayores y (Cons x xs')) + cantidad (noMayores y (Cons x xs')) = cantidad (Cons x xs') ?

En el casoInductivo uso el siguiente lema (se demuestra despues de la demo principal):

LEMA-BOOL)
    ¿ para todo x, y, xs'.
        cantidad (if x > y then Cons x (mayores y xs') else mayores y xs')
      + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
      = 1 + (cantidad (mayores y xs') + cantidad (noMayores y xs')) ?


DEMO:

casoBase)
LI)
    cantidad (mayores y Vacia) + cantidad (noMayores y Vacia)
=                                                               mayores.1
    cantidad Vacia + cantidad (noMayores y Vacia)
=                                                               noMayores.1
    cantidad Vacia + cantidad Vacia
=                                                               cantidad.1
    0 + 0
=                                                               aritm
    0

LD)
    cantidad Vacia
=                                                               cantidad.1
    0

Vale para este caso.


casoInductivo)
LI)
    cantidad (mayores y (Cons x xs')) + cantidad (noMayores y (Cons x xs'))
=                                                               mayores.2
    cantidad (if x > y then Cons x (mayores y xs') else mayores y xs') + cantidad (noMayores y (Cons x xs'))
=                                                               noMayores.2
    cantidad (if x > y then Cons x (mayores y xs') else mayores y xs') + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
=                                                               LEMA-BOOL
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))
=                                                               HI
    1 + cantidad xs'

LD)
    cantidad (Cons x xs')
=                                                               cantidad.2
    1 + cantidad xs'

Vale para este caso.

La propiedad vale.


LEMA-BOOL)
    ¿ para todo x, y, xs'.
        cantidad (if x > y then Cons x (mayores y xs') else mayores y xs')
      + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
      = 1 + (cantidad (mayores y xs') + cantidad (noMayores y xs')) ?

Sean x, y, xs' cualesquiera.

por analisis de casos sobre x > y

c1) x > y = True
c2) x > y = False

c1)
LI)
    cantidad (if x > y then Cons x (mayores y xs') else mayores y xs') + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
=                                                               def. if, ya que x > y = True
    cantidad (Cons x (mayores y xs')) + cantidad (noMayores y xs')
=                                                               cantidad.2
    (1 + cantidad (mayores y xs')) + cantidad (noMayores y xs')
=                                                               aritm (asociatividad de +)
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))

LD)
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))

Vale para este caso.

c2)
LI)
    cantidad (if x > y then Cons x (mayores y xs') else mayores y xs') + cantidad (if x > y then noMayores y xs' else Cons x (noMayores y xs'))
=                                                               def. if, ya que x > y = False
    cantidad (mayores y xs') + cantidad (Cons x (noMayores y xs'))
=                                                               cantidad.2
    cantidad (mayores y xs') + (1 + cantidad (noMayores y xs'))
=                                                               aritm (conmutatividad y asociatividad de +)
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))

LD)
    1 + (cantidad (mayores y xs') + cantidad (noMayores y xs'))

Vale para este caso.

El lema vale.
-}
