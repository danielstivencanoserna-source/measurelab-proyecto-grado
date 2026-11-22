✅ PostgreSQL conectado correctamente

=== registro ===
✅ R1. Datos válidos → 201 y la respuesta no incluye la contraseña
✅ R1b. En la base de datos la contraseña está hasheada con bcrypt (cost 12), no en texto plano
✅ R2. Correo duplicado → 409
✅ R3. Contraseña de menos de 8 caracteres → 400 con el detalle del error
✅ R4. Rol inexistente → 400
✅ R5. Correo con formato inválido → 400
✅ R6. Sin indicar rol, se asigna "analista" por defecto

=== login ===
✅ L1. Credenciales correctas → 200, access token y usuario sin contraseña
✅ L2. El refresh token viaja en cookie httpOnly, sameSite strict, de 7 días
✅ L3. El access token lleva id, email y rol, nunca la contraseña, y dura 15 minutos
✅ L4. Contraseña incorrecta → 401 "Credenciales incorrectas"
✅ L5. Correo inexistente → mismo 401 y mismo mensaje que la contraseña incorrecta
✅ L6. Falta la contraseña → 400

=== refresh ===
✅ F1. Cookie válida → 200 y un access token nuevo, válido y del mismo usuario
✅ F2. Sin cookie → 401 "No hay refresh token"
✅ F3. Cookie falsa → 401
✅ F4. Un access token no sirve como refresh token → 401 (secretos distintos)

=== logout y me ===
✅ O1. Logout limpia la cookie refreshToken y confirma la sesión cerrada
✅ O2. me devuelve el usuario que el middleware dejó en req.usuario

=== integración con el middleware del Módulo 5 ===
✅ I1. El access token emitido por login es aceptado por autenticar
✅ I2. El refresh token NO es aceptado por autenticar como si fuera un access token

=== usuario desactivado ===
✅ D1. Usuario desactivado con la contraseña correcta → 401 en login
✅ D2. Refresh token todavía vigente de un usuario desactivado → 401

=== observaciones (no cuentan como pasadas ni falladas) ===
ℹ️  Registro sin cuerpo (req.body sin definir) → HTTP 500: {"error":"Error interno del servidor"}
ℹ️  Login sin cuerpo (req.body sin definir)    → HTTP 500: {"error":"Error interno del servidor"}
ℹ️  Registro público pidiendo rol "admin"       → HTTP 201, rol asignado: admin

Resultado: 23 pasadas, 0 falladas