## 1. Evaluación de Expresiones
Dar el valor de las siguientes expresiones:
* **a)** `(\f -> f 2 + f 4) id`
* **b)** `(\f -> f 2 + f 4) doble`
* **c)** `(\f -> f 2 + f 4) (suma 17)`
* **d)** `(\f -> f 2 + f 4) (const 21)`

---

## 2. Reducciones
Mostrar el paso a paso de la reducción de:
* **a)** `(suma 2) 3`
* **b)** `((subst const) suma) 17`
* **c)** `((subst const) twice) doble`

---

## 3. Expresiones Equivalentes (I)
A partir de las reducciones anteriores, concluir expresiones equivalentes para:
* **a)** `((subst const) suma)`
* **b)** `\f -> (subst const) f`

---

## 4. Definiciones sin Nombre
Dar expresiones equivalentes (usando lambdas) que **NO** nombren a las funciones originales:
* **a)** `id`
* **b)** `const`
* **c)** `flip`

---

## 5. Completar Definición
Completar la definición de la función `yTambien` de forma tal que `yTambien b1 b2 = b1 && b2`:

```haskell
yTambien :: Bool -> Bool -> Bool
yTambien b = \b2 -> if b then ?? 
                         else ??
```

---

## 6. Reducción Compleja
Mostrar la reducción de:
* `((subst (flip apply)) suma) 17`

---

## 7. Expresiones Equivalentes (II)
A partir de la reducción anterior, dar una expresión equivalente para:
* `(subst (flip apply)) suma`

---

## 8. Tipado
Dar los tipos para **TODAS** las funciones definidas o utilizadas en los ejercicios anteriores (id, const, flip, subst, twice, suma, doble, apply, etc.).

