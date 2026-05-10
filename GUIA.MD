### 0. Inicio
* **`ghci nombre_archivo.hs`**: Para iniciar GHCi en un archivo.

Ejemplo:
```bash
ghci tps/tp-7/seccion-2.hs
```

### 1. Navegación y Control (Lo básico)
* **`:q`** o **`:quit`**: Salir de GHCi (para no usar `exit`).
* **`:r`**: Recargar el archivo actual. Úsalo cada vez que guardes cambios en VS Code.
* **`:l <archivo>.hs`**: Cargar un archivo nuevo (reemplaza lo que tenías).
* **`:add <archivo>.hs`**: Añadir un archivo extra a la sesión actual.
* **`:cd <ruta>`**: Cambiar de carpeta sin salir de GHCi.

Ejemplos:
```haskell
:r
:l tps/tp-7/seccion-3.hs
:add tps/tp-7/seccion-3.hs
:cd tps/tp-7
```

Si estás parado en `seccion-2.hs` y querés abrir `seccion-3.hs` sin cerrar GHCi, tenés dos opciones:
```haskell
-- Reemplaza el archivo cargado por completo
:l tps/tp-7/seccion-3.hs

-- O agrega el archivo y mantené el anterior cargado
:add tps/tp-7/seccion-3.hs
```

La diferencia es esta:
* `:l` carga solo ese archivo y descarta lo que tenías antes.
* `:add` suma otro archivo a la sesión actual, útil si uno depende del otro.

### 2. Inspección de Código (Para entender qué pasa)
* **`:t <nombre>`**: Ver el **tipo** de una función o variable (ej: `:t double`).
* **`:i <nombre>`**: Ver **información** detallada (dónde está definido, su tipo y a qué clase pertenece).
* **`:k <nombre>`**: Ver el "kind" de un tipo (es como el "tipo de un tipo", útil más adelante).

Para ver en qué quedó cargada la sesión:
```haskell
:show modules
:show bindings
```

Ejemplo de uso:
```haskell
Prelude> :show modules
Main             ( tps/tp-7/seccion-2.hs, interpreted )

Prelude> :add tps/tp-7/seccion-3.hs
Prelude> :show modules
Main             ( tps/tp-7/seccion-2.hs, interpreted )
Main             ( tps/tp-7/seccion-3.hs, interpreted )
```

Si querés saber si un nombre existe y de dónde viene, también sirve:
```haskell
:i cantidadDeBifurcaciones
```

### 3. Utilidades y Ayuda
* **`:?`**: Muestra la lista completa de comandos disponibles.
* **`:!`**: Ejecutar un comando del sistema (Windows) sin salir (ej: `:! dir` o `:! cls`).
* **`Ctrl + L`**: Limpiar la pantalla de la terminal.
* **`:set +t`**: Configuración para que GHCi te muestre el tipo de cada resultado automáticamente después de cada ejecución.

Ejemplo útil si querés ubicarte rápido:
```haskell
:show modules
:! cd
```

### Importaciones
module Main where 
import Logica --- Aca para importar el archivo Logica.hs