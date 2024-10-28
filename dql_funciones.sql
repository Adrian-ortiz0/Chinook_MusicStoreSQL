-- funciones

-- 1. Calcula el total de ventas de un cliente en un año específico.
DELIMITER //
create function TotalDeVentasCliente(ClienteId int, Año int)
returns decimal(10, 2)
deterministic
begin
	declare TotalVentas decimal(10, 2);
    select
		sum(Total) into TotalVentas
	from
		Invoice
	Where
		CustomerId = ClienteID and year(InvoiceDate) = Año;
	return
		ifnull(TotalVentas, 0);
end //
DELIMITER ;

-- 2. Retorna el precio promedio de canciones en una compra.
DELIMITER //
create function PrecioPromedioPorCompra(CompraID int)
returns decimal(10, 2)
deterministic
begin
	declare PrecioPromedio decimal(10, 2);
    select 
		avg(UnitPrice) into PrecioPromedio
	from
		InvoiceLine
	where
		InvoiceId = CompraID;
	return
		ifnull(PrecioPromedio, 0);
end //
DELIMITER ;

-- 3. Retorna la duración total de canciones en un álbum.

DELIMITER //

create function DuracionTotalAlbum(AlbumId int)
returns int
deterministic
begin
	declare DuracionTotal int;
    select sum(Milliseconds) into DuracionTotal
	from
		Track
	where
		AlbumId = AlbumID;
	return 
		ifnull(DuracionTotal, 0);
end //

DELIMITER ;

-- 4. Calcula el descuento a aplicar según el historial de compras.
