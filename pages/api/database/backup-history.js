// pages/api/database/backup-history.js
const fs = require('fs');
const path = require('path');

export default function handler(req, res) {
  try {
    const backupDir = path.join(process.cwd(), 'backups');
    if (!fs.existsSync(backupDir)) {
      return res.status(200).json({ history: [] });
    }

    // Leer archivos en el directorio de backups
    const files = fs.readdirSync(backupDir)
      .filter(file => file.endsWith('.sql'))
      .map(file => {
        const stats = fs.statSync(path.join(backupDir, file));
        const fileInfo = file.split('_');
        return {
          filename: file,
          type: fileInfo[1] || 'completo',
          date: stats.mtime,
          size: stats.size
        };
      })
      .sort((a, b) => b.date - a.date); // Ordenar por fecha, más reciente primero

    return res.status(200).json({ history: files });
  } catch (error) {
    console.error('Error al leer historial de backups:', error);
    return res.status(500).json({ message: 'Error al obtener historial de backups' });
  }
}