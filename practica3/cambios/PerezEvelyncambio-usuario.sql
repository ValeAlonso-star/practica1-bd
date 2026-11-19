CREATE TABLE IF NOT EXISTS ia_predicciones_sismicas (
    id_prediccion SERIAL PRIMARY KEY,
    id_sismo INT NOT NULL,
    modelo_version VARCHAR(50) NOT NULL,
    tipo_anomalia_detectada VARCHAR(100) NOT NULL,
    es_anomalia BOOLEAN NOT NULL DEFAULT FALSE,
    probabilidad_riesgo DECIMAL(5,4) NOT NULL,
    fecha_generacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_iapred_sismo FOREIGN KEY (id_sismo)
        REFERENCES dim_sismos(id_sismo) ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT chk_probabilidad_riesgo CHECK (
        probabilidad_riesgo >= 0.0000 AND probabilidad_riesgo <= 1.0000
    )
);


CREATE INDEX IF NOT EXISTS idx_ia_pred_anomalia_version
    ON ia_predicciones_sismicas (es_anomalia, modelo_version);
