BEGIN;

-- Regla 1: ampliacion de los atributos de la entidad fuerte Sismo.
ALTER TABLE dim_sismos
    ADD COLUMN IF NOT EXISTS intensidad_mercalli_estimada VARCHAR(5);

ALTER TABLE dim_sismos
    ADD COLUMN IF NOT EXISTS riesgo_estructural_estimado VARCHAR(10);

-- Controlar el dominio de las etiquetas nuevas.
-- La nulabilidad preserva las filas historicas sin estimacion.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'dim_sismos'::regclass
          AND conname = 'chk_dim_sismos_mercalli_estimada'
    ) THEN
        ALTER TABLE dim_sismos
            ADD CONSTRAINT chk_dim_sismos_mercalli_estimada
            CHECK (
                intensidad_mercalli_estimada IN (
                    'I', 'II', 'III', 'IV', 'V', 'VI',
                    'VII', 'VIII', 'IX', 'X', 'XI', 'XII'
                )
            );
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'dim_sismos'::regclass
          AND conname = 'chk_dim_sismos_riesgo_estimado'
    ) THEN
        ALTER TABLE dim_sismos
            ADD CONSTRAINT chk_dim_sismos_riesgo_estimado
            CHECK (riesgo_estructural_estimado IN ('Ligero', 'Moderado', 'Severo'));
    END IF;
END
$$;

COMMIT;
