# Bitácora / Informe de Entrega — Módulo 5: Middleware de Autenticación

**Estado:** ✅ Cerrado
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

Esta quincena se dedicó a reconstruir y verificar `src/middlewares/auth.middleware.js`, el componente que protege las rutas del backend: `autenticar` valida el token JWT y confirma en base de datos que el usuario siga activo, y `autorizar` restringe el acceso según el rol. El archivo había quedado vacío pese a estar comiteado desde el Módulo 2. Se configuraron los secretos JWT en el `.env` real, se diseñó una prueba aislada con objetos simulados de Express (sin servidor ni controlador de login, que aún no existen) y se ejecutaron 9 verificaciones, todas exitosas. Durante la quincena se documentaron 4 incidentes de configuración y control de versiones.

## 2. Objetivo del módulo

Dejar el middleware de autenticación y autorización funcional y verificado de forma independiente, de modo que el controlador y las rutas de los módulos siguientes puedan apoyarse en él.

## 3. Avance paso a paso

### Paso 1 — Auditoría inicial
`wc -l src/middlewares/auth.middleware.js` devolvió 0 líneas: el archivo estaba vacío pese al commit `6e50aaf` del Módulo 2.

### Paso 2 — Reconstrucción del middleware
Se escribió el archivo con sus dos funciones (`autenticar` y `autorizar`), verificando la pestaña activa del editor antes de pegar. `wc -l` confirmó 56 líneas guardadas.

### Paso 3 — Configuración de los secretos JWT
`grep -c "JWT_ACCESS_SECRET" .env` devolvió 0: el `.env` real no tenía las variables de autenticación. Se generaron dos secretos aleatorios de 64 bytes con el módulo `crypto` de Node y se agregaron al `.env` junto con los tiempos de expiración, sin mostrarlos en pantalla. Se verificó con `grep -c "JWT" .env` (4 variables) y con `git check-ignore .env` que Git ignora el archivo.

### Paso 4 — Diseño de la prueba aislada
Como `auth.controller.js` (que emite los tokens reales) aún no existe, se diseñó un script temporal que invoca el middleware con objetos `req`, `res` y `next` simulados. Los tokens de prueba se firman manualmente con la misma librería y el mismo secreto que usará el login. El script crea un usuario real de prueba y lo elimina al terminar, aunque alguna verificación falle.

### Paso 5 — Primer intento fallido de ejecución
El script se detuvo al arrancar con `la autentificación password falló para el usuario "postgres"`. Se descartaron causas en este orden: el `.env` leído por Node tenía host, puerto, base de datos y usuario correctos y sin espacios ocultos; solo había un servicio de PostgreSQL activo (`postgresql-x64-17`); y ninguna variable del sistema sobrescribía `DB_PASSWORD`. La causa era una contraseña del `.env` distinta a la del servidor. Se restableció la contraseña del usuario `postgres` desde SQL Shell y se alineó el `.env`.

### Paso 6 — Ejecución de la verificación
Con la conexión restablecida, el script ejecutó 9 verificaciones sobre los 7 casos planificados más 2 adicionales: la comprobación de que `req.usuario` no expone `password_hash` y la revocación inmediata de un token todavía vigente cuando el usuario es desactivado.

| # | Caso | Resultado |
|---|---|---|
| 1 | Petición sin token | 401 «Token de acceso requerido» |
| 2 | Token mal formado | 401 «Token inválido» |
| 3 | Token expirado | 401 con código `TOKEN_EXPIRED` |
| 4 | Token válido de usuario inexistente | 401 «Usuario no autorizado» |
| 5 | Token válido de usuario activo | Llama a `next()` y puebla `req.usuario` |
| 5b | Contenido de `req.usuario` | No expone `password_hash` |
| 6 | `autorizar('admin')` con rol analista | 403 |
| 7 | `autorizar('admin')` con rol admin | Pasa a `next()` |
| 8 | Token vigente de usuario desactivado | 401, acceso revocado al instante |

Resultado final: 9 pasadas, 0 falladas.

### Paso 7 — Limpieza y commit
Se agregó al commit únicamente `auth.middleware.js`, indicado por nombre y no con `git add .`. El script de prueba no se versionó.

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| 1 | `auth.middleware.js` vacío (0 líneas) pese a estar comiteado | Contenido sin guardar en disco antes del `git add` del Módulo 2 (patrón ya documentado en módulos anteriores) | Alta | Reconstrucción y verificación con `wc -l` antes de comitear | `4a15bd9` |
| 2 | El `.env` real no contenía las variables JWT | En el Módulo 2 solo se actualizó la plantilla `.env.example`, no el archivo real | Alta: sin ellas no se pueden firmar ni verificar tokens | Generación de secretos aleatorios con `crypto.randomBytes` y verificación con `grep` y `git check-ignore` | N/A (el `.env` no se versiona) |
| 3 | `la autentificación password falló` al conectar a PostgreSQL | La contraseña del `.env` no coincidía con la del servidor | Media | Diagnóstico por descarte (valores del `.env`, servicios activos, variables del sistema) y restablecimiento de la contraseña alineada con el `.env` | N/A (configuración local) |
| 4 | `.env.example` quedó modificado con frases personales en lugar de valores de ejemplo | Posible edición del archivo equivocado: `.env` y `.env.example` aparecen contiguos en el explorador de VS Code | Media: de comitearse, habría expuesto en GitHub valores con apariencia de secretos | Detectado con `git status` y `git diff` antes de comitear; restaurado con `git restore`. Nunca salió del equipo local | N/A (no llegó a comitearse) |

## 5. Evidencia — historial de commits

```
4a15bd9 feat(auth): middleware de autenticacion JWT y autorizacion por roles, verificado con 9 pruebas
ff751cb docs: agrega bitacora tecnica del modulo 4 (modelo de usuarios)
d146b0e feat(usuarios): modelo de acceso a datos con borrado logico, verificado end-to-end
```

## 6. Pendientes inmediatos

- [ ] Quincena 6: reconstrucción y verificación de `src/controllers/auth.controller.js`
- [ ] Quincena 7: `src/routes/auth.routes.js`, conexión final en `server.js` y prueba de login completa a través de HTTP

## 7. Lecciones aprendidas

- Los mensajes de error de PostgreSQL permiten diagnosticar por descarte: «autentificación falló» significa que el servidor sí respondió y el usuario existe; «no existe la base de datos» y un rechazo de conexión cuentan historias distintas. Leer el mensaje antes de actuar acortó el diagnóstico.
- Un middleware puede verificarse de forma aislada, con objetos simulados, antes de que exista el resto del sistema. Esa prueba no reemplaza la verificación a través de HTTP real, que se hará al conectar las rutas.
- Revisar `git status` y `git diff` antes de comitear, y agregar los archivos por nombre en lugar de usar `git add .`, evitó que un archivo modificado por error llegara al repositorio público.
- Los archivos `.env` y `.env.example` tienen nombres casi idénticos y propósitos opuestos: uno guarda secretos reales y no se versiona, el otro es una plantilla pública. Confirmar el nombre de la pestaña activa antes de escribir es parte del hábito de trabajo.