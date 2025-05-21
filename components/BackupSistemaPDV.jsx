// components/BackupSistemaPDV.js
import { useState } from 'react';

export default function BackupSistemaPDV({ onBackupCreated }) {
  const [tipoBackup, setTipoBackup] = useState('completo');
  const [loading, setLoading] = useState(false);
  const [mensaje, setMensaje] = useState(null);
  const [error, setError] = useState(null);

  async function crearBackup() {
    setLoading(true);
    setMensaje(null);
    setError(null);

    try {
      const res = await fetch('/api/database/backup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ tipo: tipoBackup }),
      });

      if (!res.ok) {
        const data = await res.json();
        throw new Error(data.message || 'Error desconocido al crear backup');
      }

      const data = await res.json();
      setMensaje(data.message);

      // Notificar al padre para que recargue historial
      if (typeof onBackupCreated === 'function') {
        onBackupCreated();
      }
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-lg font-semibold mb-4">Crear Copia de Seguridad</h2>

      <label className="block mb-2 font-medium" htmlFor="tipoBackup">Tipo de Backup:</label>
      <select
        id="tipoBackup"
        value={tipoBackup}
        onChange={(e) => setTipoBackup(e.target.value)}
        className="mb-4 p-2 border rounded w-full"
      >
        <option value="completo">Completo</option>
        <option value="inventario">Inventario</option>
        <option value="ventas">Ventas</option>
      </select>

      <button
        onClick={crearBackup}
        disabled={loading}
        className={`w-full py-2 rounded text-white font-semibold ${loading ? 'bg-gray-400 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700'}`}
      >
        {loading ? 'Creando copia...' : 'Crear Copia de Seguridad'}
      </button>

      {mensaje && <p className="mt-4 text-green-600">{mensaje}</p>}
      {error && <p className="mt-4 text-red-600">{error}</p>}
    </div>
  );
}
