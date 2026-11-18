data Calabozo g r = 
      Salida  
    | Celda r 
    | Pasillo Int (Calabozo g r)  
    | Bifurcacion (Calabozo g r) g (Calabozo g r) deriving Show

data Instr = Izq | Der | PasilloDe Int  deriving Show
type Path = [Instr]

{- MIYAGI
f  Salida =
f (Celda r) =
f (Pasillo l c) =
f (Bifurcacion ci g cd) =
-}

distASalida :: Calabozo g r -> Maybe Int
-- que describe la distancia a la salida más 
-- cercana. Describe Nothing si no hay ningún camino con salida. Ejemplos: 
distASalida  Salida = Just 0
distASalida (Celda r) = Nothing
distASalida (Pasillo l c) = maybe Nothing (Just . (+l)) (distASalida c)
distASalida (Bifurcacion ci g cd) = 
        let izq = maybe Nothing (Just . (+1)) (distASalida ci) 
            der = maybe Nothing (Just . (+1)) (distASalida cd) in
                _maybes min der izq     
                 
_maybes :: (a -> a -> a) -> Maybe a -> Maybe a -> Maybe a 
_maybes f (Just x) (Just y) = Just (f x y)
_maybes _ (Just x) Nothing = Just x
_maybes _ Nothing (Just x) = Just x
_maybes _ _ _ = Nothing

normaliza :: Calabozo g r -> Calabozo g r 
-- que describe el resultado de eliminar toda 
-- aplicación de una bifurcación que inmediatamente tiene 2 salidas (el guardia de esa 
-- bifurcación se retira). Ejemplos
normaliza  Salida = Salida
normaliza (Celda r) = (Celda r)
normaliza (Pasillo l c) = Pasillo l (normaliza c)
normaliza (Bifurcacion ci g cd) = consBif (normaliza ci) g (normaliza cd)

consBif :: Calabozo g r -> g -> Calabozo g r -> Calabozo g r 
consBif Salida _ Salida = Salida
consBif ci g cd = Bifurcacion ci g cd

cambioDeGuardia:: (g -> g') -> (r -> r) -> Calabozo g r -> Calabozo g' r 
cambioDeGuardia fg fr  Salida = Salida
cambioDeGuardia fg fr (Celda r) = Celda (fr r)
cambioDeGuardia fg fr (Pasillo l c) = Pasillo l (cambioDeGuardia fg fr c)
cambioDeGuardia fg fr (Bifurcacion ci g cd) = 
        Bifurcacion
        (cambioDeGuardia fg fr ci)
        (fg g)
        (cambioDeGuardia fg fr cd)


mapa :: Calabozo g r -> [Path]
-- que describe los caminos a todas las celdas y los presos 
-- que hay en cada una.
mapa  Salida = []
mapa (Celda r) = [[]]
mapa (Pasillo l c) = map (PasilloDe l :) (mapa c)
mapa (Bifurcacion ci g cd) = 
    (map (Izq :) (mapa ci))
    ++
    (map (Der :) (mapa cd))


ej1 = Bifurcacion (Pasillo 5 (Celda "A"))  1  (Pasillo 7 (Bifurcacion (Celda "B")  2  (Pasillo 9 (Celda "C"))))  
pathAlA = [Izq, PasilloDe 5] -- para llegar al preso "A"  
pathAlB = [Der, PasilloDe 7, Izq] -- para llegar al preso "B"  
pathAlC = [Der, PasilloDe 7, Der, PasilloDe 9] -- para llegar al preso "C"

errPreso :: a
errPreso = error "El camino es invalido"

liberarPreso :: Path -> Calabozo g r -> Calabozo g r
liberarPreso [] c = intentarLiberar c 
liberarPreso (x:xs) c = libPreso x (liberarPreso xs) c

intentarLiberar :: Calabozo g r -> Calabozo g r
intentarLiberar (Celda _) = Salida
intentarLiberar _         = errPreso

libPresoPasillo :: Instr -> Int -> Calabozo g r -> Calabozo g r
libPresoPasillo (PasilloDe n) l c = if n == l
                                        then Pasillo l c
                                        else errPreso
libPresoPasillo _ _ _ = errPreso

libPreso :: Instr -> (Calabozo g r -> Calabozo g r) -> Calabozo g r -> Calabozo g r
libPreso x f Salida = errPreso
libPreso x f (Celda r) = errPreso
libPreso x f (Pasillo l c) = libPresoPasillo x l (f c)
libPreso x f (Bifurcacion ci g cd) = case x of
                Izq -> Bifurcacion (f ci) g cd
                Der -> Bifurcacion ci g (f cd)
                _   -> errPreso

foldC :: b -> (r -> b) -> (Int -> b -> b) -> (b -> g -> b -> b) -> Calabozo g r -> b
foldC s c p b  Salida = s 
foldC s c p b (Celda r) = c r
foldC s c p b (Pasillo l cz) = p l (foldC s c p b cz)
foldC s c p b (Bifurcacion ci g cd) = b (foldC s c p b ci) g (foldC s c p b cd)

-- recC :: b -> (r -> b) -> 
--         (Int -> Calabozo g r -> b -> b) -> (g -> Calabozo g r -> b -> Calabozo g r -> b -> b) -> Calabozo g r -> b
-- recC s c p b  Salida = s 
-- recC s c p b (Celda r) = c r
-- recC s c p b (Pasillo l c) = p l c (recC s c p b c)
-- recC s c p b (Bifurcacion ci g cd) = b g ci (recC s c p b ci) cd (foldC s c p b cd)

-- 4 
distASalida' :: Calabozo g r -> Maybe Int
-- que describe la distancia a la salida más 
-- cercana. Describe Nothing si no hay ningún camino con salida. Ejemplos: 
distASalida'  = foldC 
                (Just 0)
                (const Nothing) 
                (\l r -> maybe Nothing (Just . (+l)) r)
                (\ri g rd -> let
                    izq = maybe Nothing (Just . (+1)) ri
                    der = maybe Nothing (Just . (+1)) rd in
                        _maybes min der izq)

normaliza' :: Calabozo g r -> Calabozo g r 
-- que describe el resultado de eliminar toda 
-- aplicación de una bifurcación que inmediatamente tiene 2 salidas (el guardia de esa 
-- bifurcación se retira). Ejemplos
normaliza' = foldC Salida Celda Pasillo consBif


cambioDeGuardia':: (g -> g') -> (r -> r) -> Calabozo g r -> Calabozo g' r 
cambioDeGuardia' fg fr = foldC 
                            Salida
                            (Celda . fr)
                            Pasillo 
                            (\ri g rd -> Bifurcacion ri (fg g) rd)

mapa' :: Calabozo g r -> [Path]
mapa' = foldC 
        []
        (const [[]])
        (\l -> map (PasilloDe l :))
        (\ri b rd -> (map (Izq :) ri) ++ (map (Der :) rd))

liberarPreso' :: Path -> Calabozo g r -> Calabozo g r
liberarPreso' = foldr libPreso intentarLiberar 

{-
¿ cantCeldas . appDup (liberarMuchos . mapa) = const 0?
por pricipio de extensionalidad, siendo c :: Calabozo g r cualquiera

¿ cantCeldas . appDup (liberarMuchos . mapa) c = const 0 c?

por def de compose, es equivalente decir:
¿ cantCeldas (appDup liberarMuchos (mapa c)) = const 0 c?

-}