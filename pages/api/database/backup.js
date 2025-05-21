// api/database/backup.js

const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');
const mysql = require('mysql2/promise');
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

  try {
    // Extrae el tipo de backup solicitado
    const { tipo = 'completo' } = req.body;
    
    // Generar nombre de archivo con fecha y hora
    const date = new Date();
    const timestamp = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}_${String(date.getHours()).padStart(2, '0')}-${String(date.getMinutes()).padStart(2, '0')}`;
    const filename = `PuntoDeVenta_${tipo}_${timestamp}.sql`;
    const filePath = path.join(backupDir, filename);
    
    // Determinar las tablas a incluir según el tipo de backup
    let tables = [];
    switch (tipo) {
      case 'inventario':
        tables = ['Productos', 'Promos', 'ProductoPromo'];
        break;
      case 'ventas':
        tables = ['Ventas', 'DetalleVentas', 'Devoluciones', 'Facturas', 'Clientes', 'Creditos', 'AbonosCredito'];
        break;
      case 'completo':
      default:
        // Todas las tablas
        tables = []; // Vacío significa todas las tablas
        break;
    }
    
    // Construir el comando de mysqldump
    let backupCommand;
    if (tables.length === 0) {
      // Backup completo de todas las tablas
      backupCommand = `mysqldump -h ${config.host} -u ${config.user} -p${config.password} ${config.database} > ${filePath}`;
    } else {
      // Backup de tablas específicas
      backupCommand = `mysqldump -h ${config.host} -u ${config.user} -p${config.password} ${config.database} ${tables.join(' ')} > ${filePath}`;
    }
    
    console.log(`Iniciando backup ${tipo} de la base de datos PuntoDeVenta en ${filePath}`);
    
    // Registrar este backup en un archivo de logs
    const logDir = path.join(process.cwd(), 'logs');
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    
    const logEntry = `${new Date().toISOString()} - Backup ${tipo} generado: ${filename}\n`;
    fs.appendFileSync(path.join(logDir, 'backup_history.log'), logEntry);
    
    exec(backupCommand, async (error, stdout, stderr) => {
      if (error) {
        console.error(`Error al ejecutar mysqldump: ${error.message}`);
        return res.status(500).json({ message: 'Error al crear la copia de seguridad' });
      }
      
      if (stderr && !stderr.includes('Warning')) {
        console.error(`mysqldump stderr: ${stderr}`);
      }
      
      // Verificar que el archivo se haya creado correctamente
      if (!fs.existsSync(filePath)) {
        return res.status(500).json({ message: 'El archivo de respaldo no se generó correctamente' });
      }
      
      // Si el backup es diario programado, registrarlo en la tabla de Reportes
      if (req.body.isScheduled) {
        try {
          const connection = await mysql.createConnection(config);
          
          // Registrar el backup como un reporte de tipo "Corte_Caja"
          await connection.execute(
            'INSERT INTO Reportes (Tipo, PeriodoIni, PeriodoFin, RutaPDF, IdUsuario, FechaGen) VALUES (?, CURDATE(), CURDATE(), ?, ?, NOW())',
            ['Corte_Caja', filePath, req.body.userId || 1] // Usa el ID de usuario proporcionado o 1 como predeterminado
          );
          
          await connection.end();
        } catch (dbError) {
          console.error('Error al registrar el backup en la base de datos:', dbError);
          // Continuamos aunque falle el registro en la BD
        }
      }
      
      // Si el cliente espera una descarga directa
      if (req.body.download) {
        res.setHeader('Content-Type', 'application/sql');
        res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
        
        const fileStream = fs.createReadStream(filePath);
        fileStream.pipe(res);
      } else {
        // Devolver información sobre el backup creado
        return res.status(200).json({ 
          message: 'Copia de seguridad creada con éxito', 
          tipo: tipo,
          filename: filename,
          path: filePath.replace(process.cwd(), ''),
          timestamp: new Date().toISOString(),
          size: fs.statSync(filePath).size
        });
      }
    });
  } catch (error) {
    console.error('Error al crear la copia de seguridad:', error);
    return res.status(500).json({ 
      message: 'Error interno del servidor al crear la copia de seguridad',
      error: error.message 
    });
  }
}