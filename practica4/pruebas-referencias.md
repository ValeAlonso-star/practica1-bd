# Ejercicio 2.3. Pruebas de integridad referencial

## 1. Pruebas por acción referencial (`RESTRICT` y `CASCADE`)[cite: 15, 17]
* **Conteo inicial de renglones en `practica1`:** `cliente` = `0`, `proveedor` = `0`, `producto` = `0`, `venta` = `0`, `compra` = `0`, `detalle_venta` = `0`, `detalle_compra` = `0`[cite: 15, 20].
* **Acción `ON DELETE RESTRICT` (`fk_venta_cliente`):** impide eliminar un cliente que tenga una venta asociada[cite: 15, 17]. Al insertar un cliente y una venta de prueba y luego intentar borrar ese cliente, el gestor rechaza el `DELETE` por violar `fk_venta_cliente` y `ROLLBACK` deja el conteo en `0` filas[cite: 17, 18, 20].
* **Acción `ON DELETE CASCADE` (`fk_detalle_venta_venta`):** al insertar una venta y su renglón en `detalle_venta` y después borrar la venta de prueba, PostgreSQL elimina automáticamente el renglón dependiente en `detalle_venta`, quedando en `0` filas tras el borrado[cite: 15, 17, 19].

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

