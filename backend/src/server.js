// server.js — punto de entrada del backend
require('dotenv').config({ quiet: true });
const express = require('express');
const cookieParser = require('cookie-parser');
const authRoutes = require('./routes/auth.routes');

const app = express();
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