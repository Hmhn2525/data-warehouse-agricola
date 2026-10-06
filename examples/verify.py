from pathlib import Path
import json
from decimal import Decimal

data = json.loads(Path(__file__).with_name('scenario.json').read_text(encoding='utf-8'))
assert data['synthetic'] is True
assert Decimal(data['expected_cost_cents']) / 100 / Decimal(data['expected_units']) == Decimal(data['expected_cost_per_unit'])
assert data['illustrative_only'] is True
assert data['center'].startswith('DEMO-')
print('Ejemplo sintético coherente; no ejecuta ni valida el sistema operativo.')

import sqlite3

db = sqlite3.connect(':memory:')
db.executescript(Path(__file__).with_name('model.sql').read_text(encoding='utf-8'))
rows = {row[0]: row for row in db.execute('SELECT * FROM synthetic_unit_cost')}
assert rows['DEMO-CC-001'][2:] == (100, 50000, 5.0)
assert rows['DEMO-CC-002'][2:] == (0, 12500, None)
assert rows['DEMO-CC-003'][2:] == (10, None, None)
assert rows['DEMO-CC-004'][2:] == (None, 1000, None)
try:
    db.execute("INSERT INTO production VALUES ('DEMO-P-001','DEMO-CC-001','2026-01',40)")
except sqlite3.IntegrityError:
    pass
else:
    raise AssertionError('El ejemplo debe rechazar una clave repetida')
db.close()
print('SQL sintético: agregación sin multiplicación, ceros, faltantes y clave repetida comprobados.')


def show(value, cents=False):
    if value is None:
        return '-'
    return f'{value / 100:.2f}' if cents else f'{value:.2f}' if isinstance(value, float) else str(value)


print(f"{'Centro':<12} {'Periodo':<8} {'Unidades':>8} {'Costo':>8} {'Costo/u':>8}")
for center in sorted(rows):
    _, period, units, cost_cents, cost_per_unit = rows[center]
    print(f'{center:<12} {period:<8} {show(units):>8} {show(cost_cents, cents=True):>8} {show(cost_per_unit):>8}')
