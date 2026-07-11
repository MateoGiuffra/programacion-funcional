data Accion a = Paso a | SaltoArriba a | SaltoAdelante a | Girar a

type Tiempo = Int -- el instante en el que sucede un movimiento

type Duracion = Int -- cantidad de tiempos que dura el mov

data Animacion a
  = Espera Duracion -- este tiempo no haces nada
  | Mov Duracion (Accion a) -- movimiento con d segundos siendo d la duracion
  | Sec (Animacion a) (Animacion a) -- secuencia (la 2da empieza al terminar la primera)
  | Par (Animacion a) (Animacion a) -- en simultaneo y dura lo que la mas larga

ej =
  Sec
    ( Par
        ( Sec
            (Sec (Espera 1) (Mov 3 (Paso "Bob")))
            (Sec (Mov 1 (Girar "Bob")) (Mov 2 (SaltoAdelante "Bob")))
        )
        ( Sec
            (Mov 2 (SaltoAdelante "Ana"))
            (Sec (Mov 1 (Girar "Ana")) (Sec (Mov 3 (Paso "Ana")) (Espera 1)))
        )
    )
    (Espera 1)

type Frame a = [Accion a] -- acciones simultaneas en un tiempo especifico

type Simulador a = Tiempo -> Frame a

-- funcio que da las acciones que ocurren en un tiempo dado

combinarSinDuplicados :: [Int] -> [Int] -> [Int]
combinarSinDuplicados [] [] = []
combinarSinDuplicados xs [] = xs
combinarSinDuplicados [] ys = ys
combinarSinDuplicados (x: xs) (y: ys) =
  if x > y
    then x : combinarSinDuplicados xs (y: ys)
    else
      if x < y
        then y : combinarSinDuplicados (x: xs) ys
        else x : combinarSinDuplicados xs ys
