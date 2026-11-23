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

## 2. Revisión contra las 4 pautas informales
* **Semántica clara:** Se cumple en las 7 tablas porque cada entidad o relación de detalle representa un concepto único del dominio de la boutique (`cliente`, `proveedor`, `producto`, `venta`, `compra`, `detalle_venta` y `detalle_compra`) sin mezclar entidades distintas en la misma fila.
* **Pocos nulos:** En general se respeta, ya que las columnas clave y campos obligatorios están marcados como `NOT NULL` (`is_nullable = NO`), dejando nulos únicamente en campos opcionales como `telefono` en `cliente` (`is_nullable = YES`).
* **Sin tuplas espurias:** Al separar las tablas maestras (`cliente`, `proveedor`, `producto`), las cabeceras (`venta`, `compra`) y las tablas de detalle (`detalle_venta`, `detalle_compra`), se evitan uniones ambiguas o combinaciones sin sentido entre clientes, proveedores y productos.
* **Sin anomalías (punto a vigilar):** Aunque la separación de tablas reduce anomalías de inserción y borrado frente a una tabla universal, **puede presentarse anomalía de actualización o inconsistencia derivada** en columnas calculadas/redundantes como `total` en `venta` y `compra` o `stock` en `producto` si no se mantienen sincronizadas con los renglones de `detalle_venta` / `detalle_compra`[cite: 32]. Asimismo, si en `producto` se guarda `color` como texto libre sin catálogo o convención uniforme, pueden colarse variaciones de escritura al actualizar o filtrar.


# Ejercicio 1.2. Las dependencias funcionales

## 1. Conjunto F de dependencias funcionales (basado en reglas del negocio)
* **`cliente`:**
  * $\text{idcliente} \rightarrow \text{nombre}, \text{apellidos}, \text{correo}, \text{telefono}$ *(cada cliente tiene un identificador único que determina sus datos personales y de contacto)*[cite: 29].
  * $\text{correo} \rightarrow \text{idcliente}$ *(cada correo electrónico identifica de forma única a un cliente registrado en la tienda)*.
* **`proveedor`:**
  * $\text{idproveedor} \rightarrow \text{nombre}, \text{contacto}, \text{telefono}, \text{correo}$ *(cada proveedor se identifica de manera única y determina sus datos de registro y contacto)*.
* **`producto`:**
  * $\text{idproducto} \rightarrow \text{nombre}, \text{precio}, \text{stock}, \text{color}$ *(cada artículo del catálogo tiene un identificador único que determina sus atributos actuales)*.
* **`venta`:**
  * $\text{idventa} \rightarrow \text{idcliente}, \text{fecha}, \text{total}$ *(cada venta se identifica de manera única y determina al cliente comprador, la fecha de la operación y el monto total)*.
* **`compra`:**
  * $\text{idcompra} \rightarrow \text{idproveedor}, \text{fecha}, \text{total}$ *(cada compra se identifica de manera única y determina al proveedor, la fecha de la operación y el monto total)*[cite: 29].
* **`detalle_venta`:**
  * $\text{iddetalleventa} \rightarrow \text{idventa}, \text{idproducto}, \text{cantidad}, \text{precio\_unitario}$ *(cada renglón de venta se identifica de forma única y determina la venta, el producto, la cantidad vendida y el precio acordado en ese renglón)*.
  * $(\text{idventa}, \text{idproducto}) \rightarrow \text{cantidad}, \text{precio\_unitario}$ *(en una misma venta, un producto aparece a lo más una vez por renglón, determinando cantidad y precio del renglón)*.
* **`detalle_compra`:**
  * $\text{iddetallecompra} \rightarrow \text{idcompra}, \text{idproducto}, \text{cantidad}, \text{precio}$ *(cada renglón de compra se identifica de forma única y determina la compra, el producto, la cantidad y el precio del renglón)*[cite: 29].
  * $(\text{idcompra}, \text{idproducto}) \rightarrow \text{cantidad}, \text{precio}$ *(en una misma compra, un producto se registra por renglón determinando su cantidad y precio)*[cite: 29].

## 2. Cierre de atributos y claves candidatas por tabla
* **`cliente`:**
  * $\{\text{idcliente}\}^+ = \{\text{idcliente}, \text{nombre}, \text{apellidos}, \text{correo}, \text{telefono}\}$[cite: 29] $\rightarrow$ incluye todos los atributos (clave candidata).
  * $\{\text{correo}\}^+ = \{\text{correo}, \text{idcliente}, \text{nombre}, \text{apellidos}, \text{telefono}\}$[cite: 29] $\rightarrow$ incluye todos los atributos (segunda clave candidata).
* **`proveedor`:**
  * $\{\text{idproveedor}\}^+ = \{\text{idproveedor}, \text{nombre}, \text{contacto}, \text{telefono}, \text{correo}\}$ $\rightarrow$ determina todos los atributos de la tabla (clave candidata).
* **`producto`:**
  * $\{\text{idproducto}\}^+ = \{\text{idproducto}, \text{nombre}, \text{precio}, \text{stock}, \text{color}\}$ $\rightarrow$ determina todos los atributos de la tabla (clave candidata).
* **`venta`:**
  * $\{\text{idventa}\}^+ = \{\text{idventa}, \text{idcliente}, \text{fecha}, \text{total}\}$ $\rightarrow$ determina todos los atributos de la tabla (clave candidata).
* **`compra`:**
  * $\{\text{idcompra}\}^+ = \{\text{idcompra}, \text{idproveedor}, \text{fecha}, \text{total}\}$[cite: 29] $\rightarrow$ determina todos los atributos de la tabla (clave candidata).
* **`detalle_venta`:**
  * $\{\text{iddetalleventa}\}^+ = \{\text{iddetalleventa}, \text{idventa}, \text{idproducto}, \text{cantidad}, \text{precio\_unitario}\}$ $\rightarrow$ clave candidata.
  * $\{\text{idventa}, \text{idproducto}\}^+ = \{\text{idventa}, \text{idproducto}, \text{iddetalleventa}, \text{cantidad}, \text{precio\_unitario}\}$ $\rightarrow$ clave candidata.
* **`detalle_compra`:**
  * $\{\text{iddetallecompra}\}^+ = \{\text{iddetallecompra}, \text{idcompra}, \text{idproducto}, \text{cantidad}, \text{precio}\}$[cite: 29] $\rightarrow$ clave candidata.
  * $\{\text{idcompra}, \text{idproducto}\}^+ = \{\text{idcompra}, \text{idproducto}, \text{iddetallecompra}, \text{cantidad}, \text{precio}\}$[cite: 29] $\rightarrow$ clave candidata.

## 3. Reducción de $F$ a un conjunto mínimo (cubrimiento canónico)
1. **Lados derechos simples (descomposición):** Se separa cada dependencia con varios atributos a la derecha en dependencias con un solo atributo en el lado derecho (por ejemplo, $\text{idcliente} \rightarrow \text{nombre}$, $\text{idcliente} \rightarrow \text{apellidos}$, $\text{idcliente} \rightarrow \text{correo}$, $\text{idcliente} \rightarrow \text{telefono}$[cite: 29]).
2. **Eliminación de atributos extraños en lados izquierdos:** En las claves compuestas como $(\text{idventa}, \text{idproducto}) \rightarrow \text{cantidad}$, ni $\{\text{idventa}\}^+$ ni $\{\text{idproducto}\}^+$ determinan por sí solos la cantidad del renglón, por lo que no hay atributos sobrantes en el lado izquierdo.
3. **Eliminación de dependencias redundantes:** Para cada dependencia $\alpha \rightarrow \beta$ restante, se calcula el cierre de $\alpha$ usando el conjunto restante sin esa dependencia; si $\beta \in \alpha^+$, la dependencia es redundante y se elimina (por ejemplo, si una dependencia se deduce transitivamente a partir de otras ya presentes). Al no haber dependencias transitivas extra entre atributos no clave en estas tablas, se conservan las dependencias directas irreducibles.

## 4. Equivalencia de conjuntos de dependencias funcionales
Para comprobar si un conjunto $F$ y otro conjunto $G$ (obtenido de otro equipo del mismo dominio) son equivalentes ($F \equiv G$), se verifica que cada dependencia en $F$ se derive del cierre bajo $G$ y que cada dependencia en $G$ se derive del cierre bajo $F$ (es decir, $\alpha^+_F$ contiene los atributos de $G$ para cada $\alpha \rightarrow \beta \in G$, y $\gamma^+_G$ contiene los atributos de $F$ para cada $\gamma \rightarrow \delta \in F$).