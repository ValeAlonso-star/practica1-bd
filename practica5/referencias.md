# Ejercicio 2.1. Las claves foráneas del proyecto propio

A continuación se presenta el análisis y desglose de todas las claves foráneas que aseguran la integridad referencial en el esquema del proyecto, relacionando el modelo Entidad-Relación Extendido (EER) con su implementación física en las tablas.

## Tabla de Claves Foráneas del Esquema

| Clave Foránea (Columna / Restricción) | Tabla Origen (Hijo) | Tabla Referenciada (Padre) | Relación del Modelo EER | ¿Admite Nulos? | Justificación de Nulabilidad y Cardinalidad Mínima |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `idCliente`<br>`fk_venta_cliente` | `VENTA` | `CLIENTE` | **CLIENTE realiza VENTA** (1:N) | **No** (`NOT NULL`) | Toda venta obligatoriamente debe estar asociada a un cliente registrado (cardinalidad mínima 1). |
| `idProveedor`<br>`fk_compra_proveedor` | `COMPRA` | `PROVEEDOR` | **PROVEEDOR surte COMPRA** (1:N) | **No** (`NOT NULL`) | Una orden de compra requiere de forma indispensable un proveedor de origen válido. |
| `idVenta`<br>`fk_detalle_venta_venta` | `DETALLE_VENTA` | `VENTA` | **VENTA contiene DETALLE_VENTA** (1:N) | **No** (`NOT NULL`) | Un renglón de detalle no puede existir de manera huérfana sin su ticket o venta cabecera. |
| `idProducto`<br>`fk_detalle_venta_producto`| `DETALLE_VENTA`| `PRODUCTO` | **PRODUCTO se incluye en DETALLE_VENTA** (1:N) | **No** (`NOT NULL`) | Cada línea de venta debe señalar inequívocamente el producto adquirido del catálogo. |
| `idCompra`<br>`fk_detalle_compra_compra` | `DETALLE_COMPRA`| `COMPRA` | **COMPRA incluye DETALLE_COMPRA** (1:N) | **No** (`NOT NULL`) | Los detalles de surtimiento pertenecen estrictamente a una orden de compra cabecera. |
| `idProducto`<br>`fk_detalle_compra_producto`| `DETALLE_COMPRA`| `PRODUCTO` | **PRODUCTO se adquiere en DETALLE_COMPRA** (1:N)| **No** (`NOT NULL`) | Todo artículo recibido en el almacén debe estar vinculado al catálogo de productos. |

---

## Análisis de Cobertura del Modelo EER
- **¿Todas las relaciones del modelo EER pasaron a claves foráneas?** Sí, todas las asociaciones de tipo 1:N y las tablas asociativas derivadas de relaciones N:M (como los detalles de venta y compra) fueron implementadas rigurosamente mediante restricciones de clave foránea (`FOREIGN KEY`) en el script DDL.
- **Integridad y Cascada:** Se configuraron acciones como `ON DELETE CASCADE` en los detalles transaccionales para asegurar que, al eliminar una venta o compra cabecera, sus renglones dependientes se limpien automáticamente evitando registros huérfanos.
