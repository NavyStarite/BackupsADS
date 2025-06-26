
# 💻 Punto de Venta con Backups Automáticos

Este proyecto es un sistema de punto de venta (PDV) desarrollado con **Next.js**, **React**, **MySQL** y **Tailwind CSS**, que incluye funcionalidades de **respaldo automático de base de datos**, **historial de copias de seguridad**, y una **interfaz administrativa** para la gestión de las mismas.

---

## 🚀 Requisitos

- Node.js (v18+ recomendado)
- XAMPP (MySQL debe estar corriendo)
- Git

---

## ⚙️ Instalación

1. **Clona el repositorio:**

```bash
git [https://github.com/NavyStarite/BackupsADS/tree/master](https://github.com/NavyStarite/BackupsADS/tree/master)
cd BackupsADS
````

2. **Instala las dependencias:**

```bash
npm install
```

3. **Configura el entorno:**

Crea un archivo `.env.local` en la raíz del proyecto basado en el archivo de ejemplo:

```bash
cp .env.example .env.local
```

Edita `.env.local` y ajusta tus variables de entorno:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=           # tu contraseña de MySQL en XAMPP
DB_NAME=PuntoDeVenta
DB_PORT=3306
```

4. **Asegúrate de tener MySQL corriendo desde XAMPP.**

5. **Importa la base de datos antes de iniciar la app:**

[Repositorio de la base de datos](https://github.com/Angel3304/PuntoDeVenta/tree/main)

---

## ▶️ Ejecución

```bash
npm run dev
```

Esto iniciará la aplicación en modo desarrollo. Accede desde tu navegador en:

```
http://localhost:3000
```

---

## 🗃 Backups

El sistema genera automáticamente archivos `.sql` de respaldo de la base de datos en la carpeta `/backups`.

### Para que funcione el backup necesitas:

* Tener instalado `mysqldump` (viene con MySQL de XAMPP)
* Asegúrate de que `mysqldump` esté en el **PATH del sistema**

Ejemplo de salida:

```
backups/
├── PuntoDeVenta_completo_2025-05-22_17-06.sql
├── PuntoDeVenta_ventas_2025-05-22_17-02.sql
└── ...
```

---

