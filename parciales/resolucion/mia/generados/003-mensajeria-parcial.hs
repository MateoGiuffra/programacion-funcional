type Contacto = String

data Mensaje = Eliminado                          -- mensaje borrado (no se ve nada)
             | Texto String                       -- una línea de texto
             | Reenvio Contacto Mensaje           -- reenviado a un contacto
             | Edicion (String -> String) Mensaje -- el cliente transforma cada línea al mostrarla
             | Respuesta Mensaje Mensaje          -- Respuesta original respuesta

instance Show Mensaje where
  show Eliminado       = "Eliminado"
  show (Texto s)       = "Texto " ++ show s
  show (Reenvio c m)   = "Reenvio " ++ show c ++ " (" ++ show m ++ ")"
  show (Edicion _ m)   = "Edicion <fun> (" ++ show m ++ ")"
  show (Respuesta o r) = "Respuesta (" ++ show o ++ ") (" ++ show r ++ ")"

m1, m2, m3, m4 :: Mensaje
m1 = Respuesta (Texto "hola") (Texto "que tal")
m2 = Reenvio "Ana" (Reenvio "Beto" (Texto "fiesta"))
m3 = Respuesta (Respuesta (Texto "a") (Edicion reverse (Texto "abc")))
               (Reenvio "Zoe" (Texto "b"))
m4 = Respuesta Eliminado (Respuesta (Texto "x") Eliminado)
m5 = Reenvio "Ana" (Respuesta (Texto "a") (Texto "b"))
-- ["Fwd Ana: a", "b"]
-- ["Fwd Ana: a", "Fwd Ana: b"]
-- función ya dada 
responder :: Mensaje -> Mensaje -> Mensaje
responder Eliminado r = r              -- responder.1
responder o Eliminado = o              -- responder.2
responder o r         = Respuesta o r  -- responder.3

{-
cantidadLineas  :: Mensaje -> Int
cantidadLineas Eliminado = undefined
cantidadLineas (Texto s) = undefined
cantidadLineas (Reenvio c m) = undefined
cantidadLineas (Edicion f m) = undefined
cantidadLineas (Respuesta m1 m2) = undefined
-}

cantidadLineas :: Mensaje -> Int
cantidadLineas Eliminado = 0
cantidadLineas (Texto s) = 1
cantidadLineas (Reenvio c m) = cantidadLineas m 
cantidadLineas (Edicion f m) = cantidadLineas m
cantidadLineas (Respuesta m1 m2) = cantidadLineas m1 + cantidadLineas m2


fwd :: Contacto -> String
fwd c = "Fwd " ++ c ++ ": "

-- reverse "Fwd Ana: Fwd Beto: fiesta" -> "Fwd Ana: Fwd Beto: fiesta"
-- reverse "Fwd Ana: Fwd Beto: fiesta" -> "Fwd Ana: Fwd Beto: atseif" -- sabemos que lo mejor es esta opcion

profundidadReenvios  :: Mensaje -> Int
profundidadReenvios  Eliminado = 0
profundidadReenvios  (Texto s) = 0
profundidadReenvios  (Reenvio c m) = 1 + profundidadReenvios m
profundidadReenvios  (Edicion f m) = profundidadReenvios m
profundidadReenvios  (Respuesta m1 m2) = max (profundidadReenvios m1) (profundidadReenvios m2)

primeraLinea :: Mensaje -> Maybe String
primeraLinea Eliminado = Nothing
primeraLinea (Texto s) = Just s
primeraLinea (Reenvio c m) = case primeraLinea m of
                                Nothing -> Nothing
                                Just s -> Just (fwd c ++ s)
primeraLinea (Edicion f m) = case primeraLinea m of
                                Nothing -> Nothing
                                Just s -> Just (edit f s)
primeraLinea (Respuesta m1 m2) = case primeraLinea m1 of
                                        Nothing -> primeraLinea m2 
                                        Just s  -> Just s


citas :: Mensaje -> [String]
citas Eliminado = undefined
citas (Texto s) = undefined
citas (Reenvio c m) = undefined
citas (Edicion f m) = undefined
citas (Respuesta m1 m2) = undefined


leer :: Mensaje -> [String]
leer Eliminado = []
leer (Texto s) = [s]
leer (Reenvio c m) = map (fwd c ++) (leer m)
leer (Edicion f m) = map f (leer m)
leer (Respuesta m1 m2) = leer m1 ++ leer m2


limpiar :: Mensaje -> Mensaje
limpiar Eliminado = Eliminado
limpiar (Texto s) = Texto s
limpiar (Reenvio c m) = Reenvio c (limpiar m)
limpiar (Edicion f m) = Edicion f (limpiar m)
limpiar (Respuesta m1 m2) = responder (limpiar m1) (limpiar m2)


-- 4a) por inducción estructural sobre Mensaje
¿ cantidadLineas = length . leer ?
-- se pueden usar, sin demostrar:
-- LEN-APP: length (xs ++ ys) = length xs + length ys
-- LEN-MAP: length (map f xs) = length xs
-- Por principio de extensionalidad, siendo m un Mensaje cualquiera
¿ para todo m. cantidadLineas m = (length . leer) m ?
-- por def de (.), es equivalente decir:
¿ para todo m. cantidadLineas m = length (leer m) ?
-- por ppio de induccion estructural sobre la estructura de m, planteo:
-- CB1) m = Eliminado
--      ¿ cantidadLineas Eliminado = length (leer Eliminado) ?
-- CB2) m = Texto s
--      ¿ cantidadLineas (Texto s) = length (leer (Texto s)) ?
-- CI1) m = Reenvio c m 
--      HI) ! cantidadLineas m = length (leer m) !
--      TI) ¿ cantidadLineas (Reenvio c m) = length (leer (Reenvio c m)) ?
-- CI2) m = Edicion f m 
--      HI) ! cantidadLineas m = length (leer m) !
--      TI) ¿ cantidadLineas (Edicion f m) = length (leer (Edicion f m)) ?
-- CI3) m = Respuesta m1 m2
--      HI1) ! cantidadLineas m1 = length (leer m1) !
--      HI2) ! cantidadLineas m2 = length (leer m2) !
--      TI1) ¿ cantidadLineas (Respuesta m1 m2) = length (leer (Respuesta m1 m2)) ?

CB1)
LI)
    cantidadLineas Eliminado
=                               cantidadLineas.1
    0
LD)
    length (leer Eliminado)
=                               leer.1 
    length []
=                               length.1
    0
Vale.
CB2)
LI)
    cantidadLineas (Texto s)
=                               cantidadLineas.2
    1
LD)
    length (leer (Texto s))
=                               leer.2
    length [s]
=                               length.2
    1 + length []
=                               length.1
    1 + 0
=                               arit.
    1
Vale.
CI1)
LI)
    cantidadLineas (Reenvio c m) 
=                                   cantidadLineas.3              
    cantidadLineas m

LD)
    length (leer (Reenvio c m))
=                                   leer.3
    length (map (fwd c ++) (leer m))
=                                   LEN-MAP
    length (leer m)
=                                   HI
    cantidadLineas m
Vale.

CI2)
LI)
    cantidadLineas (Edicion f m) 
=                                   cantidadLineas.4              
    cantidadLineas m

LD)
    length (leer (Edicion f m))
=                                   leer.4
    length (map f (leer m))
=                                   LEN-MAP
    length (leer m)
=                                   HI
    cantidadLineas m
Vale.


CI3)
LI)
    cantidadLineas (Respuesta m1 m2) 
=                                   cantidadLineas.5
    cantidadLineas m1 + cantidadLineas m2

LD)
    length (leer (Respuesta m1 m2))
=                                   leer.5
    length (leer m1 ++ leer m2)
=                                   LEN-APP
    length (leer m1) + length (leer m2)
=                                   HI1 y HI2
    cantidadLineas m1 + cantidadLineas m2
Vale.


-- 4b) por inducción estructural sobre Mensaje
¿ leer . limpiar = leer ?
por ppio de extensionalidad, siendo m un Mensaje cualquiera:
¿para todo m. (leer . limpiar) m = leer m ?
por def (.), es equivalente decir:
¿para todo m. leer (limpiar m) = leer m ?
por ppio de induccion estructural sobre la estructura de m, se plantea:
-- CB1) m = Eliminado
--      ¿ leer (limpiar Eliminado) = (leer Eliminado) ?
-- CB2) m = Texto s
--      ¿leer (limpiar (Texto s)) = (leer (Texto s)) ?
-- CI1) m = Reenvio c m 
--      HI) ! leer (limpiar m) = (leer m) !
--      TI) ¿ leer (limpiar (Reenvio c m)) = (leer (Reenvio c m)) ?
-- CI2) m = Edicion f m 
--      HI) ! leer (limpiar m) = (leer m) !
--      TI) ¿ leer (limpiar (Edicion f m)) =  (leer (Edicion f m)) ?
-- CI3) m = Respuesta m1 m2
--      HI1) ! leer (limpiar m1) = (leer m1) !
--      HI2) ! leer (limpiar m2) = (leer m2) !
--      TI1) ¿ leer (limpiar (Respuesta m1 m2)) = (leer (Respuesta m1 m2)) ?
CB1
LI
    leer (limpiar Eliminado)
=                            limpiar.1
    leer Eliminado
LD
    leer Eliminado
vale.

CB2
LI
    leer (limpiar (Texto s))
=                            limpiar.2
    leer (Texto s)
LD
    leer (Texto s)
vale.

CI1
LI
    leer (limpiar (Reenvio c m))
=                            limpiar.3
    leer (Reenvio c (limpiar m))
=                               leer.3
    map (fwd c ++) (leer (limpiar m))
=                                HI.
    map (fwd c ++) (leer m)
LD
    leer (Reenvio c m)
=                             leer.3
    map (fwd c ++) (leer m)
vale.

CI2
LI
    leer (limpiar (Edicion f m))
=                            limpiar.4
    leer (Edicion f (limpiar m))
=                               leer.4
    map f (leer (limpiar m))
=                                HI.
    map f (leer m)
LD
    leer (Edicion f m)
=                             leer.4
    map f (leer m)
vale.

CI3
LI
    leer (limpiar (Respuesta m1 m2))
=                            limpiar.5
    leer (responder (limpiar m1) (limpiar m2))
=                               LEMA-res
    leer (limpiar m1) ++ leer (limpiar m2)
LD
    leer (Respuesta m1 m2)
=                             leer.5
    leer m1 ++ leer m2
=                             hi
    leer (limpiar m1) ++ leer (limpiar m2)
vale.



LEMA-res
Siendo m1, m2 :: Mensaje
¿ para todo m1, m2. leer (responder m1 m2) = leer m1 ++ leer m2 ? 
Por analisis de casos sobre m1 y m2:
C1)
m1 = Eliminado, m2 != Eliminado
LI)
    leer (responder Eliminado m2)
=                               responder.1
    leer m2
LD)
    leer Eliminado ++ leer m2
=                               leer.1
    [] ++ leer m2
=                               ++.1
    leer m2
Vale.

C2)
m2 = Eliminado, m1 != Eliminado
LI)
    leer (responder m1 Eliminado)
=                               responder.2
    leer m1
LD)
    leer m1 ++ leer Eliminado
=                               leer.1
    leer m1 ++ []
=                               por conmutatividad del ++
    [] ++ leer m1
=                               ++.1
    leer m1
Vale.
C3)
m1 != Eliminado, m2 != Eliminado
LI)
    leer (responder m1 m2)
=                               responder.3
    leer (Respuesta m1 m2)
=                               leer.5
    leer m1 ++ leer m2
LD)
    leer m1 ++ leer m2
Vale.

- hay alguna formalidad para demostrar un lema?
- se pueden usar funciones sobre Maybe a  definidas en la bibloteca estandar de haskell como maybe en el parcial?
