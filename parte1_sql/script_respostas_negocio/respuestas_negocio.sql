/***
1. Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas 
realizadas en enero 2020 sea superior a 1500.
***/

SELECT 
	c.customerId,
    c.email,
    c.nombre,
    c.apellido,
    c.fechaNacimiento,
    COUNT(o.orderId) as Cantidad
FROM mlDatabase.Customer c
JOIN mlDatabase.Order o 
	ON c.customerId = o.sellerId -- Join utilizando "sellerId" para listar apenas vendedores
JOIN mlDatabase.OrderStatus os
	ON o.orderId = os.orderId
WHERE c.fechaNacimiento = CAST(CURRENT_TIMESTAMP() AS DATE) -- Usuarios que cumplan años el día de hoy
AND o.fechaOrder BETWEEN '2020-01-01' AND '2020-01-31' -- Ventas realizadas en enero 2020
AND os.statusDescripcion <> 'Cancelado' -- Filtrando apenas vendas efetivas
GROUP BY 
	c.customerId,
    c.email,
    c.nombre,
    c.apellido,
    c.sexo,
    c.direccion,
    c.fechaNacimiento
HAVING COUNT(o.orderId) > 1500; -- Ventas superiores a 1500

/***
Fim
***/


/***
Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares. 
Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas, 
cantidad de productos vendidos y el monto total transaccionado.

Inicio
***/

WITH ranked_vendedores AS (

SELECT
	DATE_FORMAT(o.fechaOrder, '%Y-%m') AS ano_mes,
    c.customerId,
    c.nombre,
    c.apellido,
    COUNT(DISTINCT o.orderId) cantidad_ventas, -- cantidad de ventas realizadas
    SUM(oi.Cantidad) suma_itens, -- cantidad de productos vendidos
    SUM(oi.precoUnitario) monto_total, -- monto total transaccionado
    ROW_NUMBER() OVER (PARTITION BY DATE_FORMAT(o.fechaOrder, '%Y-%m') ORDER BY SUM(oi.precoUnitario) DESC) as ranking -- clasificar a los mejores vendedores($) por mes
FROM mlDatabase.Customer c
JOIN mlDatabase.Order o
	ON c.customerId = o.sellerId -- Join utilizando "sellerId" para listar apenas vendedores
JOIN mlDatabase.OrderStatus os 
	ON o.orderId = os.orderId 
JOIN mlDatabase.OrderItem oi
	ON o.orderId = oi.orderId
JOIN mlDatabase.Item i
	ON oi.itemId = i.itemId
JOIN mlDatabase.category ct
	ON i.categoryId = ct.categoryId
WHERE o.fechaOrder BETWEEN '2020-01-01' AND '2020-12-31' -- Ventas realizadas en 2020
AND ct.categoryDescripcion = 'Celulares'
AND os.statusDescripcion <> 'Cancelado' -- Apenas vendas efetivas
GROUP BY DATE_FORMAT(o.fechaOrder, '%Y-%m'),
    c.customerId,
    c.nombre,
    c.apellido
)
SELECT
	ano_mes,
    customerId,
    nombre,
    apellido,
    cantidad_ventas,
    suma_itens,
    monto_total,
    ranking
FROM ranked_vendedores
WHERE ranking < 6
ORDER BY ano_mes, ranking

/***
Fim
***/


/***
Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día. 
Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, 
vamos a tener únicamente el último estado informado por la PK definida. 
(Se puede resolver a través de StoredProcedure) 

Inicio
***/


DELIMITER //

DROP PROCEDURE IF EXISTS sp_merge_itemHistorico;

CREATE PROCEDURE sp_merge_itemHistorico()
BEGIN
    
    INSERT INTO mlDatabase.itemHistorico (itemId, precio, estado, fechaActualizacion)
    SELECT
		i.itemId, 
        i.precio, 
        i.estado, 
        CURRENT_TIMESTAMP() AS fechaActualizacion
	FROM mlDatabase.Item i
    ON DUPLICATE KEY UPDATE
        precio = i.precio,
        estado = i.estado;

END;
//

DELIMITER ;

/***


CALL sp_merge_itemHistorico; -- Executando procedure

SELECT * FROM mlDatabase.itemHistorico; -- Validando resultado

-- Alterando estado e precio
UPDATE dbo.Item
SET 
	precio = '59.99', 
    estado = 'Ativo',
	fechaBaja = NULL
WHERE itemId = 5

***/


/***
Fim
***/






