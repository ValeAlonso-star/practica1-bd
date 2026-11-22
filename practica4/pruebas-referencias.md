# Ejercicio 2.3. Pruebas de integridad referencial

## 1. Pruebas por acción referencial (`RESTRICT` y `CASCADE`)
* **Conteo inicial de renglones en `practica1`:** `cliente` = `0`, `proveedor` = `0`, `producto` = `0`, `venta` = `0`, `compra` = `0`, `detalle_venta` = `0`, `detalle_compra` = `0`.
* **Acción `ON DELETE RESTRICT` (`fk_venta_cliente`):** impide eliminar un cliente que tenga una venta asociada. Al insertar un cliente y una venta de prueba y luego intentar borrar ese cliente, el gestor rechaza el `DELETE` por violar `fk_venta_cliente` y `ROLLBACK` deja el conteo en `0` filas.
* **Acción `ON DELETE CASCADE` (`fk_detalle_venta_venta`):** al insertar una venta y su renglón en `detalle_venta` y después borrar la venta de prueba, PostgreSQL elimina automáticamente el renglón dependiente en `detalle_venta`, quedando en `0` filas tras el borrado.

```sql
BEGIN;
WITH c AS (
    INSERT INTO cliente (nombre, apellidos, correo)
    VALUES ('Valeria', 'Alonso', 'valeria.test@boutique.mx')
    RETURNING idcliente
)
INSERT INTO venta (idcliente, total)
SELECT idcliente, 350.00 FROM c;

DELETE FROM cliente
WHERE correo = 'valeria.test@boutique.mx';
ROLLBACK;
```
## INSERT con clave foránea inexistente
**Operación intentada:**
```sql
BEGIN;
INSERT INTO venta (idcliente, total) VALUES (999999, 250.00);
ROLLBACK;
```
**Resultado esperado:** El gestor rechaza la inserción porque el idcliente 999999 no existe en cliente.

**Mensaje devuelto por el gestor:**
ERROR:  insert or update on table "venta" violates foreign key constraint "fk_venta_cliente"
Key (idcliente)=(999999) is not present in table "cliente".
SQL state: 23503
Detail: Key (idcliente)=(999999) is not present in table "cliente".

## Orden de carga: tablas hijas antes que tablas padres
**Qué ocurre:** Si se intenta cargar o insertar en una tabla hija (detalle_venta, venta, compra o detalle_compra) antes de que existan los registros padre en cliente, proveedor, producto, venta o compra, PostgreSQL rechaza la operación por violación de clave foránea.   

**Cómo se resuelve:** Poblar primero las tablas maestras/padres (cliente, proveedor, producto), después las cabeceras (venta, compra) y al final las tablas detalle (detalle_venta, detalle_compra). 

## Comprobaciones de integridad (salen vacías / 0 filas)
```sql
SELECT v.*
FROM venta v
LEFT JOIN cliente c ON v.idcliente = c.idcliente
WHERE c.idcliente IS NULL;

SELECT correo, COUNT(*)
FROM cliente
GROUP BY correo
HAVING COUNT(*) > 1;

SELECT *
FROM producto
WHERE nombre IS NULL;
```
**Resultado devuelto por el gestor:** Las consultas ejecutan sin errores y regresan vacías (0 rows affected), confirmando ausencia de claves foráneas huérfanas, duplicados en columnas únicas y nulos en columnas NOT NULL.