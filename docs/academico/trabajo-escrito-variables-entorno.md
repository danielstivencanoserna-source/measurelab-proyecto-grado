# Variables de Entorno en el Desarrollo de Software

**Fundamentación teórica y aplicación práctica en el proyecto MeasureLab**

**Aprendiz:** Daniel Stiven Cano Serna
**Programa:** Tecnólogo en Análisis y Desarrollo de Software
**Proyecto:**Sistema de Gestión de Laboratorio
**Quincena:** 3

---

## 1. Introducción

Durante la construcción de los Módulos 0 y 1 del proyecto se implementó un mecanismo para separar la configuración del sistema (credenciales de base de datos, puertos, secretos de autenticación) del código fuente, mediante archivos `.env`. Este documento explica el fundamento teórico detrás de esa decisión técnica, por qué es una práctica estándar en la industria, y cómo se aplicó concretamente en el proyecto.

## 2. ¿Qué es una variable de entorno?

Una variable de entorno es un valor con nombre que vive **fuera del código fuente**, en el sistema operativo o en el proceso que ejecuta la aplicación, y que el programa puede leer en tiempo de ejecución. A diferencia de una variable normal de un lenguaje de programación (que se define dentro del código y solo existe mientras ese programa corre), una variable de entorno:

- No está escrita en ningún archivo `.js`, `.py`, etc. que se suba a un repositorio.
- Puede cambiar su valor sin tocar una sola línea de código — solo cambiando el entorno donde corre la aplicación.
- Es la misma variable (ej. `DB_HOST`) pero con valores distintos según dónde se ejecute el programa: en la máquina del desarrollador, en un servidor de pruebas, o en producción.

## 3. Por qué existen: el problema que resuelven

Antes de que esta práctica fuera estándar, era común escribir credenciales directamente en el código:

\`\`\`javascript
// Práctica incorrecta — NUNCA hacer esto
const pool = new Pool({
  host: 'localhost',
  password: 'MiClaveReal123',
});
\`\`\`

Este enfoque genera tres problemas concretos:

1. **Seguridad comprometida.** Si el código se sube a un repositorio (incluso privado), la contraseña real queda expuesta en el historial de Git para siempre, incluso si después se borra — Git conserva el historial completo de cambios.
2. **Falta de portabilidad.** El mismo código no puede ejecutarse en dos entornos distintos (por ejemplo, la base de datos del desarrollador y la del servidor de producción) sin modificar manualmente el archivo fuente cada vez.
3. **Riesgo de errores humanos.** Cada persona que trabaja en el proyecto tendría que recordar cambiar esos valores antes de hacer *commit*, y basta un descuido para filtrar credenciales reales.

Esta idea está formalizada en la metodología **"The Twelve-Factor App"** (Wiggins, 2011), un conjunto de buenas prácticas para construir aplicaciones modernas. Su tercer principio, *"Config"*, establece textualmente que la configuración que varía entre entornos (desarrollo, pruebas, producción) debe almacenarse en variables de entorno, estrictamente separada del código.

## 4. Cómo funciona técnicamente en Node.js

Node.js expone las variables de entorno del sistema operativo a través del objeto global `process.env`. Cualquier variable definida en el entorno del sistema es accesible así:

\`\`\`javascript
console.log(process.env.DB_HOST);
\`\`\`

El problema práctico es que definir manualmente cada variable en el sistema operativo (por ejemplo, con `export DB_HOST=localhost` en la terminal) es incómodo y hay que repetirlo cada vez que se abre una terminal nueva. Para resolver esto se usa la librería **`dotenv`**, que:

1. Lee un archivo de texto plano llamado `.env` en la raíz del proyecto.
2. Carga cada línea (`CLAVE=valor`) dentro de `process.env`, como si se hubiera definido manualmente en el sistema.
3. Se ejecuta con una sola línea al inicio del programa:

\`\`\`javascript
require('dotenv').config();
\`\`\`

En el proyecto MeasureLab, esto ocurre en `backend/src/config/db.js`, antes de crear el `Pool` de conexión a PostgreSQL — así, cuando se construye el pool, `process.env.DB_HOST`, `process.env.DB_PASSWORD`, etc., ya están disponibles.

## 5. Buenas prácticas aplicadas en el proyecto

| Práctica | Cómo se aplicó en MeasureLab |
|---|---|
| Nunca subir el archivo `.env` real a Git | Se agregó `.env` al `.gitignore` desde el Módulo 0 |
| Proveer una plantilla pública sin secretos | Se creó `.env.example` con las mismas claves pero valores de ejemplo (`cambia_esto`) |
| Nombres de variables en mayúsculas con guión bajo | `DB_HOST`, `JWT_ACCESS_SECRET`, `NODE_ENV` (convención estándar, no una regla técnica obligatoria pero sí universalmente adoptada) |
| Separar por dominio de configuración | Variables de base de datos (`DB_*`), del servidor (`PORT`, `NODE_ENV`) y de autenticación (`JWT_*`) agrupadas y comentadas por bloques |
| Fallar rápido si falta configuración crítica | `db.js` llama a `process.exit(1)` si la conexión a PostgreSQL falla, evitando que el servidor quede corriendo sin base de datos funcional |

## 6. Variables de entorno usadas en MeasureLab y su propósito

| Variable | Propósito |
|---|---|
| `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` | Credenciales de conexión a PostgreSQL — distintas en cada máquina donde corre el proyecto |
| `PORT` | Puerto donde escucha el servidor Express — permite cambiarlo sin tocar código si hay conflicto con otro proceso |
| `NODE_ENV` | Indica si el entorno es `development` o `production`; se usa, por ejemplo, para decidir si una cookie lleva el flag `secure` (solo HTTPS) |
| `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET` | Claves secretas para firmar los tokens de autenticación — si estuvieran en el código y se filtraran, cualquiera podría fabricar tokens válidos y suplantar usuarios |
| `JWT_ACCESS_EXPIRES`, `JWT_REFRESH_EXPIRES` | Duración de cada tipo de token, configurable sin tocar el código de `auth.controller.js` |

## 7. Conclusiones

La separación entre configuración y código no es una convención arbitraria: resuelve problemas reales de seguridad (credenciales expuestas), portabilidad (mismo código en distintos entornos) y mantenibilidad (cambiar un valor sin tocar ni redesplegar código). En MeasureLab, esta práctica se implementó desde el primer módulo de infraestructura y sostiene la seguridad del módulo de autenticación desarrollado posteriormente, particularmente en la protección de los secretos usados para firmar los JSON Web Tokens.

## 8. Referencias

- Wiggins, A. (2011). *The Twelve-Factor App*. https://12factor.net/es/config
- Node.js Foundation. *Documentación oficial de `process.env`*. https://nodejs.org/api/process.html#processenv
- Motdotla. *dotenv — Documentación oficial*. https://github.com/motdotla/dotenv