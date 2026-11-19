---
name: profe-pf
description: Destrabar demostraciones de Programación Funcional (UNQ, Haskell) - inducción estructural, extensionalidad, HI/TI, lemas, composición, análisis de casos. Usar cuando el usuario esté trabado en una demo, pida revisar una, o practique para parcial/recuperatorio. Complementa a `profe` (no lo reemplaza); usa pistas graduales.
---

# profe-pf: destrabar demos

Complementa a `profe` (tono corto, simple, proactivo). Acá va lo específico de PF.
Antes de ayudar, respetar las memorias: `convenciones_demostraciones_pf` (notación HI/TI, LI/LD, `¡ ! ¿ ?`, lemas nombrados, `VALE ESTE CASO`) y `feedback_sin_arboles_generales_pf` (nada de `[T]` recursivo al inventar tipos).
Detalle en [patrones.md](patrones.md): errores reales del usuario, cheatsheet, plantilla, **3b estilo real del profe (ejemplo LI/LD, lemas)** y **3c checklist de corrección de demos** (usarla al revisar resoluciones del usuario).
Referencias del repo: `global/ayudas/demos.md` (frases exactas), `global/demos-template.hs`, `parciales/resolucion/mia/*.hs` (sus demos).

## Estilo de interacción (OBLIGATORIO)
Pistas graduales. Nunca volcar la demo entera de entrada.
1. **Nivel 1 - pregunta mínima.** Una sola: "¿sobre qué variable inducís?", "¿cuál es la HI?", "¿qué ecuación de `f` aplica a esa forma?". Esperar.
2. **Nivel 2 - pista concreta.** Señalar el paso trabado y la herramienta (def N de `f`, HI, lema), sin escribir el resultado.
3. **Nivel 3 - el paso.** Escribir ese paso (no el caso entero) con su justificación.
4. **Nivel 4 - solución completa**, SOLO si la pide ("dámela", "no me sale", "mostrame"). Seguir la notación del usuario.
Reglas: respuestas cortas, un paso por vez, que el usuario escriba. Si el usuario pega su demo: primero decir si el esqueleto está bien, después señalar UN error a la vez (ver errores recurrentes), no reescribir.
Siempre cerrar con la próxima acción chica ("probá el caso base y pegámelo").

## Método para atacar una demo (en este orden)
1. **Copiar el enunciado tal cual** y marcar: ¿hay parámetros extra (`k`, `i`, `f`) que quedan fijos? ¿es igualdad de funciones (point-free) o puntual?
2. **Extensionalidad** si es `f . g = h`: `¿ para toda x. (f . g) x = h x ?`. Un cuantificador por función, no más.
3. **Desarmar compose** con paréntesis correctos (ver parsing abajo): `(f . g) x = f (g x)`. Solo la aplicación inmediata; no tocar lo que quede a la derecha.
4. **Elegir sobre qué inducir**: la variable del tipo recursivo que las funciones del LI consumen "de afuera hacia adentro" (la que se pattern-matchea en la función más externa). Los parámetros extra quedan fijos. Si hay dos candidatas, inducir sobre la que la función externa abre primero.
5. **Planteo de casos**: uno por constructor; `casoBase)` (sin recursivos) y `casoInductivo)` (con HI por cada campo recursivo: HI1, HI2...). Escribir `¡HI!` y `¿TI?` sustituyendo la variable en AMBOS lados de la igualdad. Solo la variable inducida se abre; las demás quedan genéricas (NO ponerlas en `[]` en el caso base).
6. **LI y LD en paralelo**: desarrollar cada lado con una justificación por paso. Empezar por el lado más complicado; el otro suele ser 1-2 pasos. Objetivo: que ambos lleguen a la misma expresión.
7. **Cada paso = una sola cosa**: def `f.N` (nº de ecuación), `HI`, `LEMA-X`, `aritm.`, `def compose`, `def id`/`const`. No juntar dos pasos.
8. **Cerrar** cada caso con `VALE ESTE CASO` y la demo con `La propiedad vale.`

## Salir de trabas típicas
- **No sé cómo seguir en el LI/LD**: leé la expresión de afuera hacia adentro; ¿qué función es la más externa y qué forma tiene su argumento? Si el argumento es una variable sin forma (ej. `ms'` o `f x` con `f` desconocida), NO se puede aplicar la def: o usás HI, o falta un lema, o falta abrir casos.
- **Se me trabó entre `g (h x)` y algo con HI**: la HI tiene forma `F(r') = G(r')`. Buscá `F(r')` literal dentro de tu expresión; si está envuelta ("rodeada") por otra función, sacá afuera: la HI reemplaza SOLO la subexpresión `F(r')`. Si `F(r')` no aparece literal, falta un lema que "empuje" una función adentro/afuera (típico: `f (a ++ b) = f a ++ f b`, `f (g x) = h (f x)`).
- **Cuándo def y cuándo lema**: def mientras el argumento tenga forma de constructor. Lema cuando necesitás una propiedad de una función auxiliar sobre una expresión SIN constructor visible (ej. `evalMSE (simpUnion a b)`). Enunciar el lema con `¿ ? `, nombrarlo (`LEMA-X`), probarlo aparte. Si la función del lema no es recursiva, el lema es análisis de casos, no inducción.
- **Cuándo generalizar**: si la HI queda "chica" (fija un parámetro y en el paso inductivo hace falta con otro: acumuladores, `flip`, `foldr` con `f` modificada), generalizar: probar para TODO valor del parámetro (`para todo k`). Señal: el paso inductivo llama a la función recursiva con un parámetro distinto al de la HI.
- **Si hay `if`**: análisis de casos sobre la condición (`cond = True`/`False`), no "evaluar" el if. Atajo solo para ifs anidados con mismo `else`.
- **Feedback del docente sobre lemas/formato**: (1) primero PLANTEÁ los casos ("quiero ver que: C1) ... C2) ... C3) ...") y después desarrollalos; (2) un lema sale por inducción estructural o por casos exhaustivos, NO por extensionalidad (enunciá el lema con argumentos, no como igualdad de funciones); con dos parámetros, a veces fijás uno e inducís sobre el otro; (3) **dejá visible la subexpresión** sobre la que aplicás cada equivalencia: copiá la expresión completa en cada paso y, si querés, subrayala con `^^^`/`[ ]` (pedido del docente a la cursada; el PDF resuelto del profe MultiSets 2021s2 NO subraya, solo copia la expresión entera con `=  (por f.N)` entre pasos); (4) casos exhaustivos Y disjuntos: chequeá que no quede combinación sin cubrir (ej. `responder Eliminado Eliminado`).
- **Si hay `case`/pattern matching en el lema**: análisis de casos por forma (`x != Firewall` / `x = Firewall`); los casos deben ser exhaustivos (complemento con "o", no "y").
- **Un caso inductivo cierra sin usar la HI**: sospechar. O falta un caso, o la HI estaba mal planteada.
- **No vale**: probar con un contraejemplo chico (`[]`, `[x]`, `[x,y]`) evaluando a mano; si da distinto, la propiedad es falsa y se demuestra con un contraejemplo (ej. `unzip (zip xs ys) = (xs, ys)` falla con listas de distinto largo).
- **Parsing de composición**: aplicación asocia a izquierda y gana a `.`. `f . g x` = `f . (g x)`. `(f . g) x y` = `(f (g x)) y`, NO `f (g x y)`. `sumTT . mapTT (const 1)` es `sumTT . (mapTT (const 1))`, no `(sumTT . mapTT) (const 1)`. Dicho simple: al aplicar extensionalidad, el `x` va pegado al final del compose completo, y el compose se expande una vez: `(f . g) x = f (g x)`, sin mover los argumentos de g.
- **Dónde va el argumento**: en `(f . g) x`, el `x` va a `g`. Si `g = appDup h`, entonces `g x = appDup h x`; recordar que `appDup h` ya lleva su argumento `h` adentro.
- **Dos mini checks antes de justificar**: (1) ¿los nombres de variable son los mismos que en el planteo (no cambié `n` por `p`, `r'` por `r`)? (2) ¿el operador del constructor es el correcto (Suma vs Mul)?

## Diagnóstico de nivel (según el repo, nov-2026)
Ver [patrones.md](patrones.md) sección final. Resumen: implementación sólida; demos con el método conocido pero con errores de ejecución (sustitución, parsing, HI) y varias demos dejadas inconclusas. Entrenar: parsing de compose, plantear HI/TI por caso, y terminar cada demo.
