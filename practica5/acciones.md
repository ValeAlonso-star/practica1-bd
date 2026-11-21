# Ejercicio 2.2. Acciones referenciales y reglas de integridad

A continuación se determinan las acciones referenciales (`ON DELETE` y `ON UPDATE`) definidas en `002-referencias.sql` para las relaciones de la boutique y su justificación.

## Tabla de Acciones Referenciales por Relación

| Clave Foránea (Restricción) | Tablas (Hijo -> Padre) | Acción Referencial Elegida | Justificación y Regla del Dominio |
| :--- | :--- | :--- | :--- |
| `fk_venta_cliente` (`venta.id_cliente`) | `venta` -> `cliente` | `ON DELETE RESTRICT`<br>`ON UPDATE CASCADE` | Impide eliminar a un cliente si tiene ventas asociadas para conservar el historial; si cambia su identificador, se actualiza en cascada. |
| `fk_detalle_venta` (`detalle_venta.id_venta`) | `detalle_venta` -> `venta` | `ON DELETE CASCADE`<br>`ON UPDATE CASCADE` | El detalle depende de la venta cabecera; si se elimina la venta, se borran sus líneas de detalle en cascada y se propaga cualquier cambio de clave. |
| `fk_detalle_producto` (`detalle_venta.id_producto`) | `detalle_venta` -> `producto` | `ON DELETE RESTRICT`<br>`ON UPDATE CASCADE` | Evita borrar un producto que ya figura en ventas registradas para preservar el historial; si cambia su clave, se propaga en cascada. |

## Criterios Aplicados en `002-referencias.sql`

* **Restricción al borrar (`ON DELETE RESTRICT`):** Protege `cliente` y `producto` cuando existen ventas o líneas de detalle vinculadas.
* **Eliminación en cascada (`ON DELETE CASCADE`):** Elimina automáticamente las filas de `detalle_venta` al borrar su `venta` correspondiente.
* **Actualización en cascada (`ON UPDATE CASCADE`):** Mantiene sincronizadas las claves foráneas si se modifica el identificador referenciado.
