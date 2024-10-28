-- triggers

-- 1. Al realizar una venta, actualiza la cantidad de canciones en stock.
DELIMITER //
create trigger ActualizarStockEnVenta
after insert
on InvoiceLine for each row
begin   
update Track    
set Stock = Stock - 1    
where TrackId = NEW.TrackId;
end;
DELIMITER ;

-- 2. Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
DELIMITER //
create trigger AuditarCambioCliente
after update
on Customer for each row
begin    
insert into CustomerAudit (CustomerId, ChangeDate, OldEmail, NewEmail)    
values (OLD.CustomerId, NOW(), OLD.Email, NEW.Email);
end;
DELIMITER ;

-- 3. Guarda el historial de cambios de precio en las canciones.
DELIMITER //
create trigger RegistrarCambioPrecio
before update
on Track for each row
begin   
if OLD.UnitPrice <> NEW.UnitPrice then        
insert into PriceHistory (TrackId, OldPrice, NewPrice, ChangeDate)        
values (OLD.TrackId, OLD.UnitPrice, NEW.UnitPrice, NOW());    
end if;
end;
DELIMITER ;

-- 4. Notifica cuando se elimina un registro de venta.
DELIMITER // 
create trigger NotificarEliminacionVenta
before delete
on Invoice for each row
begin    
insert into DeletionLog (InvoiceId, DeletionDate)    
values (OLD.InvoiceId, NOW());
end;
DELIMITER ;

-- 5. Evita la compra de un cliente si tiene deuda pendiente.
DELIMITER //
create trigger BloquearCompraConDeuda
before insert 
on Invoice for each row
begin    
declare Deuda decimal(10, 2);    
select SUM(Balance) into Deuda    
from Invoice    
where CustomerId = NEW.CustomerId AND Balance > 0;
    if Deuda > 0 then        
    signal sqlstate '45000' set message_text = 'El cliente tiene deuda pendiente.';    
    end if;
end;
DELIMITER ;