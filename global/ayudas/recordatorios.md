# Recordatorios generales

Ver también: [índice](README.md) · [patrones.md](patrones.md) · [esquemas.md](esquemas.md)

---

## Antes de escribir una sola línea

- [ ] **Leé cada precondición como una pista de diseño, no como decoración.** Si el enunciado te garantiza algo (orden, unicidad, totalidad de una función, etc.), preguntate qué chequeo te ahorra tener esa garantía. Una precondición que "no usás para nada" es sospechosa — probablemente la estás dejando pasar.
- [ ] **No confíes ciegamente en los datos de ejemplo del enunciado.** Pueden venir mal transcriptos (de un PDF escaneado, de un apunte a mano, etc.). Antes de programar contra un ejemplo, auditalo con algo que no dependa de tu propia implementación:
  - Si el enunciado dice que algo "se repite" con cierto período, dos posiciones congruentes módulo ese período **tienen** que dar el mismo resultado. Si no da lo mismo, el dato está mal.
  - Si hay un orden impuesto por la propia estructura (una secuencia, una cadena), un elemento no puede aparecer antes que el que lo precede.
  - Contá cantidades (duraciones, tamaños, pasos) a mano con sumas simples antes de asumir cualquier otra cosa sobre un ejemplo complejo.
- [ ] **Simulá un caso chico a mano en papel** antes de tipear Haskell. Si el algoritmo "se siente" natural haciéndolo vos mismo con un ejemplo concreto, traducirlo a código es fácil; inventarlo en abstracto de una no.

---

## Checklist final antes de dar por terminado un ejercicio

- [ ] **Chequeo "en papel" de sintaxis y tipos** (no hay ghci en el parcial, así que esto se hace a ojo y a mano):
  - Contá los argumentos de cada aplicación de constructor contra su aridad en el `data` — dedo por dedo si hace falta. Un constructor de aridad 2 usado con un solo argumento es el error más común y el más fácil de pasar por alto.
  - Contá paréntesis abiertos vs. cerrados en cada línea con llamadas anidadas (`f (g x) (h y)`), en particular alrededor de una llamada recursiva que le pasás como argumento a otra función.
  - Para cada `let`, verificá que tiene su `in` — no se pueden encadenar dos `let` sin cerrar el primero.
  - Para cada llamada (recursiva o no) que escribas, mirá la firma `::` de esa función y chequeá que el orden de los argumentos que le pasás coincide de izquierda a derecha.
  - Recordá que la negación booleana en Haskell es `not`, no `!`.
- [ ] **¿Los tipos cierran?** ¿Le estás dando a cada constructor todos sus argumentos, en el orden correcto? ¿El orden de los argumentos de cada función coincide con su firma?
- [ ] **¿Los nombres de variable representan lo que decís que representan?** Usar el nombre de un parámetro de otra definición en un paso de demo, en vez del nombre real de la variable que tenés fija en ese contexto, es inconsistente aunque el resultado final no cambie.
- [ ] **¿Usaste la HI?** ¿En qué paso exactamente? Si no la usaste en ningún caso inductivo, revisá ese caso.
- [ ] **¿Los casos cubren todos los constructores del tipo?** Contalos contra la declaración de `data`.
- [ ] **¿Verificaste tu implementación contra los ejemplos del enunciado**, no solo contra tu intuición?
- [ ] **¿Hay alguna búsqueda o recorrido extra** (`elem`, recorrer una lista ya generada, etc.) donde el enunciado pedía "único recorrido" o una complejidad acotada?
- [ ] **¿Hay recursión explícita** en una función donde el enunciado pedía usar solo esquemas?
