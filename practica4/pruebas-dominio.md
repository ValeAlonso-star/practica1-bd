# Ejercicio 1.5. Pruebas de restricciones de dominio — Proyecto propio

## Caso 1: Violación de `NOT NULL` en atributo obligatorio
 * **Regla del dominio protegida:** Todo producto debe tener un nombre registrado para identificarse en el catálogo.
 * **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO producto (nombre, precio, stock, color) VALUES (NULL, 250.00, 10, 'Negro');
  ROLLBACK;
 **Resultado esperado:** El gestor rechaza la inserción por violar la restricción NOT NULL en nombre[cite: 16, 20].
 **Mensaje devuelto por el gestor:**
 ERROR:  null value in column "nombre" of relation "producto" violates not-null constraint
 DETAIL:  Failing row contains (1, null, 250.00, 10, Negro).

## Caso 2: Violación de `NOT NULL` en clave foránea obligatoria
* **Regla del dominio protegida:** Toda venta debe asociarse a un cliente existente (`idcliente` no nulo).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO venta (idcliente, total) VALUES (NULL, 300.00);
  ROLLBACK;
**Resultado esperado:** El gestor rechaza la inserción por valor nulo en idcliente.
**Mensaje devuelto por el gestor:**
ERROR:  null value in column "idcliente" of relation "venta" violates not-null constraint
DETAIL:  Failing row contains (1, null, 2026-11-19 21:08:04.715503, 300.00, null).

## Caso 3: Comprobación de `DEFAULT`
* **Regla del dominio protegida:** Si no se indican `stock` ni `color` al registrar un producto, se asignan los valores por omisión (`0` y `'Estándar'`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO producto (nombre, precio) VALUES ('Blusa básica', 220.00)
  RETURNING idproducto, nombre, precio, stock, color;
  ROLLBACK;
**Resultado esperado:** La inserción aplica los valores DEFAULT (stock = 0 y color = 'Estándar') y al revertir la transacción de prueba se ejecuta ROLLBACK.
**Mensaje devuelto por el gestor:**
ROLLBACK
Query returned successfully in 117 msec.

## Caso 4: Violación de `UNIQUE` simple
* **Regla del dominio protegida:** No pueden existir dos clientes registrados con el mismo correo electrónico (`uq_cliente_correo`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO cliente (nombre, apellidos, correo) VALUES ('Ana', 'López', 'ana@test.com');
  INSERT INTO cliente (nombre, apellidos, correo) VALUES ('Ana', 'Ruiz', 'ana@test.com');
  ROLLBACK;
**Resultado esperado:** El segundo INSERT falla por clave duplicada en correo.
**Mensaje devuelto por el gestor:**
ERROR:  duplicate key value violates unique constraint "uq_cliente_correo"
DETAIL:  Key (correo)=(ana@test.com) already exists.

## Caso 5: Violación de `UNIQUE` compuesta
* **Regla del dominio protegida:** Dentro de una misma venta no puede repetirse el mismo producto como dos filas distintas (`uq_venta_producto` sobre `idventa, idproducto`).
* **Operación intentada:**
  ```sql
  BEGIN;
  WITH c AS (
      INSERT INTO cliente (nombre, apellidos, correo)
      VALUES ('Cliente1', 'Test', 'c1@test.com')
      RETURNING idcliente
  ),
  p AS (
      INSERT INTO producto (nombre, precio)
      VALUES ('Prod1', 100.00)
      RETURNING idproducto
  ),
  v AS (
      INSERT INTO venta (idcliente, total)
      SELECT idcliente, 200.00 FROM c
      RETURNING idventa
  )
  INSERT INTO detalle_venta (idventa, idproducto, cantidad, precio)
  SELECT v.idventa, p.idproducto, 1, 100.00 FROM v, p;

  WITH v AS (SELECT idventa FROM venta ORDER BY idventa DESC LIMIT 1),
       p AS (SELECT idproducto FROM producto ORDER BY idproducto DESC LIMIT 1)
  INSERT INTO detalle_venta (idventa, idproducto, cantidad, precio)
  SELECT v.idventa, p.idproducto, 2, 100.00 FROM v, p;
  ROLLBACK;
**Resultado esperado:** El segundo INSERT falla por violar la restricción única compuesta (idventa, idproducto)
**Mensaje devuelto por el gestor:**
ERROR:  duplicate key value violates unique constraint "uq_venta_producto"
DETAIL:  Key (idventa, idproducto)=(2, 6) already exists.

## Caso 6: Violación de `CHECK` de rango (precio)
* **Regla del dominio protegida:** El precio de un producto debe ser mayor que `0.00` (`chk_producto_precio`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO producto (nombre, precio, stock) VALUES ('Falda', 0.00, 5);
  ROLLBACK;
**Resultado esperado:** Rechazo por violar chk_producto_precio
**Mensaje devuelto por el gestor:**
ERROR:  new row for relation "producto" violates check constraint "chk_producto_precio"
DETAIL:  Failing row contains (7, Falda, 0.00, 5, Estándar).

## Caso 7: Violación de `CHECK` de rango (stock negativo)
* **Regla del dominio protegida:** Las existencias en inventario (`stock`) no pueden ser negativas (`chk_producto_stock`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO producto (nombre, precio, stock) VALUES ('Sudadera', 350.00, -1);
  ROLLBACK;
**Resultado esperado:** Rechazo por violar chk_producto_stock.
**Mensaje devuelto por el gestor:**
ERROR:  new row for relation "producto" violates check constraint "chk_producto_stock"
DETAIL:  Failing row contains (8, Sudadera, 350.00, -1, Estándar).

## Caso 8: Violación de `CHECK` de longitud / rango
* **Regla del dominio protegida:** El nombre del cliente debe tener al menos 2 caracteres (`chk_cliente_nombre_largo`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO cliente (nombre, apellidos, correo) VALUES ('A', 'Pérez', 'a@test.com');
  ROLLBACK;
**Resultado esperado:**Rechazo por violar chk_cliente_nombre_largo
**Mensaje devuelto por el gestor:**
ERROR:  new row for relation "cliente" violates check constraint "chk_cliente_nombre_largo"
DETAIL:  Failing row contains (4, A, Pérez, a@test.com, S/N).

## Caso 9: Violación de `CHECK` de formato
* **Regla del dominio protegida:** El correo electrónico debe cumplir con la validación de formato (`chk_cliente_correo`).
* **Operación intentada:**
  ```sql
  BEGIN;
  INSERT INTO cliente (nombre, apellidos, correo) VALUES ('Luis', 'Díaz', 'luis.sin.arroba');
  ROLLBACK;
**Resultado esperado:** Rechazo por violar chk_cliente_correo
**Mensaje devuelto por el gestor:**
ERROR:  new row for relation "cliente" violates check constraint "chk_cliente_correo"
DETAIL:  Failing row contains (5, Luis, Díaz, luis.sin.arroba, S/N).

## Caso 10: Violación de `CHECK` entre columnas
* **Regla del dominio protegida:** La fecha de entrega (`fecha_entrega`) no puede ser anterior a la fecha de la venta (`fecha`) (`chk_venta_fechas`).
* **Operación intentada:**
  ```sql
  BEGIN;
  WITH c AS (
      INSERT INTO cliente (nombre, apellidos, correo)
      VALUES ('Sofía', 'Mora', 'sofia@test.com')
      RETURNING idcliente
  )
  INSERT INTO venta (idcliente, fecha, fecha_entrega, total)
  SELECT idcliente, '2026-11-15 10:00:00', '2026-11-10 10:00:00', 400.00 FROM c;
  ROLLBACK;
**Resultado esperado:** Rechazo por violar la restricción CHECK entre columnas chk_venta_fechas
**Mensaje devuelto por el gestor:**
ERROR:  new row for relation "venta" violates check constraint "chk_venta_fechas"
DETAIL:  Failing row contains (4, 7, 2026-11-15 10:00:00, 400.00, 2026-11-10 10:00:00).
