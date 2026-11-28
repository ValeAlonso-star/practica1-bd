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
