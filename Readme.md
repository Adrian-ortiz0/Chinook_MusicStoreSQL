# Chinook

Descripcion

## Tabla de contenido 

| Indice | Titulo          |
| ------ | --------------- |
| 1      | Requisitos del Sistema      |
| 2      | Instalación     |
| 3      | Estructura de la Base de Datos  |
| 4      | Diagrama UML    |
| 5      | Normalizacion   |
| 6      | FAQs            |
| 7      | Licencia        |
| 8      | Creador         |


## Requisitos del Sistema

Lista de tecnologías utilizadas en el proyecto:
- **MySQL** (versión 5.7 o superior): Sistema de gestión de bases de datos relacional de código abierto, utilizado para la creación, administración y consulta de la base de datos. Es necesario instalar MySQL en el sistema para ejecutar los scripts SQL y gestionar la estructura de la base de datos de manera eficiente.

- **MySQL Workbench** (versión 8.0 o superior): Herramienta gráfica de administración y desarrollo para MySQL, que permite diseñar, administrar y ejecutar consultas SQL, así como visualizar la base de datos de manera más interactiva.

## Instalación 

Clona el proyecto

```bash
  git https://github.com/Adrian-ortiz0/AdrianDanielUstarizOrtiz_SQLFILTRO.git
```

Ve al directorio del proyecto

```bash
  cd https://github.com/Adrian-ortiz0/AdrianDanielUstarizOrtiz_SQLFILTRO.git
```

Ir al archivo

```bash
  code .
```
#### En cada uno de los archivos .sql encontraras diferentes funciones
- ddl.sql (Creación de base de datos con tablas y relaciones)
- dml.sql (inserciones de datos)
- dql_select.sql (Consultas)
- dql_procedimientos.sql (procedimientos almacenados)
- dql_funciones.sql (funciones)
- dql. triggers.sql (triggers)
- dql. eventos.sql (eventos)

> **Nota:** Primero debes ejecutar el DDL para crear las tablas y, posteriormente, el DML para realizar las inserciones. Una vez completados estos pasos, podrás ejecutar consultas individuales, procedimientos o funciones según sea necesario.

## Estructura de la Base de Datos:

-- ALBUM

CREATE TABLE `Album`
(
    `AlbumId` INT NOT NULL,
    `Title` NVARCHAR(160) NOT NULL,
    `ArtistId` INT NOT NULL,
    CONSTRAINT `PK_Album` PRIMARY KEY  (`AlbumId`)
);

-- ARTIST

CREATE TABLE `Artist`
(
    `ArtistId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Artist` PRIMARY KEY  (`ArtistId`)
);

-- CUSTOMER

CREATE TABLE `Customer`
(
    `CustomerId` INT NOT NULL,
    `FirstName` NVARCHAR(40) NOT NULL,
    `LastName` NVARCHAR(20) NOT NULL,
    `Company` NVARCHAR(80),
    `Address` NVARCHAR(70),
    `City` NVARCHAR(40),
    `State` NVARCHAR(40),
    `Country` NVARCHAR(40),
    `PostalCode` NVARCHAR(10),
    `Phone` NVARCHAR(24),
    `Fax` NVARCHAR(24),
    `Email` NVARCHAR(60) NOT NULL,
    `SupportRepId` INT,
    CONSTRAINT `PK_Customer` PRIMARY KEY  (`CustomerId`)
);

-- EMPLOYEE

CREATE TABLE `Employee`
(
    `EmployeeId` INT NOT NULL,
    `LastName` NVARCHAR(20) NOT NULL,
    `FirstName` NVARCHAR(20) NOT NULL,
    `Title` NVARCHAR(30),
    `ReportsTo` INT,
    `BirthDate` DATETIME,
    `HireDate` DATETIME,
    `Address` NVARCHAR(70),
    `City` NVARCHAR(40),
    `State` NVARCHAR(40),
    `Country` NVARCHAR(40),
    `PostalCode` NVARCHAR(10),
    `Phone` NVARCHAR(24),
    `Fax` NVARCHAR(24),
    `Email` NVARCHAR(60),
    CONSTRAINT `PK_Employee` PRIMARY KEY  (`EmployeeId`)
);

-- GENRE

CREATE TABLE `Genre`
(
    `GenreId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Genre` PRIMARY KEY  (`GenreId`)
);

-- INVOICE (TABLA IMPORTANTE)

CREATE TABLE `Invoice`
(
    `InvoiceId` INT NOT NULL,
    `CustomerId` INT NOT NULL,
    `InvoiceDate` DATETIME NOT NULL,
    `BillingAddress` NVARCHAR(70),
    `BillingCity` NVARCHAR(40),
    `BillingState` NVARCHAR(40),
    `BillingCountry` NVARCHAR(40),
    `BillingPostalCode` NVARCHAR(10),
    `Total` NUMERIC(10,2) NOT NULL,
    CONSTRAINT `PK_Invoice` PRIMARY KEY  (`InvoiceId`)
);

-- INVOICELINE

CREATE TABLE `InvoiceLine`
(
    `InvoiceLineId` INT NOT NULL,
    `InvoiceId` INT NOT NULL,
    `TrackId` INT NOT NULL,
    `UnitPrice` NUMERIC(10,2) NOT NULL,
    `Quantity` INT NOT NULL,
    CONSTRAINT `PK_InvoiceLine` PRIMARY KEY  (`InvoiceLineId`)
);

-- MEDIATYPE

CREATE TABLE `MediaType`
(
    `MediaTypeId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_MediaType` PRIMARY KEY  (`MediaTypeId`)
);

-- PLAYLIST

CREATE TABLE `Playlist`
(
    `PlaylistId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Playlist` PRIMARY KEY  (`PlaylistId`)
);

-- PLAYLIST TRACK

CREATE TABLE `PlaylistTrack`
(
    `PlaylistId` INT NOT NULL,
    `TrackId` INT NOT NULL,
    CONSTRAINT `PK_PlaylistTrack` PRIMARY KEY  (`PlaylistId`, `TrackId`)
);

-- TRACK

CREATE TABLE `Track`
(
    `TrackId` INT NOT NULL,
    `Name` NVARCHAR(200) NOT NULL,
    `AlbumId` INT,
    `MediaTypeId` INT NOT NULL,
    `GenreId` INT,
    `Composer` NVARCHAR(220),
    `Milliseconds` INT NOT NULL,
    `Bytes` INT,
    `UnitPrice` NUMERIC(10,2) NOT NULL,
    CONSTRAINT `PK_Track` PRIMARY KEY  (`TrackId`)
);

### INDEXES PARA AGILIZAR CONSULTAS

ALTER TABLE `Album` ADD CONSTRAINT `FK_AlbumArtistId`
    FOREIGN KEY (`ArtistId`) REFERENCES `Artist` (`ArtistId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_AlbumArtistId` ON `Album` (`ArtistId`);

ALTER TABLE `Customer` ADD CONSTRAINT `FK_CustomerSupportRepId`
    FOREIGN KEY (`SupportRepId`) REFERENCES `Employee` (`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_CustomerSupportRepId` ON `Customer` (`SupportRepId`);

ALTER TABLE `Employee` ADD CONSTRAINT `FK_EmployeeReportsTo`
    FOREIGN KEY (`ReportsTo`) REFERENCES `Employee` (`EmployeeId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_EmployeeReportsTo` ON `Employee` (`ReportsTo`);

ALTER TABLE `Invoice` ADD CONSTRAINT `FK_InvoiceCustomerId`
    FOREIGN KEY (`CustomerId`) REFERENCES `Customer` (`CustomerId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_InvoiceCustomerId` ON `Invoice` (`CustomerId`);

ALTER TABLE `InvoiceLine` ADD CONSTRAINT `FK_InvoiceLineInvoiceId`
    FOREIGN KEY (`InvoiceId`) REFERENCES `Invoice` (`InvoiceId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_InvoiceLineInvoiceId` ON `InvoiceLine` (`InvoiceId`);

ALTER TABLE `InvoiceLine` ADD CONSTRAINT `FK_InvoiceLineTrackId`
    FOREIGN KEY (`TrackId`) REFERENCES `Track` (`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_InvoiceLineTrackId` ON `InvoiceLine` (`TrackId`);

ALTER TABLE `PlaylistTrack` ADD CONSTRAINT `FK_PlaylistTrackPlaylistId`
    FOREIGN KEY (`PlaylistId`) REFERENCES `Playlist` (`PlaylistId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_PlaylistTrackPlaylistId` ON `PlaylistTrack` (`PlaylistId`);

ALTER TABLE `PlaylistTrack` ADD CONSTRAINT `FK_PlaylistTrackTrackId`
    FOREIGN KEY (`TrackId`) REFERENCES `Track` (`TrackId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_PlaylistTrackTrackId` ON `PlaylistTrack` (`TrackId`);

ALTER TABLE `Track` ADD CONSTRAINT `FK_TrackAlbumId`
    FOREIGN KEY (`AlbumId`) REFERENCES `Album` (`AlbumId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_TrackAlbumId` ON `Track` (`AlbumId`);

ALTER TABLE `Track` ADD CONSTRAINT `FK_TrackGenreId`
    FOREIGN KEY (`GenreId`) REFERENCES `Genre` (`GenreId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_TrackGenreId` ON `Track` (`GenreId`);

ALTER TABLE `Track` ADD CONSTRAINT `FK_TrackMediaTypeId`
    FOREIGN KEY (`MediaTypeId`) REFERENCES `MediaType` (`MediaTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX `IFK_TrackMediaTypeId` ON `Track` (`MediaTypeId`);

## Esquema UML:


![alt text](imagenes/esquema.png)

## Contribuciones

| Tipo de contribución | Nombre | Comentarios |
|:---------------------|:--------:|------------:|
| Trabajo en equipo  | Ambos       | Nos organizamos y repartimos las tareas de manera eficiente y efectiva.|
| Ayuda | Ambos      | Nos apoyamos mutuamente cuando nos encontramos con obstáculos o bloqueos. |
| Diagrama | Daniel      | Creó el diagrama de manera rápida, clara y congruente con los requisitos.|


## Licencia

Este proyecto está licenciado bajo la Licencia MIT. 

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)


## Contacto

Si tienes alguna pregunta o deseas más información, no dudes en contactarnos:

- **Nombre**: Adrian
- **Correo electrónico**: [dxniel7328@gmail.com](mailto:tu.dxniel7328@gmail.com)
- **GitHub**: [https://github.com/Adrian-ortiz0](https://github.com/Adrian-ortiz0)

También puedes dejar un mensaje en el link del repositorio.