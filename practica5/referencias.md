# Ejercicio 2.1. Las claves foráneas del proyecto propio

A continuación se describen las claves foráneas definidas en `002-referencias.sql` para mantener la integridad referencial en el esquema de la boutique.

## Tabla de Claves Foráneas del Esquema

| Clave Foránea (Columna / Restricción) | Tabla Origen (Hijo) | Tabla Referenciada (Padre) | Relación del Modelo EER | ¿Admite Nulos? | Justificación de Nulabilidad y Cardinalidad Mínima |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `id_cliente` (`fk_venta_cliente`) | `venta` | `cliente` | `cliente` realiza `venta` (1:N) | No (`NOT NULL`) | Toda venta debe corresponder a un cliente registrado. |
| `id_venta` (`fk_detalle_venta`) | `detalle_venta` | `venta` | `venta` contiene `detalle_venta` (1:N) | No (`NOT NULL`) | Cada renglón del detalle pertenece obligatoriamente a una venta. |
| `id_producto` (`fk_detalle_producto`) | `detalle_venta` | `producto` | `producto` se registra en `detalle_venta` (1:N) | No (`NOT NULL`) | Cada línea de detalle debe identificar el producto vendido. |

## Observaciones

* Las tres restricciones (`fk_venta_cliente`, `fk_detalle_venta` y `fk_detalle_producto`) quedan documentadas tal como se declaran en `002-referencias.sql`.
* Si más adelante agregan más claves foráneas a `002-referencias.sql` (como las de `compra` o `detalle_compra`), solo habría que añadir sus filas aquí.
