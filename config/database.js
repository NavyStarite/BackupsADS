// config/database.js
module.exports = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',        // Cambia esto por tu usuario
    password: process.env.DB_PASSWORD || '',    // Cambia esto por tu contraseña
    database: process.env.DB_NAME || 'PuntoDeVenta',
    port: process.env.DB_PORT || 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  };