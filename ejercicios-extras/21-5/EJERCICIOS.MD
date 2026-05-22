### Ejercicio 1

Dadas las siguientes definiciones en Haskell:

```haskell
data Objeto = Moneda | Pelusa
data Dungeon = Cueva | Habitacion [Objeto] Dungeon Dungeon

objs :: Dungeon -> [Objeto]
objs = error "implementar"

doblar :: [Objeto] -> [Objeto]
doblar [] = []
doblar (o:os) = dobleObj o ++ doblar os

dobleObj :: Objeto -> [Objeto]
dobleObj Moneda = [Moneda, Moneda]
dobleObj o = [o]

excavar :: Dungeon -> Dungeon
excavar Cueva = Cueva
excavar (Habitacion os d1 d2) = Habitacion (doblar os) (excavar d1) (excavar d2) -- Corregido: d2 en lugar de d1 para tener sentido recursivo.
```

a) Definir la función `objs`.
b) Demostrar la propiedad: `objs . excavar = doblar . objs`.

---

### Ejercicio 2

Dar la función `losAntecesoresDe :: Eq a => a -> Tree a -> [a]` que describe la lista de antecesores del elemento dado dentro del árbol, suponiendo que el elemento existe en el árbol.

**Ejemplo:**

`losAntecesoresDe 7 A` debería devolver `[1, 3]`.

Con el siguiente árbol `A`:

```haskell
data Tree a = EmptyT | NodeT a (Tree a) (Tree a)

A :: Tree Int
A = NodeT 1 
        (NodeT 2
                (NodeT 4 EmptyT EmptyT)
                (NodeT 5 EmptyT EmptyT)
        )
        (NodeT 3
                (NodeT 6 EmptyT EmptyT)
                (NodeT 7
                        (NodeT 8 EmptyT EmptyT)
                        (NodeT 9 EmptyT EmptyT)
                )
        )
```