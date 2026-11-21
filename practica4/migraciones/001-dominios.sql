-- Migración 001: Restricciones adicionales de dominio y columnas para la Boutique
ALTER TABLE cliente
    ADD CONSTRAINT chk_cliente_correo CHECK (correo LIKE '%@%');

ALTER TABLE venta
    ADD COLUMN IF NOT EXISTS fecha_entrega TIMESTAMP,
    ADD CONSTRAINT chk_venta_fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha);