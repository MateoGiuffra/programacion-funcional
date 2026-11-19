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
