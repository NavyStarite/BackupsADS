const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const config = require('../../../config/database');

// Crear directorio para backups si no existe
const backupDir = path.join(process.cwd(), 'backups');
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ message: 'Método no permitido' });
  }

  const { tipo } = req.body;
  const database = config.database;
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  let filename = `PuntoDeVenta_${tipo}_${timestamp}.sql`;
  let tablas = '';

  switch (tipo) {
    case 'completo':
      filename = `PuntoDeVenta_completo_${timestamp}.sql`;
      tablas = ''; // Todas las tablas
      break;
    case 'ventas':
      filename = `PuntoDeVenta_ventas_${timestamp}.sql`;
      tablas = 'Ventas DetalleVentas';
      break;
    case 'inventario':
      filename = `PuntoDeVenta_inventario_${timestamp}.sql`;
      tablas = 'Productos Promos ProductoPromo';
      break;
    default:
      return res.status(400).json({ message: 'Tipo de backup no válido' });
  }

  const filePath = path.join(backupDir, filename);
  console.log(`Iniciando backup ${tipo} de la base de datos ${database} en ${filePath}`);

  // 👉 Comando modificado para evitar prompt de contraseña
  const command = `echo ${config.password} | mysqldump -h ${config.host} -u ${config.user} --password=${config.password} ${database} ${tablas} > "${filePath}"`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error('Error al ejecutar mysqldump:', error.message);
      return res.status(500).json({ message: 'Error al realizar el backup', error: error.message });
    }
    return res.status(200).json({ message: 'Backup completado con éxito', filename });
  });
}
