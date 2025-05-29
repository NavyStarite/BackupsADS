-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: PuntoDeVenta
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.28-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abonoscredito`
--

DROP TABLE IF EXISTS `abonoscredito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `abonoscredito` (
  `IdAbono` int(11) NOT NULL AUTO_INCREMENT,
  `IdCredito` int(11) NOT NULL,
  `Monto` decimal(10,2) NOT NULL,
  `FechaAbono` datetime NOT NULL,
  PRIMARY KEY (`IdAbono`),
  KEY `IdCredito` (`IdCredito`),
  CONSTRAINT `abonoscredito_ibfk_1` FOREIGN KEY (`IdCredito`) REFERENCES `creditos` (`IdCredito`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abonoscredito`
--

LOCK TABLES `abonoscredito` WRITE;
/*!40000 ALTER TABLE `abonoscredito` DISABLE KEYS */;
/*!40000 ALTER TABLE `abonoscredito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `IdCliente` int(11) NOT NULL AUTO_INCREMENT,
  `NombreCompleto` varchar(255) NOT NULL,
  `Celular` varchar(20) DEFAULT NULL,
  `RFC` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`IdCliente`),
  UNIQUE KEY `Celular` (`Celular`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditos`
--

DROP TABLE IF EXISTS `creditos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `creditos` (
  `IdCredito` int(11) NOT NULL AUTO_INCREMENT,
  `IdCliente` int(11) NOT NULL,
  `MontoCredito` decimal(10,2) NOT NULL,
  `SaldoPendiente` decimal(10,2) NOT NULL,
  `Fecha` date NOT NULL,
  `Estado` enum('Activo','Liquidado','Rechazado') DEFAULT 'Activo',
  PRIMARY KEY (`IdCredito`),
  KEY `IdCliente` (`IdCliente`),
  CONSTRAINT `creditos_ibfk_1` FOREIGN KEY (`IdCliente`) REFERENCES `clientes` (`IdCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditos`
--

LOCK TABLES `creditos` WRITE;
/*!40000 ALTER TABLE `creditos` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalleventas`
--

DROP TABLE IF EXISTS `detalleventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalleventas` (
  `IdDetalle` int(11) NOT NULL AUTO_INCREMENT,
  `IdVenta` int(11) NOT NULL,
  `CodigoBarras` varchar(50) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `PrecioUnitario` decimal(10,2) NOT NULL,
  `Importe` decimal(10,2) NOT NULL,
  PRIMARY KEY (`IdDetalle`),
  KEY `IdVenta` (`IdVenta`),
  KEY `CodigoBarras` (`CodigoBarras`),
  CONSTRAINT `detalleventas_ibfk_1` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`),
  CONSTRAINT `detalleventas_ibfk_2` FOREIGN KEY (`CodigoBarras`) REFERENCES `productos` (`CodigoBarras`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalleventas`
--

LOCK TABLES `detalleventas` WRITE;
/*!40000 ALTER TABLE `detalleventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalleventas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devoluciones`
--

DROP TABLE IF EXISTS `devoluciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devoluciones` (
  `IdDevolucion` int(11) NOT NULL AUTO_INCREMENT,
  `IdDetalle` int(11) NOT NULL,
  `CantidadDevuelta` int(11) NOT NULL,
  `Fecha` datetime NOT NULL,
  `Motivo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`IdDevolucion`),
  KEY `IdDetalle` (`IdDetalle`),
  CONSTRAINT `devoluciones_ibfk_1` FOREIGN KEY (`IdDetalle`) REFERENCES `detalleventas` (`IdDetalle`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devoluciones`
--

LOCK TABLES `devoluciones` WRITE;
/*!40000 ALTER TABLE `devoluciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `devoluciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `IdFacturas` int(11) NOT NULL AUTO_INCREMENT,
  `IdVenta` int(11) DEFAULT NULL,
  `IdCliente` int(11) DEFAULT NULL,
  `RazonSocial` varchar(255) DEFAULT NULL,
  `FechaEmision` datetime NOT NULL,
  PRIMARY KEY (`IdFacturas`),
  KEY `IdVenta` (`IdVenta`),
  KEY `IdCliente` (`IdCliente`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`IdVenta`) REFERENCES `ventas` (`IdVenta`),
  CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`IdCliente`) REFERENCES `clientes` (`IdCliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productopromo`
--

DROP TABLE IF EXISTS `productopromo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productopromo` (
  `CodigoBarras` varchar(50) NOT NULL,
  `IdPromo` int(11) NOT NULL,
  PRIMARY KEY (`CodigoBarras`,`IdPromo`),
  KEY `IdPromo` (`IdPromo`),
  CONSTRAINT `productopromo_ibfk_1` FOREIGN KEY (`CodigoBarras`) REFERENCES `productos` (`CodigoBarras`),
  CONSTRAINT `productopromo_ibfk_2` FOREIGN KEY (`IdPromo`) REFERENCES `promos` (`IdPromo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productopromo`
--

LOCK TABLES `productopromo` WRITE;
/*!40000 ALTER TABLE `productopromo` DISABLE KEYS */;
/*!40000 ALTER TABLE `productopromo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `CodigoBarras` varchar(50) NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Marca` varchar(50) NOT NULL,
  `Presentacion` varchar(50) NOT NULL,
  `Proveedor` varchar(50) NOT NULL,
  `PrecioVenta` decimal(10,2) NOT NULL,
  `Costo` decimal(10,2) NOT NULL,
  `Categoria` varchar(50) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Estado` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`CodigoBarras`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
INSERT INTO `productos` VALUES ('000000000001','Coca-Cola 600ml','Coca-Cola','Botella','Coca-Cola FEMSA',1.50,1.00,'Bebidas',100,1),('000000000002','Pepsi 600ml','PepsiCo','Botella','PepsiCo México',1.40,0.95,'Bebidas',80,1),('000000000003','Agua Bonafont 1L','Bonafont','Botella','Danone',1.00,0.60,'Bebidas',120,1),('000000000004','Galletas Oreo','Oreo','Paquete 120g','Mondelez',1.80,1.20,'Snacks',50,1),('000000000005','Sabritas Clasicas','Sabritas','Bolsa 150g','PepsiCo',1.90,1.30,'Snacks',60,1),('000000000006','Chetos Torciditos','Cheetos','Bolsa 120g','PepsiCo',1.70,1.10,'Snacks',55,1),('000000000007','Pan Bimbo Blanco','Bimbo','Paquete 680g','Bimbo',2.50,1.80,'Panadería',40,1),('000000000008','Pan Integral Bimbo','Bimbo','Paquete 680g','Bimbo',2.70,2.00,'Panadería',35,1),('000000000009','Leche Lala 1L','Lala','Tetra Pak','Lala México',2.00,1.50,'Lácteos',70,1),('000000000010','Yogurt Danone Fresa','Danone','Vaso 240g','Danone',1.20,0.80,'Lácteos',45,1),('000000000011','Huevo San Juan 12pzas','San Juan','Docena','San Juan',3.00,2.30,'Abarrotes',30,1),('000000000012','Cereal Zucaritas','Kellogg\'s','Caja 300g','Kellogg\'s',3.50,2.70,'Desayuno',25,1),('000000000013','Arroz Verde Valle 1kg','Verde Valle','Bolsa','Verde Valle',1.80,1.20,'Abarrotes',60,1),('000000000014','Frijol Negro 1kg','Verde Valle','Bolsa','Verde Valle',2.00,1.40,'Abarrotes',50,1),('000000000015','Aceite Capullo 1L','Capullo','Botella','Grupo Altex',3.00,2.30,'Abarrotes',40,1),('000000000016','Salsa Valentina','Tamazula','Botella 370ml','Tamazula',1.20,0.80,'Salsas',65,1),('000000000017','Ketchup Heinz','Heinz','Botella 500ml','Kraft Heinz',2.20,1.50,'Salsas',45,1),('000000000018','Mayonesa McCormick','McCormick','Frasco 390g','McCormick México',2.30,1.70,'Salsas',50,1),('000000000019','Shampoo Head & Shoulders','H&S','Botella 400ml','P&G',4.00,3.20,'Higiene',30,1),('000000000020','Papel Higiénico Regio','Regio','Paquete 4 rollos','Kimberly-Clark',2.60,1.90,'Higiene',70,1),('000000000021','Detergente Ariel 800g','Ariel','Bolsa','P&G',3.00,2.10,'Limpieza',35,1),('000000000022','Cloro Cloralex 1L','Cloralex','Botella','AlEn',1.60,1.10,'Limpieza',40,1),('000000000023','Fabuloso 1L','Fabuloso','Botella','Colgate-Palmolive',1.80,1.20,'Limpieza',38,1),('000000000024','Suavitel 850ml','Suavitel','Botella','Colgate-Palmolive',2.00,1.40,'Limpieza',33,1),('000000000025','Jabón Zote Blanco','Zote','Barra','Fábrica La Corona',0.90,0.50,'Limpieza',80,1),('000000000026','Plátano Tabasco','Local','Kg','Productor Local',0.70,0.40,'Frutas y Verduras',90,1),('000000000027','Manzana Roja','Local','Kg','Productor Local',0.90,0.60,'Frutas y Verduras',80,1),('000000000028','Tomate Saladet','Local','Kg','Productor Local',0.80,0.50,'Frutas y Verduras',85,1),('000000000029','Cebolla Blanca','Local','Kg','Productor Local',0.70,0.40,'Frutas y Verduras',70,1),('000000000030','Limón Agrio','Local','Kg','Productor Local',1.10,0.70,'Frutas y Verduras',75,1);
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promos`
--

DROP TABLE IF EXISTS `promos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promos` (
  `IdPromo` int(11) NOT NULL AUTO_INCREMENT,
  `M` tinyint(3) unsigned NOT NULL,
  `N` tinyint(3) unsigned NOT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaFin` date DEFAULT NULL,
  `Descripcion` varchar(100) DEFAULT NULL,
  `Estado` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`IdPromo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promos`
--

LOCK TABLES `promos` WRITE;
/*!40000 ALTER TABLE `promos` DISABLE KEYS */;
/*!40000 ALTER TABLE `promos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reportes`
--

DROP TABLE IF EXISTS `reportes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reportes` (
  `IdReporte` int(11) NOT NULL AUTO_INCREMENT,
  `Tipo` enum('Quincenal','Mensual','Trimestral','Predictivo','Corte_Caja') NOT NULL,
  `Periodoini` date NOT NULL,
  `PeriodoFin` date NOT NULL,
  `RutaPDF` varchar(255) DEFAULT NULL,
  `IdUsuario` int(11) NOT NULL,
  `FechaGen` datetime NOT NULL,
  PRIMARY KEY (`IdReporte`),
  KEY `IdUsuario` (`IdUsuario`),
  CONSTRAINT `reportes_ibfk_1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuarios` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reportes`
--

LOCK TABLES `reportes` WRITE;
/*!40000 ALTER TABLE `reportes` DISABLE KEYS */;
/*!40000 ALTER TABLE `reportes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `IdUsuario` int(11) NOT NULL AUTO_INCREMENT,
  `Rol` varchar(20) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `Estado` tinyint(1) DEFAULT 1,
  `UltimoInicioSesion` datetime DEFAULT NULL,
  `IntentosFallidos` int(11) DEFAULT 0,
  PRIMARY KEY (`IdUsuario`),
  UNIQUE KEY `Nombre` (`Nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventas`
--

DROP TABLE IF EXISTS `ventas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventas` (
  `IdVenta` int(11) NOT NULL AUTO_INCREMENT,
  `IdCajero` int(11) DEFAULT NULL,
  `FechaHora` datetime NOT NULL,
  `MetodoPago` enum('Efectivo','Tarjeta','Credito') NOT NULL,
  `TotalVenta` decimal(10,2) NOT NULL,
  PRIMARY KEY (`IdVenta`),
  KEY `IdCajero` (`IdCajero`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`IdCajero`) REFERENCES `usuarios` (`IdUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventas`
--

LOCK TABLES `ventas` WRITE;
/*!40000 ALTER TABLE `ventas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ventas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-29 17:12:04
