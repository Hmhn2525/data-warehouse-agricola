# Caso de estudio: Data Warehouse Agrícola y Analítica de Rendimiento Operativo

## Necesidad

Organizar registros de trabajo, catálogos y movimientos operativos para su consulta analítica, manteniendo coherencia temporal y trazabilidad.

## Aportación documentada

Este caso organiza la revisión de fuentes, pruebas sintéticas, arquitectura y límites de una solución asociada al portafolio. La revisión no acredita autoría exclusiva de todos sus componentes. Los detalles de responsabilidades históricas requieren evidencia adicional antes de ampliarlos.

## Decisiones observadas

La fuente separa consolidación, catálogos y utilidades. Este caso distingue lo inspeccionado en GAS de la integración analítica reportada. El ejemplo SQL público usa un esquema ficticio propio, sin pretender reproducir consultas empresariales.

## Evidencia

El 5 de octubre de 2026 se abrieron la hoja y el informe facilitados y se revisaron cuatro archivos GAS con 16 definiciones de función. La compilación conjunta de la copia inspeccionada no detectó errores de sintaxis. El endpoint compartido mostró una declaración duplicada de HOJA_LOG: la correspondencia entre ese despliegue y el editor queda pendiente. No se ejecutaron consolidaciones ni escrituras remotas.

El [recorrido ilustrativo](../demo/index.html) usa datos inventados y no demuestra ejecución de la aplicación original. La imagen conserva esa identificación explícita.

## Aprendizajes

Un informe accesible no certifica el linaje ni la actualización de todos sus datos. Antes de calcular costos unitarios hay que definir el grano, evitar multiplicar importes al unir hechos y conservar casos sin producción.

## Próxima fase

- Resolver la declaración duplicada de HOJA_LOG y comprobar la versión desplegada en una fase técnica.
- Verificar consultas SQL, conexión BigQuery, linaje y definiciones de indicadores.
- Validar consolidación, duplicados y recuperación sobre una copia con datos ficticios.
- Acreditar modelo dimensional, latencia y resultados operativos antes de afirmarlos.
- Confirmar responsabilidades históricas y decidir licencia.
