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
   git clone [https://github.com/ValeAlonso-star/Seismic-Data-Visualization-System.git](https://github.com/ValeAlonso-star/Seismic-Data-Visualization-System.git)
   cd Seismic-Data-Visualization-System

   Despliegue de Contenedores y Sincronización:
   docker run -d -p 80:80 --name app-sismos php:8.1-apache
docker cp . app-sismos:/var/www/html/
docker exec -it app-sismos chmod -R 755 /var/www/html

Verificación de Contenedores y Servicios:
docker ps

Base de Datos: Contenedor de PostgreSQL/PostGIS activo respondiendo en el puerto 5433.

Servidor Web: Contenedor Apache/PHP (app-sismos) activo mapeado al puerto 80.
Acceso a la Interfaz Web:

Acceso directo a la vista del sistema mediante: http://localhost/src/vista.html

Verificación de persistencia de datos mediante consultas directas en PostgreSQL.

## 3.Levantamiento Contextual del Dominio
Contexto General
El Servicio Sismológico Nacional (SSN) requiere centralizar, almacenar y visualizar la actividad telúrica registrada en México para análisis geofísico, emisión de alertas tempranas y evaluación de riesgos.

Entidades Principales

Eventos Sísmicos (Sismos): Registro de fecha, hora local/UTC, magnitud, profundidad (km), epicentro (latitud/longitud) y estado de validación.

Estaciones Monitoreadoras: Ubicaciones territoriales que albergan instrumental de medición.

Sensores / Lecturas: Dispositivos instalados en las estaciones que generan trazas de aceleración y amplitud.

Zonas Geográficas: Clasificación territorial por estados, municipios y regiones según la vulnerabilidad del suelo.

## 4. Documentación de Errores Encontrados y Diagnóstico
Paso en el que se presenta la observación
Despliegue y acceso a la interfaz web del sistema mediante el servidor Apache en el puerto 80.

Descripción del error y mensaje recibido
Al ingresar desde el navegador web a la dirección raíz http://localhost/ o http://localhost/src/, el servidor devolvía una respuesta HTTP 403 (Forbidden):
Forbidden
You don't have permission to access this resource.
Apache/2.4.65 (Debian) Server at localhost Port 80

Diagnóstico Técnico

Contenedores y Base de Datos: Los servicios web y de base de datos se encontraban activos e integrados.

Servidor Web / Enrutamiento: Apache generaba la restricción HTTP 403 debido a la ausencia de un archivo de índice explícito (index.php / index.html) en el directorio raíz de la aplicación, así como a restricciones de permisos en el sistema de archivos del contenedor.

Solución Aplicada / Corrección

Se asignaron permisos recursivos de lectura y ejecución sobre el directorio web del contenedor:
docker exec -it app-sismos chmod -R 755 /var/www/html

Se identificó la ubicación de la vista principal dentro del proyecto (/src/vista.html) y se estableció la URL directa de entrada al sistema: http://localhost/src/vista.html.

Se verificó el funcionamiento de la persistencia ejecutando la consulta en la base de datos:
docker exec -it pg-practica1 psql -U postgres -d datawarehouse -c "SELECT * FROM dim_sismos LIMIT 5;"

## 5. Evidencias de Funcionamiento

1. **Arranque de Contenedores en Terminal**
   ![Arranque de Contenedores](<./Alonso Peña Valeria Elide terminal.jpeg>)

2. **Respuesta e Interfaz Web Desplegada**
   ![Respuesta Servidor Web](<./Alonso Peña Valeria Elide app-funcionando.jpeg>)

3. **Consulta a la Base de Datos PostgreSQL**
   ![Consulta SQL](<./Alonso Peña Valeria Elide consulta-sql.jpeg>)