# Ejercicio 1.1. Pautas de diseño

En el esquema actual de **Boutique Style** (`practica1`), se revisa cada tabla bajo la frase *"cada fila es..."* y se contrasta con las cuatro pautas informales de diseño: **semántica clara**, **sin anomalías**, **pocos nulos** y **sin tuplas espurias**[cite: 24, 28, 32].

## 1. Definición de cada fila por tabla
* **`cliente`:** Cada fila es un cliente registrado en la tienda, identificado por `idcliente`, con su `nombre`, `apellidos`, `correo` y `telefono`.
* **`proveedor`:** Cada fila es un proveedor de mercancía para la boutique, identificado por su clave primaria, con sus datos de contacto/identificación.
* **`producto`:** Cada fila es un artículo o prenda del catálogo de la tienda, identificado por `idproducto`, con su `nombre`, `precio`, `stock` y `color`.
* **`venta`:** Cada fila es una operación o nota de venta realizada a un cliente (`idcliente`), con su fecha y `total`[cite: 2, 32].
* **`compra`:** Cada fila es una orden o registro de compra de mercancía a un proveedor (`idproveedor`), con su `fecha` y `total`.
* **`detalle_venta`:** Cada fila es un renglón o partida de producto incluido dentro de una venta específica, con cantidad y precio unitario del renglón.
* **`detalle_compra`:** Cada fila es un renglón o partida de producto incluido dentro de una compra específica (`idcompra` e `idproducto`), con su `cantidad` y `precio`.

## 2. Revisión contra las 4 pautas informales
* **Semántica clara:** Se cumple en las 7 tablas porque cada entidad o relación de detalle representa un concepto único del dominio de la boutique (`cliente`, `proveedor`, `producto`, `venta`, `compra`, `detalle_venta` y `detalle_compra`) sin mezclar entidades distintas en la misma fila[cite: 1, 24, 32].
* **Pocos nulos:** En general se respeta, ya que las columnas clave y campos obligatorios están marcados como `NOT NULL` (`is_nullable = NO`), dejando nulos únicamente en campos opcionales como `telefono` en `cliente` (`is_nullable = YES`)[cite: 24, 32].
* **Sin tuplas espurias:** Al separar las tablas maestras (`cliente`, `proveedor`, `producto`), las cabeceras (`venta`, `compra`) y las tablas de detalle (`detalle_venta`, `detalle_compra`), se evitan uniones ambiguas o combinaciones sin sentido entre clientes, proveedores y productos[cite: 1, 24, 32].
* **Sin anomalías (punto a vigilar):** Aunque la separación de tablas reduce anomalías de inserción y borrado frente a una tabla universal, **puede presentarse anomalía de actualización o inconsistencia derivada** en columnas calculadas/redundantes como `total` en `venta` y `compra` o `stock` en `producto` si no se mantienen sincronizadas con los renglones de `detalle_venta` / `detalle_compra`[cite: 32]. Asimismo, si en `producto` se guarda `color` como texto libre sin catálogo o convención uniforme, pueden colarse variaciones de escritura al actualizar o filtrar[cite: 3].