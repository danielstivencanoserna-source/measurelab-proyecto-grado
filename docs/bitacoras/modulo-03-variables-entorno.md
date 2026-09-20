# Bitácora / Informe de Entrega — Quincena 3: Fundamentación Teórica — Variables de Entorno

**Estado:** ✅ Cerrado
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

Esta quincena se dedicó a la fundamentación teórica de un concepto ya implementado en el proyecto desde el Módulo 0: las variables de entorno. Se elaboró un documento escrito que explica el problema técnico que resuelven, su base teórica (metodología Twelve-Factor App), su funcionamiento en Node.js mediante `dotenv`, y se documentó explícitamente cada variable de entorno usada en el proyecto con su propósito. Adicionalmente, se corrigieron 3 incidentes de control de versiones detectados durante la auditoría de archivos del Módulo 2.

## 2. Objetivo del módulo

Consolidar el fundamento teórico detrás de la separación entre configuración y código fuente, y sanear el historial de commits pendiente del módulo anterior.

## 3. Avance paso a paso

### Paso 1 — Auditoría de archivos del Módulo 2
Se revisó el contenido real de los archivos de autenticación, detectando que 4 de ellos (`usuario.model.js`, `auth.middleware.js`, `auth.controller.js`, `auth.routes.js`) habían quedado vacíos pese a estar comiteados.

### Paso 2 — Corrección de commits pendientes
Se identificaron cambios sin comitear en `package.json`, `.env.example`, `server.js` y `auth.routes.js`. Se agruparon en un commit correctivo (`065b844`).

### Paso 3 — Limpieza de artefactos erróneos
Se detectó un `package.json` y `node_modules/` generados por error en la raíz del repositorio, producto de ejecutar `npm install` desde una ubicación incorrecta. Se eliminaron tras verificación.

### Paso 4 — Investigación teórica y redacción
Consulta de la metodología Twelve-Factor App y de la documentación oficial de `process.env`/`dotenv`. Elaboración de `docs/academico/trabajo-escrito-variables-entorno.md`.

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| 1 | 4 archivos del módulo de autenticación quedaron vacíos pese a estar comiteados | Contenido no guardado en disco antes del `git add`, mismo patrón del Incidente #1 del Módulo 0 | Alta | Auditoría archivo por archivo con `cat`/`wc -l` antes de dar el módulo por cerrado | Pendiente — se corrige en Quincena 4 |
| 2 | `package.json`/`.env.example`/`server.js` con cambios reales sin comitear | Ediciones realizadas durante depuración, sin `git add` inmediato | Media | Commit correctivo agrupando las 5 modificaciones pendientes | `065b844` |
| 3 | `package.json`/`node_modules` duplicados en la raíz del repositorio | `npm install -D nodemon` ejecutado desde la raíz en vez de `backend/` | Baja | Eliminación tras verificar con `ls node_modules` que no afectaba dependencias reales | N/A (no llegó a comitearse) |

## 5. Evidencia — historial de commits

\`\`\`
[pegar aquí la salida de: git log --oneline -6]
\`\`\`

## 6. Pendientes inmediatos

- [ ] Quincena 4: reconstrucción y verificación de `src/models/usuario.model.js`
- [ ] Quincena 5: reconstrucción y verificación de `src/middlewares/auth.middleware.js`
- [ ] Quincena 6: reconstrucción y verificación de `src/controllers/auth.controller.js`
- [ ] Quincena 7: `src/routes/auth.routes.js` + conexión final en `server.js` + prueba end-to-end de login

## 7. Lecciones aprendidas

- Un commit exitoso en el historial de Git no garantiza que el archivo tenga contenido real — la auditoría con `wc -l` debe ser parte del cierre de cada módulo, no una excepción.
- Verificar la ubicación (`pwd`) antes de `npm install`, igual que antes de `git add`, evita artefactos duplicados que ensucian la raíz del repositorio.
