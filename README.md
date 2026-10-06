# Data Warehouse Agrícola y Analítica de Rendimiento Operativo

Consolidación de registros operativos en Google Sheets y ejemplo SQL reproducible de costo por unidad.

> [!NOTE]
> **Repositorio documental.** El código operativo y sus datos son privados. Aquí se publican documentación nueva, datos ficticios y un ejemplo SQL ejecutable.

[Probar el ejemplo](#probar-el-ejemplo) · [Caso de estudio](docs/case-study.md) · [Arquitectura](docs/architecture.md) · [Verificación y límites](docs/verification.md)

## Problema

Los registros de trabajo, catálogos y movimientos operativos llegan por separado. Para consultarlos de forma analítica hay que consolidarlos con coherencia temporal y trazabilidad, sin duplicar importes al cruzar fuentes.

## Solución

Un proyecto Google Apps Script ligado a Google Sheets separa consolidación, autocompletado y validación de entradas, depuración de duplicados y registro de eventos. Un informe Looker Studio presenta la información consolidada.

![Recorrido documental con datos ficticios: consolidación por centro y periodo](docs/images/recorrido-demo.png)

*Recorrido ilustrativo con valores inventados. No es la interfaz original ni ejecuta su backend.*

## Aportación personal

<!-- APORTACION-PERSONAL: sustituir tras la confirmación agrupada de responsabilidades. -->
Las responsabilidades personales específicas se publicarán después de confirmarlas. Este repositorio no atribuye autoría exclusiva del código operativo; presenta el caso, la arquitectura observada y un ejemplo reproducible.

## Pregunta analítica del ejemplo

> ¿Cuál es el costo por unidad de cada centro y periodo, sin duplicar costos ni producción al unir ambas fuentes?

El [modelo SQL](examples/model.sql) responde con **SQLite** en memoria y datos ficticios. Agrega cada hecho por centro y periodo antes de unirlos:

```sql
WITH p AS (
    SELECT center, period, SUM(units) AS units FROM production GROUP BY center, period
), c AS (
    SELECT center, period, SUM(cost_cents) AS cost_cents FROM costs GROUP BY center, period
), keys AS (
    SELECT center, period FROM p UNION SELECT center, period FROM c
)
SELECT keys.center, keys.period, p.units, c.cost_cents,
       CASE WHEN p.units > 0 AND c.cost_cents IS NOT NULL
            THEN CAST(c.cost_cents AS REAL) / 100 / p.units
            ELSE NULL END AS cost_per_unit
FROM keys
LEFT JOIN p ON p.center = keys.center AND p.period = keys.period
LEFT JOIN c ON c.center = keys.center AND c.period = keys.period;
```

Resultado comprobado por `examples/verify.py` para el periodo ficticio 2026-01:

| Centro ficticio | Unidades | Costo | Costo por unidad | Tratamiento |
|---|---:|---:|---:|---|
| DEMO-CC-001 | 100 | 500.00 | 5.00 | Dos registros por fuente, sin duplicar importes |
| DEMO-CC-002 | 0 | 125.00 | — | Producción cero: no se divide |
| DEMO-CC-003 | 10 | — | — | Producción sin costo registrado |
| DEMO-CC-004 | — | 10.00 | — | Costo sin producción registrada |

El esquema también rechaza un identificador de registro repetido. Es un ejemplo pedagógico independiente: no es una exportación de BigQuery ni una réplica del modelo real.

## Probar el ejemplo

Requiere Python 3 y su biblioteca estándar. Desde la raíz del repositorio:

```text
python examples/verify.py
```

Para ver el recorrido, abra [demo/index.html](demo/index.html) en un navegador. Funciona sin servidor ni conexión a servicios; usa [datos sintéticos](examples/scenario.json).

## Resultados comprobados

- **Consolidación trazable:** la fuente revisada separa consolidación, validación, depuración de duplicados y registro de eventos (cuatro archivos GAS, 16 definiciones de función, 5 de octubre de 2026).
- **Cruce sin duplicar importes:** el ejemplo agrega antes de unir y conserva como casos explícitos la producción cero y los datos faltantes.
- **Informe accesible:** la hoja y el informe Looker Studio facilitados abrieron durante la revisión.

No se publican métricas de ahorro, adopción o productividad.

## Tecnologías

| Alcance | Tecnologías |
|---|---|
| Observadas en la fuente | Google Apps Script, Google Sheets, Looker Studio |
| Ejemplo público | SQL sobre SQLite, Python (biblioteca estándar) |
| Reportada, pendiente de inspección | BigQuery y sus consultas SQL conectadas al informe |

## Límites

- La integración BigQuery y sus consultas no se inspeccionaron; el SQL público es un modelo SQLite independiente.
- El endpoint compartido muestra una declaración duplicada de `HOJA_LOG`; la copia del editor pasa sintaxis y su correspondencia con el despliegue está pendiente.
- No se ejecutaron consolidaciones ni escrituras remotas.

Detalle técnico y condiciones pendientes: [verificación y límites](docs/verification.md).

## Licencia

Pendiente de decisión expresa. No se asigna una licencia de software ni se atribuyen derechos sobre el código operativo.
