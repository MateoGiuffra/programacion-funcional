# Funciones de Prelude que aparecen todo el tiempo

Ver también: [índice](README.md) · [sintaxis.md](sintaxis.md)

---

| Función | Tipo | Para qué sirve |
|---|---|---|
| `map` | `(a -> b) -> [a] -> [b]` | aplicar una función a cada elemento, preservando la forma de la lista |
| `filter` | `(a -> Bool) -> [a] -> [a]` | quedarte con los elementos que cumplen un predicado |
| `flip` | `(a -> b -> c) -> b -> a -> c` | invertir el orden de los primeros dos argumentos de una función — típico cuando tenés `f :: A -> B -> C` pero necesitás pasarla como `B -> C` con `A` ya fijo |
| `(.)` (compose) | `(b -> c) -> (a -> b) -> a -> c` | encadenar dos funciones sin nombrar el argumento intermedio; `(f . g) x = f (g x)` |
| `id` | `a -> a` | no hacer nada — útil como placeholder cuando necesitás pasar una función pero no debería importar cuál (con cuidado: no siempre es seguro usarlo para "simular" un valor real, ver [patrones.md](patrones.md)) |
| `const` | `a -> b -> a` | ignora el segundo argumento, devuelve siempre el primero — típico para armar un valor constante independiente del input |
| `flip const` | `a -> b -> b` | el opuesto de `const`: ignora el primero, devuelve siempre el segundo. No tiene nombre propio en el Prelude — se escribe `flip const` o directo `\_ y -> y` |
| `subtract` | `Num a => a -> a -> a` | `subtract n = \y -> y - n` (resta `n`, en ese orden). Existe porque `(- n)` como sección **no** funciona — Haskell lo lee como el número negativo `-n`, no como una función. Si necesitás "restar n" en punto libre (ej. para pasarle a `map`), `subtract n` es la forma correcta, `(- n)` no |
| `curry` | `((a,b) -> c) -> a -> b -> c` | convierte una función que toma un par en una función currificada (dos argumentos separados en vez de uno solo tipo tupla) |
| `uncurry` | `(a -> b -> c) -> (a,b) -> c` | la inversa de `curry`: convierte una función currificada en una que toma un solo par |
| `uflip` | `(a -> b -> c) -> (a,b) -> c` | "flip sin currificar": toma los dos argumentos como un par y se los pasa invertidos a `f` — `uflip f (x,y) = f y x`. No es un nombre estándar de Haskell (es `uncurry` compuesto con `flip`, `uncurry (flip f)`), así que fijate si tu cátedra lo define distinto |
| `apply` (`($)`) | `(a -> b) -> a -> b` | aplicar una función a un argumento escrito como función en vez de yuxtaposición — `apply f x = f x`. En Haskell esto ya existe como el operador `($)`, útil sobre todo para no encadenar paréntesis: `f $ g $ h x` en vez de `f (g (h x))` |
| `twice` | `(a -> a) -> a -> a` | aplicar la misma función dos veces seguidas — `twice f = f . f`, o punto a punto `twice f x = f (f x)` |
| `replicate` | `Int -> a -> [a]` | lista de `n` copias del mismo elemento — cuidado, tiene que ser una lista de `n` elementos, no un único elemento que contenga `n` cosas adentro |
| `null` | `[a] -> Bool` | ¿la lista está vacía? — útil para distinguir a mano los dos sentidos de un caso base compartido en un `fold` (ver [esquemas.md](esquemas.md)) |
| `(++)` | `[a] -> [a] -> [a]` | concatenar listas — suele ser lo que hace por debajo una secuencia/concatenación de dos sub-resultados |
| `zip` | `[a] -> [b] -> [(a,b)]` | empareja dos listas elemento a elemento en tuplas — se corta en la lista más corta, no acarrea el resto de la más larga |
| `zipWith` | `(a -> b -> c) -> [a] -> [b] -> [c]` | como `zip`, pero combinando cada par con una función en vez de armar la tupla — `zipWith f xs ys = map (uncurry f) (zip xs ys)`. Misma salvedad: se corta en la más corta, no es lo mismo que "acarrear el resto" (ver "dos ramas que corren en simultáneo" en [patrones.md](patrones.md)) |
| `maybe` | `b -> (a -> b) -> Maybe a -> b` | destructor de `Maybe`: `maybe defecto f Nothing = defecto`, `maybe defecto f (Just x) = f x` — evita escribir el `case` a mano |
| `either` | `(a -> c) -> (b -> c) -> Either a b -> c` | lo mismo que `maybe` pero para `Either` — aplica una función u otra según qué lado tenga el valor |
