# Programación Funcional - Práctica de demostraciones - Listas con `if` - solo demos

Libro abierto. Se pueden usar propiedades vistas en clase citando su origen; lo demás se demuestra. Ejercicio de práctica: no hay código para resolver, solo las demostraciones.

## Base

```haskell
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
```

- `cantidad` describe la cantidad de elementos.
- `mayores y xs` describe la lista que queda de `xs` al quedarse con los elementos mayores que `y`, en el mismo orden.
- `noMayores y xs` describe la lista que queda de `xs` al quedarse con los elementos que **no** son mayores que `y`, en el mismo orden.
- `mayores 3 ej1 = Cons 5 (Cons 8 Vacia)` y `noMayores 3 ej1 = Cons 1 (Cons 3 Vacia)`

## Demostración 1

Por inducción estructural, con casos, HI/TI y justificando cada paso.

```
¿ para todo y, xs. cantidad (mayores y xs) + cantidad (noMayores y xs) = cantidad xs ?
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
¿ para todo y. (mayores y . mayores y) = mayores y ?
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
¿ para todo y, z. (mayores y . mayores z) = (mayores z . mayores y) ?
```

## Pruebas

Para chequear la base y comprobar sobre ejemplos que las propiedades valen. Se ejecuta con `runghc`.

```haskell
main :: IO ()
main = do
  print (mayores 3 ej1)   -- Cons 5 (Cons 8 Vacia)
  print (noMayores 3 ej1)   -- Cons 1 (Cons 3 Vacia)
  print (mayores 9 ej1)   -- Vacia
  print (and [ cantidad (mayores y xs) + cantidad (noMayores y xs) == cantidad xs | y <- [0 .. 9], xs <- [ej1, ej2, ej3] ])               -- True
  print (and [ (mayores y . mayores y) xs == mayores y xs | y <- [0 .. 9], xs <- [ej1, ej2, ej3] ])                        -- True
  print (and [ (mayores y . mayores z) xs == (mayores z . mayores y) xs | y <- [0 .. 9], z <- [0 .. 9], xs <- [ej1, ej2, ej3] ]) -- True
```
