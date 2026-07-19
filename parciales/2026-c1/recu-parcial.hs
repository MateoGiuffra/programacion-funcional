-- ACLARACION: Es de memoria todo, seguramente alguna cosa este mal pero sirve para practicar. 

type Caudal = Int
data Acueducto = 
        Vertiente Caudal                            -- es un manantial. devuelve un caudal fijo.  
        | Filtro (Caudal -> Bool) Acueducto         -- un filtro sobre su acueducto. Si no pasa el filtro seca a su acueducto (caudal=0)
        | Confluencia Acueducto Acueducto           -- se suman
        | Divergencia Acueducto Acueducto Acueducto -- se suman
-- no te preocupes por los negativos
type Tramo = Recto | Ramal1 | Ramal2 | Ramal3

ejAc = Confluencia 
        (Filtro (\c -> c < 10) 
            (Filtro (\c -> c >= 0) 
                (Confluencia 
                    (Vertiente 6)
                    (Filtro (\c -> c < 4) 
                        (Confluencia (Vertiente 2) (Vertiente 100)) )))) 
        (Confluencia (Vertiente 5) (Vertiente 10))

caudalFinal :: Acueducto -> Maybe Caudal
-- devolver el ultimo. Si falla su filtro es Nothing, pero solo para su acueducto.
maximoCaudal :: Acueducto -> Caudal
-- devolver el maximo caudal. para confluencias y divergencias se suma.
-- ej: maximoCaudal ejAc = 10
comprimirAcueducto :: Acueducto -> Acueducto
-- si hay Confluenciasconsecutivas las haces divergencia priorizando las de la izquierda (no perdes datos)
-- ej: comprimirAcueducto ejAc = 
caminoAlPrimerFiltroSeco  :: Acueducto -> Maybe [Tramo]
-- nothing si no hay caudal seco. Just lista con los tramos a recorrer. El que seca no cuenta.
nucleoRamificado :: Acueducto -> Acueducto 
-- nidea, inventalo
-- se recomiendan hacer funciones auxiliares sobre maybe y funciones que te permitan conocer el estado del caudal post aplicar la funcion. 
-- No se pueden hacer de forma directa algunos si no.
-- No se pueden reutilizar funciones del enunciado 1 en niguna de las funciones de arriba.

{-
2. demostrar:
    maximoCaudal . comprimirAcueducto = maximoCaudal
    se puede evitar la demo para para divergencia

3. hace foldAc y recAc
4. rehace las funciones recursivas del ej1 con foldAc o recAc
-}