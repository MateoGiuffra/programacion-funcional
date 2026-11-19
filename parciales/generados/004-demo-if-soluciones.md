# Soluciones - 004 Demo con `if`

Verificado con GHC: la base compila y las tres propiedades valen sobre los ejemplos. Los pasos de abajo los armé a mano con las ecuaciones de la base. No abrir antes de intentar.

## Demostración 1: `¿ para todo y, xs. f (g y xs) + f (h y xs) = f xs ?`

Inducción estructural sobre `xs` (`y` queda como está). El `if` obliga a abrir dos casos sobre `x > y`.

```
casoBase) xs = Vacia
    ¿ f (g y Vacia) + f (h y Vacia) = f Vacia ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ f (g y xs) + f (h y xs) = f xs !
    TI) ¿ f (g y (Cons x xs)) + f (h y (Cons x xs)) = f (Cons x xs) ?

DEMO:

casoBase)
LI)
    f (g y Vacia) + f (h y Vacia)
=                                       -- g.1
    f Vacia + f (h y Vacia)
=                                       -- h.1
    f Vacia + f Vacia
=                                       -- f.1
    0 + 0
=                                       -- aritm.
    0
LD)
    f Vacia
=                                       -- f.1
    0
Vale para este caso.

casoInductivo)
LD)
    f (Cons x xs)
=                                       -- f.2
    1 + f xs

LI)
    f (g y (Cons x xs)) + f (h y (Cons x xs))
=                                       -- g.2
    f (if x > y then Cons x (g y xs) else g y xs) + f (h y (Cons x xs))
=                                       -- h.2
    f (if x > y then Cons x (g y xs) else g y xs) + f (if x > y then h y xs else Cons x (h y xs))

por analisis de casos sobre x > y

caso1) x > y = True
    f (if x > y then Cons x (g y xs) else g y xs) + f (if x > y then h y xs else Cons x (h y xs))
=                                       -- def. if, ya que x > y = True
    f (Cons x (g y xs)) + f (h y xs)
=                                       -- f.2
    (1 + f (g y xs)) + f (h y xs)
=                                       -- aritm. (asociatividad de +)
    1 + (f (g y xs) + f (h y xs))
=                                       -- HI
    1 + f xs
    que es el LD.
    Vale para este caso.

caso2) x > y = False
    f (if x > y then Cons x (g y xs) else g y xs) + f (if x > y then h y xs else Cons x (h y xs))
=                                       -- def. if, ya que x > y = False
    f (g y xs) + f (Cons x (h y xs))
=                                       -- f.2
    f (g y xs) + (1 + f (h y xs))
=                                       -- aritm. (conmutatividad y asociatividad de +)
    1 + (f (g y xs) + f (h y xs))
=                                       -- HI
    1 + f xs
    que es el LD.
    Vale para este caso.

La propiedad vale.
```

## Demostración 2: `¿ para todo y. (g y . g y) = g y ?`

Extensionalidad sobre la lista; luego inducción sobre `xs`. Acá **la misma condición `x > y` aparece dos veces** (una por cada `g`): fijado su valor en el primer `if`, el segundo se resuelve con ese mismo valor.

```
Sea y un Int cualquiera.

Por principio de extensionalidad, siendo xs una Lista cualquiera, quiero ver que:
    ¿ (g y . g y) xs = g y xs ?
por def. de compose, es equivalente decir:
    ¿ g y (g y xs) = g y xs ?

por principio de induccion estructural sobre la estructura de xs

casoBase) xs = Vacia
    ¿ g y (g y Vacia) = g y Vacia ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ g y (g y xs) = g y xs !
    TI) ¿ g y (g y (Cons x xs)) = g y (Cons x xs) ?

DEMO:

casoBase)
LI)
    g y (g y Vacia)
=                                       -- g.1
    g y Vacia
=                                       -- g.1
    Vacia
LD)
    g y Vacia
=                                       -- g.1
    Vacia
Vale para este caso.

casoInductivo)

por analisis de casos sobre x > y

caso1) x > y = True
LI)
    g y (g y (Cons x xs))
=                                       -- g.2 (el de adentro)
    g y (if x > y then Cons x (g y xs) else g y xs)
=                                       -- def. if, ya que x > y = True
    g y (Cons x (g y xs))
=                                       -- g.2
    if x > y then Cons x (g y (g y xs)) else g y (g y xs)
=                                       -- def. if, ya que x > y = True
    Cons x (g y (g y xs))
=                                       -- HI
    Cons x (g y xs)
LD)
    g y (Cons x xs)
=                                       -- g.2
    if x > y then Cons x (g y xs) else g y xs
=                                       -- def. if, ya que x > y = True
    Cons x (g y xs)
Vale para este caso.

caso2) x > y = False
LI)
    g y (g y (Cons x xs))
=                                       -- g.2 (el de adentro)
    g y (if x > y then Cons x (g y xs) else g y xs)
=                                       -- def. if, ya que x > y = False
    g y (g y xs)
=                                       -- HI
    g y xs
LD)
    g y (Cons x xs)
=                                       -- g.2
    if x > y then Cons x (g y xs) else g y xs
=                                       -- def. if, ya que x > y = False
    g y xs
Vale para este caso.

La propiedad vale.
```

## Demostración 3: `¿ para todo y, z. (g y . g z) = (g z . g y) ?`

Igual que la 2, pero **las condiciones son distintas** (`x > y` y `x > z`): no hay atajo, se abren los 4 casos combinados.

```
Sean y y z Int cualesquiera.

Por principio de extensionalidad, siendo xs una Lista cualquiera, quiero ver que:
    ¿ (g y . g z) xs = (g z . g y) xs ?
por def. de compose, es equivalente decir:
    ¿ g y (g z xs) = g z (g y xs) ?

por principio de induccion estructural sobre la estructura de xs

casoBase) xs = Vacia
    ¿ g y (g z Vacia) = g z (g y Vacia) ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ g y (g z xs) = g z (g y xs) !
    TI) ¿ g y (g z (Cons x xs)) = g z (g y (Cons x xs)) ?

DEMO:

casoBase)
LI)
    g y (g z Vacia)
=                                       -- g.1
    g y Vacia
=                                       -- g.1
    Vacia
LD)
    g z (g y Vacia)
=                                       -- g.1
    g z Vacia
=                                       -- g.1
    Vacia
Vale para este caso.

casoInductivo)

por analisis de casos sobre x > y, x > z

caso1) x > y = True, x > z = True
LI)
    g y (g z (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > z = True
    g y (Cons x (g z xs))
=                                       -- g.2, def. if, ya que x > y = True
    Cons x (g y (g z xs))
=                                       -- HI
    Cons x (g z (g y xs))
LD)
    g z (g y (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > y = True
    g z (Cons x (g y xs))
=                                       -- g.2, def. if, ya que x > z = True
    Cons x (g z (g y xs))
Vale para este caso.

caso2) x > y = True, x > z = False
LI)
    g y (g z (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > z = False
    g y (g z xs)
LD)
    g z (g y (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > y = True
    g z (Cons x (g y xs))
=                                       -- g.2, def. if, ya que x > z = False
    g z (g y xs)
LI y LD: g y (g z xs) y g z (g y xs), iguales por HI.
Vale para este caso.

caso3) x > y = False, x > z = True
LI)
    g y (g z (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > z = True
    g y (Cons x (g z xs))
=                                       -- g.2, def. if, ya que x > y = False
    g y (g z xs)
LD)
    g z (g y (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > y = False
    g z (g y xs)
LI y LD: g y (g z xs) y g z (g y xs), iguales por HI.
Vale para este caso.

caso4) x > y = False, x > z = False
LI)
    g y (g z (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > z = False
    g y (g z xs)
LD)
    g z (g y (Cons x xs))
=                                       -- g.2 (el de adentro), def. if, ya que x > y = False
    g z (g y xs)
LI y LD: iguales por HI.
Vale para este caso.

La propiedad vale.
```

## Qué practicás en cada una

- **Demo 1:** un `if` simple en dos funciones a la vez, con aritmética; cada rama termina con la HI.
- **Demo 2:** `if` **anidado con la misma condición**: en `caso1` se usa `def. if` dos veces sobre el mismo `x > y`.
- **Demo 3:** condiciones **distintas** (`x > y`, `x > z`): 4 casos combinados, sin atajo.
