# Ejercicio 1.1. Tipos de dato y dominios

A continuación se presenta la tabla de dominios, tipos de datos, longitudes y precisiones elegidos para cada columna del proyecto de base de datos, considerando el uso estricto de tipos exactos para montos monetarios (evitando punto flotante) y restricciones de validación.

## Tabla general de atributos y dominios

| Entidad / Tabla | Columna / Atributo | Tipo de Dato | Longitud / Precisión | Justificación del Tipo y Dominio |
| :--- | :--- | :--- | :--- | :--- |
| **CLIENTE** | `idCliente` | SERIAL / INT | 4 bytes (Entero autoincremental) | Identificador único unívoco y secuencial para cada cliente. |
| | `nombre` | VARCHAR | 50 caracteres | Espacio suficiente para nombres de pila estándar. |
| | `apellidos` | VARCHAR | 80 caracteres | Permite almacenar apellidos compuestos o largos sin truncamiento. |
| | `correo` | VARCHAR | 100 caracteres | Espacio estándar para direcciones de correo electrónico. |
| **PRODUCTO** | `idProducto` | SERIAL / INT | Entero autoincremental | Clave primaria identificadora de cada artículo. |
| | `nombre` | VARCHAR | 100 caracteres | Descripción nominal del producto. |
| | `precio` | DECIMAL | `DECIMAL(10,2)` | Monto monetario exacto (hasta 10 dígitos totales, 2 decimales para centavos). Se evita punto flotante para prevenir errores de redondeo financiero. |
| | `stock` | INT | Entero positivo | Cantidad de piezas disponibles en inventario. |
| | `color` | VARCHAR | 30 caracteres | Descripción textual del color del producto. |
| **VENTA** | `idVenta` | SERIAL / INT | Entero autoincremental | Identificador único de cada ticket o transacción de venta. |
| | `idCliente` | INT | Entero (FK) | Clave foránea que referencia al cliente comprador. |
| | `fecha` | TIMESTAMP / DATE | Fecha y hora | Momento exacto en que se realiza la transacción comercial. |
| | `total` | DECIMAL | `DECIMAL(10,2)` | Monto total exacto de la venta, calculado o consolidado sin errores de precisión flotante. |
| **COMPRA** | `idCompra` | SERIAL / INT | Entero autoincremental | Identificador único de la orden de compra a proveedores. |
| | `idProveedor` | INT | Entero (FK) | Clave foránea que referencia al proveedor surtidor. |
| | `fecha` | TIMESTAMP / DATE | Fecha y hora | Registro temporal de la adquisición de mercancía. |
| | `total` | DECIMAL | `DECIMAL(10,2)` | Costo total exacto de la compra a proveedores. |
| **PROVEEDOR** | `idProveedor`| SERIAL / INT | Entero autoincremental | Clave primaria del proveedor. |
| | `nombre` | VARCHAR | 100 caracteres | Razón social o nombre comercial del proveedor. |
| | `correo` | VARCHAR | 100 caracteres | Contacto electrónico corporativo. |
| **DETALLE_VENTA**| `idDetalleVenta`| SERIAL / INT| Entero autoincremental | Identificador de cada línea del ticket de venta. |
| | `idVenta` | INT | Entero (FK) | Relación con la venta cabecera. |
| | `idProducto` | INT | Entero (FK) | Producto vendido en esta línea. |
| | `cantidad` | INT | Entero positivo | Número de unidades compradas de este producto en específico. |
| | `precio` | DECIMAL | `DECIMAL(10,2)` | Precio unitario histórico al momento de la venta. |
| **DETALLE_COMPRA**| `idDetalleCompra`| SERIAL / INT| Entero autoincremental | Identificador de línea en la orden de compra. |
| | `idCompra` | INT | Entero (FK) | Relación con la compra cabecera. |
| | `idProducto` | INT | Entero (FK) | Producto adquirido. |
| | `cantidad` | INT | Entero positivo | Unidades surtidas. |
| | `precio` | DECIMAL | `DECIMAL(10,2)` | Costo unitario de adquisición. |

---
## Definición de Dominios Reutilizables (CREATE DOMAIN)

Para mantener la consistencia en los atributos que se repiten a lo largo de múltiples tablas como los correos electrónicos, los precios monetarios y las cantidades enteras positivas, se definieron los siguientes dominios en PostgreSQL:

```sql
CREATE DOMAIN d_correo AS VARCHAR(100)
CHECK (VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

CREATE DOMAIN d_moneda AS DECIMAL(10,2)
CHECK (VALUE >= 0.00);

CREATE DOMAIN d_cantidad AS INT
CHECK (VALUE > 0);