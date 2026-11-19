# Soluciones - 004 Demo con `if`

Verificado con GHC: la base compila y las tres propiedades valen sobre los ejemplos. Los pasos de abajo los armé a mano con las ecuaciones de la base. No abrir antes de intentar.

## Demostración 1: `¿ para todo y, xs. cantidad (mayores y xs) + cantidad (noMayores y xs) = cantidad xs ?`

Inducción estructural sobre `xs` (`y` queda como está). El `if` obliga a abrir dos casos sobre `x > y`.

```
casoBase) xs = Vacia
    ¿ cantidad (mayores y Vacia) + cantidad (noMayores y Vacia) = cantidad Vacia ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ cantidad (mayores y xs) + cantidad (noMayores y xs) = cantidad xs !
    TI) ¿ cantidad (mayores y (Cons x xs)) + cantidad (noMayores y (Cons x xs)) = cantidad (Cons x xs) ?

DEMO:

casoBase)
LI)
    cantidad (mayores y Vacia) + cantidad (noMayores y Vacia)
=                                       -- mayores.1
    cantidad Vacia + cantidad (noMayores y Vacia)
=                                       -- noMayores.1
    cantidad Vacia + cantidad Vacia
=                                       -- cantidad.1
    0 + 0
=                                       -- aritm.
    0
LD)
    cantidad Vacia
=                                       -- cantidad.1
    0
Vale para este caso.

casoInductivo)
LD)
    cantidad (Cons x xs)
=                                       -- cantidad.2
    1 + cantidad xs

LI)
    cantidad (mayores y (Cons x xs)) + cantidad (noMayores y (Cons x xs))
=                                       -- mayores.2
    cantidad (if x > y then Cons x (mayores y xs) else mayores y xs) + cantidad (noMayores y (Cons x xs))
=                                       -- noMayores.2
    cantidad (if x > y then Cons x (mayores y xs) else mayores y xs) + cantidad (if x > y then noMayores y xs else Cons x (noMayores y xs))

por analisis de casos sobre x > y

caso1) x > y = True
    cantidad (if x > y then Cons x (mayores y xs) else mayores y xs) + cantidad (if x > y then noMayores y xs else Cons x (noMayores y xs))
=                                       -- def. if, ya que x > y = True
    cantidad (Cons x (mayores y xs)) + cantidad (noMayores y xs)
=                                       -- cantidad.2
    (1 + cantidad (mayores y xs)) + cantidad (noMayores y xs)
=                                       -- aritm. (asociatividad de +)
    1 + (cantidad (mayores y xs) + cantidad (noMayores y xs))
=                                       -- HI
    1 + cantidad xs
    que es el LD.
    Vale para este caso.

caso2) x > y = False
    cantidad (if x > y then Cons x (mayores y xs) else mayores y xs) + cantidad (if x > y then noMayores y xs else Cons x (noMayores y xs))
=                                       -- def. if, ya que x > y = False
    cantidad (mayores y xs) + cantidad (Cons x (noMayores y xs))
=                                       -- cantidad.2
    cantidad (mayores y xs) + (1 + cantidad (noMayores y xs))
=                                       -- aritm. (conmutatividad y asociatividad de +)
    1 + (cantidad (mayores y xs) + cantidad (noMayores y xs))
=                                       -- HI
    1 + cantidad xs
    que es el LD.
    Vale para este caso.

La propiedad vale.
```

## Demostración 2: `¿ para todo y. (mayores y . mayores y) = mayores y ?`

Extensionalidad sobre la lista; luego inducción sobre `xs`. Acá **la misma condición `x > y` aparece dos veces** (una por cada `mayores`): fijado su valor en el primer `if`, el segundo se resuelve con ese mismo valor.

```
Sea y un Int cualquiera.

Por principio de extensionalidad, siendo xs una Lista cualquiera, quiero ver que:
    ¿ (mayores y . mayores y) xs = mayores y xs ?
por def. de compose, es equivalente decir:
    ¿ mayores y (mayores y xs) = mayores y xs ?

por principio de induccion estructural sobre la estructura de xs

casoBase) xs = Vacia
    ¿ mayores y (mayores y Vacia) = mayores y Vacia ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ mayores y (mayores y xs) = mayores y xs !
    TI) ¿ mayores y (mayores y (Cons x xs)) = mayores y (Cons x xs) ?

DEMO:

casoBase)
LI)
    mayores y (mayores y Vacia)
=                                       -- mayores.1
    mayores y Vacia
=                                       -- mayores.1
    Vacia
LD)
    mayores y Vacia
=                                       -- mayores.1
    Vacia
Vale para este caso.

casoInductivo)

por analisis de casos sobre x > y

caso1) x > y = True
LI)
    mayores y (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro)
    mayores y (if x > y then Cons x (mayores y xs) else mayores y xs)
=                                       -- def. if, ya que x > y = True
    mayores y (Cons x (mayores y xs))
=                                       -- mayores.2
    if x > y then Cons x (mayores y (mayores y xs)) else mayores y (mayores y xs)
=                                       -- def. if, ya que x > y = True
    Cons x (mayores y (mayores y xs))
=                                       -- HI
    Cons x (mayores y xs)
LD)
    mayores y (Cons x xs)
=                                       -- mayores.2
    if x > y then Cons x (mayores y xs) else mayores y xs
=                                       -- def. if, ya que x > y = True
    Cons x (mayores y xs)
Vale para este caso.

caso2) x > y = False
LI)
    mayores y (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro)
    mayores y (if x > y then Cons x (mayores y xs) else mayores y xs)
=                                       -- def. if, ya que x > y = False
    mayores y (mayores y xs)
=                                       -- HI
    mayores y xs
LD)
    mayores y (Cons x xs)
=                                       -- mayores.2
    if x > y then Cons x (mayores y xs) else mayores y xs
=                                       -- def. if, ya que x > y = False
    mayores y xs
Vale para este caso.

La propiedad vale.
```

## Demostración 3: `¿ para todo y, z. (mayores y . mayores z) = (mayores z . mayores y) ?`

Igual que la 2, pero **las condiciones son distintas** (`x > y` y `x > z`): no hay atajo, se abren los 4 casos combinados.

```
Sean y y z Int cualesquiera.

Por principio de extensionalidad, siendo xs una Lista cualquiera, quiero ver que:
    ¿ (mayores y . mayores z) xs = (mayores z . mayores y) xs ?
por def. de compose, es equivalente decir:
    ¿ mayores y (mayores z xs) = mayores z (mayores y xs) ?

por principio de induccion estructural sobre la estructura de xs

casoBase) xs = Vacia
    ¿ mayores y (mayores z Vacia) = mayores z (mayores y Vacia) ?

casoInductivo) siendo x un Int cualquiera y xs una Lista cualquiera.
    HI) ¡ mayores y (mayores z xs) = mayores z (mayores y xs) !
    TI) ¿ mayores y (mayores z (Cons x xs)) = mayores z (mayores y (Cons x xs)) ?

DEMO:

casoBase)
LI)
    mayores y (mayores z Vacia)
=                                       -- mayores.1
    mayores y Vacia
=                                       -- mayores.1
    Vacia
LD)
    mayores z (mayores y Vacia)
=                                       -- mayores.1
    mayores z Vacia
=                                       -- mayores.1
    Vacia
Vale para este caso.

casoInductivo)

por analisis de casos sobre x > y, x > z

caso1) x > y = True, x > z = True
LI)
    mayores y (mayores z (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > z = True
    mayores y (Cons x (mayores z xs))
=                                       -- mayores.2, def. if, ya que x > y = True
    Cons x (mayores y (mayores z xs))
=                                       -- HI
    Cons x (mayores z (mayores y xs))
LD)
    mayores z (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > y = True
    mayores z (Cons x (mayores y xs))
=                                       -- mayores.2, def. if, ya que x > z = True
    Cons x (mayores z (mayores y xs))
Vale para este caso.

caso2) x > y = True, x > z = False
LI)
    mayores y (mayores z (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > z = False
    mayores y (mayores z xs)
LD)
    mayores z (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > y = True
    mayores z (Cons x (mayores y xs))
=                                       -- mayores.2, def. if, ya que x > z = False
    mayores z (mayores y xs)
LI y LD: mayores y (mayores z xs) y mayores z (mayores y xs), iguales por HI.
Vale para este caso.

caso3) x > y = False, x > z = True
LI)
    mayores y (mayores z (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > z = True
    mayores y (Cons x (mayores z xs))
=                                       -- mayores.2, def. if, ya que x > y = False
    mayores y (mayores z xs)
LD)
    mayores z (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > y = False
    mayores z (mayores y xs)
LI y LD: mayores y (mayores z xs) y mayores z (mayores y xs), iguales por HI.
Vale para este caso.

caso4) x > y = False, x > z = False
LI)
    mayores y (mayores z (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > z = False
    mayores y (mayores z xs)
LD)
    mayores z (mayores y (Cons x xs))
=                                       -- mayores.2 (el de adentro), def. if, ya que x > y = False
    mayores z (mayores y xs)
LI y LD: iguales por HI.
Vale para este caso.

La propiedad vale.
```

## Qué practicás en cada una

- **Demo 1:** un `if` simple en dos funciones a la vez, con aritmética; cada rama termina con la HI.
- **Demo 2:** `if` **anidado con la misma condición**: en `caso1` se usa `def. if` dos veces sobre el mismo `x > y`.
- **Demo 3:** condiciones **distintas** (`x > y`, `x > z`): 4 casos combinados, sin atajo.
