// server.js — punto de entrada del backend
require('dotenv').config({ quiet: true });
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');
const authRoutes = require('./routes/auth.routes');

const app = express();

// Cabeceras de seguridad HTTP: quita X-Powered-By y agrega CSP, HSTS, nosniff, etc.
app.use(helmet());

// CORS: solo el frontend configurado puede llamar a la API desde un navegador.
// credentials: true permite que viaje la cookie del refresh token.
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
  credentials: true,
}));

// Registro de cada petición en consola: método, ruta, estado y tiempo.
app.use(morgan('dev'));

app.use(express.json());
app.use(cookieParser());

const PORT = process.env.PORT || 3001;

app.get('/', (req, res) => {
  res.json({ mensaje: 'Measurelab API funcionando' });
});

app.use('/api/auth', authRoutes);

app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});