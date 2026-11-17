-- Migración 002: Claves Foráneas y Acciones Referenciales para la Boutique

-- 1. Relación entre venta y cliente (si se borra un cliente, restringimos o manejamos según regla)
ALTER TABLE venta
    ADD CONSTRAINT fk_venta_cliente 
    FOREIGN KEY (id_cliente) 
    REFERENCES cliente(id_cliente) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE;

-- 2. Relación entre detalle_venta y venta (entidad débil: si se borra la venta, se borra su detalle)
ALTER TABLE detalle_venta
    ADD CONSTRAINT fk_detalle_venta 
    FOREIGN KEY (id_venta) 
    REFERENCES venta(id_venta) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE;

-- 3. Relación entre detalle_venta y producto
ALTER TABLE detalle_venta
    ADD CONSTRAINT fk_detalle_producto 
    FOREIGN KEY (id_producto) 
    REFERENCES producto(id_producto) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE;