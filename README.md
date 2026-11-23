# Práctica 6 5: Integridad Referencial y Pruebas en el Modelo Relacional

## Integrantes del Equipo
- Alonso Peña Valeria Elide
- Perez Mateos Evelyn Yamilet
- Martinez Gonzalez Irvin

## Datos Generales
- **Proyecto Propio:** Boutique Style (Tienda de Ropa — base `practica1`)
- **Proyecto Asignado:** Sistema de Sismos (Almacén analítico — base `proyecto_asignado`)
- **Sistema Gestor de Base de Datos (SGBD):** PostgreSQL 18 (administrado en pgAdmin 4)

## Estructura y Entregables de la Práctica
- **Inventario y Acciones Referenciales (`referencias.md` / `acciones.md`):** Documentación de claves foráneas y reglas `ON DELETE` / `ON UPDATE` (`RESTRICT`, `CASCADE`) del proyecto propio.
- **Pruebas de Integridad Referencial (`pruebas-referencias.md` - Ejercicio 2.3):** Validación en PostgreSQL mediante transacciones de prueba (`ON DELETE RESTRICT`, `ON DELETE CASCADE`), inserciones con claves foráneas inexistentes (`SQL state: 23503`), orden de carga entre tablas padres e hijas y consultas de integridad.
- **Integridad Referencial en el Almacén Asignado (`almacen-referencias.md` - Ejercicio 2.5):** Identificación de tabla de hechos, dimensiones y granularidad en el dominio sísmico (`proyecto_asignado`), verificación de restricciones `FOREIGN KEY`, consultas para detección de registros huérfanos y análisis de riesgos al omitir claves foráneas en un almacén de datos.
- **Trabajo Individual por Integrante (Ejercicio 2.6):**
  - **Alonso Peña Valeria Elide:** Análisis y cambio de acción referencial (`ON DELETE RESTRICT` a `ON DELETE CASCADE`) sobre la relación `COMPRA -> PROVEEDOR` (`fk_compra_proveedor`).
  - **Perez Mateos Evelyn Yamilet:** Análisis y cambio de acción referencial (`ON DELETE RESTRICT` a `ON DELETE CASCADE`) sobre la relación `VENTA -> CLIENTE` (`fk_venta_cliente`).

## Declaración de Inteligencia Artificial
Se empleó inteligencia artificial generativa como herramienta de apoyo y consulta para la estructuración de la documentación en Markdown, la sintaxis de consultas SQL de validación referencial y el análisis de comportamiento de restricciones en PostgreSQL, bajo la supervisión y validación del equipo.
