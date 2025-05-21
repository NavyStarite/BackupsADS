// pages/admin/backup.js
import { useState, useEffect } from 'react';
import Head from 'next/head';
import BackupSistemaPDV from '../../components/BackupSistemaPDV';

export default function BackupPage() {
  const [backupHistory, setBackupHistory] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Función para cargar el historial de copias de seguridad
    async function loadBackupHistory() {
      try {
        setLoading(true);
        const response = await fetch('/api/database/backup-history');
        
        if (response.ok) {
          const data = await response.json();
          setBackupHistory(data.history);
        } else {
          console.error('Error al cargar el historial de copias de seguridad');
        }
      } catch (error) {
        console.error('Error:', error);
      } finally {
        setLoading(false);
      }
    }

    loadBackupHistory();
  }, []);

  return (
    <div className="bg-gray-50 min-h-screen">
      <Head>
        <title>Copias de Seguridad | Sistema Punto de Venta</title>
        <meta name="description" content="Gestión de copias de seguridad del Sistema Punto de Venta" />
      </Head>

      <div className="max-w-5xl mx-auto py-8 px-4">
        <h1 className="text-2xl font-bold text-gray-800 mb-6">Gestión de Copias de Seguridad</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Panel principal de backup */}
          <div className="md:col-span-2">
            <BackupSistemaPDV />
          </div>
          
          {/* Panel de información */}
          <div className="bg-white rounded-lg shadow-md p-6">
            <h2 className="text-lg font-semibold text-gray-800 mb-4">Información</h2>
            
            <div className="space-y-4 text-sm">
              <div>
                <h3 className="font-medium text-gray-700">Backup Completo</h3>
                <p className="text-gray-600">Incluye todas las tablas de la base de datos PuntoDeVenta.</p>
              </div>
              
              <div>
                <h3 className="font-medium text-gray-700">Backup de Inventario</h3>
                <p className="text-gray-600">Incluye solo las tablas: Productos, Promos y ProductoPromo.</p>
              </div>
              
              <div>
                <h3 className="font-medium text-gray-700">Backup de Ventas</h3>
                <p className="text-gray-600">Incluye las tablas: Ventas, DetalleVentas, Devoluciones, Facturas, Clientes, Creditos y AbonosCredito.</p>
              </div>
            </div>
          </div>
          
          {/* Historial de backups */}
          <div className="md:col-span-3">
            <div className="bg-white rounded-lg shadow-md p-6">
              <h2 className="text-lg font-semibold text-gray-800 mb-4">Historial de Copias de Seguridad</h2>
              
              {loading ? (
                <p className="text-gray-500 text-center py-4">Cargando historial...</p>
              ) : backupHistory.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-gray-200">
                    <thead>
                      <tr>
                        <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Archivo</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tipo</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tamaño</th>
                      </tr>
                    </thead>
                    <tbody className="bg-white divide-y divide-gray-200">
                      {backupHistory.map((backup, index) => (
                        <tr key={index} className="hover:bg-gray-50">
                          <td className="px-4 py-3 text-sm text-gray-900">{backup.filename}</td>
                          <td className="px-4 py-3 text-sm text-gray-900 capitalize">{backup.type}</td>
                          <td className="px-4 py-3 text-sm text-gray-900">{new Date(backup.date).toLocaleString()}</td>
                          <td className="px-4 py-3 text-sm text-gray-900">{(backup.size / 1024).toFixed(2)} KB</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <p className="text-gray-500 text-center py-4">No hay copias de seguridad disponibles.</p>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}