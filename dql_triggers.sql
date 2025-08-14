-- ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.

CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER UPDATE ON EMPLEADO
FOR EACH ROW
BEGIN
    IF OLD.VENTA <> NEW.VENTA THEN
        SELECT CONCAT('actualiza el total de ventas acumuladas por el empleado ', NEW.id_EMPLEADO) AS aviso;
    END IF;
END$$


-- AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
CREATE TABLE AuditoriaClientes (
    IdAuditoria INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT,
    CampoModificado VARCHAR(100),
    ValorAnterior VARCHAR(MAX),
    ValorNuevo VARCHAR(MAX),
    FechaCambio DATETIME DEFAULT GETDATE(),
    Usuario VARCHAR(100) DEFAULT SYSTEM_USER
);
CREATE TRIGGER AuditarActualizacionCliente
ON Clientes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

 
    INSERT INTO AuditoriaClientes (IdCliente, CampoModificado, ValorAnterior, ValorNuevo)
    SELECT
        i.IdCliente,
        'Nombre',
        d.Nombre,
        i.Nombre
    FROM inserted i
    INNER JOIN deleted d ON i.IdCliente = d.IdCliente
    WHERE ISNULL(i.Nombre, '') <> ISNULL(d.Nombre, '');

    INSERT INTO AuditoriaClientes (IdCliente, CampoModificado, ValorAnterior, ValorNuevo)
    SELECT
        i.IdCliente,
        'Email',
        d.Email,
        i.Email
    FROM inserted i
    INNER JOIN deleted d ON i.IdCliente = d.IdCliente
    WHERE ISNULL(i.Email, '') <> ISNULL(d.Email, '');

    INSERT INTO AuditoriaClientes (IdCliente, CampoModificado, ValorAnterior, ValorNuevo)
    SELECT
        i.IdCliente,
        'Telefono',
        d.Telefono,
        i.Telefono
    FROM inserted i
    INNER JOIN deleted d ON i.IdCliente = d.IdCliente
    WHERE ISNULL(i.Telefono, '') <> ISNULL(d.Telefono, '');
END;



-- RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.
CREATE TABLE HistorialPrecioCancion (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TrackId INT,
    PrecioAnterior DECIMAL(10,2),
    PrecioNuevo DECIMAL(10,2),
    FechaCambio DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER RegistrarHistorialPrecioCancion
ON Track
AFTER UPDATE
AS
BEGIN
    INSERT INTO HistorialPrecioCancion (TrackId, PrecioAnterior, PrecioNuevo)
    SELECT i.TrackId, d.UnitPrice, i.UnitPrice
    FROM inserted i
    JOIN deleted d ON i.TrackId = d.TrackId
    WHERE i.UnitPrice <> d.UnitPrice;
END


-- NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.
CREATE TABLE Notificaciones (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Mensaje VARCHAR(255),
    Fecha DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER NotificarCancelacionVenta
ON Invoice
AFTER DELETE
AS
BEGIN
    INSERT INTO Notificaciones (Mensaje)
    SELECT 'Venta con ID ' + CAST(d.InvoiceId AS VARCHAR) + ' fue cancelada.'
    FROM deleted d
END;


-- RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.
ALTER TABLE Customer ADD SaldoDeudor DECIMAL(10,2) DEFAULT 0;

CREATE TRIGGER RestringirCompraConSaldoDeudor
ON Invoice
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Customer c ON i.CustomerId = c.CustomerId
        WHERE c.SaldoDeudor > 0
    )
    BEGIN
        RAISERROR('Cliente con saldo deudor no puede comprar.', 16, 1)
        ROLLBACK
    END
    ELSE
    BEGIN
        INSERT INTO Invoice
        SELECT * FROM inserted
    END
END;

