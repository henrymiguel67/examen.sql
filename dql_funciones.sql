-- TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.
CREATE FUNCTION TotalGastoCliente( ClienteID INT, Anio INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE Total DECIMAL(10, 2)

    SELECT Total = ISNULL(SUM(i.Total), 0)
    FROM Invoice i
    WHERE i.CustomerId = ClienteID
      AND YEAR(i.InvoiceDate) = Anio

    RETURN Total
END


-- DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.
CREATE FUNCTION PromedioPrecioPorAlbum(AlbumID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE Promedio DECIMAL(10, 2)

    SELECT Promedio = AVG(t.UnitPrice)
    FROM Track t
    WHERE t.AlbumId = @AlbumID

    RETURN Promedio
END;


-- PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.
CREATE FUNCTION PromedioPrecioPorAlbum(AlbumID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE Promedio DECIMAL(10, 2)

    SELECT Promedio = AVG(t.UnitPrice)
    FROM Track t
    WHERE t.AlbumId = @AlbumID

    RETURN Promedio
END;




-- DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
CREATE FUNCTION DescuentoPorFrecuencia(@ClienteID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE Compras INT
    DECLARE Descuento DECIMAL(5,2)

    SELECT Compras = COUNT(*)
    FROM Invoice
    WHERE CustomerId = @ClienteID

    IF Compras > 20
        SET Descuento = 0.20
    ELSE IF Compras > 10
        SET Descuento = 0.10
    ELSE
        SET Descuento = 0.00

    RETURN Descuento
END;


-- VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
CREATE FUNCTION VerificarClienteVIP(ClienteID INT)
RETURNS BIT
AS
BEGIN
    DECLARE TotalAnual DECIMAL(10,2)

    SELECT TotalAnual = SUM(Total)
    FROM Invoice
    WHERE CustomerId = ClienteID
      AND YEAR(InvoiceDate) = YEAR(GETDATE())

    IF TotalAnual >= 1000
        RETURN 1
    RETURN 0
END;

