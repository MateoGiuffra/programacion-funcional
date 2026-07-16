# Sintaxis que conviene tener fresca

Ver también: [índice](README.md) · [funciones.md](funciones.md)

---

## `let ... in`
```haskell
let x = expr1
    y = expr2
in expr3
```
- Es una **expresión** — va en cualquier lugar donde puede ir un valor (adentro de un `if`, como argumento de una función, etc.).
- Todo `let` necesita su `in`. No se pueden encadenar dos `let` sin cerrar el primero:
```haskell
-- MAL: al primer let le falta el in
let res = f x y
let final = res + 1
in final

-- BIEN: un solo let con dos bindings alineadas
let res   = f x y
    final = res + 1
in final
```
- Varias bindings en el mismo `let` van alineadas en columna (mismo margen izquierdo), sin `,` ni `;` entre ellas — el layout de Haskell las separa solo por la indentación.

## `where`
```haskell
f x
  | cond1 = a
  | cond2 = b
  where
    a = ...
    b = ...
```
- **No** es una expresión — se pega después de una ecuación completa (una definición de función o un patrón), no se puede meter suelto en el medio de otra expresión como el `let`.
- El scope de un `where` cubre **todas** las guards y el cuerpo de esa ecuación — por eso conviene cuando el mismo valor auxiliar hace falta en más de una guard.
- Si la función tiene varias ecuaciones (varios patrones distintos), cada ecuación tiene su propio `where` — no se comparte entre ecuaciones.

## `case ... of`
```haskell
case expr of
  Patron1   -> resultado1
  Patron2 x -> resultado2   -- podés bindear variables del patrón acá
  _         -> resultadoDefault
```
- Es una **expresión** (da un valor) — a diferencia del pattern matching a nivel de ecuaciones de función, se puede usar sobre cualquier valor intermedio sin tener que nombrarlo como argumento de una función nueva.
- Los patrones se prueban en orden, de arriba hacia abajo — gana el primero que matchea.

## Guards (`|`)
```haskell
f x
  | cond1 = resultado1
  | cond2 = resultado2
  | cond3 = resultado3
```
- Se evalúan en orden, de arriba hacia abajo — gana la primera condición que dé `True`.
- Si ninguna guard matchea y no hay un catch-all, es error en tiempo de ejecución. En vez de agregar `otherwise` como última guard, una alternativa es cerrar con una ecuación aparte de patrón comodín (`f _ = ...`) después de las guards, o un patrón `_` si estás dentro de un `case`.

## Lambda (`\x -> ...`)
```haskell
\x -> x + 1
\x y -> x && y
```
- Función anónima, sin nombre — útil para pasarle a otra función un comportamiento "de una sola vez" (a `map`, `filter`, un campo de tipo función de un constructor, etc.) sin definirlo aparte.
- Puede tomar más de un argumento: `\x y -> ...` es lo mismo que `\x -> \y -> ...`.

## Secciones
```haskell
(+1)   -- \x -> x + 1
(1+)   -- \x -> 1 + x
(2>)   -- \x -> 2 > x
(>2)   -- \x -> x > 2
```
- Aplicación parcial de un operador infijo, escribiendo solo uno de los dos lados entre paréntesis.
- Ojo con `-`: `(- n)` **no** es una sección, Haskell lo lee como el número negativo `-n`. Para "restar `n`" como función usá `subtract n` (ver [funciones.md](funciones.md)).
