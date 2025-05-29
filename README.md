
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

Desde **phpMyAdmin** o consola de MySQL:

```sql
-- Crea y selecciona la base de datos
create database PuntoDeVenta;
use PuntoDeVenta;

create table Usuarios(
	IdUsuario int auto_increment primary key,
	Rol varchar (20) not null,
    Nombre varchar (50) unique not null,
    contraseña varchar (255) not null,
    Estado boolean default true,
    UltimoInicioSesion datetime,
    IntentosFallidos int default 0
);

create table Productos(
	CodigoBarras varchar(50) primary key,
    Nombre varchar(100) not null,
    Marca varchar(50) not null,
    Presentacion varchar(50) not null,
    Proveedor varchar(50) not null,
    PrecioVenta decimal(10,2) not null,
    Costo decimal(10,2) not null,
    Categoria varchar(50) not null,
    Cantidad int not null,
    Estado boolean default true
);

create table Promos(
	IdPromo int auto_increment primary key,
    M tinyint unsigned not null,
    N tinyint unsigned not null,
    FechaInicio date,
    FechaFin date,
    Descripcion varchar (100),
    Estado boolean default true
);

create table ProductoPromo(
	CodigoBarras varchar(50) not null,
    IdPromo int not null,
    primary key(CodigoBarras,IdPromo),
    foreign key(CodigoBarras) references Productos(CodigoBarras),
    foreign key(IdPromo) references Promos(IdPromo)
);

create table Clientes(
	IdCliente int auto_increment primary key,
    NombreCompleto varchar (255) not null,
    Celular varchar (20) unique,
    RFC varchar (20)
);

create table Creditos(
	IdCredito int auto_increment primary key,
    IdCliente int not null,
    MontoCredito decimal(10,2) not null,
    SaldoPendiente decimal(10,2) not null,
    Fecha date not null,
    Estado enum('Activo','Liquidado','Rechazado') default 'Activo',
    foreign key (IdCliente) references Clientes (IdCliente)
);

create table AbonosCredito(
	IdAbono int auto_increment primary key,
    IdCredito int not null,
    Monto decimal(10,2) not null,
    FechaAbono datetime not null,
    foreign key (IdCredito) references Creditos (IdCredito)
    );

create table Ventas(
	IdVenta int auto_increment primary key,
    IdCajero int,
    FechaHora datetime not null,
    MetodoPago enum('Efectivo','Tarjeta','Credito') not null,
    TotalVenta decimal(10,2) not null,
    foreign key (IdCajero) references Usuarios(IdUsuario)
);

create table DetalleVentas(
	IdDetalle int auto_increment primary key,
    IdVenta int not null,
    CodigoBarras varchar(50) not null,
    Cantidad int not null,
    PrecioUnitario decimal(10,2) not null,
    Importe decimal(10,2) not null,
    foreign key (IdVenta) references Ventas(IdVenta),
    foreign key (CodigoBarras) references Productos(CodigoBarras)
);

create table Devoluciones(
	IdDevolucion int auto_increment primary key,
    IdDetalle int not null,
    CantidadDevuelta int not null,
    Fecha datetime not null,
    Motivo varchar (255),
    foreign key (IdDetalle) references DetalleVentas (IdDetalle)
    );
    
create table Facturas(
	IdFacturas int auto_increment primary key,
    IdVenta int,
    IdCliente int,
    RazonSocial varchar(255),
    FechaEmision datetime not null,
    foreign key (IdVenta) references Ventas (IdVenta),
    foreign key (IdCliente) references Clientes(IdCliente)
);

create table Reportes (
	IdReporte int auto_increment primary key,
    Tipo enum('Quincenal','Mensual','Trimestral','Predictivo','Corte_Caja') not null,
    Periodoini date not null,
    PeriodoFin date not null,
    RutaPDF varchar(255),
    IdUsuario int not null,
    FechaGen datetime not null,
    foreign key (IdUsuario) references Usuarios (IdUsuario)
    );
    
DELIMITER //


-- ---------------------------------------------------USUARIOS--------------------------------------------------------------------------------------
-- Crear usuario
create procedure CrearUsuario(
	in p_Rol varchar(20),
    in p_Nombre varchar(50),
    in p_Contraseña varchar(255)
)begin
	insert into Usuarios (Rol, Nombre, Contraseña, Estado, IntentosFallidos, UltimoInicioSesion)
    values (p_rol, p_nombre,p_contraseña,true,0,null);
end
//

-- Obtener usuarios activos
create procedure ObtenerUsuariosActivos()
begin
    select IdUsuario, Rol, Nombre, Estado, UltimoInicioSesion, IntentosFallidos
    from Usuarios
    where Estado = true;
end //

-- Mostrar empleado por ID
create procedure ObtenerUsuarioId(
	in p_UsuarioId int 
)
begin
		select IdUsuario, Rol, Nombre, Estado, UltimoInicioSesion, IntentosFallidos
        from Usuarios
        where IdUsuario = p_IdUsuario;
end//

-- Actualizar Usuario
create procedure ActualizarUsuario(
	in p_IdUsuario INT,
    in p_Rol varchar(20),
    in p_Nombre varchar(50),
    in p_Contraseña varchar(255) -- Se espera que ya venga hasheada si es un cambio
)
begin
	Update Usuarios
    set
		Rol=p_Rol,
        Nombre = p_Nombre,
        Contraseña = p_Contraseña
    WHERE IdUsuario = p_IdUsuario;
end //

-- Actualizar el Ultimo inicio de sesion y los intentos fallidos
create procedure ActualizarLoginUsuario(
    in p_Nombre varchar(50),
    in p_EsExitoso boolean
)
begin
    if p_EsExitoso then
        update Usuarios
        set
            UltimoInicioSesion = NOW(),
            IntentosFallidos = 0
        where Nombre = p_Nombre;
    else
        update Usuarios
        set
            IntentosFallidos = IntentosFallidos + 1
        where Nombre = p_Nombre;
    end if;
end //

-- Actualizar estado de usuario 
CREATE PROCEDURE SP_DesactivarUsuario(
    IN p_IdUsuario INT
)
BEGIN
    UPDATE Usuarios
    SET Estado = FALSE
    WHERE IdUsuario = p_IdUsuario;
END //

-- Activar Usuario (desbloquear)
CREATE PROCEDURE ActivarUsuario(
    IN p_IdUsuario INT
)
BEGIN
    UPDATE Usuarios
    SET Estado = TRUE, IntentosFallidos = 0
    WHERE IdUsuario = p_IdUsuario;
END //
-- ---------------------------------------------------PRODUCTOS--------------------------------------------------------------------------------------

-- Crear Producto
CREATE PROCEDURE SP_CrearProducto(
    IN p_CodigoBarras VARCHAR(50),
    IN p_Nombre VARCHAR(100),
    IN p_Marca VARCHAR(50),
    IN p_Presentacion VARCHAR(50),
    IN p_Proveedor VARCHAR(50),
    IN p_PrecioVenta DECIMAL(10,2),
    IN p_Costo DECIMAL(10,2),
    IN p_Categoria VARCHAR(50),
    IN p_Cantidad INT
)
BEGIN
    INSERT INTO Productos (CodigoBarras, Nombre, Marca, Presentacion, Proveedor, PrecioVenta, Costo, Categoria, Cantidad, Estado)
    VALUES (p_CodigoBarras, p_Nombre, p_Marca, p_Presentacion, p_Proveedor, p_PrecioVenta, p_Costo, p_Categoria, p_Cantidad, TRUE);
END //

-- Obtener Productos (todos los activos)
CREATE PROCEDURE ObtenerProductosActivos()
BEGIN
    SELECT CodigoBarras, Nombre, Marca, Presentacion, Proveedor, PrecioVenta, Costo, Categoria, Cantidad, Estado
    FROM Productos
    WHERE Estado = TRUE;
END //

-- Obtener Producto por Código de Barras
CREATE PROCEDURE SP_ObtenerProductoPorCodigoBarras(
    IN p_CodigoBarras VARCHAR(50)
)
BEGIN
    SELECT CodigoBarras, Nombre, Marca, Presentacion, Proveedor, PrecioVenta, Costo, Categoria, Cantidad, Estado
    FROM Productos
    WHERE CodigoBarras = p_CodigoBarras;
END //

-- Actualizar Producto (todos los campos excepto CodigoBarras)
CREATE PROCEDURE ActualizarProducto(
    IN p_CodigoBarras VARCHAR(50),
    IN p_Nombre VARCHAR(100),
    IN p_Marca VARCHAR(50),
    IN p_Presentacion VARCHAR(50),
    IN p_Proveedor VARCHAR(50),
    IN p_PrecioVenta DECIMAL(10,2),
    IN p_Costo DECIMAL(10,2),
    IN p_Categoria VARCHAR(50),
    IN p_Cantidad INT
)
BEGIN
    UPDATE Productos
    SET
        Nombre = p_Nombre,
        Marca = p_Marca,
        Presentacion = p_Presentacion,
        Proveedor = p_Proveedor,
        PrecioVenta = p_PrecioVenta,
        Costo = p_Costo,
        Categoria = p_Categoria,
        Cantidad = p_Cantidad
    WHERE CodigoBarras = p_CodigoBarras;
END //

-- Actualizar Cantidad de Producto (para ventas/devoluciones/entradas)
CREATE PROCEDURE ActualizarCantidadProducto(
    IN p_CodigoBarras VARCHAR(50),
    IN p_CantidadCambio INT -- Puede ser positivo para entradas, negativo para ventas/salidas
)
BEGIN
    UPDATE Productos
    SET Cantidad = Cantidad + p_CantidadCambio
    WHERE CodigoBarras = p_CodigoBarras;
END //

-- Dar de baja un producto (Borrado Lógico)
CREATE PROCEDURE DesactivarProducto(
    IN p_CodigoBarras VARCHAR(50)
)
BEGIN
    UPDATE Productos
    SET Estado = FALSE
    WHERE CodigoBarras = p_CodigoBarras;
END //
-- ---------------------------------------------------PROMOS--------------------------------------------------------------------------------------

-- Crear Promoción (para 2x1, 3x2, MxN)
CREATE PROCEDURE CrearPromo(
    IN p_M TINYINT UNSIGNED,
    IN p_N TINYINT UNSIGNED,
    IN p_FechaInicio DATE,
    IN p_FechaFin DATE,
    IN p_Descripcion VARCHAR(100)
)
BEGIN
    INSERT INTO Promos (M, N, FechaInicio, FechaFin, Descripcion, Estado)
    VALUES (p_M, p_N, p_FechaInicio, p_FechaFin, p_Descripcion, TRUE);
END //

-- Leer Promociones (obtener todas las activas y vigentes)
CREATE PROCEDURE ObtenerPromosActivas()
BEGIN
    SELECT IdPromo, M, N, FechaInicio, FechaFin, Descripcion, Estado
    FROM Promos
    WHERE Estado = TRUE AND FechaFin >= CURDATE();
END //

-- Leer Promoción por ID
CREATE PROCEDURE ObtenerPromoPorId(
    IN p_IdPromo INT
)
BEGIN
    SELECT IdPromo, M, N, FechaInicio, FechaFin, Descripcion, Estado
    FROM Promos
    WHERE IdPromo = p_IdPromo;
END //

-- Actualizar Promoción (modificar detalles de una promoción existente)
CREATE PROCEDURE ActualizarPromo(
    IN p_IdPromo INT,
    IN p_M TINYINT UNSIGNED,
    IN p_N TINYINT UNSIGNED,
    IN p_FechaInicio DATE,
    IN p_FechaFin DATE,
    IN p_Descripcion VARCHAR(100)
)
BEGIN
    UPDATE Promos
    SET
        M = p_M,
        N = p_N,
        FechaInicio = p_FechaInicio,
        FechaFin = p_FechaFin,
        Descripcion = p_Descripcion
    WHERE IdPromo = p_IdPromo;
END //

-- Desactivar Promoción (Borrado Lógico)
CREATE PROCEDURE DesactivarPromo(
    IN p_IdPromo INT
)
BEGIN
    UPDATE Promos
    SET Estado = FALSE
    WHERE IdPromo = p_IdPromo;
END //

-- Activar Promoción
CREATE PROCEDURE ActivarPromo(
    IN p_IdPromo INT
)
BEGIN
    UPDATE Promos
    SET Estado = TRUE
    WHERE IdPromo = p_IdPromo;
END //
-- 1. Asignar Producto a Promoción
CREATE PROCEDURE SP_AsignarProductoPromo(
    IN p_CodigoBarras VARCHAR(50),
    IN p_IdPromo INT
)
BEGIN
    INSERT INTO ProductoPromo (CodigoBarras, IdPromo)
    VALUES (p_CodigoBarras, p_IdPromo);
END //

-- 2. Obtener Productos de una Promoción Específica
CREATE PROCEDURE SP_ObtenerProductosDePromo(
    IN p_IdPromo INT
)
BEGIN
    SELECT pp.CodigoBarras, p.Nombre, p.PrecioVenta
    FROM ProductoPromo pp
    JOIN Productos p ON pp.CodigoBarras = p.CodigoBarras
    WHERE pp.IdPromo = p_IdPromo AND p.Estado = TRUE; -- Mostrar solo productos activos
END //

-- 3. Obtener Promociones de un Producto Específico
CREATE PROCEDURE SP_ObtenerPromosDeProducto(
    IN p_CodigoBarras VARCHAR(50)
)
BEGIN
    SELECT pp.IdPromo, pr.M, pr.N, pr.FechaInicio, pr.FechaFin, pr.Descripcion
    FROM ProductoPromo pp
    JOIN Promos pr ON pp.IdPromo = pr.IdPromo
    WHERE pp.CodigoBarras = p_CodigoBarras AND pr.Estado = TRUE AND pr.FechaFin >= CURDATE(); -- Mostrar solo promos activas y vigentes
END //

-- 4. Eliminar Asignación de Producto a Promoción
CREATE PROCEDURE SP_EliminarProductoDePromo(
    IN p_CodigoBarras VARCHAR(50),
    IN p_IdPromo INT
)
BEGIN
    DELETE FROM ProductoPromo
    WHERE CodigoBarras = p_CodigoBarras AND IdPromo = p_IdPromo;
END //

DELIMITER ;
```


6. **Pobla la base de datos antes de iniciar la app:**

```sql

USE PuntoDeVenta;



INSERT INTO Productos (
  CodigoBarras, Nombre, Marca, Presentacion, Proveedor,
  PrecioVenta, Costo, Categoria, Cantidad, Estado
) VALUES
('000000000001', 'Coca-Cola 600ml', 'Coca-Cola', 'Botella', 'Coca-Cola FEMSA', 1.50, 1.00, 'Bebidas', 100, true),
('000000000002', 'Pepsi 600ml', 'PepsiCo', 'Botella', 'PepsiCo México', 1.40, 0.95, 'Bebidas', 80, true),
('000000000003', 'Agua Bonafont 1L', 'Bonafont', 'Botella', 'Danone', 1.00, 0.60, 'Bebidas', 120, true),
('000000000004', 'Galletas Oreo', 'Oreo', 'Paquete 120g', 'Mondelez', 1.80, 1.20, 'Snacks', 50, true),
('000000000005', 'Sabritas Clasicas', 'Sabritas', 'Bolsa 150g', 'PepsiCo', 1.90, 1.30, 'Snacks', 60, true),
('000000000006', 'Chetos Torciditos', 'Cheetos', 'Bolsa 120g', 'PepsiCo', 1.70, 1.10, 'Snacks', 55, true),
('000000000007', 'Pan Bimbo Blanco', 'Bimbo', 'Paquete 680g', 'Bimbo', 2.50, 1.80, 'Panadería', 40, true),
('000000000008', 'Pan Integral Bimbo', 'Bimbo', 'Paquete 680g', 'Bimbo', 2.70, 2.00, 'Panadería', 35, true),
('000000000009', 'Leche Lala 1L', 'Lala', 'Tetra Pak', 'Lala México', 2.00, 1.50, 'Lácteos', 70, true),
('000000000010', 'Yogurt Danone Fresa', 'Danone', 'Vaso 240g', 'Danone', 1.20, 0.80, 'Lácteos', 45, true),
('000000000011', 'Huevo San Juan 12pzas', 'San Juan', 'Docena', 'San Juan', 3.00, 2.30, 'Abarrotes', 30, true),
('000000000012', 'Cereal Zucaritas', 'Kellogg\'s', 'Caja 300g', 'Kellogg\'s', 3.50, 2.70, 'Desayuno', 25, true),
('000000000013', 'Arroz Verde Valle 1kg', 'Verde Valle', 'Bolsa', 'Verde Valle', 1.80, 1.20, 'Abarrotes', 60, true),
('000000000014', 'Frijol Negro 1kg', 'Verde Valle', 'Bolsa', 'Verde Valle', 2.00, 1.40, 'Abarrotes', 50, true),
('000000000015', 'Aceite Capullo 1L', 'Capullo', 'Botella', 'Grupo Altex', 3.00, 2.30, 'Abarrotes', 40, true),
('000000000016', 'Salsa Valentina', 'Tamazula', 'Botella 370ml', 'Tamazula', 1.20, 0.80, 'Salsas', 65, true),
('000000000017', 'Ketchup Heinz', 'Heinz', 'Botella 500ml', 'Kraft Heinz', 2.20, 1.50, 'Salsas', 45, true),
('000000000018', 'Mayonesa McCormick', 'McCormick', 'Frasco 390g', 'McCormick México', 2.30, 1.70, 'Salsas', 50, true),
('000000000019', 'Shampoo Head & Shoulders', 'H&S', 'Botella 400ml', 'P&G', 4.00, 3.20, 'Higiene', 30, true),
('000000000020', 'Papel Higiénico Regio', 'Regio', 'Paquete 4 rollos', 'Kimberly-Clark', 2.60, 1.90, 'Higiene', 70, true),
('000000000021', 'Detergente Ariel 800g', 'Ariel', 'Bolsa', 'P&G', 3.00, 2.10, 'Limpieza', 35, true),
('000000000022', 'Cloro Cloralex 1L', 'Cloralex', 'Botella', 'AlEn', 1.60, 1.10, 'Limpieza', 40, true),
('000000000023', 'Fabuloso 1L', 'Fabuloso', 'Botella', 'Colgate-Palmolive', 1.80, 1.20, 'Limpieza', 38, true),
('000000000024', 'Suavitel 850ml', 'Suavitel', 'Botella', 'Colgate-Palmolive', 2.00, 1.40, 'Limpieza', 33, true),
('000000000025', 'Jabón Zote Blanco', 'Zote', 'Barra', 'Fábrica La Corona', 0.90, 0.50, 'Limpieza', 80, true),
('000000000026', 'Plátano Tabasco', 'Local', 'Kg', 'Productor Local', 0.70, 0.40, 'Frutas y Verduras', 90, true),
('000000000027', 'Manzana Roja', 'Local', 'Kg', 'Productor Local', 0.90, 0.60, 'Frutas y Verduras', 80, true),
('000000000028', 'Tomate Saladet', 'Local', 'Kg', 'Productor Local', 0.80, 0.50, 'Frutas y Verduras', 85, true),
('000000000029', 'Cebolla Blanca', 'Local', 'Kg', 'Productor Local', 0.70, 0.40, 'Frutas y Verduras', 70, true),
('000000000030', 'Limón Agrio', 'Local', 'Kg', 'Productor Local', 1.10, 0.70, 'Frutas y Verduras', 75, true);

```

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

