# Ejercicio 1.1. Tipos de dato y dominios

## Tabla de atributos, tipos de dato y restricciones aplicadas

| Tabla | Columna | Tipo de dato / Longitud o precisión | Regla / Justificación |
| :--- | :--- | :--- | :--- |
| **CLIENTE** | `idCliente` | `SERIAL` (`INT`) | Identificador único autoincremental por cliente[cite: 2]. |
| | `nombre` | `VARCHAR(50)` | Nombre del cliente[cite: 2]. |
| | `apellidos` | `VARCHAR(100)` | Apellidos del cliente[cite: 2]. |
| | `correo` | `VARCHAR(100)` | Validado en `001-dominios.sql` con `chk_cliente_correo` (`correo LIKE '%@%'`) para exigir un formato básico de correo[cite: 2]. |
| **VENTA** | `idVenta` | `SERIAL` (`INT`) | Identificador único autoincremental de la venta[cite: 2]. |
| | `idCliente` | `INT` | Clave foránea hacia `CLIENTE`[cite: 2]. |
| | `fecha` | `DATE` | Fecha en que se registra la venta[cite: 2]. |
| | `fecha_entrega` | `TIMESTAMP` | Agregada en `001-dominios.sql`; validada con `chk_venta_fechas` (`fecha_entrega IS NULL OR fecha_entrega >= fecha`) para que la entrega no ocurra antes de la venta[cite: 2]. |
| | `total` | `DECIMAL(10,2)` | Monto total con precisión decimal exacta (sin punto flotante)[cite: 2]. |
| **DETALLE_VENTA** | `idDetalleVenta` | `SERIAL` (`INT`) | Identificador único de cada línea de venta[cite: 2]. |
| | `idVenta` | `INT` | Clave foránea hacia `VENTA`[cite: 2]. |
| | `idProducto` | `INT` | Clave foránea hacia `PRODUCTO`[cite: 2]. |
| | `cantidad` | `INT` | Cantidad de unidades vendidas[cite: 2]. |
| | `precio` | `DECIMAL(10,2)` | Precio unitario con decimales exactos[cite: 2]. |
| **PRODUCTO** | `idProducto` | `SERIAL` (`INT`) | Identificador único autoincremental del producto[cite: 2]. |
| | `nombre` | `VARCHAR(100)` | Nombre del producto[cite: 2]. |
| | `precio` | `DECIMAL(10,2)` | Precio con precisión decimal exacta (sin punto flotante)[cite: 2]. |
| | `stock` | `INT` | Unidades disponibles en existencia[cite: 2]. |
| | `color` | `VARCHAR(50)` | Color del producto[cite: 2]. |
| **ROPA_PRENDA** | `idProducto` | `INT` | Clave primaria y foránea hacia `PRODUCTO`[cite: 2]. |
| | `talla` | `VARCHAR(10)` | Talla de la prenda[cite: 2]. |
| | `type_corte` | `VARCHAR(50)` | Tipo de corte de la prenda[cite: 2]. |
| **ACCESORIO** | `idProducto` | `INT` | Clave primaria y foránea hacia `PRODUCTO`[cite: 2]. |
| | `material` | `VARCHAR(50)` | Material del accesorio[cite: 2]. |
| | `dimensiones` | `VARCHAR(50)` | Dimensiones del accesorio[cite: 2]. |
| **PROVEEDOR** | `idProveedor` | `SERIAL` (`INT`) | Identificador único autoincremental del proveedor[cite: 2]. |
| | `nombre` | `VARCHAR(100)` | Nombre o razón social del proveedor[cite: 2]. |
| | `correo` | `VARCHAR(100)` | Correo electrónico del proveedor[cite: 2]. |
| **PROVEEDOR_TELEFONO** | `idProveedor` | `INT` | Clave foránea hacia `PROVEEDOR`[cite: 2]. |
| | `telefono` | `VARCHAR(20)` | Teléfono almacenado como texto para conservar caracteres como `+`, `-` o espacios[cite: 2]. |
| **COMPRA** | `idCompra` | `SERIAL` (`INT`) | Identificador único autoincremental de la compra[cite: 2]. |
| | `idProveedor` | `INT` | Clave foránea hacia `PROVEEDOR`[cite: 2]. |
| | `fecha` | `DATE` | Fecha en que se realiza la compra[cite: 2]. |
| | `total` | `DECIMAL(10,2)` | Monto total con precisión decimal exacta[cite: 2]. |
| **DETALLE_COMPRA** | `idDetalleCompra` | `SERIAL` (`INT`) | Identificador único de cada línea de compra[cite: 2]. |
| | `idCompra` | `INT` | Clave foránea hacia `COMPRA`[cite: 2]. |
| | `idProducto` | `INT` | Clave foránea hacia `PRODUCTO`[cite: 2]. |
| | `cantidad` | `INT` | Cantidad de unidades compradas[cite: 2]. |
| | `precio` | `DECIMAL(10,2)` | Costo unitario con decimales exactos[cite: 2]. |

## Restricciones definidas en `001-dominios.sql`
* **`chk_cliente_correo`**: Verifica que `correo` contenga `@` (`correo LIKE '%@%'`).
* **`fecha_entrega` y `chk_venta_fechas`**: Añade `fecha_entrega TIMESTAMP` a `VENTA` y exige que, si no es nula, sea mayor o igual a `fecha` (`fecha_entrega IS NULL OR fecha_entrega >= fecha`).
