// pages/_app.js
import '../styles/globals.css';
import { useEffect } from 'react';

function MyApp({ Component, pageProps }) {
  useEffect(() => {
    // Solo inicializar el programador de backups en modo producción y del lado del servidor
    if (typeof window === 'undefined' && process.env.NODE_ENV === 'production') {
      // Import dinámico para evitar errores en el lado del cliente
      import('../utils/backupScheduler').then(({ initBackupScheduler }) => {
        initBackupScheduler({
          scheduleTime: '0 1 * * *', // Cada día a la 1 AM
          backupType: 'completo',
          userId: 1 // ID del usuario administrador
        });
        console.log('Programador de backups inicializado');
      });
    }
  }, []);

  return <Component {...pageProps} />;
}

export default MyApp;