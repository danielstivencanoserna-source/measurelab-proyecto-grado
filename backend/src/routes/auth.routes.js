// routes/auth.routes.js
const express = require('express');
const router = express.Router();
const AuthController = require('../controllers/auth.controller');
const { autenticar } = require('../middlewares/auth.middleware');

router.post('/registro', AuthController.registro);
router.post('/login', AuthController.login);
router.post('/refresh', AuthController.refresh);
router.post('/logout', AuthController.logout);
router.get('/me', autenticar, AuthController.me);

module.exports = router;