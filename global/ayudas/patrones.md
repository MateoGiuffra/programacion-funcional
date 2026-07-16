# Reconocer la forma del problema

Ver también: [índice](README.md) · [esquemas.md](esquemas.md) · [demos.md](demos.md)

---

La mayoría de los ejercicios de "definir función sobre tipo recursivo" son una de estas
formas, aunque el nombre del tipo y el dominio cambien de parcial a parcial. Antes de
escribir, identificá cuál es:

- **Lista disfrazada** (un caso base "vacío" + un caso recursivo que agrega un elemento y sigue). Las funciones típicas sobre esto son reinvenciones de `length`, `sum`, `maximum`, `(++)` con otro nombre — si reconocés el patrón, no hace falta inventar el algoritmo de cero.

- **Dos ramas que corren en simultáneo** (arrancan del mismo punto, avanzan "a la par"). Se combinan elemento a elemento; cuando una termina antes que la otra, la que sigue continúa sola sin nada que combinar.

- **Dos ramas donde una alimenta a la otra** (secuencialidad: "lo que sale de recorrer la primera es el punto de partida para recorrer la segunda"). Si la primera falla, la segunda ni se intenta — el resultado global es el fallo, sin explorar más.

- **Ramificación codificada con solo dos campos recursivos** (un tipo que conceptualmente tiene "N alternativas posibles" pero el constructor solo trae dos punteros recursivos). Ahí un campo representa "la continuación real" y el otro representa "otra alternativa al mismo nivel" — son roles distintos, no intercambiables. Al recorrer este tipo, lo que se propaga por la "continuación real" no se propaga por la "alternativa", y viceversa.

- **Colapsar/simplificar cadenas de constructores repetidos.** El patrón que funciona es recursar primero al hijo, y **después** mirar si el resultado ya procesado matchea el mismo constructor para seguir fusionando — así colapsás cadenas de largo arbitrario, no solo pares consecutivos.

- **Simplificar solo en un caso muy puntual y específico.** Si el enunciado describe una condición sintáctica exacta ("cuando la expresión es tal forma particular"), la única manera segura de detectarla es hacer pattern matching de esa forma exacta. **Nunca** evalúes/ejecutes la expresión con un valor "de prueba" inventado para adivinar si estás en ese caso — si la expresión depende de algo que no conocés en ese punto, evaluarla puede no solo fallar, sino darte un resultado **incorrecto y silencioso** (si por casualidad el resultado "parece" válido). Un fallo explícito siempre es preferible a un resultado silenciosamente equivocado.

- **Fusionar dos secuencias ya ordenadas en una sola.** El patrón de "dos punteros": comparás las cabezas actuales de cada secuencia y avanzás **solo** la que ya "ganó" esa comparación — la otra se queda pendiente, porque todavía no se comparó contra lo que sigue. Buscar en lo ya generado (`elem` o similar) nunca hace falta si el problema te garantiza orden y ausencia de repetidos: esa garantía es justamente lo que te permite no buscar.

- **Contar pasos, tamaño o altura sobre una estructura con ramificación.** Definí explícitamente qué cuenta como una unidad (¿el nodo de ramificación en sí suma un paso?) y aplicá cada incremento **solo** al lado de la estructura que efectivamente lo atraviesa. Es un error común "repartir" un mismo incremento a ramas alternativas que en la práctica no pasan por ese punto.
