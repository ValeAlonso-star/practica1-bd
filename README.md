# Proyecto de Bases de Datos — Boutique Style (ESCOM 3CV2)

**Integrantes del equipo:**
* Valeria Elide Alonso Peña
* Evelyn Yamilet Pérez Mateos
* Irvin Martínez González

---

## 1. Proyecto Propio: Boutique Style

Aplicación web de gestión de clientes e inventario conectada a una base de datos relacional en PostgreSQL mediante una API REST en Node.js/Express ejecutada en Docker.

### Ejecución local (Backend + Frontend)
1. **Requisitos:** Docker Desktop activo y PostgreSQL corriendo en el puerto `5433` con la base de datos `practica1`.
2. **Levantar la API en Docker:**
   ```powershell
   cd backend
   docker rm -f boutique-api 2>$null
   docker run -d --name boutique-api -p 3000:3000 --add-host=host.docker.internal:host-gateway -e DB_HOST=host.docker.internal -e DB_PORT=5433 -e DB_NAME=practica1 -e DB_USER=postgres -e DB_PASSWORD=practica1 boutique-backend

Verificar conexión: Abrir http://localhost:3000/api/health en el navegador (debe devolver {"ok":true,"message":"Conectado a PostgreSQL"}).

Abrir la aplicación web: Abrir index.html en el navegador y registrar un cliente desde el formulario.

Esquema, Scripts y Evidencias
Diagrama Relacional Actualizado: practica3/proyecto-propio/diagrama-relacional.png

Script DDL (Creación y Restricciones): practica3/proyecto-propio/sql/esquema.sql

Diccionario de Datos: practica3/proyecto-propio/diccionario-de-datos.pdf

Transformación del Modelo: practica3/proyecto-propio/transformacion.pdf

Evidencia de Registro (Formulario Web): practica6-8/evidencias/01-registro-web.png

Evidencia de Registro (Consulta SELECT en pgAdmin): practica6-8/evidencias/02-select-cliente-pgadmin.png

Práctica Integrada (6, 7 y 8)
Normalización (Dependencias funcionales, 3FN y FNBC): practica6-8/normalizacion.md

Ejercicios de Álgebra Relacional y SQL: practica6-8/algebra.md

Grupo de RelaX (Dataset y consultas): [Pegar enlace o ruta al archivo del grupo de RelaX]

## 2. Proyecto Asignado (Sismos)
Repositorio (Fork): [Pegar enlace al fork en GitHub]

Versión Publicada: [Pegar enlace a GitHub Pages o demo publicada]

Instrucciones de Montaje: [Pegar enlace a las instrucciones o describir pasos de levantamiento]

Consultas, Árboles, SQL y Resultados: [Pegar enlace al archivo con las 3 consultas]

## 3. Artículo y Exposición
Referencia en formato APA 7: [Pegar cita completa en APA 7 con enlace directo al manuscrito y DOI]

Presentación utilizada: [Pegar enlace o ruta al archivo de diapositivas]

Propuestas de mejora sobre el esquema:

Propuesta 1 (Extensión geoespacial PostGIS): practica3/cambios/ValeriaAlonsocambio-usuario.sql

Propuesta 2 (Tabla de predicciones IA): practica3/cambios/ValeriaAlonsocambio-usuario.sql / practica3/cambios/PerezEvelyncambio-usuario.sql

Aportaciones por Integrante
Valeria Elide Alonso Peña: Desarrollo del formulario web de registro, integración del backend en Node.js/Express con PostgreSQL y Docker, evidencias de ejecución, propuesta de mejora geoespacial/IA y documentación en README.

Evelyn Yamilet Pérez Mateos: Diseño del diagrama relacional actualizado, diccionario de datos, scripts DDL/restricciones y [completar aportaciones de prácticas 6-8 / proyecto asignado].

Irvin Martínez González: Scripts de creación/ejecución SQL, pruebas de integridad referencial y [completar aportaciones de prácticas 6-8 / proyecto asignado].
