use Chinook;

-- consultas

-- 1. Obtén el álbum más vendido en cada país en el último año.

select
	BillingCountry, AlbumId, count(*) as total_ventas_por_pais
from
	Invoice as inv
join
	 InvoiceLine as invl on inv.InvoiceId = invl.InvoiceId
join
	Track as trk on invl.TrackId = trk.TrackId
where
	year(InvoiceDate) = year(curdate() - 1)
group by
	BillingCountry, AlbumId
order by
	BillingCountry, total_ventas_por_pais DESC;



-- 2. Lista los clientes que han gastado más de $40 en total en la tienda

select
	CustomerId, SUM(Total) AS Total
from
	Invoice
Group by
	CustomerId
Having
	Total > 40;
    
-- 3. 5 generos mas vendidos

select 
	GenreId ,count(*) as total_ventas
from
	InvoiceLine as invl
join
	Track as trk on invl.TrackId = trk.TrackId
group by
	GenreId
order by
	total_ventas
desc
limit 5;

-- 4. Calcula el número de canciones compradas por cada cliente.

select
	CustomerId,count(invl.TrackId) as cancionesAdquiridas
from
	Invoice as inv
join
	InvoiceLine as invl on inv.InvoiceId = invl.InvoiceId
group by
	CustomerId;

-- 5. Lista los clientes que no han realizado compras en los últimos 6 meses.

select
	CustomerId
from
	Customer
where
	CustomerId in (select CustomerId from Invoice where InvoiceDate >= date_sub(curdate(), interval 6 month));
    
-- 6. Consulta el número total de ventas por cada artista.

select art.ArtistId, art.Name, count(invl.InvoiceLineId) as total
from
    InvoiceLine as invl
join
	Track as trk on invl.TrackId = trk.TrackId
join
	Album as alb on trk.AlbumId = alb.AlbumId
join
	Artist as art on alb.ArtistId = art.ArtistId
group by
	art.ArtistId;
    
-- 7. Calcula el total de ventas de cada empleado en el último mes.

select emp.EmployeeId, emp.FirstName, sum(inv.Total) as total_ventas
from
	Invoice as inv
join
	Employee as emp on inv.SupportRepId = emp.EmployeeId
where
	month(InvoiceDate) = month(curdate() - 1)
group by 
	emp.EmployeeId;
    
-- 8. Encuentra los clientes más frecuentes de cada país.

select
	BillingCountry, CustomerId, count(*) as compras_frequencia
from
	Invoice
group by
	BillingCountry, CustomerId
order by
	BillingCountry, compras_frequencia
DESC;

-- 9. Lista las ventas diarias de canciones en un mes específico.

select
	date(InvoiceDate) as fecha_ventas, count(invl.TrackId) as total_ventas
from
	Invoice as inv
join
	InvoiceLine as invl on inv.InvoiceId = invl.InvoiceId
where
	month(InvoiceDate) = 1
group by
	fecha_ventas;
    
-- 10. Genera un informe de los cinco clientes más recientes.

select
	CustomerId, FirstName, LastName, Email
from
	Customer
Order by
	CustomerId
Desc
Limit 5;

-- 11. Calcula el precio promedio de venta de canciones.

select
	avg(UnitPrice) as precio_promedio
from
	InvoiceLine;

-- 12. Lista las canciones más caras y más baratas vendidas.

select TrackId, UnitPrice as precio_mas_caras
from
InvoiceLine
Order by
UnitPrice
Desc
limit 5;

select TrackId, UnitPrice as precio_mas_baratas
from
InvoiceLine
order by
UnitPrice
ASC
limit 5;

-- 13. Muestra los cinco clientes que compraron más canciones de Rock.

select 
	cus.CustomerId, count(invl.TrackId) as canciones_de_rock
from
	InvoiceLine as invl
join
	Track as trk on invl.TrackId = trk.TrackId
join
	Invoice as inv on inv.InvoiceId = invl.InvoiceId
join
	Customer as cus on inv.CustomerId = cus.CustomerId
join
	Genre as gen on trk.GenreId = gen.GenreId
where
	gen.Name = "Rock"
group by CustomerId
order by canciones_de_rock
Desc
limit 5;

-- 14. Encuentra la duración total de canciones en cada álbum.

select AlbumId, sum(trk.Milliseconds) / 1000 as total_duracion
from
	Track as trk
group by
AlbumId;

-- 15. Lista los empleados que generaron más ventas en el último año.

select emp.EmployeeId, emp.FirstName, emp.LastName, sum(inv.Total) as total_ventas
from
	Invoice as inv
Join
	Employee as emp on inv.SupportRepId = emp.EmployeeId
Where
	year(InvoiceDate) = year(curdate() - 1)
group by
	emp.EmployeeId
Order by
	total_ventas
DESC;

-- 16. Calcula el descuento promedio aplicado a los clientes VIP.

-- 17. Encuentra el cliente con más canciones compradas.

select 
	cus.CustomerId, count(invl.TrackId) as canciones_compradas
from
	InvoiceLine as invl
join
	Invoice as inv on inv.InvoiceId = invl.InvoiceId
join
	Customer as cus on inv.CustomerId = cus.CustomerId
group by CustomerId
order by canciones_compradas
DESC
limit 1;

-- 18. Lista los álbumes con más canciones vendidas en el último trimestre.

select
	alb.AlbumId, count(invl.TrackId) as Total_canciones_vendidas
from
	InvoiceLine invl
join
	Track as trk on invl.TrackId = trk.TrackId
join
	Album as alb on trk.AlbumId = alb.AlbumId
join
	Invoice as inv on inv.InvoiceId = invl.InvoiceId
where
	quarter(InvoiceDate) = quarter(curdate() - 1)
group by
	alb.AlbumId
order by
	Total_canciones_vendidas
Desc;

-- 19. Muestra las ventas semanales de canciones en el último año.

select week(InvoiceDate) as numeroSemanas, count(invl.TrackId) as total_ventas_semanales
from
	Invoice as inv
join
	InvoiceLine as invl on inv.InvoiceId = invl.InvoiceId
where
	year(InvoiceDate) = year(curdate() - 1)
group by
	numeroSemanas
order by
	total_ventas_semanales;

-- 20. Lista los géneros que no han sido vendidos en el último año.

select
	gen.GenreId, gen.Name
from
	Genre as gen
left join
	Track as trk on gen.GenreId = trk.GenreId
left join
	InvoiceLine as invl on trk.TrackId = invl.TrackId
left join
	Invoice as inv on invl.InvoiceId = inv.InvoiceId
where
	inv.InvoiceId is null or year(inv.InvoiceDate) > year(curdate() - 1);
    
