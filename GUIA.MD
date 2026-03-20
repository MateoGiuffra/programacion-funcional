### 0. Inicio
* **`ghci nombre_archivo.hs`**: Para iniciar GHCi en un archivo.

### 1. Navegación y Control (Lo básico)
* **`:q`** o **`:quit`**: Salir de GHCi (para no usar `exit`).
* **`:r`**: Recargar el archivo actual. Úsalo cada vez que guardes cambios en VS Code.
* **`:l <archivo>.hs`**: Cargar un archivo nuevo (reemplaza lo que tenías).
* **`:add <archivo>.hs`**: Añadir un archivo extra a la sesión actual.
* **`:cd <ruta>`**: Cambiar de carpeta sin salir de GHCi.

### 2. Inspección de Código (Para entender qué pasa)
* **`:t <nombre>`**: Ver el **tipo** de una función o variable (ej: `:t double`).
* **`:i <nombre>`**: Ver **información** detallada (dónde está definido, su tipo y a qué clase pertenece).
* **`:k <nombre>`**: Ver el "kind" de un tipo (es como el "tipo de un tipo", útil más adelante).

### 3. Utilidades y Ayuda
* **`:?`**: Muestra la lista completa de comandos disponibles.
* **`:!`**: Ejecutar un comando del sistema (Windows) sin salir (ej: `:! dir` o `:! cls`).
* **`Ctrl + L`**: Limpiar la pantalla de la terminal.
* **`:set +t`**: Configuración para que GHCi te muestre el tipo de cada resultado automáticamente después de cada ejecución.

### Importaciones
module Main where 
import Logica --- Aca para importar el archivo Logica.hs