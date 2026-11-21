# Ejercicio 1.6. Roles y permisos — Proyecto propio (Boutique)

## Roles definidos
* **`rol_consulta_boutique`**: Acceso de solo lectura (`SELECT`) sobre las tablas de la boutique para consulta o reportes.
* **`rol_ventas_boutique`**: Lectura en `cliente`, `producto`, `venta` y `detalle_venta`, con `INSERT` y `UPDATE` en `venta` y `detalle_venta` (y uso de sus secuencias), sin permiso de `DELETE` ni acceso a `compra` o `proveedor`.

## Sentencias de configuración (`GRANT` / `REVOKE`)
```sql
GRANT CONNECT ON DATABASE practica1 TO rol_consulta_boutique, rol_ventas_boutique;
GRANT USAGE ON SCHEMA public TO rol_consulta_boutique, rol_ventas_boutique;

GRANT SELECT ON cliente, proveedor, producto, venta, compra, detalle_venta, detalle_compra
TO rol_consulta_boutique;

GRANT SELECT ON cliente, producto, venta, detalle_venta TO rol_ventas_boutique;
GRANT INSERT, UPDATE ON venta, detalle_venta TO rol_ventas_boutique;
GRANT USAGE, SELECT ON SEQUENCE venta_idventa_seq, detalle_venta_iddetalleventa_seq TO rol_ventas_boutique;
```
**Mensaje devuelto por el gestor:** 
GRANT
Query returned successfully in 178 msec.

## Pruebas de permisos
## Prueba 1: Inserción no autorizada con rol_consulta_boutique
```sql
**Operación intentada:**
BEGIN;
SET LOCAL ROLE rol_consulta_boutique;
INSERT INTO producto (nombre, precio, stock) VALUES ('Top encaje', 280.00, 5);
ROLLBACK;
```
**Resultado esperado:**
PostgreSQL deniega el permiso de escritura en producto.
**Mensaje devuelto por el gestor:**
ERROR:  permission denied for table producto
SQL state: 42501

