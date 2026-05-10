{-
a.  
Prop.: ¿ cantidadDeAceitunas Prepizza 
  ​=​ cantidadDeAceitunas(conDescripcionMejorada Prepizza) ? 
Dem.:
    Lado izq:
            cantidadDeAceitunas Prepizza 
        =                                (def cantidadDeAceitunas, Prepizza)
            0
    
    Lado der:
            cantidadDeAceitunas (conDescripcionMejorada Prepizza)
        =                                                          (def conDescripcionMejorada, Prepizza)                                                     
            cantidadDeAceitunas Prepizza
        =                                                           por lema de cantidadDeAceitunas del lado izq.
            0
Cumple.

b.  

Prop.: ¿ cantidadDeAceitunas (Capa Queso Prepizza) 
  ​=​ 
  cantidadDeAceitunas (conDescripcionMejorada (Capa Queso Prepizza)) ?

Dem.:
    Lado izq.:
            cantidadDeAceitunas (Capa Queso Prepizza) 

    Lado der.:
            cantidadDeAceitunas (conDescripcionMejorada (Capa Queso Prepizza))
        =                                                                       def conDescripcionMejorada, i <- Queso, p <- Prepizza
            cantidadDeAceitunas (Capa Queso (conDescripcionMejorada Prepizza))
        =                                                                       def conDescripcionMejorada, Prepizza
            cantidadDeAceitunas (Capa Queso Prepizza)

Cumple.

c. 
Prop.: ¿ cantidadDeAceitunas (Capa (Aceitunas 8) 
                          (Capa Queso Prepizza)) 
  ​=​ cantidadDeAceitunas 
      (conDescripcionMejorada  
         (Capa (Aceitunas 8) 
               (Capa Queso Prepizza)))  ?

Dem.: 
        
    Lado izq.:
            cantidadDeAceitunas (Capa (Aceitunas 8) (Capa Queso Prepizza))

    Lado der.: 
            cantidadDeAceitunas (conDescripcionMejorada  (Capa (Aceitunas 8) (Capa Queso Prepizza)))
        =                                                                                            conDescripcionMejorada.1, c <- 8, p <- (Capa Queso Prepizza) 
            cantidadDeAceitunas (Capa (Aceitunas 8) (conDescripcionMejorada (Capa Queso Prepizza))) 
        =                                                                                            conDescripcionMejorada.2, i <- Queso, p <- Prepizza
            cantidadDeAceitunas (Capa (Aceitunas 8) (Capa Queso (conDescripcionMejorada Prepizza)))
        =                                                                                            conDescripcionMejorada.3
            cantidadDeAceitunas (Capa (Aceitunas 8) (Capa Queso Prepizza))
        
Cumple.
        
d. 

Prop.: ¿ cantidadDeAceitunas (Capa (Aceitunas 9)  
                          (Capa (Aceitunas 8) 
                                (Capa Queso Prepizza))) 
  ​=​ cantidadDeAceitunas 
      (conDescripcionMejorada  
         (Capa (Aceitunas 9)  
               (Capa (Aceitunas 8) 
                     (Capa Queso Prepizza)))) ?
Dem.:
    Lado izq.:
            cantidadDeAceitunas (Capa (Aceitunas 9) (Capa (Aceitunas 8) (Capa Queso Prepizza)))
        =                                                                                       cantidadDeAceitunas.1, c <- 9, p <- (Capa (Aceitunas 8) (Capa Queso Prepizza))
            9 + cantidadDeAceitunas (Capa (Aceitunas 8) (Capa Queso Prepizza))
        =                                                                                       cantidadDeAceitunas.2, c <- 8, p <- (Capa Queso Prepizza)
            9 + 8 + cantidadDeAceitunas (Capa Queso Prepizza)
        =                                                                                       cantidadDeAceitunas.3, p <- Prepizza
            9 + 8 + cantidadDeAceitunas Prepizza                                                
        =                                                                                       cantidadDeAceitunas.4
            9 + 8 + 0
        =                                                                                       por aritm.
            17

    Lado der.: 
            cantidadDeAceitunas (conDescripcionMejorada (Capa (Aceitunas 9)  (Capa (Aceitunas 8) (Capa Queso Prepizza))))
        =                                                                                                                   conDescripcionMejorada.1, p <- (Capa (Aceitunas 8) (Capa Queso Prepizza))
            cantidadDeAceitunas (conDescripcionMejorada (Capa (Aceitunas 8) (Capa Queso Prepizza)))
        =                                                                                                                   conDescripcionMejorada.2, c <- 8, p <- (Capa Queso Prepizza)
            cantidadDeAceitunas (Capa (Aceitunas 8) (conDescripcionMejorada (Capa Queso Prepizza)))
        =                                                                                                                   conDescripcionMejorada.3, i <- Queso, p <- Prepizza
            cantidadDeAceitunas (Capa (Aceitunas 8) (Capa Queso (conDescripcionMejorada Prepizza)))
        =                                                                                                                   conDescripcionMejorada.4
            cantidadDeAceitunas (Capa (Aceitunas 8)  Prepizza)
        =                                                                                                                   cantidadDeAceitunas.1, c <- 8, p <- Prepizza
            8 + cantidadDeAceitunas Prepizza
        =                                                                                                                   cantidadDeAceitunas.2
            8 + 0 
        =                                                                                                                   por aritm.
            8

No cumple.






-}          