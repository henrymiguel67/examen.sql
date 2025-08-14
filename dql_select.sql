-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.


SELECT CustomerId ,BillingCity , Total 
FROM Invoice i 
order by CustomerId  ASC;


-- Lista los cinco artistas con más canciones vendidas en el último año.

SELECT Composer, Name, Bytes 
FROM Track t 

-- Obtén el total de ventas y la cantidad de canciones vendidas por país.
SELECT CustomerId , BillingCity , Total 
FROM Invoice i 

-- Calcula el número total de clientes que realizaron compras por cada género en un mes específico.
SELECT  AlbumId , Name 
FROM Track t 

-- Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.
SELECT id_cliente , FirstName, albumid 
FROM cliemte
join Album a on AlbumId = AlbumId 
orden by id_cliente acs

-- Lista los tres países con mayores ventas durante el último semestre.

-- Muestra los cinco géneros menos vendidos en el último año.
SELECT  Bytes, GenreId  
FROM Track t 
join Genre g on GenreId = GenreId 


-- Encuentra los cinco empleados que realizaron más ventas de Rock.
SELECT  Total , GenreId , Name , CustomerId 
FROM Genre g2 
join Invoice i  on CustomerId  = CustomerId  
WHERE Name = 'Rock'
order by GenreId ASC 


-- Genera un informe de los clientes con más compras recurrentes.


-- Calcula el precio promedio de venta por género.
SELECT  GenreId , Name ,Total
FROM Genre g 
join Invoice i on Total  = Total

-- Lista las cinco canciones más largas vendidas en el último año.
SELECT AlbumId , Name , Milliseconds  
FROM Track t 

-- Muestra los clientes que compraron más canciones de Jazz.
SELECT  GenreId , Name , CustomerId 
FROM Genre g2 
join cliente  on id_cliente  = id_cliente  
WHERE Name = 'JAZZ'
order by GenreId ASC 

-- Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
SELECT Name , Milliseconds , id_cliente
FROM cliente
join Track t on Milliseconds = Milliseconds 
