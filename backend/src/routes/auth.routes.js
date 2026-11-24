// routes/auth.routes.js
// Solo define las URLs y qué controller las maneja.
// No tiene lógica de negocio.

const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const AuthController = require('../controllers/auth.controller');
const { autenticar } = require('../middlewares/auth.middleware');

// Límite de intentos en el login: 5 intentos FALLIDOS por IP cada 15 minutos.
// Los inicios de sesión exitosos no cuentan.
const limitadorLogin = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 5,
  skipSuccessfulRequests: true,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Demasiados intentos fallidos. Intenta de nuevo en 15 minutos.' },
});

// Rutas públicas (no requieren token)
router.post('/registro', AuthController.registro);
router.post('/login', limitadorLogin, AuthController.login);
router.post('/refresh', AuthController.refresh);
router.post('/logout', AuthController.logout);

// Ruta protegida (requiere token válido)
router.get('/me', autenticar, AuthController.me);

module.exports = router;