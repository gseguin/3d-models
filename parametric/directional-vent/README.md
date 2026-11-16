# Directional Vent

A highly restrictive, directional HVAC ceiling vent insert for a 242 × 140 mm rectangular duct opening with a 29 mm lip. It throttles airflow down to ~1–5 % of the duct's capacity and steers the remaining air sideways (east/west) and forward (north).

## Parts

| `part` | What it is |
|---|---|
| `vent` (default) | Lip plate, insert walls, 49° slats, and dividers. |
| `throttle` | A flat plate that drops into the vent's lower cavity from the duct side and sets the restriction through its slot sizes. Print a new one to change airflow, and keep the vent body. |

The throttle is held and sealed with HVAC aluminium foil tape applied from the duct side.

## Files

- `directional-vent.scad`: the model.
- `directional-vent.json`: Customizer sets. "New set 1" is the current production print.
- `directional-vent-test.scad`: geometric invariant tests.
- `directional-vent.md`: design contract (constraints, rationale, change-impact map).

## Render

```bash
openscad -p directional-vent.json -P "New set 1" -o vent.stl directional-vent.scad
openscad -p directional-vent.json -P "New set 1" -D 'part="throttle"' -o throttle.stl directional-vent.scad
openscad -p directional-vent.json -P "New set 1" -o /tmp/x.stl directional-vent-test.scad   # tests
```

## Print

Designed for a 0.6 mm nozzle in PETG, which tolerates duct temperatures that soften PLA.

- Lip face **down** on the bed; slats and dividers point up.
- 0.32 mm layers, 3 perimeters.
- No supports.
- A 4–6 mm brim keeps the 240 mm lip from lifting at the corners.
- Bed 70–80 °C, nozzle 235–245 °C.
