data Pizza = Prepizza | Capa Ingrediente Pizza

data Ingrediente = Aceitunas Int | Cebolla | Queso


{-
    !!!!!!!!!!!!!!!!!!!!!!!!HACE ESTO EN EL PARCIAL¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
 para todo p
¿cantAceitunas(dupAcs p) = 2 * cantAceitunas p ?

sea q una Pizza cualquiera 
    por principio de induccion estructural sobre q
-- caso base
    q = Prepizza 
    ¿cantAceitunas(dupAcs Prepizza) = 2 * cantAceitunas Prepizza?

-- caso inductivo
    q = Capa Ing q' 
    ¿cantAceitunas(dupAcs Capa ing q') = 2 * cantAcitunas (Capa ing q')?

    HI) !cantAceitunas(dupAcs q') = 2 * cantAceitunas(q')¡
    TI) !cantAceitunas(dupAcs (Capa i q')) = 2 * cantAceitunas (Capa i q')¡
--lado izq
    cantAceitunas(dupAcs (Capa i q'))
=                                       def dupAcs
    cantAceitunas(Capa (dupIngAc i) (dupsAcs q'))
=                                                   def cantAceitunas
    aceitunas (dupIngAc i) + cantAceitunas (dupAcs q')
=                                                       hi
    aceitunas (dupIngAc i) + 2 * cantAceitunas q'    
=                                                   por lema
    2 * aceitunas i + 2 * cantAceitunas q'
queda demostrado CI

lema: ¿para todo i.aceitunas(dupIngAc i) = 2 * aceitunas i ?

    sea Ing un Ingredinete cualquiera vemos los casos
ing = Aceitunas n
    aceitunas (dupingAc (Aceitunas n)) = 2 * aceitunas (Aceitunas n)
--lado izq
    aceitunas (dupingAc (Aceitunas n))
=                                       def dupIngAC
    aceitunas (Aceituna 2 * n)
=                               def aceitunas
    2 * n

--laod der
    2 * aceitunas (Aceitunas n)
=                               def aceitunas
    2 * n

por lado der e izq iguales queda demostrado el lema

ing != Aceitunas n
    aceitunas (dupingAc (ing)) = 2 * aceitunas (ing)
--lado izq
    aceitunas (dupingAc (ing))
=                               def dupIngAc
    aceitunas ing
=                       def aceitunas
    0
-- lado der
    2 * aceitunas (ing)
=                       def aceitunas
    2 * 0   
=               def arit
    0
por lado der e izq iguales queda demostrado el lema 
--lado der
    2 * cantAceitunas (Capa i q')
=                                   def cantAcitunas
    2 * aceitunas i + cantAceituans q'
=                                           def distributiva
    2 * (aceitunas i) + 2 * (cantAceitunas q') 

por haber demostrado cada uno de los casos queda demostrado la prop
-}
-------------------------------------------------------------------------------
--p8 ej1 
{-
length :: [a] -> Int
length [] = 0
length (x:xs) = 1 + length xs

sum ::[Int] -> Int
sum [] = 0
sum (x:xs) = x + sum xs

prod :: [Int] -> Int
prod [] = 1
prod (x:xs) = x * prod xs

concat :: [[a]] -> [a]
concat [] = []
concat (xs:xss) = xs ++ concat xsss 

elem :: Eq a => a -> [a] -> Bool
elem e [] = False
elem e (x:xs) = e == x || elem e xs

all :: (a -> Bool) -> [a] -> Bool
all f [] = True
all f (x:xs) = f x && all f xs

any :: (a -> Bool) -> [a] -> Bool
any  f [] = False
any  f (x:xs) = f x || any f xs

count :: (a -> Bool) -> [a] -> Int
count f [] = 0
count f (x:xs) = unoSi (f x) + count f xs

unoSi :: Bool -> Int
unoSi True = 1
unoSi False = 0

subset :: Eq a => [a] -> [a] -> Bool
subset [] ys = True
subset (x:xs) ys = (elem x ys) && subset xs ys 

(++) :: [a] -> [a] -> [a]
(++) [] ys = ys
(++) (x:xs) ys =  x : (++) xs ys

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = reverse xs : x

zip :: [a] -> [b] -> [(a,b)]
zip [] ys = []
zip xs [] = []
zip (x:xs) (y:ys) = (x,y) : zip xs ys

-}
--------------------------------------------------------------------
--ej3

type NBin = [DigBin]
data DigBin = I | O
    deriving Show
succNM :: NBin -> NBin
succNM [] = [I]
succNM (x:xs) = case x of   
                I -> O : succNM xs
                O -> I : xs

addNB :: NBin -> NBin -> NBin
addNB   []    ys = ys 
addNB    xs   [] = xs
addNB (x:xs)  (y:ys) = sumarDigito x y (addNB xs ys) 

sumarDigito :: DigBin -> DigBin -> NBin -> NBin
sumarDigito I O ys = I : ys
sumarDigito O O ys = O : ys
sumarDigito I I ys = I : succNM ys
sumarDigito O I ys = I : ys










