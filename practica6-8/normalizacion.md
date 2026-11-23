# Ejercicio 1.1. Pautas de diseño

En el esquema actual de **Boutique Style** (`practica1`), se revisa cada tabla bajo la frase *"cada fila es..."* y se contrasta con las cuatro pautas informales de diseño: **semántica clara**, **sin anomalías**, **pocos nulos** y **sin tuplas espurias**.

## 1. Definición de cada fila por tabla
* **`cliente`:** Cada fila es un cliente registrado en la tienda, identificado por `idcliente`, con su `nombre`, `apellidos`, `correo` y `telefono`.
* **`proveedor`:** Cada fila es un proveedor de mercancía para la boutique, identificado por su clave primaria, con sus datos de contacto/identificación.
* **`producto`:** Cada fila es un artículo o prenda del catálogo de la tienda, identificado por `idproducto`, con su `nombre`, `precio`, `stock` y `color`.
* **`venta`:** Cada fila es una operación o nota de venta realizada a un cliente (`idcliente`), con su fecha y `total`.
* **`compra`:** Cada fila es una orden o registro de compra de mercancía a un proveedor (`idproveedor`), con su `fecha` y `total`.
* **`detalle_venta`:** Cada fila es un renglón o partida de producto incluido dentro de una venta específica, con cantidad y precio unitario del renglón.
* **`detalle_compra`:** Cada fila es un renglón o partida de producto incluido dentro de una compra específica (`idcompra` e `idproducto`), con su `cantidad` y `precio`.

# Ejercicio 1.2. Las dependencias funcionales

## 1. Conjunto F de dependencias funcionales (basado en reglas del negocio)
- **`cliente`:**
  - `idcliente -> nombre, apellidos, correo, telefono` *(cada cliente tiene un identificador único que determina sus datos personales y de contacto)*.
  - `correo -> idcliente` *(cada correo electrónico identifica de forma única a un cliente registrado en la tienda)*.
- **`proveedor`:**
  - `idproveedor -> nombre, contacto, telefono, correo` *(cada proveedor se identifica de manera única y determina sus datos de registro y contacto)*.
- **`producto`:**
  - `idproducto -> nombre, precio, stock, color` *(cada artículo del catálogo tiene un identificador único que determina sus atributos actuales)*.
- **`venta`:**
  - `idventa -> idcliente, fecha, total` *(cada venta se identifica de manera única y determina al cliente comprador, la fecha de la operación y el monto total)*.
- **`compra`:**
  - `idcompra -> idproveedor, fecha, total` *(cada compra se identifica de manera única y determina al proveedor, la fecha de la operación y el monto total)*.
- **`detalle_venta`:**
  - `iddetalleventa -> idventa, idproducto, cantidad, precio_unitario` *(cada renglón de venta se identifica de forma única y determina la venta, el producto, la cantidad vendida y el precio acordado en ese renglón)*.
  - `(idventa, idproducto) -> cantidad, precio_unitario` *(en una misma venta, un producto aparece a lo más una vez por renglón, determinando cantidad y precio del renglón)*.
- **`detalle_compra`:**
  - `iddetallecompra -> idcompra, idproducto, cantidad, precio` *(cada renglón de compra se identifica de forma única y determina la compra, el producto, la cantidad y el precio del renglón)*.
  - `(idcompra, idproducto) -> cantidad, precio` *(en una misma compra, un producto se registra por renglón determinando su cantidad y precio)*.

## 2. Cierre de atributos y claves candidatas por tabla
- **`cliente`:**
  - `{idcliente}+ = {idcliente, nombre, apellidos, correo, telefono}` -> incluye todos los atributos (clave candidata).
  - `{correo}+ = {correo, idcliente, nombre, apellidos, telefono}` -> incluye todos los atributos (segunda clave candidata).
- **`proveedor`:**
  - `{idproveedor}+ = {idproveedor, nombre, contacto, telefono, correo}` -> determina todos los atributos de la tabla (clave candidata).
- **`producto`:**
  - `{idproducto}+ = {idproducto, nombre, precio, stock, color}` -> determina todos los atributos de la tabla (clave candidata).
- **`venta`:**
  - `{idventa}+ = {idventa, idcliente, fecha, total}` -> determina todos los atributos de la tabla (clave candidata).
- **`compra`:**
  - `{idcompra}+ = {idcompra, idproveedor, fecha, total}` -> determina todos los atributos de la tabla (clave candidata).
- **`detalle_venta`:**
  - `{iddetalleventa}+ = {iddetalleventa, idventa, idproducto, cantidad, precio_unitario}` -> clave candidata.
  - `{idventa, idproducto}+ = {idventa, idproducto, iddetalleventa, cantidad, precio_unitario}` -> clave candidata.
- **`detalle_compra`:**
  - `{iddetallecompra}+ = {iddetallecompra, idcompra, idproducto, cantidad, precio}` -> clave candidata.
  - `{idcompra, idproducto}+ = {idcompra, idproducto, iddetallecompra, cantidad, precio}` -> clave candidata.

## 3. Reducción de F a un conjunto mínimo (cubrimiento canónico)
1. **Lados derechos simples (descomposición):** Se separa cada dependencia con varios atributos a la derecha en dependencias con un solo atributo en el lado derecho (por ejemplo, `idcliente -> nombre`, `idcliente -> apellidos`, `idcliente -> correo`, `idcliente -> telefono`).
2. **Eliminación de atributos extraños en lados izquierdos:** En las claves compuestas como `(idventa, idproducto) -> cantidad`, ni `{idventa}+` ni `{idproducto}+` determinan por sí solos la cantidad del renglón, por lo que no hay atributos sobrantes en el lado izquierdo.
3. **Eliminación de dependencias redundantes:** Para cada dependencia `X -> Y` restante, se calcula el cierre de `X` usando el conjunto restante sin esa dependencia; si `Y` pertenece a `X+`, la dependencia es redundante y se elimina. Al no haber dependencias transitivas extra entre atributos no clave en estas tablas, se conservan las dependencias directas irreducibles.

## 4. Equivalencia de conjuntos de dependencias funcionales
Para comprobar si un conjunto `F` y otro conjunto `G` (obtenido de otro equipo del mismo dominio) son equivalentes (`F ≡ G`), se verifica que cada dependencia en `F` se derive del cierre bajo `G` y que cada dependencia en `G` se derive del cierre bajo `F` (es decir, `X+_F` contiene los atributos de `G` para cada `X -> Y` en `G`, y `Z+_G` contiene los atributos de `F` para cada `Z -> W` en `F`).