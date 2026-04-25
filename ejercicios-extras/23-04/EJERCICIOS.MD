## Definiciones de Tipos y Funciones

```haskell
data Shape = Circle Float | Rect Float Float

data Par a = DosCosas a a
data AVeces a = Nada | AcaEsta a

cuadrado n = Rect n n
shapeNormal c = c 1.0
chocoHelate c = c Chocolate

string2gusto "DDL" = DDL
string2gusto "Chocolate" = Chocolate
-- ...
string2gusto "Frutilla" = Frutilla

armarHeladoCon sg = Vasito (sg "Chocolate")
```

---

## Ejercicios

### 1. Dar el tipo de:
i) `cuadrado`  
ii) `shapeNormal`  
iii) `chocoHelate`  
iv) `string2gusto`  
v) `armarHeladoCon`  

### 2. Dar el tipo y reducir:
a) `shapeNormal Circle`  
b) `shapeNormal cuadrado`  
c) `shapeNormal Rect`  
d) `shapeNormal Rect 2`  
e) `shapeNormal (Rect 2)`  
f) `chocoHelate Vasito`  
g) `chocoHelate Cucurucho`  
h) `chocoHelate Cucurucho Sambayon`  
i) `chocoHelate (Cucurucho Sambayon)`  
j) `chocoHelate (flip Cucurucho Sambayon)`  
k) `chocoHelate (\g -> Cucurucho g Sambayon)`  
l) `chocoHelate (chocoHelate Cucurucho)`  
m) `chocoHelate Pote`  
n) `chocoHelate Pote DulceDeLeche`  
o) `armarHeladoCon string2gusto`  
p) `armarHeladoCon error`  
q) `esVasito (armarHeladoCon error)`  

### 3. Dar algunos elementos de los siguientes tipos:
a) `Par Bool`  
b) `Par Helado`  
c) `Par (Gusto -> Helado)`  

### 4. Dar el tipo de:
`DosCosas (Cucurucho DDL)`

### 5. Escribir las funciones:

**a) esCuadrado :: Shape -> Bool** Que verifica si la figura dada es un cuadrado.

**b) armaCuadradoAlRecibir :: Float -> (Float -> Shape) -> Bool** Que verifica si la función dada arma un cuadrado al recibir el número dado.

**c) armaCuadradoDeTamañoCuandoReciba :: Float -> Float -> (Float -> Shape) -> Bool** Que verifica si la función dada arma un cuadrado del tamaño del primer número al recibir el segundo número.

**d) siempreArmaCuadrado :: (Float -> Shape) -> Float -> Float -> Bool**
Indica si la funcion arma un cuadrado sin importar lo que le pases