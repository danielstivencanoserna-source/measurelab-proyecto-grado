# Bitácora / Informe de Entrega — Módulo 1: Base de Datos

**Estado:** ✅ Cerrado
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

En este período se diseñó y construyó la capa de persistencia del sistema MeasureLab: esquema relacional completo en PostgreSQL (8 tablas con sus relaciones, restricciones e índices), módulo de conexión mediante pool (`pg`), configuración de variables de entorno para credenciales de base de datos, y carga del catálogo inicial de pictogramas GHS requerido por el módulo de reactivos.

## 2. Objetivo del módulo

Establecer la base de datos del sistema y su capa de conexión desde el backend, de forma que los módulos funcionales (usuarios, reactivos, preparaciones, SICOQ) puedan construirse sobre un esquema ya validado y estable.

## 3. Avance paso a paso

### Paso 1 — Instalación de dependencias de base de datos
```bash
npm install pg@^8.20.0 dotenv@^17.3.1
```
Se instalaron únicamente las dependencias necesarias para este módulo, siguiendo el principio de que cada módulo justifica sus propias dependencias en el historial de commits.

### Paso 2 — Variables de entorno
Creación de `backend/.env.example` (plantilla pública) y `backend/.env` (credenciales reales, excluido por `.gitignore`) con las variables `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `PORT`, `NODE_ENV`.

### Paso 3 — Diseño del esquema relacional
Creación de `backend/database/schema.sql` con 8 tablas (`usuarios`, `proveedores`, `pictogramas`, `reactivos`, `reactivo_pictogramas`, `preparacion_soluciones`, `preparacion_reactivos`, `sicoq_consumos`), llaves foráneas respetando el orden de dependencia, restricciones `CHECK` equivalentes a las validaciones de negocio, triggers de actualización automática de `updated_at`, e índices sobre las columnas de búsqueda más frecuentes.

### Paso 4 — Configuración del pool de conexión
Creación de `backend/src/config/db.js` usando `pg.Pool` con verificación de conexión al arrancar el servidor (`pool.connect()`), evitando que el proceso quede vivo sin acceso a base de datos.

### Paso 5 — Carga de datos iniciales
Creación de `backend/database/seed_pictogramas.sql` con el catálogo estándar GHS (9 pictogramas), usando `ON CONFLICT DO NOTHING` para que el script sea idempotente.

### Paso 6 — Verificación
```bash
node -e "require('dotenv').config(); require('./src/config/db.js')"
```
Verificado localmente: conexión exitosa a PostgreSQL, 8 tablas creadas sin errores, 9 pictogramas insertados.

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| — | Ninguno registrado en este módulo | — | — | — | — |

## 5. Evidencia — historial de commits