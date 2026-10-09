# Data Warehouse Agrícola y Analítica de Rendimiento Operativo

Caso documental y ejemplo reproducible para consolidar producción y costos por centro y periodo.

> [!NOTE]
> **Datos sintéticos.** Este repositorio es independiente del sistema operativo. No contiene código, datos ni credenciales privadas. El ejemplo público ejecuta SQLite local; no acredita BigQuery ni una interfaz real.

[Abrir dashboard](demo/index.html) · [Ver mockup sintético](docs/images/mockup-synthetic.svg) · [Reproducir el flujo](#reproducir-el-flujo) · [Diccionario de datos](docs/data-dictionary.md) · [Verificación y límites](docs/verification.md) · [Caso de estudio](docs/case-study.md)

## Problema

Los registros de trabajo, catálogos y costos llegan por separado. Un análisis por centro y periodo debe agregar cada fuente antes de cruzarlas para no multiplicar importes. También debe conservar ceros explícitos y distinguirlos de datos ausentes.

## Ejemplo público

El flujo usa cuatro CSV ficticios, un modelo SQLite y un verificador Python de biblioteca estándar:

- Cuatro centros y seis periodos.
- Producción dividida en varios registros para comprobar la agregación.
- Un cero registrado, una combinación sin producción y otra sin costo.
- Claves únicas, referencias válidas, huellas SHA-256 y reimportación idempotente.
- Consulta SQL con grano de centro-periodo y exportación de las 24 combinaciones.
- Dashboard con filtros, producción, costos, costo unitario ponderado, tendencia y anomalías.

La página carga `examples/outputs/dashboard-data.js`, que genera `verify.py`. El mismo comando exporta `aggregated-results.csv`. HTML no tiene valores del escenario escritos en la página ni carga `scenario.json`.

El [mockup sintético](docs/images/mockup-synthetic.svg) resume indicadores y categorías del fixture público. La fuente enlazada solo se usó como referencia estructural general. El SVG no copia filas, nombres de pestañas, IDs ni valores del libro.

## Reproducir el flujo

Requiere Python 3 y SQLite, incluido en Python. No requiere paquetes externos.

```text
python examples/verify.py
```

El comando carga y valida los CSV, ejecuta la consulta, prueba los controles de duplicados y escribe:

- `examples/outputs/aggregated-results.csv`
- `examples/outputs/dashboard-data.js`

Abra `demo/index.html` para ver el dashboard. También puede iniciar un servidor local desde esta carpeta:

```text
python -m http.server 8000
```

Luego abra `http://localhost:8000/demo/`.

Para conservar la base entre ejecuciones, indique una ruta local con `--db`. El mismo archivo CSV se reconoce por su SHA-256 y no se vuelve a sumar. Un archivo cambiado con `record_id` ya usado se rechaza dentro de una transacción. Sin `--db`, cada ejecución inicia una base nueva en memoria.

```text
python examples/verify.py --db C:\temp\agricola-demo.sqlite
```

## Indicadores

El costo unitario de cada fila divide el costo agregado entre la producción agregada cuando ambos existen y la producción es mayor que cero. El indicador ponderado suma costos y unidades solo de pares completos con producción positiva. El total de costos incluye costos registrados aunque su producción falte o sea cero. El [diccionario](docs/data-dictionary.md) define filtros, faltantes y alertas.

Resultado base comprobado: 1,768 unidades registradas, MXN 12,025.00 en costos y costo unitario ponderado de MXN 6.79 para 1,713 unidades con costo completo. Los totales globales y filtrados pueden diferir porque conservan los costos sin producción.

## Aportación documentada

Diseñé el flujo de consolidación en Google Sheets tras consultar directamente las dinámicas y necesidades operativas con las áreas responsables. Estructuré la lógica de cruce de datos, el modelo de indicadores y las consultas analíticas orientadas al reporte en Looker Studio, cuidando la coherencia entre registros y costos sin duplicar importes.

La experiencia real se mantiene separada de la demostración sintética. La evidencia actual de BigQuery, sus consultas, el dashboard conectado y la interfaz original está pendiente; el ejemplo local no pretende probar esos componentes.

## Alcance observado y pendiente

Una revisión histórica del 5 de octubre de 2026 registró cuatro archivos GAS locales con 16 definiciones de función y una compilación sin errores de sintaxis. También anotó una declaración duplicada de `HOJA_LOG` en un endpoint compartido. La correspondencia entre ese endpoint y el editor quedó pendiente. No se ejecutaron consolidaciones ni escrituras remotas.

La apertura histórica de una hoja y un informe no acredita su estado actual, la conexión a BigQuery, el linaje, las definiciones de indicadores ni una captura revisada de la interfaz real. Esos elementos siguen pendientes hasta contar con evidencia actual accesible. No se publican métricas de ahorro, adopción o productividad.

## Tecnologías

| Alcance | Tecnología |
|---|---|
| Ejemplo reproducible | SQLite, Python 3, CSV |
| Solución descrita en la revisión local | Google Apps Script y Google Sheets |
| Reporte descrito históricamente | Looker Studio; conexión BigQuery pendiente de evidencia actual |

## Licencia

Pendiente de decisión expresa. No se asigna licencia de software ni se atribuyen derechos sobre código operativo.
