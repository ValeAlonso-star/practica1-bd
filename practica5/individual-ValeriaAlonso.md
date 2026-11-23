# Ejercicio 2.6. Trabajo Individual - Acciones Referenciales en el Proyecto Propio
Valeria Alonso
* **Relación analizada:** `COMPRA` -> `PROVEEDOR` (Clave foránea: `fk_compra_proveedor` sobre la columna `idProveedor`)

---

## 1. Planteamiento del Caso de Prueba
Para evaluar el comportamiento de la integridad referencial, analizamos la relación entre la tabla padre `PROVEEDOR` y la tabla hija `COMPRA`.

* **Escenario Base (Diseño Original):** La clave foránea está configurada con `ON DELETE RESTRICT`. Si se intenta eliminar un proveedor que tiene órdenes de compra registradas, el gestor bloquea la operación para conservar el historial de abastecimiento.
* **Escenario de Modificación (Prueba):** En una copia de la base de datos, cambiamos la regla de borrado a **`ON DELETE CASCADE`** para observar qué ocurre al intentar eliminar un proveedor que cuenta con compras asociadas.

---

## 2. Demostración Práctica con Datos y Sentencias en Copia

Supongamos el siguiente estado inicial en la base copia:
* **Tabla `PROVEEDOR`:** `idProveedor` = `201`, `nombre` = `Distribuidora Norte`
* **Tabla `COMPRA`:** `idCompra` = `8001`, `idProveedor` = `201`, `total` = `4,200.00`
* **Tabla `DETALLE_COMPRA`:** `idDetalleCompra` = `1200`, `idCompra` = `8001`, `idProducto` = `10`, `cantidad` = `5`

Sentencias aplicadas en la copia para modificar la restricción y probar el borrado del padre:
```sql
ALTER TABLE compra
DROP CONSTRAINT fk_compra_proveedor;

ALTER TABLE compra
ADD CONSTRAINT fk_compra_proveedor
FOREIGN KEY (idproveedor) REFERENCES proveedor (idproveedor)
ON DELETE CASCADE ON UPDATE CASCADE;

DELETE FROM proveedor
WHERE idproveedor = 201;
```
## 3. Comparativa de Resultados al Borrar el Renglón Padre (`PROVEEDOR` con ID `201`)

| Aspecto evaluado | Diseño Original (`ON DELETE RESTRICT`) | Prueba en Copia (`ON DELETE CASCADE`) |
| :--- | :--- | :--- |
| **¿Qué ocurre al borrar el renglón padre (`PROVEEDOR`)?** | El gestor **rechaza el `DELETE`** porque existen compras referenciando a ese proveedor[cite: 3]. | El gestor **elimina al proveedor** y propaga el borrado en cascada hacia `COMPRA` (y `DETALLE_COMPRA` si `fk_detalle_compra_compra` tiene `ON DELETE CASCADE`). |
| **¿Qué se pierde?** | **Nada**; el registro del proveedor y sus compras se mantienen sin alteraciones[cite: 3]. | Se pierde el registro del proveedor `201` y se borran sus órdenes de compra (`8001`) y renglones asociados. |
| **¿Qué se conserva?** | Todo: el proveedor, sus compras y los demás registros del catálogo[cite: 3]. | Se conservan los demás proveedores, las compras de otros proveedores y los productos en `PRODUCTO`. |

## 4. Conclusión y Opción Correcta para el Dominio

La opción correcta para nuestro dominio es **`ON DELETE RESTRICT`**[cite: 3, 4, 27]. Un proveedor con historial de compras no debe eliminarse directamente porque se perdería la trazabilidad de compras, costos y entradas de inventario[cite: 3]; impedir el borrado mientras existan compras asociadas protege la integridad histórica de la operación[cite: 3].