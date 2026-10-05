-- SQLite: esquema pedagógico independiente. No reproduce el esquema empresarial.
CREATE TABLE production (
    record_id TEXT PRIMARY KEY,
    center TEXT NOT NULL,
    period TEXT NOT NULL,
    units INTEGER NOT NULL CHECK (units >= 0)
);
CREATE TABLE costs (
    record_id TEXT PRIMARY KEY,
    center TEXT NOT NULL,
    period TEXT NOT NULL,
    cost_cents INTEGER NOT NULL
);

INSERT INTO production VALUES
('DEMO-P-001', 'DEMO-CC-001', '2026-01', 40),
('DEMO-P-002', 'DEMO-CC-001', '2026-01', 60),
('DEMO-P-003', 'DEMO-CC-002', '2026-01', 0),
('DEMO-P-004', 'DEMO-CC-003', '2026-01', 10);
INSERT INTO costs VALUES
('DEMO-C-001', 'DEMO-CC-001', '2026-01', 20000),
('DEMO-C-002', 'DEMO-CC-001', '2026-01', 30000),
('DEMO-C-003', 'DEMO-CC-002', '2026-01', 12500),
('DEMO-C-004', 'DEMO-CC-004', '2026-01', 1000);

-- Agregar cada hecho antes de unir: evita duplicar costos y producción.
CREATE VIEW synthetic_unit_cost AS
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
