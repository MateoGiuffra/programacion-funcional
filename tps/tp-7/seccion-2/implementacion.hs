type Nombre = String

data Planilla = Fin | Registro Nombre Planilla
  deriving (Show)

data Equipo
  = Becario Nombre
  | Investigador Nombre Equipo Equipo Equipo
  deriving (Show)

--  Ej 1.
-- Planilla
-- Regla Base -> Fin esta en Planilla
-- Regla Inductiva -> Si p esta en Planilla
--                     entonces Registro Nombre p esta en Planilla

-- Equipo
-- Regla base -> Becario Nombre esta en Equipo
-- Regla Inductiva -> Si e esta en Equipo
--                         entonces Investigar Nombre e e e esta en Equipo

-- Ej 2.
-- f :: Planilla -> a
-- f Fin = ...
-- f (Registro Nombre p) = ... f p ...

-- f' :: Equipo -> a
-- f' (Becario n) = ...
-- f' (Investigador n e1 e2 e3) = ... f' e1 ... f' e2 ... f' e3 ...

-- planillas de testeo
planillaVacia :: Planilla
planillaVacia = Fin

planillaSimple :: Planilla
planillaSimple = Registro "Ana" (Registro "Carlos" Fin)

planillaLarga :: Planilla
planillaLarga = Registro "Juan" (Registro "Maria" (Registro "Pedro" (Registro "Sofia" Fin)))

-- equipos de testeo
becarioSimple :: Equipo
becarioSimple = Becario "Pablo"

equipoUnNivel :: Equipo
equipoUnNivel = Investigador "Dr. Garcia" (Becario "Lucas") (Becario "Valentina") (Becario "Mateo")

equipoDosNiveles :: Equipo
equipoDosNiveles =
  Investigador
    "Dra. Lopez"
    (Investigador "Dr. Martin" (Becario "Tomas") (Becario "Lucia") (Becario "Andres"))
    (Becario "Elena")
    (Becario "Franco")

equipoComplejo :: Equipo
equipoComplejo =
  Investigador
    "Prof. Ruiz"
    (Investigador "Dr. Garcia" (Becario "A") (Becario "B") (Becario "C"))
    (Investigador "Dra. Fernandez" (Becario "D") (Becario "E") (Becario "F"))
    (Investigador "Dr. Sanchez" (Becario "G") (Becario "H") (Becario "I"))

-- a. largoDePlanilla​, que describe la cantidad de nombres en una planilla
-- dada.
largoDePlanilla :: Planilla -> Int
largoDePlanilla Fin = 0
largoDePlanilla (Registro n p) = largoDePlanilla p + 1

-- b. esta​, que toma un nombre y una planilla e indica si en la planilla dada esta el
-- nombre dado.
esta :: Planilla -> Nombre -> Bool
esta (Fin) n = False
esta (Registro n p) nombreABuscar =
  if nombreABuscar == n
    then True
    else esta p nombreABuscar

-- c. juntarPlanillas​, que toma dos planillas y genera una única planilla con
-- los registros de ambas planillas.
juntarPlanillas :: Planilla -> Planilla -> Planilla
juntarPlanillas Fin Fin = Fin
juntarPlanillas (Registro n1 p1) p2 = (Registro n1 (juntarPlanillas p1 p2))
juntarPlanillas p1 (Registro n2 p2) = (Registro n2 (juntarPlanillas p1 p2))

-- d. nivelesJerarquicos​, que describe la cantidad de niveles jerarquicos de
-- un equipo dado.
nivelesJerarquicos :: Equipo -> Int
nivelesJerarquicos (Becario n) = 0
nivelesJerarquicos (Investigador n e1 e2 e3) =
  1 + nivelesJerarquicos e1 + nivelesJerarquicos e2 + nivelesJerarquicos e3

-- e. cantidadDeIntegrantes​, que describe la cantidad de integrantes de un
-- equipo dado.
cantidadDeIntegrantes :: Equipo -> Int
cantidadDeIntegrantes (Becario n) = 1
cantidadDeIntegrantes (Investigador n e1 e2 e3) =
  1
    + cantidadDeIntegrantes e1
    + cantidadDeIntegrantes e2
    + cantidadDeIntegrantes e3

-- f. planillaDeIntegrantes​, que describe la planilla de integrantes de un
-- equipo dado.
planillasDeIntegrantes :: Equipo -> Planilla
planillasDeIntegrantes (Becario n) = Registro n Fin
planillasDeIntegrantes (Investigador n e1 e2 e3) =
  juntarPlanillas
    (Registro n (planillasDeIntegrantes e1))
    (juntarPlanillas (planillasDeIntegrantes e2) (planillasDeIntegrantes e3))

    