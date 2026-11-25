import "dotenv/config";
import express from "express";
import cors from "cors";
import { Pool } from "pg";

const app = express();
app.use(cors());
app.use(express.json());

// Las credenciales viven solo del lado del servidor (variables de entorno)
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "practica1",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD,
});

// Ruta de prueba rápida para comprobar que el servidor está vivo
app.get("/api/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ ok: true, message: "Conectado a PostgreSQL" });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// Registro de cliente desde el formulario web
app.post("/api/clientes", async (req, res) => {
  const { nombre, apellidos, correo, telefono } = req.body;

  if (!nombre || !apellidos || !correo) {
    return res.status(400).json({
      ok: false,
      error: "nombre, apellidos y correo son obligatorios",
    });
  }

  try {
    const result = await pool.query(
      `INSERT INTO cliente (nombre, apellidos, correo, telefono)
       VALUES ($1, $2, $3, $4)
       RETURNING idcliente, nombre, apellidos, correo, telefono`,
      [nombre.trim(), apellidos.trim(), correo.trim(), telefono ? telefono.trim() : null]
    );

    res.status(201).json({
      ok: true,
      mensaje: "Cliente registrado correctamente",
      cliente: result.rows[0],
    });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});