# Bitácora / Informe de Entrega — Módulo 0: Infraestructura y Configuración Base

**Estado:** 🔄 En curso (avance parcial — entrega intermedia)
**Rama de trabajo:** main
**Repositorio:** github.com/danielstivencanoserna-source/measurelab-proyecto-grado

## 1. Resumen ejecutivo

En este período se estableció la base del repositorio del proyecto Measurelab: inicialización de Git, conexión con el repositorio remoto en GitHub, estructura de documentación del proyecto (bitácoras, manual técnico, manual de usuario, documento académico) y el esqueleto inicial del backend (Node.js + Express). Durante el proceso se identificaron y corrigieron 3 incidentes reales de configuración, documentados aquí como evidencia del control de calidad aplicado desde el primer commit del proyecto.

## 2. Objetivo del módulo

Preparar la infraestructura técnica y documental necesaria para iniciar el desarrollo funcional del sistema: repositorio Git correctamente configurado, estructura de carpetas del monorepo, y servidor backend base operativo.

## 3. Avance paso a paso

### Paso 1 — Verificación de entorno
Confirmado: Git, Node.js y npm instalados y operativos en el equipo de desarrollo.

### Paso 2 — Creación del repositorio remoto
Repositorio creado en GitHub sin archivos iniciales (sin README/.gitignore automáticos), para evitar conflictos de merge en el primer push.

### Paso 3 — Inicialización del repositorio local
```bash
git init
git remote add origin https://github.com/.../measurelab-proyecto-grado.git
git branch -M main
```

### Paso 4 — Primer commit (README + .gitignore)
Ver **Incidente #1**.

### Paso 5 — Estructura de documentación (`docs/`)
Se crearon `docs/academico`, `docs/manual-tecnico`, `docs/manual-usuario`, `docs/bitacoras`, con el índice de roadmap de módulos en `docs/bitacoras/README.md`.
Ver **Incidente #2**.

### Paso 6 — Inicialización del backend
`npm init -y` + `npm install express` + servidor base (`src/server.js`) con ruta de prueba `GET /`, verificado localmente en `http://localhost:3001`.
Ver **Incidente #3**. Commit de este paso **pendiente de cerrar** (ver sección 6).

## 4. Incidentes técnicos — causa raíz y solución

| # | Incidente | Causa raíz | Severidad | Solución | Commit |
|---|---|---|---|---|---|
| 1 | Primer commit (`.gitignore`, `README.md`) quedó vacío (0 insertions) | Contenido no guardado en disco antes del `git add` | Alta | Commit correctivo con el contenido real | `6edd527` |
| 2 | `mkdir docs\bitacoras` (y similares) crearon carpetas planas (`docsbitacoras/`) en la raíz en vez de anidadas dentro de `docs/` | `\` se interpreta como carácter de escape en Git Bash (MINGW64), no como separador de ruta como en PowerShell/CMD | Media | `mkdir -p` con `/`, `mv` del archivo real, `rmdir` de las carpetas mal creadas | `7297196` |
| 3 | `cd ..` sacó de la raíz del repositorio hacia la carpeta de usuario de Windows, rompiendo comandos `git` posteriores | Cada terminal nueva inicia en su propio directorio; no se verificó con `pwd` antes de operar | Baja | Verificación explícita con `pwd` antes de cada operación sensible | N/A |

## 5. Evidencia — historial de commits

## 6. Pendientes inmediatos
- [ ] Confirmar `git status` limpio (sin `node_modules/`) y cerrar commit `feat: inicializa backend con Express y servidor base`
- [ ] Push del backend a `origin/main`
- [ ] Paso 7: variables de entorno (`.env`) y conexión a PostgreSQL

## 7. Lecciones aprendidas

- La verificación explícita (`pwd`, `git status`, `git diff`) antes de asumir el estado del sistema evitó que el Incidente #2 se propagara al historial remoto sin detectarse.
- Las advertencias de Git sobre CRLF/LF no son errores bloqueantes — distinguir severidad real evita decisiones apresuradas.
- Un commit ya subido (`push`) a un remoto se corrige hacia adelante con un commit nuevo, no reescribiendo historia con `--amend --force`, salvo justificación clara.