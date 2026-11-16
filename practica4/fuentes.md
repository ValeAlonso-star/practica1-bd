# Ejercicio 1.2. Restricciones de columna y tabla (DDL)

A continuación se presenta el script DDL completo para la creación del esquema relacional del proyecto, incorporando las reglas de integridad solicitadas:
1. **`NOT NULL`** en atributos obligatorios y claves foráneas de cardinalidad mínima 1.
2. **`DEFAULT`** para valores iniciales naturales (fechas y contadores).
3. **`UNIQUE`** para atributos y combinaciones únicas.
4. **Restricciones `CHECK`** (más de 10 validaciones de rango, formato y lógica de negocio).

## Script DDL en PostgreSQL

```sql
DROP TABLE IF EXISTS DETALLE_COMPRA CASCADE;
DROP TABLE IF EXISTS DETALLE_VENTA CASCADE;
DROP TABLE IF EXISTS COMPRA CASCADE;
DROP TABLE IF EXISTS VENTA CASCADE;
DROP TABLE IF EXISTS PROVEEDOR CASCADE;
DROP TABLE IF EXISTS PRODUCTO CASCADE;
DROP TABLE IF EXISTS CLIENTE CASCADE;

CREATE TABLE CLIENTE (
    idCliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) DEFAULT 'S/N',
    CONSTRAINT uq_cliente_correo UNIQUE (correo), -- UNIQUE 1
    CONSTRAINT chk_cliente_nombre_largo CHECK (LENGTH(nombre) >= 2) -- CHECK 1
);

CREATE TABLE PROVEEDOR (
    idProveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) DEFAULT 'Sin teléfono',
    CONSTRAINT uq_proveedor_correo UNIQUE (correo), -- UNIQUE 2
    CONSTRAINT chk_proveedor_nombre CHECK (LENGTH(nombre) >= 3) -- CHECK 2
);

CREATE TABLE PRODUCTO (
    idProducto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    color VARCHAR(30) DEFAULT 'Estándar',
    CONSTRAINT chk_producto_precio CHECK (precio > 0.00), -- CHECK 3
    CONSTRAINT chk_producto_stock CHECK (stock >= 0), -- CHECK 4
    CONSTRAINT chk_producto_nombre CHECK (LENGTH(nombre) >= 2) -- CHECK 5
);

CREATE TABLE VENTA (
    idVenta SERIAL PRIMARY KEY,
    idCliente INT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- DEFAULT para fecha
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente),
    CONSTRAINT chk_venta_total CHECK (total >= 0.00) -- CHECK 6
);

CREATE TABLE COMPRA (
    idCompra SERIAL PRIMARY KEY,
    idProveedor INT NOT NULL,
    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, -- DEFAULT para fecha
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (idProveedor) REFERENCES PROVEEDOR(idProveedor),
    CONSTRAINT chk_compra_total CHECK (total >= 0.00) -- CHECK 7
);

CREATE TABLE DETALLE_VENTA (
    idDetalleVenta SERIAL PRIMARY KEY,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (idVenta) REFERENCES VENTA(idVenta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (idProducto) REFERENCES PRODUCTO(idProducto),
    CONSTRAINT uq_venta_producto UNIQUE (idVenta, idProducto), -- UNIQUE 3 (Compuesta)
    CONSTRAINT chk_detalle_venta_cantidad CHECK (cantidad > 0), -- CHECK 8
    CONSTRAINT chk_detalle_venta_precio CHECK (precio > 0.00) -- CHECK 9
);

CREATE TABLE DETALLE_COMPRA (
    idDetalleCompra SERIAL PRIMARY KEY,
    idCompra INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_compra_compra FOREIGN KEY (idCompra) REFERENCES COMPRA(idCompra) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_compra_producto FOREIGN KEY (idProducto) REFERENCES PRODUCTO(idProducto),
    CONSTRAINT uq_compra_producto UNIQUE (idCompra, idProducto), -- UNIQUE 4 (Compuesta)
    CONSTRAINT chk_detalle_compra_cantidad CHECK (cantidad > 0), -- CHECK 10
    CONSTRAINT chk_detalle_compra_precio CHECK (precio > 0.00) -- CHECK 11
);