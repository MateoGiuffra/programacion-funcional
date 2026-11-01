# Clase 12 (presencial) — BST23

Siendo:

```haskell
data BST23 a = Cero
             | Dos  Int Int (BST23 a) a (BST23 a)
             | Tres Int Int (BST23 a) a (BST23 a) a (BST23 a)
```

## Invariantes de representación

En `t = Dos h n t1 x t2`:

- `h` es la altura de `t` y `n` es el size de `t`
- `t1` y `t2` tienen la misma altura
- todos los elementos de `t1` son `< x`
- todos los elementos de `t2` son `> x`
- `t1` y `t2` cumplen este invariante de representación

En `t = Tres h n t1 x t2 y t3`:

- `h` es la altura de `t` y `n` es el size de `t`
- `t1`, `t2` y `t3` tienen la misma altura
- `x < y`
- todos los elementos de `t1` son `< x`
- todos los elementos de `t2` son `> x` y `< y`
- todos los elementos de `t3` son `> y`
- `t1`, `t2` y `t3` cumplen este invariante de representación

## Ejercicios

1. Dar el tipo y definir `fold23` y `rec23`.
2. Definir las siguientes funciones **sin usar recursión explícita**:
   - a. `inOrder`
   - b. `cantElem` — sin usar el invariante de representación
   - c. `altura` — sin usar el invariante de representación
   - d. `minElem :: BST23 a -> a` — sin usar los `Int`
   - e. `maxElem :: BST23 a -> a` — sin usar los `Int`
   - f. `search :: a -> BST23 a -> a`
   - g. **[Bonus]** `verificarMisDatos :: BST23 a -> (Bool, Int, Int, Maybe a, Maybe a)`, que calcula una indicación de que el árbol cumple el invariante de representación, junto con la altura, el tamaño, el mínimo y el máximo elemento del árbol.
   - h. **[Bonus++]** `insert :: a -> BST23 a -> BST23 a`. Ayuda: usar y definir `armar23DesdeDos` y `armar23DesdeTres`.
