# "Sin recursión explícita" / esquemas (fold, rec)

Ver también: [índice](README.md) · [patrones.md](patrones.md) · [demos.md](demos.md)

---

- [ ] La restricción es **sobre el tipo que estás recorriendo en la función que estás escribiendo ahora mismo**, no sobre "nada en el programa puede usar recursión". Podés seguir llamando a funciones ya definidas (aunque internamente usen recursión explícita) — eso es aplicar una función, no recurrir vos.
- [ ] Si la función que tenés que escribir recorre un tipo para el que el enunciado **no** te pidió un esquema explícito en otro ejercicio, armate el esquema de ese tipo igual — es un prerrequisito implícito, no algo opcional.
- [ ] **`fold` vs `rec`:** un `fold` solo te da, en cada campo recursivo, el resultado ya procesado (`b`). Un `rec` te da además la subestructura original sin procesar. Necesitás `rec` en cuanto tengas que volver a mirar la forma de un hijo (no solo su resumen) — típicamente en funciones que "simplifican" o "reconstruyen" comparando contra el original.
- [ ] Pista rápida: "recorro todo y devuelvo un resumen/acumulado" → `fold`. "En algún punto necesito el árbol/lista original, no solo su resultado" → `rec`.
- [ ] Ojo con el **caso base compartido**: un esquema usa un único valor para representar el caso base, aunque ese mismo caso base pueda aparecer en dos lugares distintos de la estructura con un significado distinto en cada uno (por ejemplo, un tipo con dos campos recursivos donde el mismo constructor "vacío" significa cosas distintas según en qué campo aparece). Si eso pasa, la distinción hay que hacerla **a mano dentro del combinador** que le pasás al esquema, no esperar que el esquema la resuelva sola.
