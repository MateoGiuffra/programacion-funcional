-- Dadas las siguientes definiciones

data Objeto = Moneda | Pelusa

data Dungeon = Cueva | Habitacion [Objeto] Dungeon Dungeon

objs :: Dungeon -> [Objeto]
objs Cueva = []
objs (Habitacion os ti td) = os ++ objs ti ++ objs td

dobleObj :: Objeto -> [Objeto]
dobleObj Moneda = [Moneda, Moneda]
dobleObj o = [o]

doblar :: [Objeto] -> [Objeto]
doblar [] = []
doblar (o : os) = dobleObj o ++ doblar os

excavar Cueva = Cueva
excavar (Habitacion os d1 d2) = Habitacion (doblar os) (excavar d1) (excavar d1)

-- a) Definir objs
-- b) Demostrar: objs . excavar = doblar . objs

{-
2) objs . excavar = doblar . objs
Prop.: ¿ (objs . excavar) d = (doblar . objs) d ?
Dem.:

Caso Base 

          Lado Izq:
                (objs . excavar) Cueva
              =                         por (.)
                objs (excavar Cueva)
              =                         por excavar
                objs (Cueva)
              =                         por objs
                []

          Lado Der:
                (doblar . objs) Cueva
              =                       por (.)
                doblar (objs Cueva)
              =                       por objs
                doblar []
              =                       por doblar
                []

Cumple en caso base

Caso Inductivo


H1) objs (excavar (Habitacion os d1 d2)) = doblar (objs (Habitacion os d1 d2))
H2) objs (excavar (Habitacion os d1 d2)) = doblar (objs (Habitacion os d1 d2))

          Lado Izq.:
                (objs . excavar) d
              =                                                         por (.)
                objs (excavar d)     
              =                                                         por excavar
                objs (Habitacion (doblar os) (excavar d1) (excavar d1))
              
          Lado Der.:
                (doblar . objs) d
              =                                                                         por (.)
                doblar (objs d)
              =                                                                         por objs
                doblar (os ++ objs d1 ++ objs d2)
              =                                                                         LEMA
                doblar os ++ doblar (objs d1) ++ doblar (objs d2)
              =                                                    
                doblar os ++ doblar (objs (excavar d1)) ++ doblar (objs (excavar d2))

-}

-- 2) Dar la funcion losAntecesoresDe :: a -> Tree a -> [a] que describe la lista de antecesores del elemento dado
-- dentro del arbol dado suponiendo que el elemento existe en el arbol.

-- Ej: losAntecesoresDe 7 arbol = [1, 3]
data Tree a = EmptyT | NodeT a (Tree a) (Tree a)

arbol :: Tree Int
arbol =
  NodeT
    1
    ( NodeT
        2
        (NodeT 4 EmptyT EmptyT)
        (NodeT 5 EmptyT EmptyT)
    )
    ( NodeT
        3
        (NodeT 6 EmptyT EmptyT)
        ( NodeT
            7
            (NodeT 8 EmptyT EmptyT)
            (NodeT 9 EmptyT EmptyT)
        )
    )

esRaiz :: (Eq a) => a -> Tree a -> Bool
esRaiz _ (EmptyT) = False
esRaiz x (NodeT e _ _) = e == x

losAntecesoresDe :: (Eq a) => a -> Tree a -> [a]
losAntecesoresDe _ EmptyT = []
losAntecesoresDe x (NodeT e ti td) =
  if esRaiz x ti || esRaiz x td
    then [e]
    else
      if perteneceLaRaiz ti (losAntecesoresDe x ti) || perteneceLaRaiz td (losAntecesoresDe x td)
        then e : (losAntecesoresDe x ti ++ losAntecesoresDe x td)
        else (losAntecesoresDe x ti ++ losAntecesoresDe x td)

perteneceLaRaiz :: (Eq a) => Tree a -> [a] -> Bool
perteneceLaRaiz EmptyT _ = False
perteneceLaRaiz (NodeT x _ _) xs = x `elem` xs

{-
2) objs . excavar = doblar . objs
Prop.: ¿ (objs . excavar) d = (doblar . objs) d ?
Dem.:

¿ cantCapas (juntarPizzas c pizza2) = cantCapas cantCapas (juntarPizzas p pizza2) = cantCapas p + cantCapas pizza2 + cantCapas pizza2?

--------------- Planteo --------------- 

Caso base p = Prepizza 

¿ cantCapas (juntarPizzas Prepizza pizza2) = cantCapas Prepizza + cantCapas pizza2?

Caso ind. p = Capa i p (<- esa p no es la misma que pizza1, seria pizza1' | p' | p. Pensamos que está p de aca piso pizza1)

truco: suponer que vale para la parte recursiva (saco los signos de pregunta, es literalmente (por lo menos en este caso) lo mismo que queremos demostrar)

(Hipotesis Inductiva)
HI) ! cantCapas (juntarPizzas p pizza2) = cantCapas p + cantCapas pizza2 ¡
    
(Tesis Inductiva) Aca abro la estructura:
TI) ¿ cantCapas (juntarPizzas (Capa i p) pizza2) = cantCapas (Capa i p) + cantCapas pizza2 ?
    Me paro en cualquier punto (de una recta por ej) no te digo cual es. Ya te demostre el caso base. Entre ese punto y el caso base asumo que todos valen.
    Sin decirte cuantos son ni quienes son entre ese intervalo. (El matematico que lo invento demostro que esto vale pero no lo vemos eso.)

--------------- Planteo --------------- 

caso base:

  lado izq
  cantCapas (juntarPizzas Prepizza pizza2)
  = def juntarPizzas.1
  cantCapas pizza2

  lado der:
  cantCapas Prepizza + cantCapas pizza2
  = def cantCapas.1
  0 + cantCapas pizza2
  = neutro de la suma o arit. (es clave saber el neutro de las operaciones elementales como esta)
  cantCapas pizza2

caso inductivo: 

  lado izq
  cantCapas (juntarPizzas (Capa i p) pizza2)
  = def juntarPizzas.1, p <- Capa i p
  cantCapas (Capa i (juntarPizzas p pizza2))  --> aca estoy medio trabado porque no se que es p ni pizza2. No es buena idea ver casos de pizzas (base o inductivo) o ingredientes. Es mejor usar un LEMA.
  =  def cantCapas.2, p <- juntarPizzas p pizza2 --> el ingrediente lo elimina
  1 + cantCapas (juntarPizzas p pizza2)
  = HI --> ANTES de aplicarla, avanza con el otro caso. Aca si la necesito
  1 + (cantCapas p + cantCapas pizza2) --> PONER PARENTESIS AL REEMPLAZAR
  = por assoc. de + 
  1 + cantCapas p + cantCapas pizza2

  lado der
  cantCapas (Capa i p) + cantCapas pizza2
  = def cantCapas.2
  1 + cantCapas p + cantCapas pizza2


Anotaciones: 
  - primero hacer el planteo.
  - caso base se puede demo antes o edspues no importa.
  - necesito que el texto se empiece a parecer a la hipotesis. Si pudiste resolver sin hipotesis, no hacia falta induccion o hiciste algo mal. 

--- OTRO

para todo p. cantAceitunas (dupAceitunas p) = 2 * cantAceitunas p

-- Voy a demostrar por ind estructural sobre p de tipo Pizaz

Sea pizza una Pizza cualqueira:

¿cantAceitunas (dupAceitunas pizza) = 2 * cantAceitunas pizza?

Planteo

caso base pizza = Prepizza
¿cantAceitunas (dupAceitunas Prepizza) = 2 * cantAceitunas Prepizza?
0 
TRIVIAL

HI) cantAceitunas (dupAceitunas pizza) = 2 * cantAceitunas pizza
TI) cantAceitunas (dupAceitunas (Capa i p)) = 2 * cantAceitunas (Capa i p)

lado izq
lado der 
cumple, hacer.


-}