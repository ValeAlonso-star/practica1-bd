# Ejercicio 1.2. Restricciones de columna y tabla (DDL)

A continuación se presenta el script DDL de referencia para la creación del esquema relacional de la boutique, incorporando reglas de integridad mediante:

1. **`NOT NULL`** en atributos obligatorios y claves foráneas de cardinalidad mínima 1.
2. **`DEFAULT`** para valores iniciales por defecto (fechas, estados/valores iniciales y contadores).
3. **`UNIQUE`** para atributos y combinaciones únicas.
4. **Restricciones `CHECK`** (más de 10 validaciones de rango, formato básico y lógica de negocio).

## Script DDL en PostgreSQL

```sql
DROP TABLE IF EXISTS detalle_compra CASCADE;
DROP TABLE IF EXISTS detalle_venta CASCADE;
DROP TABLE IF EXISTS compra CASCADE;
DROP TABLE IF EXISTS venta CASCADE;
DROP TABLE IF EXISTS proveedor CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) DEFAULT 'No especificado',
    CONSTRAINT uq_cliente_correo UNIQUE (correo), -- UNIQUE 1
    CONSTRAINT chk_cliente_correo CHECK (correo LIKE '%@%'), -- CHECK 1
    CONSTRAINT chk_cliente_nombre_largo CHECK (LENGTH(TRIM(nombre)) >= 2) -- CHECK 2
);

CREATE TABLE proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) DEFAULT 'No especificado',
    CONSTRAINT uq_proveedor_correo UNIQUE (correo), -- UNIQUE 2
    CONSTRAINT chk_proveedor_nombre CHECK (LENGTH(TRIM(nombre)) >= 3) -- CHECK 3
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    color VARCHAR(50) DEFAULT 'Estándar',
    CONSTRAINT chk_producto_precio CHECK (precio > 0.00), -- CHECK 4
    CONSTRAINT chk_producto_stock CHECK (stock >= 0), -- CHECK 5
    CONSTRAINT chk_producto_nombre CHECK (LENGTH(TRIM(nombre)) >= 2) -- CHECK 6
);

CREATE TABLE venta (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE, -- DEFAULT para fecha de venta
    fecha_entrega TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT chk_venta_total CHECK (total >= 0.00), -- CHECK 7
    CONSTRAINT chk_venta_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha::timestamp) -- CHECK 8
);

CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    id_proveedor INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE, -- DEFAULT para fecha de compra
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    CONSTRAINT chk_compra_total CHECK (total >= 0.00) -- CHECK 9
);

CREATE TABLE detalle_venta (
    id_detalle_venta SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT uq_venta_producto UNIQUE (id_venta, id_producto), -- UNIQUE 3 (Compuesta)
    CONSTRAINT chk_detalle_venta_cantidad CHECK (cantidad > 0), -- CHECK 10
    CONSTRAINT chk_detalle_venta_precio CHECK (precio > 0.00) -- CHECK 11
);

CREATE TABLE detalle_compra (
    id_detalle_compra SERIAL PRIMARY KEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_compra_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_compra_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT uq_compra_producto UNIQUE (id_compra, id_producto) -- UNIQUE 4 (Compuesta)
);
