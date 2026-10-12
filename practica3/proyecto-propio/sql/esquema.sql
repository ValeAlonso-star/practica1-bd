-- Creación de tablas con nombres de restricciones explícitas (DDL)

CREATE TABLE CLIENTE (
    idCliente SERIAL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    CONSTRAINT pk_cliente PRIMARY KEY (idCliente),
    CONSTRAINT uk_cliente_correo UNIQUE (correo)
);

CREATE TABLE PROVEEDOR (
    idProveedor SERIAL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    CONSTRAINT pk_proveedor PRIMARY KEY (idProveedor)
);

CREATE TABLE PROVEEDOR_TELEFONO (
    idProveedor INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT pk_proveedor_telefono PRIMARY KEY (idProveedor, telefono),
    CONSTRAINT fk_proveedortel_proveedor FOREIGN KEY (idProveedor) 
        REFERENCES PROVEEDOR(idProveedor) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PRODUCTO (
    idProducto SERIAL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    color VARCHAR(30),
    CONSTRAINT pk_producto PRIMARY KEY (idProducto),
    CONSTRAINT chk_producto_precio CHECK (precio >= 0),
    CONSTRAINT chk_producto_stock CHECK (stock >= 0)
);

CREATE TABLE ACCESORIO (
    idProducto INT NOT NULL,
    material VARCHAR(50),
    dimensiones VARCHAR(50),
    CONSTRAINT pk_accesorio PRIMARY KEY (idProducto),
    CONSTRAINT fk_accesorio_producto FOREIGN KEY (idProducto) 
        REFERENCES PRODUCTO(idProducto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ROPA_PRENDA (
    idProducto INT NOT NULL,
    talla VARCHAR(10),
    type_corte VARCHAR(50),
    CONSTRAINT pk_ropaprenda PRIMARY KEY (idProducto),
    CONSTRAINT fk_ropaprenda_producto FOREIGN KEY (idProducto) 
        REFERENCES PRODUCTO(idProducto) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE VENTA (
    idVenta SERIAL,
    idCliente INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_venta PRIMARY KEY (idVenta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (idCliente) 
        REFERENCES CLIENTE(idCliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE COMPRA (
    idCompra SERIAL,
    idProveedor INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_compra PRIMARY KEY (idCompra),
    CONSTRAINT fk_compra_proveedor FOREIGN KEY (idProveedor) 
        REFERENCES PROVEEDOR(idProveedor) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE DETALLE_VENTA (
    idDetalleVenta SERIAL,
    idVenta INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_detalleventa PRIMARY KEY (idDetalleVenta),
    CONSTRAINT fk_detalleventa_venta FOREIGN KEY (idVenta) 
        REFERENCES VENTA(idVenta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalleventa_producto FOREIGN KEY (idProducto) 
        REFERENCES PRODUCTO(idProducto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dv_cantidad CHECK (cantidad > 0)
);

CREATE TABLE DETALLE_COMPRA (
    idDetalleCompra SERIAL,
    idDetalleCompra_pk SERIAL, -- Nota: usamos serial para id unico de detalle
    idCompra INT NOT NULL,
    idProducto INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_detallecompra PRIMARY KEY (idDetalleCompra),
    CONSTRAINT fk_detallecompra_compra FOREIGN KEY (idCompra) 
        REFERENCES COMPRA(idCompra) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detallecompra_producto FOREIGN KEY (idProducto) 
        REFERENCES PRODUCTO(idProducto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dc_cantidad CHECK (cantidad > 0)
);