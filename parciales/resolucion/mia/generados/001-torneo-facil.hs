type Nombre = String

data Torneo = Libre                  -- lugar vacío (pasa de ronda sin jugar)
            | Jugador Nombre Int     -- un jugador y su puntaje
            | Cruce Torneo Torneo    -- dos torneos cuyos ganadores se enfrentan
            deriving (Show, Eq)

ej1 :: Torneo
ej1 = Cruce (Cruce (Jugador "Ana" 10) (Jugador "Beto" 7))
            (Cruce Libre (Jugador "Cami" 4))

ej2 :: Torneo
ej2 = Cruce (Jugador "Dani" 5) Libre


cantJugadores :: Torneo -> Int
cantJugadores Libre = 0
cantJugadores (Jugador n p) = 1 
cantJugadores (Cruce t1 t2) = cantJugadores t1 + cantJugadores t2


puntajeTotal :: Torneo -> Int
puntajeTotal Libre = 0
puntajeTotal (Jugador n p) = p
puntajeTotal (Cruce t1 t2) = puntajeTotal t1 + puntajeTotal t2


nombres :: Torneo -> [Nombre]
nombres Libre = []
nombres (Jugador n p) = [n]
nombres (Cruce t1 t2) = nombres t1 ++ nombres t2

puntajes :: Torneo -> [Int]
puntajes Libre = []
puntajes (Jugador n p) = [p]
puntajes (Cruce t1 t2) = puntajes t1 ++ puntajes t2


escalar :: Int -> Torneo -> Torneo
escalar k Libre = Libre
escalar k (Jugador n p) = Jugador n (p*k) 
escalar k (Cruce t1 t2) = Cruce (escalar k t1) (escalar k t2)


foldTorneo :: b -> (Nombre -> Int -> b) -> (b -> b -> b) -> Torneo -> b
foldTorneo l j c Libre = l
foldTorneo l j c (Jugador n p) = j n p
foldTorneo l j c (Cruce t1 t2) = c (foldTorneo t1) (foldTorneo t2)

cantJugadores' :: Torneo -> Int
cantJugadores' = foldTorneo 0 (const 1 . const 1) (+)

puntajeTotal' :: Torneo -> Int
puntajeTotal' = foldTorneo 0 (\n p -> p) (+)

nombres' :: Torneo -> [Nombre]
nombres' = foldTorneo [] (\n p -> [n]) (++)

puntajes' :: Torneo -> [Int]
puntajes' = foldTorneo [] (\n p -> [p]) (++)

escalar' :: Int -> Torneo -> Torneo
escalar' = foldTorneo Libre (\n p -> Jugador n (p*k)) Cruce

-- 4a) por inducción estructural sobre Torneo
¿ cantJugadores = length . nombres ?
-- se puede usar:
-- LEN-APP: length (xs ++ ys) = length xs + length ys
