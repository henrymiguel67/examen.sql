-- ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
DO
INSERT INTO Notificaciones (Mensaje)
SELECT CONCAT('Ventas del mes ', MONTH(NOW()), ': ', SUM(Total))
FROM Invoice
WHERE YEAR(InvoiceDate) = YEAR(NOW()) AND MONTH(InvoiceDate) = MONTH(NOW());


-- ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.
CREATE EVENT ActualizarSaldosCliente
ON SCHEDULE EVERY 1 MONTH
DO
UPDATE Customer
SET SaldoDeudor = SaldoDeudor + (
    SELECT ISNULL(SUM(i.Total), 0)
    FROM Invoice i
    WHERE i.CustomerId = Customer.CustomerId
      AND i.Total > 0
      AND NOT EXISTS (
          SELECT 1 FROM InvoiceLine il WHERE il.InvoiceId = i.InvoiceId
      )
);


-- AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR
DO
INSERT INTO Notificaciones (Mensaje)
SELECT 'Álbum no vendido en el último año: ' + a.Title
FROM Album a
WHERE NOT EXISTS (
    SELECT 1
    FROM Track t
    JOIN InvoiceLine il ON il.TrackId = t.TrackId
    JOIN Invoice i ON i.InvoiceId = il.InvoiceId
    WHERE t.AlbumId = a.AlbumId
      AND i.InvoiceDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
);


-- LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.
CREATE EVENT LimpiarAuditoriaCada6Meses
ON SCHEDULE EVERY 6 MONTH
DO
DELETE FROM AuditoriaCliente
WHERE Fecha < DATE_SUB(NOW(), INTERVAL 1 YEAR);


-- ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.
CREATE TABLE GenerosPopulares (
    GeneroId INT,
    TotalVentas DECIMAL(10,2),
    Fecha DATETIME
);

CREATE EVENT ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DELETE FROM GenerosPopulares;

    INSERT INTO GenerosPopulares (GeneroId, TotalVentas, Fecha)
    SELECT t.GenreId, SUM(il.UnitPrice * il.Quantity), NOW()
    FROM InvoiceLine il
    JOIN Track t ON il.TrackId = t.TrackId
    GROUP BY t.GenreId;
END




