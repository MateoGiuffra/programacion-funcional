type Nombre = String
type Puntaje = Int

data Torneo = Jugador Nombre Puntaje
            | Partido Torneo Torneo
            deriving Show
data Dir = Izq | Der
            deriving Show
type Ruta = [Dir]

-- ejs
semi1 = Partido (Jugador "Bruno" 30) (Jugador "Carla" 45)
semi2 = Partido (Jugador "Diego" 20) (Jugador "Elena" 45)
final = Partido semi1 semi2
-- ejs

cantidadJugadores :: Torneo -> Int
cantidadJugadores (Jugador n  p ) = 1 
cantidadJugadores (Partido ti td) = cantidadJugadores ti + cantidadJugadores td

puntajeTotal :: Torneo -> Puntaje
puntajeTotal (Jugador n  p ) = p 
puntajeTotal (Partido ti td) = puntajeTotal ti + puntajeTotal td


ganador :: Torneo -> Nombre
ganador t = fst (ganadorConPuntaje t)

ganadorConPuntaje :: Torneo -> (Nombre, Puntaje)
ganadorConPuntaje (Jugador n p)   = (n, p)
ganadorConPuntaje (Partido ti td) = maxPar (ganadorConPuntaje ti) (ganadorConPuntaje td)

maxPar :: (Nombre, Puntaje) -> (Nombre, Puntaje) -> (Nombre, Puntaje)
maxPar (n1, p1) (n2, p2) = if p1 >= p2 then (n1, p1) else (n2, p2)

caminoHasta :: Nombre -> Torneo -> Maybe Ruta 
caminoHasta j (Jugador n  p ) = if j == n then Just [] else Nothing 
caminoHasta j (Partido ti td) = case (caminoHasta j ti) of
                                    (Just rs) -> Just (Izq : rs)
                                    Nothing   -> case (caminoHasta j td) of
                                                (Just rs) -> Just (Der : rs)
                                                Nothing   -> Nothing

escalarPuntajes :: Int -> Torneo -> Torneo
escalarPuntajes fac (Jugador n  p ) = Jugador n (fac * p)
escalarPuntajes fac (Partido ti td) = Partido (escalarPuntajes fac ti) (escalarPuntajes fac td)
{-
-- demo
ganador . escalarPuntajes k = ganador

Por principio de extensionalidad, siendo t un torneo cualquiera quiero demostrar que:
¿ para todo t. (ganador . escalarPuntajes k) t = ganador t ?

Por def. de compose, es equivalante decir que:
¿ para todo t. ganador (escalarPuntajes k t) = ganador t ?

Por principio de induccion estructural sobre la estructura de t:

demo:

caso base)
siendo n un nombre cualquiera y p un puntaje cualquiera
t = Jugador n p ¿ ganador (escalarPuntajes k (Jugador n p)) = ganador (Jugador n p) ?

caso inductivo)
siendo t1, t2 un torneo cualquiera
t = Partido t1 t2
HI1) ganador (escalarPuntajes k t1) = ganador t1
HI2) ganador (escalarPuntajes k t2) = ganador t2
TI) ¿ ganador (escalarPuntajes k (Partido t1 t2)) = ganador (Partido t1 t2) ?

Demuestro:

caso base)
LI)
    ganador (escalarPuntajes k (Jugador n p))
=                                               -- escalarPuntajes.1
    ganador (Jugador n (k * p))
=                                               -- ganador
    fst (ganadorConPuntaje (Jugador n (k * p)))
=                                               -- ganadorConPuntaje.1
    fst (n, p * k)
=                                               -- fst
    n
LD)
    ganador (Jugador n p)
=                                               -- ganador
    fst (ganadorConPuntaje (Jugador n p))
=                                               -- ganadorConPuntaje.1
    fst (n , p)
=                                               -- fst
    n

caso inductivo)

LI)
    ganador (escalarPuntajes k (Partido t1 t2))
=                                               -- escalarPuntajes.2
    ganador (Partido (escalarPuntajes fac ti) (escalarPuntajes fac td))
=                                               -- ganador
    fst (ganadorConPuntaje (Partido (escalarPuntajes fac ti) (escalarPuntajes fac td)))
=                                               -- ganadorConPuntaje.2
    fst (
        maxPar 
            (ganadorConPuntaje ((escalarPuntajes fac ti))) 
            (ganadorConPuntaje ((escalarPuntajes fac td)))
        )
=    
LD)
    ganador (Partido t1 t2)
=   
pendiente

-}

--3
foldT :: (Nombre -> Puntaje -> b) -> (b -> b -> b) -> Torneo -> b
foldT j p (Jugador n  p ) = j n p 
foldT j p (Partido ti td) = p (foldT j p ti) (foldT j p td)

recT :: (Nombre -> Puntaje -> b) -> (Torneo -> b -> Torneo -> b -> b) -> Torneo -> b
recT j p (Jugador n  p ) = j n p 
recT j p (Partido ti td) = p ti (recT j p ti) td (recT j p td)

--4 
cantidadJugadores' = foldT 1 (+)
cantidadJugadores' = foldT second (+)