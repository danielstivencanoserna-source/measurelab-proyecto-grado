# Bitácora / Informe de Entrega — Módulo 2: Autenticación

**Estado:** ✅ Cerrado
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

En este período se construyó el módulo de autenticación del backend: modelo de usuarios con borrado lógico, autenticación mediante JWT dual (access token de corta duración + refresh token en cookie httpOnly), middleware de autorización por roles, y las rutas correspondientes. El módulo fue verificado con 8 casos de prueba end-to-end contra una base de datos PostgreSQL real. Durante el cierre se detectaron y corrigieron 2 incidentes de control de versiones, documentados aquí como evidencia del control de calidad aplicado.

## 2. Objetivo del módulo

Implementar el sistema de autenticación y autorización del backend, permitiendo registro, inicio de sesión, renovación de sesión y control de acceso por rol (admin, analista, auditor), como base para proteger los módulos funcionales que se construirán a continuación.

## 3. Avance paso a paso

### Paso 1 — Instalación de dependencias del módulo
```bash
npm install bcryptjs jsonwebtoken joi cookie-parser
```
Se agregaron únicamente las dependencias que este módulo requiere: `bcryptjs` (hash de contraseñas), `jsonwebtoken` (generación/verificación de JWT), `joi` (validación de datos de entrada) y `cookie-parser` (lectura de cookies httpOnly).

### Paso 2 — Variables de entorno
Se agregaron a `.env` y `.env.example`: `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `JWT_ACCESS_EXPIRES`, `JWT_REFRESH_EXPIRES`.

### Paso 3 — Modelo de usuarios
Creación de `src/models/usuario.model.js`: consultas de búsqueda por email/id, creación y desactivación (borrado lógico) de usuarios. El campo `password_hash` nunca se expone en `findById`, que es el método usado por el middleware en cada petición autenticada.

### Paso 4 — Middleware de autenticación y autorización
Creación de `src/middlewares/auth.middleware.js` con dos funciones: `autenticar` (verifica el JWT y consulta el usuario fresco en base de datos en cada petición) y `autorizar(...roles)` (bloquea el acceso según el rol del usuario autenticado).

### Paso 5 — Controlador de autenticación
Creación de `src/controllers/auth.controller.js` con los endpoints de registro, login (emite access token en el body y refresh token en cookie httpOnly), refresh (renueva el access token) y logout.

### Paso 6 — Rutas
Creación de `src/routes/auth.routes.js` y conexión en `server.js` bajo el prefijo `/api/auth`.

### Paso 7 — Verificación
Suite de 8 pruebas end-to-end vía HTTP real contra PostgreSQL: registro, registro duplicado (409), login correcto, login con contraseña incorrecta (401), acceso a ruta protegida sin token (401), acceso con token válido (200), renovación de token con refresh cookie, y logout. Los 8 casos pasaron correctamente.

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| 1 | `git add backend/package.json` y rutas similares fallaron con `pathspec did not match any files` | La terminal estaba parada dentro de `backend/`, por lo que las rutas con prefijo `backend/` apuntaban a `backend/backend/`, una carpeta inexistente | Media | Verificación con `pwd` y ajuste de rutas relativas a la ubicación real de la terminal | `084c423`, `0d0b2e3`, `6e50aaf` |
| 2 | `src/config/db.js` y `.env.example` quedaron como *untracked* tras el commit del esquema de base de datos del Módulo 1 — nunca se subieron a Git | El `git add database/` del commit anterior no incluyó estos archivos, que fueron creados en la misma sesión pero en rutas distintas | Alta — el proyecto no arrancaría en otra máquina sin `db.js` | Commit correctivo agregando ambos archivos | `9d1fc42` |

## 5. Evidencia — historial de commits


## 6. Pendientes inmediatos

- [ ] Módulo 3: modelo, middleware de subida de claearchivos (Multer), controlador y rutas de reactivos

## 7. Lecciones aprendidas

- `pwd` antes de cualquier `git add` no es opcional cuando se trabaja desde subcarpetas del proyecto — evita perder tiempo depurando un `pathspec` que en realidad es un error de ubicación, no de sintaxis.
- Un `git status` limpio inmediatamente después de cada commit (no solo al final del módulo) detecta archivos huérfanos mientras el contexto todavía está fresco, en vez de descubrirlos varios commits después.