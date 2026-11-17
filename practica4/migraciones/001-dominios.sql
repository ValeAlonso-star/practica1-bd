-- Migración 001: Restricciones de Dominio y Columnas para la Boutique

-- 1. Restricciones en la tabla de clientes (ej. correo único y teléfono válido)
ALTER TABLE cliente 
    ADD CONSTRAINT chk_cliente_correo CHECK (correo LIKE '%@%'),
    ALTER COLUMN correo SET NOT NULL;

-- 2. Restricciones en la tabla de productos (ej. precios y stock no negativos, montos sin punto flotante lógico)
ALTER TABLE producto 
    ADD CONSTRAINT chk_producto_precio CHECK (precio > 0),
    ADD CONSTRAINT chk_producto_stock CHECK (stock >= 0),
    ALTER COLUMN nombre_producto SET NOT NULL;

-- 3. Restricciones en la tabla de ventas (ej. total positivo y fecha por defecto)
ALTER TABLE venta 
    ADD CONSTRAINT chk_venta_total CHECK (total_venta >= 0),
    ALTER COLUMN fecha_venta SET DEFAULT CURRENT_TIMESTAMP;