
{-
a. para todo ​p​ :: Planilla ​. 

Fin :: Planilla
Registro "a" Fin :: Planilla 
Registro "a" (Registro "b" Fin) :: Planilla 
Registro "a" (Registro "b" (Registro "b" Fin)) :: Planilla 



Prop.: ¿ ​largoDePlanilla (juntarPlanillas Fin ​p​)  =​ largoDePlanilla Fin + largoDePlanilla ​p ?
Dem.:  

Caso BASE (p = Fin) 

    lado izq.: 
            largoDePlanilla (juntarPlanillas Fin Fin​)
        =                                               juntarPlanillas, p2 <- Fin
            largoDePlanilla Fin
        =                                               largoDePlanilla
            0

    lado der.:
            largoDePlanilla Fin + largoDePlanilla ​Fin
        =                                              largoDePlanilla Fin
            0 + 0 
        =                                              por aritm.
            0

Se cumple.

Caso Inductivo (p = Registro n pa)

HI: ¿ largoDePlanilla (juntarPlanillas Fin (Registro n pa)) = largoDePlanilla Fin + largoDePlanilla ​(Registro n pa) ? 


    lado izq.: 
            largoDePlanilla (juntarPlanillas Fin (Registro n pa))
        =                                                           juntarPlanillas, p2 <- (Registro n pa)
            largoDePlanilla (Registro n pa)
        =                                                           largoDePlanilla, p <- pa
            largoDePlanilla pa + 1
    
    lado der.:
            largoDePlanilla Fin + largoDePlanilla ​(Registro n pa)
        =                                                           largoDePlanilla Fin
            0 + largoDePlanilla ​(Registro n pa)
        =                                                           largoDePlanilla, p <- pa
            0 + largoDePlanilla pa + 1
        =                                                           por aritm.
            largoDePlanilla pa + 1

Cumple.

b. para todo ​p​ :: Planilla ​. 

Prop.:  ¿ ​largoDePlanilla (juntarPlanillas (Registro "Edsger" Fin) ​p​) 
                                    =​ 
        largoDePlanilla (Registro "Edsger" Fin) + largoDePlanilla ​p ? 

Dem.:
    Lado izq.:
            ​largoDePlanilla (juntarPlanillas (Registro "Edsger" Fin) ​p​)
        =                                                                     juntarPlanillas.1, p1 <- (Registro "Edsger" Fin), p2 <- p
            ​largoDePlanilla (Registro "Edsger" (juntarPlanillas Fin p))
        =                                                                     juntarPlanillas.2, p1 <- Fin, p2 <- p
            ​largoDePlanilla (Registro "Edsger" p)
        =                                                                     ​largoDePlanilla, p <- p
            largoDePlanilla p + 1               
    
    Lado der.:
            largoDePlanilla (Registro "Edsger" Fin) + largoDePlanilla ​p
        =                                                                largoDePlanilla 
            largoDePlanilla Fin + 1  + largoDePlanilla ​p               
        =                                                                largoDePlanilla
            0 + 1  + largoDePlanilla ​p
        =                                                               por aritm.
            1 + largoDePlanilla p
        =                                                               por aritm. 
            largoDePlanilla p + 1

Cumple. 

c. para todo ​p​ :: Planilla ​. 


Prop.: ¿   ​largoDePlanilla (juntarPlanillas (Registro "Alan" (Registro "Edsger" Fin)) ​p​) 
                                ​=​ 
            largoDePlanilla (Registro "Alan" (Registro "Edsger" Fin)) + largoDePlanilla ​p  ? 

Dem.: 
    Lado izq.: 
            ​largoDePlanilla (juntarPlanillas (Registro "Alan" (Registro "Edsger" Fin)) ​p​)
            

d. para todo ​p​ :: Planilla ​. 
    ​largoDePlanilla 
    (juntarPlanillas (Registro "Alonzo" 
                        (Registro "Alan" 
                          (Registro "Edsger" Fin))) 
                     ​p​) 
   ​=​ largoDePlanilla (Registro "Alonzo" 
                        (Registro "Alan" 
                          (Registro "Edsger" Fin))) 
       + largoDePlanilla ​p


-}