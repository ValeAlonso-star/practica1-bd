# Ejercicio 2.2. Acciones referenciales y reglas de integridad
A continuación se determinan las acciones referenciales óptimas (`ON DELETE` y `ON UPDATE`) para cada clave foránea del esquema, justificando su comportamiento conforme a las reglas de negocio y dependencias del dominio.

## Tabla de Acciones Referenciales por Relación

| Clave Foránea (Restricción) | Tablas (Hijo -> Padre) | Acción Referencial Elegida | Justificación y Regla del Dominio |
| :--- | :--- | :--- | :--- |
| `fk_venta_cliente`<br>(`VENTA.idCliente`)| `VENTA` -> `CLIENTE` | **`ON DELETE RESTRICT`<br>`ON UPDATE CASCADE`** | **Restricción:** No se puede eliminar a un cliente si cuenta con historial de ventas registradas, ya que se perdería la trazabilidad fiscal y comercial. Si el identificador del cliente llega a cambiar por mantenimiento, la actualización se propaga automáticamente. |
| `fk_compra_proveedor`<br>(`COMPRA.idProveedor`)| `COMPRA` -> `PROVEEDOR` | **`ON DELETE RESTRICT`<br>`ON UPDATE CASCADE`** | **Restricción:** Un proveedor no puede ser borrado de la base de datos si existen órdenes de compra asociadas a él. Su clave se actualiza en cascada si cambia su ID. |
| `fk_detalle_venta_venta`<br>(`DETALLE_VENTA.idVenta`)| `DETALLE_VENTA` -> `VENTA` | **`ON DELETE CASCADE`<br>`ON UPDATE CASCADE`** | **Cascada:** El detalle de una venta es una entidad débil que no tiene ningún sentido ni existencia sin su ticket o venta cabecera. Si se anula o elimina la venta, sus renglones asociados deben eliminarse automáticamente. |
| `fk_detalle_venta_producto`<br>(`DETALLE_VENTA.idProducto`)| `DETALLE_VENTA` -> `PRODUCTO` | **`ON DELETE RESTRICT`<br>`ON UPDATE CASCADE`** | **Restricción:** Un producto que ha sido vendido no puede ser eliminado del catálogo para preservar el histórico de ventas e inventarios. Ante cambios en el identificador del producto, se actualiza en cascada. |
| `fk_detalle_compra_compra`<br>(`DETALLE_COMPRA.idCompra`)| `DETALLE_COMPRA` -> `COMPRA` | **`ON DELETE CASCADE`<br>`ON UPDATE CASCADE`** | **Cascada:** Los renglones de una orden de compra dependen totalmente de la cabecera de la compra. Al eliminarse la orden principal, los detalles asociados se eliminan en cascada. |
| `fk_detalle_compra_producto`<br>(`DETALLE_COMPRA.idProducto`)| `DETALLE_COMPRA` -> `PRODUCTO` | **`ON DELETE RESTRICT`<br>`ON UPDATE CASCADE`** | **Restricción:** Al igual que en las ventas, los productos surtidos protegen su integridad histórica impidiendo borrados directos en el catálogo si tienen compras vinculadas. |

---
## Criterios de Diseño Aplicados
1. **Protección Histórica (`RESTRICT`):** Aplicada en entidades maestras como `CLIENTE`, `PROVEEDOR` y `PRODUCTO` frente a operaciones de borrado, evitando la pérdida de registros financieros y transaccionales críticos.
2. **Dependencia Estructural (`CASCADE`):** Aplicada en las tablas asociativas de detalle (`DETALLE_VENTA` y `DETALLE_COMPRA`) respecto a sus cabeceras, garantizando la limpieza automática de registros huérfanos.
