# Ejercicio 1.1. Tipos de dato y dominios

## Tabla de atributos, tipos de dato y restricciones aplicadas

| Tabla | Columna | Tipo de dato / Longitud o precisión | Regla / Justificación |
| :--- | :--- | :--- | :--- |
| **CLIENTE** | `idCliente` | `SERIAL` (`INT`) | Identificador único autoincremental por cliente. |
| | `nombre` | `VARCHAR(50)` | Nombre del cliente. |
| | `apellidos` | `VARCHAR(100)` | Apellidos del cliente. |
| | `correo` | `VARCHAR(100)` | Validado en `001-dominios.sql` con `chk_cliente_correo` (`correo LIKE '%@%'`) para exigir un formato básico de correo. |
| **VENTA** | `idVenta` | `SERIAL` (`INT`) | Identificador único autoincremental de la venta. |
| | `idCliente` | `INT` | Clave foránea hacia `CLIENTE`. |
| | `fecha` | `DATE` | Fecha en que se registra la venta. |
| | `fecha_entrega` | `TIMESTAMP` | Agregada en `001-dominios.sql`; validada con `chk_venta_fechas` (`fecha_entrega IS NULL OR fecha_entrega >= fecha`) para que la entrega no ocurra antes de la venta. |
| | `total` | `DECIMAL(10,2)` | Monto total con precisión decimal exacta (sin punto flotante). |
| **DETALLE_VENTA** | `idDetalleVenta` | `SERIAL` (`INT`) | Identificador único de cada línea de venta. |
| | `idVenta` | `INT` | Clave foránea hacia `VENTA`. |
| | `idProducto` | `INT` | Clave foránea hacia `PRODUCTO`. |
| | `cantidad` | `INT` | Cantidad de unidades vendidas. |
| | `precio` | `DECIMAL(10,2)` | Precio unitario con decimales exactos. |
| **PRODUCTO** | `idProducto` | `SERIAL` (`INT`) | Identificador único autoincremental del producto. |
| | `nombre` | `VARCHAR(100)` | Nombre del producto. |
| | `precio` | `DECIMAL(10,2)` | Precio con precisión decimal exacta (sin punto flotante)[cite: 2]. |
| | `stock` | `INT` | Unidades disponibles en existencia. |
| | `color` | `VARCHAR(50)` | Color del producto. |
| **ROPA_PRENDA** | `idProducto` | `INT` | Clave primaria y foránea hacia `PRODUCTO`. |
| | `talla` | `VARCHAR(10)` | Talla de la prenda. |
| | `type_corte` | `VARCHAR(50)` | Tipo de corte de la prenda. |
| **ACCESORIO** | `idProducto` | `INT` | Clave primaria y foránea hacia `PRODUCTO`. |
| | `material` | `VARCHAR(50)` | Material del accesorio. |
| | `dimensiones` | `VARCHAR(50)` | Dimensiones del accesorio. |
| **PROVEEDOR** | `idProveedor` | `SERIAL` (`INT`) | Identificador único autoincremental del proveedor. |
| | `nombre` | `VARCHAR(100)` | Nombre o razón social del proveedor. |
| | `correo` | `VARCHAR(100)` | Correo electrónico del proveedor. |
| **PROVEEDOR_TELEFONO** | `idProveedor` | `INT` | Clave foránea hacia `PROVEEDOR`. |
| | `telefono` | `VARCHAR(20)` | Teléfono almacenado como texto para conservar caracteres como `+`, `-` o espacios. |
| **COMPRA** | `idCompra` | `SERIAL` (`INT`) | Identificador único autoincremental de la compra. |
| | `idProveedor` | `INT` | Clave foránea hacia `PROVEEDOR`. |
| | `fecha` | `DATE` | Fecha en que se realiza la compra. |
| | `total` | `DECIMAL(10,2)` | Monto total con precisión decimal exacta. |
| **DETALLE_COMPRA** | `idDetalleCompra` | `SERIAL` (`INT`) | Identificador único de cada línea de compra. |
| | `idCompra` | `INT` | Clave foránea hacia `COMPRA`. |
| | `idProducto` | `INT` | Clave foránea hacia `PRODUCTO`. |
| | `cantidad` | `INT` | Cantidad de unidades compradas. |
| | `precio` | `DECIMAL(10,2)` | Costo unitario con decimales exactos. |

## Restricciones definidas en `001-dominios.sql`
* **`chk_cliente_correo`**: Verifica que `correo` contenga `@` (`correo LIKE '%@%'`).
* **`fecha_entrega` y `chk_venta_fechas`**: Añade `fecha_entrega TIMESTAMP` a `VENTA` y exige que, si no es nula, sea mayor o igual a `fecha` (`fecha_entrega IS NULL OR fecha_entrega >= fecha`).
