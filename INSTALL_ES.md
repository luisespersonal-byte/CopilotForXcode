# Copilot for Xcode <img alt="Logo" src="/AppIcon.png" align="right" height="50">

**Copilot for Xcode** es el proyecto de GitHub que permite usar **GitHub Copilot como agente dentro de Xcode**. Es una extensión del editor de código fuente de Xcode que integra GitHub Copilot, Codeium y ChatGPT directamente en tu entorno de desarrollo.

- 🔗 Proyecto en GitHub: [https://github.com/intitni/CopilotForXcode](https://github.com/intitni/CopilotForXcode)

## Guía de Instalación en macOS

[English installation instructions / Instrucciones de instalación en inglés](README.md#installation-and-setup)

## Requisitos Previos

- Conexión a internet pública.

Para funciones de sugerencia de código:

- Para usuarios de GitHub Copilot:
  - [Node.js](https://nodejs.org/) instalado para ejecutar el LSP de Copilot.
  - Suscripción activa a GitHub Copilot.
- Para usuarios de Codeium:
  - Cuenta activa de Codeium.
- Acceso a otros LLMs.

Para funciones de chat y "Prompt to Code":

- Una clave de API de OpenAI válida.
- Acceso a otros LLMs.

## Permisos Requeridos

- Acceso a carpetas
- API de Accesibilidad

> Si te preocupa el registro de teclas y no puedes confiar en el binario, recomendamos revisar el código y [compilarlo tú mismo](DEVELOPMENT.md).

## Instalación Automática

Para instalar automáticamente con un solo comando, ejecuta esto en la **Terminal**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/intitni/CopilotForXcode/main/install.sh)
```

El script comprobará los requisitos previos, instalará la app mediante Homebrew (si está disponible) y te guiará paso a paso por las acciones manuales necesarias.

Si ya tienes el repositorio clonado localmente, también puedes ejecutar:

```bash
bash install.sh
```

---

## Instalación y Configuración Manual

> El proceso de instalación puede parecer complejo al principio. Aquí tienes un resumen rápido:
>
> 1. Instala la app en la carpeta Aplicaciones y ábrela una vez.
> 2. Habilita la extensión del editor de código fuente.
> 3. Otorga permiso de API de Accesibilidad a la extensión.
> 4. Configura las cuentas y modelos en la app principal.
> 5. Opcionalmente, ajusta la configuración de cada función y los atajos de teclado.

### Paso 1: Instalar la Aplicación

Puedes instalarla con [Homebrew](http://brew.sh/):

```bash
brew install --cask copilot-for-xcode
```

O instalarla manualmente descargando `Copilot for Xcode.app` desde la última [versión publicada](https://github.com/intitni/CopilotForXcode/releases).

Asegúrate de que la app esté dentro de la carpeta **Aplicaciones**.

Abre la app; esta creará un agente de inicio para configurar un servicio en segundo plano que realiza el trabajo real.

### Paso 2: Habilitar la Extensión

Habilita la extensión en `Ajustes del Sistema`.

#### macOS 15

Desde el menú Apple en la esquina superior izquierda, haz clic en `Ajustes del Sistema`. Navega a `General` → `Ítems de inicio y extensiones`. Haz clic en `Xcode Source Editor` y marca `Copilot for Xcode`.

#### macOS 14

Desde el menú Apple en la esquina superior izquierda, haz clic en `Ajustes del Sistema`. Navega a `Privacidad y seguridad` → desplázate hacia abajo y haz clic en `Extensiones`. Haz clic en `Xcode Source Editor` y marca `Copilot`.

#### Versiones Anteriores

Si usas macOS Monterey, accede al menú `Extensiones` en `Preferencias del Sistema` con su icono dedicado.

### Paso 3: Otorgar Permisos a la App

La primera vez que abras la app y ejecutes un comando, la extensión solicitará los permisos necesarios.

También puedes otorgar los permisos manualmente en la pestaña `Privacidad y seguridad` en `Ajustes del Sistema`.

- Para otorgar permisos de la API de Accesibilidad, haz clic en `Accesibilidad` y arrastra `CopilotForXcodeExtensionService.app` a la lista. Puedes localizar la app de extensión haciendo clic en `Reveal Extension App in Finder` en la app principal.

<img alt="Permiso API de Accesibilidad" src="/accessibility_api_permission.png" width="500px">

Si aparece una alerta solicitando un permiso que ya habías otorgado, elimina el permiso de la lista y vuelve a agregarlo.

### Paso 4: Configurar Atajos de Teclado

La extensión funciona mejor con atajos de teclado.

Puedes configurarlos en `Ajustes de Xcode > Key Bindings`. Filtra la lista escribiendo `copilot` en la barra de búsqueda.

Una [configuración recomendada](https://github.com/intitni/CopilotForXcode/issues/14) sin conflictos es:

| Comando                | Atajo de Teclado                                       |
| ---------------------- | ------------------------------------------------------ |
| Aceptar Sugerencias    | `⌥}` o Tab                                             |
| Descartar Sugerencias  | Esc                                                    |
| Rechazar Sugerencia    | `⌥{`                                                   |
| Siguiente Sugerencia   | `⌥>`                                                   |
| Sugerencia Anterior    | `⌥<`                                                   |
| Abrir Chat             | `⌥"`                                                   |
| Explicar Selección     | `⌥\|`                                                  |

También puedes usar `⇧⌘/` para buscar un comando en la barra de menú.

### Paso 5: Configurar Sugerencias de Código

#### Configurar GitHub Copilot

1. En la app principal, navega a "Service - GitHub Copilot" para acceder a la configuración de tu cuenta.
2. Haz clic en "Install" para instalar el servidor de lenguaje.
3. Opcionalmente, configura la ruta a Node. El valor predeterminado es simplemente `node`. La app buscará Node en: `/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin`.

   Si tu instalación de Node está en otra ubicación, ejecuta `which node` en la terminal para obtener la ruta correcta.

4. Haz clic en "Sign In" y serás redirigido a un sitio de verificación de GitHub. Se copiará un código de usuario a tu portapapeles.
5. Después de iniciar sesión, regresa a la app y haz clic en "Confirm Sign-in" para completar el proceso.
6. Ve a "Feature - Suggestion" y actualiza el proveedor a "GitHub Copilot".

#### Configurar Codeium

1. En la app principal, navega a "Service - Codeium" para acceder a la configuración de Codeium.
2. Haz clic en "Install" para instalar el servidor de lenguaje.
3. Haz clic en "Sign In" y serás redirigido a codeium.com. Después de iniciar sesión, se te proporcionará un token. Copia y pega este token en la app para completar el inicio de sesión.
4. Ve a "Feature - Suggestion" y actualiza el proveedor a "Codeium".

> La clave se almacena en el llavero. Cuando la app auxiliar intente acceder a la clave por primera vez, te pedirá la contraseña del llavero. Selecciona "Permitir siempre".

### Paso 6: Configurar la Función de Chat

1. En la app principal, navega a "Service - Chat Model".
2. Actualiza el modelo de OpenAI o crea uno nuevo si es necesario. Usa el botón de prueba para verificar el modelo.
3. Opcionalmente, configura el modelo de embedding en "Service - Embedding Model", necesario para algunas funciones del chat.
4. Ve a "Feature - Chat" y actualiza el proveedor de chat/embedding con el que acabas de configurar.

## Actualización

Puedes usar el actualizador integrado en la app o descargar la última versión manualmente desde la última [versión publicada](https://github.com/intitni/CopilotForXcode/releases).

Después de actualizar, abre Copilot for Xcode.app una vez y reinicia Xcode para permitir que la extensión se recargue.

Si encuentras que algunas funciones dejaron de funcionar, intenta primero volver a otorgar los permisos a la app.
