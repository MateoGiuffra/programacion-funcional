# Programación Funcional - Práctica de demostraciones - Listas con `if` - solo demos

Libro abierto. Se pueden usar propiedades vistas en clase citando su origen; lo demás se demuestra. Ejercicio de práctica: no hay código para resolver, solo las demostraciones.

## Base

```haskell
data Lista = Vacia | Cons Int Lista
  deriving (Show, Eq)

f :: Lista -> Int
f Vacia       = 0            -- f.1
f (Cons x xs) = 1 + f xs     -- f.2

g :: Int -> Lista -> Lista
g y Vacia       = Vacia                                        -- g.1
g y (Cons x xs) = if x > y then Cons x (g y xs) else g y xs    -- g.2

h :: Int -> Lista -> Lista
h y Vacia       = Vacia                                        -- h.1
h y (Cons x xs) = if x > y then h y xs else Cons x (h y xs)    -- h.2

ej1, ej2, ej3 :: Lista
ej1 = Cons 5 (Cons 1 (Cons 8 (Cons 3 Vacia)))
ej2 = Cons 2 (Cons 2 Vacia)
ej3 = Vacia
```

- `f` describe la cantidad de elementos.
- `g y xs` describe la lista que queda de `xs` al quedarse con los elementos mayores que `y`, en el mismo orden.
- `h y xs` describe la lista que queda de `xs` al quedarse con los elementos que **no** son mayores que `y`, en el mismo orden.
- `g 3 ej1 = Cons 5 (Cons 8 Vacia)` y `h 3 ej1 = Cons 1 (Cons 3 Vacia)`

## Demostración 1

Por inducción estructural, con casos, HI/TI y justificando cada paso.

```
¿ para todo y, xs. f (g y xs) + f (h y xs) = f xs ?
```

Plantilla (completar):

```
casoBase) ...
    ¿ ... ?

casoInductivo) ...
    HI) ¡ ... !
    TI) ¿ ... ?

DEMO:
...
```

## Demostración 2

Por extensionalidad e inducción estructural, con casos, HI/TI y justificando cada paso.

```
¿ para todo y. (g y . g y) = g y ?
```

Plantilla (completar):

```
Sea ... cualquiera.

Por principio de extensionalidad, ...

casoBase) ...
    ¿ ... ?

casoInductivo) ...
    HI) ¡ ... !
    TI) ¿ ... ?

DEMO:
...
```

## Demostración 3 (más difícil)

Misma consigna que la Demostración 2.

```
¿ para todo y, z. (g y . g z) = (g z . g y) ?
```

## Pruebas

Para chequear la base y comprobar sobre ejemplos que las propiedades valen. Se ejecuta con `runghc`.

```haskell
main :: IO ()
main = do
  print (g 3 ej1)   -- Cons 5 (Cons 8 Vacia)
  print (h 3 ej1)   -- Cons 1 (Cons 3 Vacia)
  print (g 9 ej1)   -- Vacia
  print (and [ f (g y xs) + f (h y xs) == f xs | y <- [0 .. 9], xs <- [ej1, ej2, ej3] ])               -- True
  print (and [ (g y . g y) xs == g y xs | y <- [0 .. 9], xs <- [ej1, ej2, ej3] ])                        -- True
  print (and [ (g y . g z) xs == (g z . g y) xs | y <- [0 .. 9], z <- [0 .. 9], xs <- [ej1, ej2, ej3] ]) -- True
```
