-- eventos

-- 1. Genera un informe de ventas semanal automáticamente.
DELIMITER //
create event InformeSemanalVentas
on schedule every 1 week starts '2024-01-01 00:00:00'do
begin    
insert into WeeklySalesReport (ReportDate, TotalSales)    
select CURDATE(), SUM(Total)    
from Invoice    
where week(InvoiceDate) = week(CURDATE()) - 1;
end;
DELIMITER ;

-- 2. Actualiza el estado de cuenta de los clientes mensualmente.
DELIMITER //
create event ActualizarEstadosCuentaMensual
on schedule every 1 month starts '2024-01-01 00:00:00'do
begin    
update Customer    
set AccountStatus = case        
when TotalSpent > 500 then 'Gold'        
when TotalSpent > 250 then 'Silver'        
else 'Regular'    
end;
end;
DELIMITER ;

-- 3. Envía una alerta cuando un álbum no se ha vendido en el último año.
DELIMITER // 
create event AlertaAlbumNoVendidoAnual
on schedule every 1 year starts '2024-01-01 00:00:00'do
begin    
insert into AlbumAlerts (AlbumId, AlertDate)    
select alb.AlbumId, CURDATE()    
from Album as alb    
left join Track as trk on alb.AlbumId = trk.AlbumId    
left join InvoiceLine as invl on trk.TrackId = invl.TrackId    
where invl.InvoiceLineId is null or year(invl.InvoiceDate) < year(CURDATE()) - 1;
end;
DELIMITER ;

-- 4. Borra los registros antiguos de auditoría cada trimestre.
DELIMITER //
create event LimpiarRegistrosAntiguosAuditoria
on schedule every 3 month starts '2024-01-01 00:00:00'do
begin    
delete from CustomerAudit    
where ChangeDate < DATE_SUB(CURDATE(), interval 1 year);
end;
DELIMITER ;

-- 5. Actualiza la lista de géneros más vendidos cada mes.
DELIMITER //
create event ActualizarGenerosMasVendidosMensual
on schedule every 1 month starts '2024-01-01 00:00:00'do
begin    
delete from TopGenres;    
insert into TopGenres (GenreId, TotalSales, ReportDate)    
select GenreId, COUNT(*) as TotalSales, CURDATE()    
from InvoiceLine as invl    
join Track as trk on invl.TrackId = trk.TrackId    
group by GenreId    
order by TotalSales desc    
limit 5;
end;
DELIMITER ;