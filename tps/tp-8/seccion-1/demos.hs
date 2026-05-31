{-
Ejercicio 2)  Demostrar por inducción estructural las siguientes propiedades:

Prop.: ¿length (xs ++ ys) = length xs + length ys?
Demo.: por ppio de induccion estructural sobre xs, es equivalente demostrar que

Sea zs :: [a], as:: [a]

CB. zs = [], as = []
    ¿length ([] ++ []) = length [] + length []?

CI. zs = (z: zs)
    HI) ¡length (zs ++ as) = length zs + length as!
    TI) ¿length ((z: zs) ++ as) = length (z: zs) + length as?

Dem. caso base)
    Lado izq:
        length ([] ++ [])
    =                       def (++)
        length []
    =                       def length,
        0

    Lado der:
        length [] + length []
    =                         def length.1
        0 + length []
    =                         def length.2
        0 + 0
    =                         aritm.
        0

    Vale.

Dem. caso inductivo)
    Lado izq:
        length ((z: zs) ++ as)
    =                               def (++), (x: xs) <- (z: zs)
        length (z:(zs ++ as))
    =                               def length
        1 + length (zs ++ as)

    Lado der:
        length (z: zs) + length as
    =                               def length.1 (z: zs)
        1 + length zs + length as
    =                               HI
        1 + length (zs ++ as)

    Vale

b.  para todo xs. para todo ys.  para todo zs.      (xs ++ ys) ++ zs = xs ++ (ys ++ zs)

Prop.: ¿(xs ++ ys) ++ zs = xs ++ (ys ++ zs)?
Demo.: por ppio de induccion estructural sobre listas, es equivalente demostrar que

Sea xs :: [a], ys :: [a], zs :: [a]

CB. xs = [], ys = [], zs = []
    ¿([] ++ []) ++ [] = [] ++ ([] ++ [])?

CI. xs = (x :xs)
    HI) ¡(xs ++ ys) ++ zs = xs ++ (ys ++ zs)!
    TI) ¿((x :xs) ++ ys) ++ zs = (x :xs) ++ (ys ++ zs)?

Caso base:
    Lado izq:
        ([] ++ []) ++ [])
    =                       def (++).1
        [] ++ []
    =                       def (++).2
        []

    Lado der
        [] ++ ([] ++ [])
    =                       def (++).1
        [] ++ ([])
    =                       def (++).2
        []

    Vale.

Caso Inductivo:
    Lado izq:
        ((x :xs) ++ ys) ++ zs
    =                           def (++).1
        (x :(xs ++ ys)) ++ zs

    Lado der:
        (x: xs) ++ (ys ++ zs)
    =                           def (++).1
        x: (xs ++ (ys ++ zs))
    =                           HI
        x: ((xs ++ ys) ++ zs)

    Vale

c.  count (const True) = length

Prop.: ¿count (const True) xs = length xs?
Dem.:  por ppio de induccion estructural sobre listas, es equivalente demostrar que:

Sea xs :: [a]

CB.
    xs = []
    ¿count (const True) [] = length []?

CI.
    xs = (x: xs)
    HI) ¡count (const True) xs = length xs!
    TI) ¿count (const True) (x: xs) = length (x: xs)?

Dem. caso base)
    Lado izq:
        count (const True) []
    =                           def count, f <- (const True), xs <- []
        0

    Lado der:
        length []
    =               def length
        0

    Vale.

Dem. caso inductivo)
    Lado izq:
        count (const True) (x: xs)
    =                              def count, f <- (const True), xs <- (x: xs)
        unoSiTrue (const True x) + count (const True) xs
    =                                                       por def const
        unoSiTrue (True) + count (const True) xs
    =                                                       por def unoSiTrue
        1 + count (const True) xs

    Lado der:
        length (x: xs)
    =                   def length
        1 + length xs
    =                   HI
        1 + count (const True) xs

d.  elem =  any . (==)
Prop.: ¿elem e xs =  (any . (==)) e xs ?
Dem.: por ppio de induccion estructural sobre listas, es equivalente demostrar que:

Sea xs :: [a], e :: a

CB.
    xs = []
    ¿elem e [] =  (any . (==)) e [] ?

CI.
    xs = (x: xs)
    HI) ¡elem e xs =  (any . (==)) e xs!
    TI) ¿elem e (x: xs) =  (any . (==)) e (x: xs) ?

Caso base:
    Lado izq:
        elem e []
    =               def elem
        False

    Lado der:
        (any . (==)) e []
    =                       def (.)
        any ((==) e) []
    =                       def any
        False

    Vale.

Caso inductivo:
    Lado izq:
        elem e (x: xs)
    =                   def elem
        x == e || elem e xs

    Lado der:
        (any . (==)) e (x: xs)
    =                           def (.)
        any ((==) e) (x: xs)
    =                           def any, f <- ((==) e), (x: xs) <- (x: xs)
        ((==) e) x || any ((==) e) xs
    =                           def (==)
        x == e || any ((==) e) xs
    =                           def HI
        x == e || elem e xs

    Vale.

e.  para todo x. any (elem x) = elem x . concat
f.  para todo xs. para todo ys. subset xs ys = all (flip elem ys) xs
g.  all null = null . concat
h.  length = length . reverse
i.  para todo xs. para todo ys.        reverse (xs ++ ys) = reverse ys ++ reverse xs
j.  para todo xs. para todo ys.    all p (xs++ys) = all p (reverse xs) && all p (reverse ys)
k.  para todo xs. para todo ys. unzip (zip xs ys) = (xs, ys)  (en este caso, mostrar que no vale)

-}