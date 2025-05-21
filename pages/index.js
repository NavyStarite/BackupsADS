// pages/index.js
import Head from 'next/head';
import Link from 'next/link';

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Head>
        <title>Sistema Punto de Venta</title>
        <meta name="description" content="Sistema de Punto de Venta" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className="max-w-5xl mx-auto py-16 px-4">
        <h1 className="text-3xl font-bold text-center mb-8">Sistema de Punto de Venta</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Link href="/admin/backup" className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
            <h2 className="text-xl font-semibold mb-2">Copias de Seguridad</h2>
            <p className="text-gray-600">Administra las copias de seguridad de la base de datos</p>
          </Link>
          
          {/* Aquí puedes añadir más enlaces a otras secciones del sistema */}
        </div>
      </main>
    </div>
  );
}