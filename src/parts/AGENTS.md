# src/parts/AGENTS.md

One printable part per `<part>.scad`. A part with non-trivial geometry ships as four files:

1. `<part>.scad`: the model.
2. `<part>.json`: Customizer parameter sets.
3. `<part>-test.scad`: geometric assertions.
4. `<part>.md`: the **design contract**: constraints, decisions, alternatives ruled out, change-impact map.

`directional-vent` is the reference example. In `directional-vent.json`, "New set 1" is the current production print; run its tests against that set.

## Modifying a part

1. Read the part's design contract (`<part>.md`) first, when one exists.
2. Make the minimal change.
3. Run `<part>-test.scad`. When an invariant changes on purpose, update its test in the same change.
4. Re-render the default part and every set in `<part>.json`. Done when each one renders cleanly.
5. Bring `<part>.md` in line with the new state whenever the change touches a constraint, decision, or the change-impact map.

## Multi-part dispatch

A file that yields several printables selects one with a top-level `part` dropdown:

```scad
// [vent, throttle]
part = "vent";

if (part == "vent")          vent_body();
else if (part == "throttle") throttle();
```

Render a non-default part with `openscad -D 'part="throttle"' -o throttle.stl directional-vent.scad`.

## Tests

Top-level `assert()` statements in `<part>-test.scad`; OpenSCAD itself is the runner, and a failed assert exits non-zero with the failing assertion on stderr.

- One test per geometric invariant (slat angle, plate dimensions, channel Z, ...).
- Letter-prefix each label (`A:`, `B:`, ...) so messages can cite it.
- `echo()` actual and expected values before each `assert()`, so a failure explains itself.
- Where a target can fall below the printable floor (e.g. open area undercutting the minimum slot), encode the floor as an alternative pass condition.

## File layout

`// ----------` rule lines separate logical sections. Parameters group under `// [Section Name]` headers, which the Customizer shows as tabs. Print settings sit in a `Print settings:` comment block at the top of each file.

## Print limits (H2D, 0.6 mm nozzle, PETG)

- Walls in 0.6 mm multiples: 1.2 (2 perimeters), 1.8 (3), 2.4 (4).
- Narrowest printable slot: ~1.2 mm.
- Longest clean bridge: ~40 mm.
- Unsupported overhang: up to ~50° from vertical.
- Layer height: 0.32 mm typical (0.3–0.4 mm range).
- Brim: 4–6 mm on wide flanges (>200 mm).
- Design support-free; a part that needs supports names where in its header comment.
