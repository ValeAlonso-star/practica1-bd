-- Asegurar extensión PostGIS para funciones geoespaciales
CREATE EXTENSION IF NOT EXISTS postgis;

-- 1. Modificar la entidad existente para añadir capacidad geoespacial (Propuesta 1)
ALTER TABLE dim_sismos 
ADD COLUMN IF NOT EXISTS geom GEOMETRY(Point, 4326);

-- Actualizar la geometría usando latitud y longitud existentes (ejemplo hipotético de transformación)
-- UPDATE dim_sismos SET geom = ST_SetSRID(ST_MakePoint(longitud, latitud), 4326);

-- 2. Crear nueva tabla para cumplir con el Requisito Extra de Inteligencia Artificial (ML Model Outputs)
CREATE TABLE IF NOT EXISTS ia_predicciones_sismicas (
    id_prediccion SERIAL,
    id_sismo INT NOT NULL,
    modelo_version VARCHAR(50) NOT NULL,
    tipo_anomalia_detectada VARCHAR(100) NOT NULL,
    probabilidad_riesgo DECIMAL(5,4) NOT NULL, -- Valor entre 0.0000 y 1.0000
    caracteristicas_entrada JSONB,            -- Parámetros normalizados evaluados por el modelo
    fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_ia_prediccion PRIMARY KEY (id_prediccion),
    CONSTRAINT fk_iapred_sismo FOREIGN KEY (id_sismo) 
        REFERENCES dim_sismos(id_sismo) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_probabilidad CHECK (probabilidad_riesgo >= 0 AND probabilidad_riesgo <= 1)
);

-- Índice espacial para acelerar consultas con PostGIS
CREATE INDEX IF NOT EXISTS idx_dim_sismos_geom ON dim_sismos USING GIST (geom);