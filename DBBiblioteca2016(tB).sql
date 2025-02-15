USE [master]
GO
/****** Object:  Database [DBBiblioteca2016]    Script Date: 15/04/2024 1:25:37 p. m. ******/
CREATE DATABASE [DBBiblioteca2016]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBBiblioteca2016', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DBBiblioteca2016.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DBBiblioteca2016_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\DBBiblioteca2016_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DBBiblioteca2016] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBBiblioteca2016].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBBiblioteca2016] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET ARITHABORT OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DBBiblioteca2016] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DBBiblioteca2016] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DBBiblioteca2016] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DBBiblioteca2016] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DBBiblioteca2016] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DBBiblioteca2016] SET  MULTI_USER 
GO
ALTER DATABASE [DBBiblioteca2016] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DBBiblioteca2016] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DBBiblioteca2016] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DBBiblioteca2016] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DBBiblioteca2016] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DBBiblioteca2016] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [DBBiblioteca2016] SET QUERY_STORE = ON
GO
ALTER DATABASE [DBBiblioteca2016] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DBBiblioteca2016]
GO
/****** Object:  User [JoseL]    Script Date: 15/04/2024 1:25:39 p. m. ******/
CREATE USER [JoseL] FOR LOGIN [JoseL] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularDiasRetraso]    Script Date: 15/04/2024 1:25:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalcularDiasRetraso]
(
    @Fecha_Devolucion datetime
)
RETURNS INT
AS
BEGIN
    DECLARE @DiasRetraso INT;

    SET @DiasRetraso = DATEDIFF(DAY, @Fecha_Devolucion, GETDATE());

    IF @DiasRetraso < 0
    BEGIN
        SET @DiasRetraso = 0;
    END

    RETURN @DiasRetraso;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[ObtenerMaximoValorMateriales]    Script Date: 15/04/2024 1:25:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ObtenerMaximoValorMateriales]()
RETURNS INT
AS
BEGIN
    DECLARE @MaximoValor INT;

    SELECT @MaximoValor = MAX(Valor)
    FROM tblMaterial;

    RETURN @MaximoValor;
END;
GO
/****** Object:  Table [dbo].[tblTipo_Material]    Script Date: 15/04/2024 1:25:39 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTipo_Material](
	[CodTipo_Material] [int] IDENTITY(1,1) NOT NULL,
	[NombreTipo_Material] [varchar](30) NOT NULL,
	[CantidadTipo_Material] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CodTipo_Material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblMaterial]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMaterial](
	[Cod_material] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_material] [varchar](30) NOT NULL,
	[Valor] [int] NOT NULL,
	[año] [int] NOT NULL,
	[CodTipo_Material] [int] NOT NULL,
	[cantidad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Vista_Materiales_Precio_Mayor_Tipo]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_Materiales_Precio_Mayor_Tipo]
AS
SELECT *
FROM tblMaterial
WHERE Valor > ANY (SELECT Valor FROM tblMaterial WHERE CodTipo_Material IN (SELECT CodTipo_Material FROM tblTipo_Material WHERE NombreTipo_Material IN ('Audiovisual', 'Revistas')));
GO
/****** Object:  UserDefinedFunction [dbo].[BuscarMaterialPorTitulo]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BuscarMaterialPorTitulo]
(
    @Titulo VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM tblMaterial
    WHERE Nombre_material LIKE '%' + @Titulo + '%'
);
GO
/****** Object:  View [dbo].[Vista_Materiales_Valor_Mayor_500K]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Vista_Materiales_Valor_Mayor_500K]
AS
SELECT *
FROM tblMaterial
WHERE Valor > 50000;
GO
/****** Object:  Table [dbo].[TBL_Datos]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_Datos](
	[Cedula] [int] NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[Telefono] [int] NOT NULL,
	[Direccion] [varchar](30) NOT NULL,
	[Cod_Tipo] [int] NOT NULL,
	[Estado_usuario] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbldependencia]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbldependencia](
	[Cod_Dependencia] [int] IDENTITY(1,1) NOT NULL,
	[Nombre_Dependencia] [varchar](30) NOT NULL,
	[Ubicacion] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Dependencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblDevolucion]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDevolucion](
	[Cod_Devolucion] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Devolucion] [datetime] NOT NULL,
	[Num_Prestamo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Devolucion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEjemplar]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEjemplar](
	[Num_Ejemplar] [int] IDENTITY(1,1) NOT NULL,
	[Cod_Material] [int] NOT NULL,
	[estado] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Num_Ejemplar] ASC,
	[Cod_Material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPertenece]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPertenece](
	[Cedula] [int] NOT NULL,
	[Cod_Dependencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cedula] ASC,
	[Cod_Dependencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPrestamo]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPrestamo](
	[Cod_Prestamo] [int] IDENTITY(1,1) NOT NULL,
	[Fecha_Entrega] [datetime] NOT NULL,
	[Fecha_Devolucion] [datetime] NOT NULL,
	[Cod_Material] [int] NOT NULL,
	[Num_Ejemplar] [int] NOT NULL,
	[Cedula] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_Prestamo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblReserva]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReserva](
	[Cod_reserva] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Cedula] [int] NOT NULL,
	[Cod_Material] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_reserva] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTipo_Usuario]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTipo_Usuario](
	[Cod_tipo] [int] IDENTITY(1,1) NOT NULL,
	[Nom_Tipo] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cod_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblusuario]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblusuario](
	[Cedula] [int] NOT NULL,
	[Nombre] [varchar](30) NOT NULL,
	[telefono] [int] NOT NULL,
	[Direccion] [varchar](30) NOT NULL,
	[Cod_Tipo] [int] NOT NULL,
	[Estado_usuario] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Nombre_material]    Script Date: 15/04/2024 1:25:40 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [Nombre_material] ON [dbo].[tblMaterial]
(
	[Nombre_material] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblDevolucion] ADD  DEFAULT (getdate()) FOR [Fecha_Devolucion]
GO
ALTER TABLE [dbo].[tblPrestamo] ADD  DEFAULT (getdate()) FOR [Fecha_Entrega]
GO
ALTER TABLE [dbo].[tblReserva] ADD  DEFAULT (getdate()) FOR [Fecha]
GO
ALTER TABLE [dbo].[tblDevolucion]  WITH CHECK ADD FOREIGN KEY([Num_Prestamo])
REFERENCES [dbo].[tblPrestamo] ([Cod_Prestamo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblEjemplar]  WITH CHECK ADD FOREIGN KEY([Cod_Material])
REFERENCES [dbo].[tblMaterial] ([Cod_material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD FOREIGN KEY([CodTipo_Material])
REFERENCES [dbo].[tblTipo_Material] ([CodTipo_Material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPertenece]  WITH CHECK ADD FOREIGN KEY([Cedula])
REFERENCES [dbo].[tblusuario] ([Cedula])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPertenece]  WITH CHECK ADD FOREIGN KEY([Cod_Dependencia])
REFERENCES [dbo].[tbldependencia] ([Cod_Dependencia])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPrestamo]  WITH CHECK ADD FOREIGN KEY([Cedula])
REFERENCES [dbo].[tblusuario] ([Cedula])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblPrestamo]  WITH CHECK ADD FOREIGN KEY([Num_Ejemplar], [Cod_Material])
REFERENCES [dbo].[tblEjemplar] ([Num_Ejemplar], [Cod_Material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblReserva]  WITH CHECK ADD FOREIGN KEY([Cedula])
REFERENCES [dbo].[tblusuario] ([Cedula])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblReserva]  WITH CHECK ADD FOREIGN KEY([Cod_Material])
REFERENCES [dbo].[tblMaterial] ([Cod_material])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblusuario]  WITH CHECK ADD FOREIGN KEY([Cod_Tipo])
REFERENCES [dbo].[tblTipo_Usuario] ([Cod_tipo])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblEjemplar]  WITH CHECK ADD CHECK  (([estado]='Prestado' OR [estado]='Disponible' OR [estado]='En reparacion' OR [estado]='Reservado'))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([cantidad]>=(1) AND [cantidad]<=(20)))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([Valor]>=(1000) AND [Valor]<=(200000)))
GO
ALTER TABLE [dbo].[tblMaterial]  WITH CHECK ADD CHECK  (([año]>=(1930) AND [año]<=(2012)))
GO
/****** Object:  StoredProcedure [dbo].[ActualizarMaterial]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarMaterial]
    @Cod_material INT,
    @Nombre_material VARCHAR(30),
    @Valor INT,
    @año INT,
    @CodTipo_Material INT,
    @cantidad INT
AS
BEGIN
    UPDATE tblMaterial
    SET Nombre_material = @Nombre_material,
        Valor = @Valor,
        año = @año,
        CodTipo_Material = @CodTipo_Material,
        cantidad = @cantidad
    WHERE Cod_material = @Cod_material;
END;
GO
/****** Object:  StoredProcedure [dbo].[BorrarPrestamo]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BorrarPrestamo]
    @Cod_Prestamo INT
AS
BEGIN
    DELETE FROM tblPrestamo
    WHERE Cod_Prestamo = @Cod_Prestamo;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertarMaterial]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarMaterial]
    @Nombre_material VARCHAR(30),
    @Valor INT,
    @año INT,
    @CodTipo_Material INT,
    @cantidad INT
AS
BEGIN
    INSERT INTO tblMaterial (Nombre_material, Valor, año, CodTipo_Material, cantidad)
    VALUES (@Nombre_material, @Valor, @año, @CodTipo_Material, @cantidad);
END;
GO
/****** Object:  StoredProcedure [dbo].[MostrarMateriales_ValorMayorQue]    Script Date: 15/04/2024 1:25:40 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MostrarMateriales_ValorMayorQue]
    @ValorMinimo INT
AS
BEGIN
    SELECT *
    FROM tblMaterial
    WHERE Valor > @ValorMinimo;
END;
GO
USE [master]
GO
ALTER DATABASE [DBBiblioteca2016] SET  READ_WRITE 
GO
