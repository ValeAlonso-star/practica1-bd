# Ejercicio 2.6. Trabajo Individual - Acciones Referenciales bajo Pruebas de Escritorio
Evelyn Yamilet Perez Mateos
* **Relación analizada:** `VENTA` -> `CLIENTE` (Clave foránea: `fk_venta_cliente` sobre la columna `idCliente`)

---

## 1. Planteamiento del Caso de Prueba
Para evaluar el comportamiento de la integridad referencial, analizamos la relación entre la tabla padre `CLIENTE` y la tabla hija `VENTA`. 

* **Escenario Base (Diseño Original):** La clave foránea está configurada con `ON DELETE RESTRICT`. Si se intenta borrar un cliente que cuenta con notas de venta emitidas, el SGBD rechaza la operación para proteger la trazabilidad financiera.
* **Escenario de Modificación (Prueba):** Simulamos el cambio de la regla a **`ON DELETE CASCADE`** para observar qué impacto tendría sobre los datos transaccionales si un cliente es eliminado del sistema.

---

## 2. Demostración Práctica con Datos Simulados

Supongamos que en la base de datos tenemos el siguiente escenario inicial:

### Estado Inicial:
* **Tabla `CLIENTE`:**
  * `idCliente`: `101` | `nombre`: `Juan Pérez` | `correo`: `juan@mail.com`
* **Tabla `VENTA`:**
  * `idVenta`: `5001` | `idCliente`: `101` | `fecha`: `2026-11-15` | `total`: `1,500.00`
* **Tabla `DETALLE_VENTA`:**
  * `idDetalleVenta`: `900` | `idVenta`: `5001` | `idProducto`: `15` | `cantidad`: `2` | `precio`: `750.00`

---

## 3. Comparativa de Resultados al Borrar el Renglón Padre (`CLIENTE` con ID `101`)

| Componente analizado | Opción A: Con `ON DELETE RESTRICT` (Original) | Opción B: Con `ON DELETE CASCADE` (Modificada) |
| :--- | :--- | :--- |
| **¿Qué ocurre al ejecutar `DELETE FROM CLIENTE WHERE idClient = 101;`?** | El motor de base de datos **bloquea la operación** y lanza un error de violación de integridad referencial. | El motor de base de datos **ejecuta el borrado con éxito**, eliminando al cliente y propagando la baja en cascada. |
| **¿Qué datos se conservan?** | **Se conserva todo:** El cliente, su historial de ventas (`5001`) y los detalles de los productos vendidos (`900`). | **Ninguno del cliente:** El registro de Juan Pérez desaparece por completo de la tabla `CLIENTE`. |
| **¿Qué datos se pierden?** | No se pierde absolutamente nada, ya que la base de datos protege los registros transaccionales activos. | **Se pierde toda la trazabilidad comercial y fiscal:** La venta `5001` y su detalle `900` son borrados automáticamente de la base de datos. |

---

## 4. Conclusión y Opción Correcta para el Dominio

La opción correcta y obligatoria para nuestro dominio financiero y comercial es **`ON DELETE RESTRICT`** (Opción A). 

**Justificación:** En un sistema de ventas y compras reales, un cliente nunca debe borrarse si tiene operaciones comerciales registradas, ya que esto rompería auditorías fiscales, reportes de ingresos y estadísticas históricas. La protección de los datos transaccionales mediante `RESTRICT` garantiza que la información financiera permanezca íntegra e inalterable ante eliminaciones accidentales de clientes.
