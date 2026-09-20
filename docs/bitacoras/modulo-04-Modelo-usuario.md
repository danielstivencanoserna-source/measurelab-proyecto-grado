# Bitácora / Informe de Entrega — Módulo 4: Modelo de Usuarios

**Estado:** ✅ Cerrado
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

Esta quincena se dedicó a reconstruir y verificar `src/models/usuario.model.js`, detectado vacío en la auditoría del Módulo 3 pese a estar comiteado desde el Módulo 2. Durante la verificación se descubrió un hallazgo más grave: la base de datos `measurelab_db` nunca había sido creada en el motor PostgreSQL local, pese a que el Módulo 1 (base de datos) se había dado por cerrado. Se corrigió creando la base de datos, ejecutando el esquema y el seed pendientes desde entonces, y se validó el modelo con una batería de 6 pruebas reales contra datos persistidos.

## 2. Objetivo del módulo

Dejar `usuario.model.js` funcional y verificado end-to-end, y sanear cualquier brecha entre lo documentado como "cerrado" en módulos anteriores y el estado real del sistema.

## 3. Avance paso a paso

### Paso 1 — Auditoría inicial
`wc -l src/models/usuario.model.js` confirmó 0 líneas — archivo vacío pese al commit `0d0b2e3` del Módulo 2.

### Paso 2 — Reconstrucción del archivo
Se pegó y guardó el contenido completo del modelo (`findByEmail`, `findById`, `create`, `findAll`, `deactivate`), verificando la pestaña activa de VS Code antes de pegar, como medida preventiva tras los incidentes de sobreescritura de la quincena anterior.

### Paso 3 — Intento de prueba real — fallo inesperado
Al ejecutar un script de prueba contra el modelo, PostgreSQL respondió `no existe la base de datos "measurelab_db"`.

### Paso 4 — Diagnóstico y corrección de la base de datos
Verificación con `psql -l` (vía SQL Shell, ya que `psql` no estaba en el PATH de Windows) confirmó que solo existían las bases del sistema (`postgres`, `template0`, `template1`). Se creó `measurelab_db` y se ejecutaron `schema.sql` (8 tablas, 1 función, 2 triggers, 5 índices) y `seed_pictogramas.sql` (9 registros), ambos sin errores.

### Paso 5 — Verificación end-to-end
Ejecución de 6 pruebas reales contra la base de datos ya creada: creación de usuario, verificación de exposición controlada de `password_hash` según el método usado, listado, y borrado lógico con confirmación de que el usuario desactivado no vuelve a aparecer en `findByEmail`.

### Paso 6 — Limpieza y commit
Eliminación del script de prueba temporal (nunca comiteado) y commit del modelo verificado.

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| 1 | `usuario.model.js` vacío pese a estar comiteado desde el Módulo 2 | Contenido no guardado antes del `git add` original (patrón recurrente, ya documentado en incidentes previos) | Alta | Reconstrucción y verificación con `wc -l` antes de comitear | `d146b0e` |
| 2 | La base de datos `measurelab_db` nunca existió en PostgreSQL, pese a que el Módulo 1 se documentó como cerrado | El esquema y el seed se construyeron y revisaron como archivos, pero nunca se ejecutó una prueba real de conexión/consulta contra una base de datos existente en esa quincena | Alta — invalidaba la base de todos los módulos funcionales posteriores | Creación de la base de datos vía SQL Shell (psql), ejecución de `schema.sql` y `seed_pictogramas.sql` | N/A (corrección de infraestructura, no de código versionado) |

## 5. Evidencia — historial de commits

\`\`\`
d146b0e feat(usuarios): modelo de acceso a datos con borrado logico, verificado end-to-end
f227286 docs: agrega trabajo escrito y bitacora tecnica del modulo 3 (variables de entorno)
065b844 fix(auth): agrega scripts dev/start, variables JWT y conexion de rutas en server.js (correcciones pendientes del modulo 2)
\`\`\`

## 6. Pendientes inmediatos

- [ ] Quincena 5: reconstrucción y verificación de `src/middlewares/auth.middleware.js`

## 7. Lecciones aprendidas

- Un módulo documentado como "cerrado" puede ocultar una brecha de infraestructura si el cierre se basó en revisar archivos en vez de ejecutar una prueba real contra el sistema completo. La prueba end-to-end de esta quincena no solo validó el modelo — también destapó que la base de datos nunca se había creado.
- Cuando una herramienta de línea de comandos (`psql`) no está en el PATH, usar la alternativa ya instalada (SQL Shell) es preferible a perder tiempo configurando el entorno a mitad de una verificación — el ajuste de PATH puede resolverse después, sin bloquear el avance.