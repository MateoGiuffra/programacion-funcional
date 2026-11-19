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
-- si hay Confluencias consecutivas las haces divergencia priorizando las de la izquierda (no perdes datos)
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


buscarNombre :: Maybe Usuario -> String
buscarNombre m = case m of 
                    Just m' -> nombre m'
                    Nothing -> "desconocido"

buscarNombre :: Maybe Usuario -> String
buscarNombre m = maybe "desconocido" nombre m



type Caudal = Int   -- no hace falta preocuparse por los negativos

data Acueducto = Vertiente Caudal                           -- manantial: caudal fijo
               | Filtro (Caudal -> Bool) Acueducto          -- si el caudal que le llega no pasa el filtro, queda en 0
               | Confluencia Acueducto Acueducto            -- los caudales se suman
               | Divergencia Acueducto Acueducto Acueducto  -- los caudales se suman

data Tramo = Recto    -- de un Filtro hacia el acueducto que filtra
           | Ramal1   -- primer operando de una Confluencia / Divergencia
           | Ramal2   -- segundo operando
           | Ramal3   -- tercer operando (solo Divergencia)


-- caudalFinal, que describe el caudal que entrega el acueducto, pero sólo para el elemento más externo: si el acueducto es un Filtro y el caudal que le llega no pasa su filtro, 
-- el resultado es Nothing. Un filtro seco más adentro solo aporta caudal 0 a su acueducto. (precisión) 
-- Una Vertiente, una Confluencia o una Divergencia siempre dan Just de su caudal.

caudalFinal ::  Acueducto           ->  Maybe Caudal
caudalFinal     (Vertiente c)       =   Just c
caudalFinal     (Filtro f  a)       =   maybe Nothing (\c -> filtro (f c) c) (caudaFinal a)
caudalFinal     (Confluencia a a1)  =   maybe_ (+) (caudalFinal a) (caudalFinal a1)
caudalFinal     (Confluencia a a1)  =   maybe_ (+) (caudalFinal a2) (maybe_ (+) (caudalFinal a) (caudalFinal a1))

maxCaudal ::  Acueducto           ->  Maybe Caudal
maxCaudal     (Vertiente c)       =   Just c
maxCaudal     (Filtro f  a)       =   maybe Nothing (\c -> filtro (f c) c) (caudaFinal a)
maxCaudal     (Confluencia a a1)  =   maybe_ max (maxCaudal a) (maxCaudal a1)
maxCaudal     (Confluencia a a1)  =   maybe_ max (maxCaudal a2) (maybe_ max (maxCaudal a) (maxCaudal a1))

applyMaybeCaudal :: Acueducto -> (Caudal -> Caudal -> Caudal) -> Maybe Caudal
applyMaybeCaudal (Vertiente c)      f = Just c
applyMaybeCaudal (Filtro f  a)      f = maybe Nothing (\c -> filtro (f c) c) (caudaFinal a)
applyMaybeCaudal (Confluencia a a1) f = maybe_ f (applyMaybeCaudal a) (applyMaybeCaudal a1)
applyMaybeCaudal (Confluencia a a1) f = maybe_ f (applyMaybeCaudal a2) (maybe_ f (applyMaybeCaudal a) (applyMaybeCaudal a1))

maxCaudal = applyMaybeAcueducto max
caudalFinal = applyMaybeAcueducto (+)

filtro  ::  Bool -> Caudal -> Maybe Caudal
filtro      True    c      =  Just c
filtro      _       _      =  Nothing 


maybe_ :: (Caudal -> Caudal -> Caudal) Maybe Caudal -> Maybe Caudal    ->  Maybe Caudal
maybe_ f  (Just x)        (Just y)        =   Just (f x y)
maybe_ f  x               Nothing         =   x
maybe_ f  Nothing         y               =   y    


maybe :: b ->  (a -> b)     -> Maybe a -> b
maybe   def    Nothing      = def
maybe   f     (Just x)      = f x

maybe Nothing (filtro . f) (caudaFinal a)
-- Just 10 
maybe  (filtro . f) (Just 10)      = (filtro . f) 10
-- = 
maybe  (filtro . f) (Just 10)      = filtro (f 10)