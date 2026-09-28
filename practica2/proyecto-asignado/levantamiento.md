# Levantar el Proyecto Asignado: Sistema de Visualización de Datos Sísmicos

**URL del Fork:** [https://github.com/ValeAlonso-star/Seismic-Data-Visualization-System](https://github.com/ValeAlonso-star/Seismic-Data-Visualization-System)
**Proyecto:** Sistema de Visualización de Datos Sísmicos de México  
**Integrantes:**

* Alonso Peña Valeria Elide
* Pérez Mateos Evelyn Yamilet
* Martínez González Irvin

---

## 1. Requisitos del Sistema

* Docker Desktop / Docker Engine
* Python 3.11+ / Conda
* PostgreSQL con extensión PostGIS
* Navegador Web (Chrome / Firefox / Edge)

---

## 2. Pasos de Instalación y Puesta en Marcha

1. **Clonar el repositorio del fork:**

   ```bash
   git clone https://github.com/ValeAlonso-star/Seismic-Data-Visualization-System.git
   cd Seismic-Data-Visualization-System

   Despliegue de Contenedores:
   docker compose up -d

   Verificación de Contenedores y Servicios:
   docker ps

   Base de Datos: Contenedor de PostgreSQL/PostGIS activo respondiendo en el puerto 5433.

Servidor Web: Contenedor Apache/PHP activo mapeado al puerto 80.

Acceso y Consulta Inicial:

Acceso a la interfaz web local mediante http://localhost/

Verificación de persistencia de datos mediante consultas directas en PostgreSQL.

## 3. Levantamiento Contextual del Dominio
Contexto General
El Servicio Sismológico Nacional (SSN) requiere centralizar, almacenar y visualizar la actividad telúrica registrada en México para análisis geofísico, emisión de alertas tempranas y evaluación de riesgos.

Entidades Principales
Eventos Sísmicos (Sismos): Registro de fecha, hora local/UTC, magnitud, profundidad (km), epicentro (latitud/longitud) y estado de validación.

Estaciones Monitoreadoras: Ubicaciones territoriales que albergan instrumental de medición.

Sensores / Lecturas: Dispositivos instalados en las estaciones que generan trazas de aceleración y amplitud.

Zonas Geográficas: Clasificación territorial por estados, municipios y regiones según la vulnerabilidad del suelo.

## 4. Documentación de Errores Encontrados y Diagnóstico
Paso en el que se presenta la observación
Despliegue y acceso a la interfaz web del sistema mediante el contenedor seismic-data-visualization-system-web-1 (Mapeo de puerto 80:80).

Descripción del error y mensaje recibido
Al desplegar los contenedores con docker compose up -d, la base de datos PostgreSQL en el puerto 5433 y el servicio Apache/PHP en el puerto 80 iniciaron correctamente. Sin embargo, al ingresar desde el navegador web a la dirección http://localhost, el servidor devuelve el mensaje HTTP 403:

Forbidden

You don't have permission to access this resource.

Apache/2.4.68 (Debian) Server at localhost Port 80

Diagnóstico Técnico
Contenedores y Base de Datos: Se verificó mediante docker ps que ambos contenedores están activos. La base de datos datawarehouse es plenamente funcional y responde a consultas SQL en la tabla dim_sismos.

Servidor Web: El contenedor web responde en el puerto 80, pero el servidor Apache deniega el acceso a la raíz (/) debido a que la estructura del proyecto carece de un archivo de índice público asignado al DocumentRoot configurado.

Solución Aplicada / Corrección
Se ajustaron los permisos de lectura sobre la carpeta /var/www/html en la construcción del contenedor Docker mediante la directiva chmod -R 755 /var/www/html.

Se corrigió la configuración de acceso a la base de datos dentro del contenedor para conectar a la instancia PostgreSQL (datawarehouse) utilizando las credenciales del contenedor seismic-data-visualization-system-db-1.

Se verificó el funcionamiento directo ejecutando consultas en PostgreSQL con docker exec -it seismic-data-visualization-system-db-1 psql -U postgres -d datawarehouse -c "SELECT * FROM dim_sismos LIMIT 5;".

## 5. Evidencias de Funcionamiento

1. Arranque de Contenedores en Terminal
![Arranque de Contenedores](./Alonso%20Peña%20Valeria%20Elide%20terminal.jpeg)

2. Respuesta del Servidor Web (Mensaje de Error HTTP 403)
![Respuesta Servidor Web](./Alonso%20Peña%20Valeria%20Elide%20app-funcionando.jpeg)

3. Consulta a la Base de Datos PostgreSQL
![Consulta SQL](./Alonso%20Peña%20Valeria%20Elide%20consulta-sql.jpeg)