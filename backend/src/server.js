// server.js — punto de entrada del backend
// Aqui arranca todo: se crea la app de Express y se pone a escuchar peticiones.

const express = require('express');   // trae el framework instalado en el paso 6.3
const app = express();                 // crea la aplicacion — un objeto que sabe manejar peticiones HTTP

const PORT = 3001;                     // puerto donde el servidor va a escuchar

// Ruta de prueba: cuando alguien visite "/", responde con JSON
app.get('/', (req, res) => {
  res.json({ mensaje: 'Measurelab API funcionando' });
});

// Pone el servidor a escuchar. El callback se ejecuta UNA VEZ, cuando ya esta listo.
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
