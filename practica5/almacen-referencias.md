# Ejercicio 2.5. Integridad referencial en el almacén asignado

## 1. Tabla de hechos, dimensiones y granularidad
* **Tabla de hechos / eventos analíticos:** En el almacén asignado del dominio sísmico, la tabla de hechos/eventos corresponde a las mediciones o predicciones generadas sobre eventos sísmicos (por ejemplo, `ia_predicciones_sismicas` / tabla de hechos de sismos).
* **Dimensiones:** Tablas descriptivas de contexto como la dimensión de sismos (`dim_sismos`), ubicación/geometría o tiempo.
* **Granularidad:** Representa exactamente un registro de evento sísmico o de predicción/medición asociada a un sismo específico y a un corte o versión de modelo.

## 2. Claves foráneas y búsqueda de hechos huérfanos
* **Revisión del esquema:** Se creó la base `proyecto_asignado` y se consultó `information_schema.tables` junto con las restricciones `FOREIGN KEY` (`information_schema.table_constraints`)[cite: 2, 24]. Actualmente la base no cuenta con tablas ni claves foráneas cargadas (`0` filas devueltas en el catálogo de tablas y restricciones)[cite: 24, 25].
* **Consulta para detectar hechos que apunten a dimensiones inexistentes:** Una vez pobladas las tablas de hechos y dimensiones, se identifica mediante un `LEFT JOIN` filtrando `NULL` en la clave de la dimensión:
  ```sql
  SELECT p.*
  FROM public.ia_predicciones_sismicas p
  LEFT JOIN public.dim_sismos d ON p.id_sismo = d.id_sismo
  WHERE d.id_sismo IS NULL;
``
## 3. Claves en copia, omisión intencional en almacenes y riesgos
- **Prueba en copia:** Al disponer de las tablas cargadas, se crean tablas copia (`CREATE TABLE ... AS TABLE ...`), se define la clave primaria/única en la dimensión y se añade la restricción `FOREIGN KEY` (`ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY ...`) para comprobar si todos los registros cumplen la integridad referencial[cite: 2].
- **Por qué un almacén de datos (DW) a veces omite las `FOREIGN KEY` a propósito:**
  - Para acelerar cargas masivas por lotes (ETL/ELT) sin el costo de validar restricciones en cada fila[cite: 2].
  - Para evitar fallos de carga cuando llegan hechos antes que sus registros de dimensión (dimensiones tardías) o al ejecutar cargas paralelas[cite: 2].
- **Qué riesgo corre al omitirlas:** Pueden insertarse registros huérfanos o claves inconsistentes que pasen desapercibidas para el motor y provoquen filas excluidas en `INNER JOIN`, conteos duplicados o métricas incorrectas en reportes y análisis[cite: 2].