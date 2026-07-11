1. Cuando el enunciado te da una precondición "gratis", preguntate qué te compra.
Si dice "ordenadas y sin repetidos", esa frase no está de adorno — casi seguro habilita un algoritmo más simple que si no la tuvieras. El reflejo tiene que ser: "¿qué chequeo puedo dejar de hacer porque esto ya me lo garantizan?". Acá: sin la precondición, sí necesitarías elem (buscar si ya lo pusiste). Con ella, comparar las dos cabezas alcanza. Cuando una precondición te resulte "obvia y sin uso", desconfiá — probablemente la estás dejando pasar.

2. Tomate en serio las restricciones de complejidad como restricciones de diseño, no como detalles de examen.
"Un único recorrido" no es una nota al margen: es información que elimina opciones de tu espacio de soluciones antes de pensar en la lógica. Si tu primera idea usa elem, ++ en cada paso, o ordenás y después limpiás duplicados, ya sabés que no puede ser la solución pedida — sin necesidad de terminarla para descubrir que está mal. Usalo como filtro temprano.

3. Construite un catálogo mental de patrones recursivos y buscá el "match".
"Combinar dos listas ordenadas en una sola ordenada" es literalmente el paso merge de mergesort. Si ese patrón ya está en tu cabeza, no lo inventás cada vez — lo reconocés. Vale la pena, cuando resolvés un ejercicio así, quedarte con el patrón pelado (no el código específico): "dos punteros, comparo cabezas, avanzo la/las que corresponda". La próxima vez que veas "dos listas ordenadas" el patrón salta solo.

4. Simulá a mano con un ejemplo chico antes de escribir Haskell.
Agarrá [1,2,3] y [2,3,4] en papel y mezclalos vos, a mano, como si fueran dos mazos de cartas ordenados. Vas a notar que naturalmente mirás solo el tope de cada mazo, nunca "todo lo que ya saqué" — eso es el algoritmo. Traducir un proceso que ya hacés intuitivamente es mucho más fácil que razonarlo en abstracto de una.

5. Antes de tipear la recursión, escribí el invariante en una frase.
Algo tipo: "en cada llamada, prometo que ___". Si no podés completar esa frase, todavía no entendiste bien la estructura recursiva. En este caso: "todo lo que ya emití es menor a las dos cabezas actuales". Este hábito además te sirve doble en esta materia: el ejercicio 3 del parcial te pide demostrar una propiedad por inducción — el invariante que usás para diseñar la función es casi literalmente el que después usás para probar cosas sobre ella.

En resumen: la próxima vez que una precondición te resulte "sospechosamente generosa" y encima te limiten la complejidad, tratalo como una pista fuerte de que existe una versión sin búsqueda — y buscá el patrón de "dos punteros" antes de agregar estructuras auxiliares.