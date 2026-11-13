# src/parts/CLAUDE.md

Guidance for working in this directory (OpenSCAD source for individual printable parts).

## Files

| File | Purpose |
|---|---|
| `directional-vent.scad` | Highly restrictive directional HVAC vent (E/W/N deflection, slide-in throttle plate). See `directional-vent.md` for design contract. |
| `directional-vent.json` | Customizer parameter sets for the vent (e.g. "New set 1" = current production print). |
| `directional-vent-test.scad` | Assertion-based geometric tests for the vent (Tests A–S). |
| `directional-vent.md` | Design contract: constraints, decisions, alternatives ruled out, change-impact map. **Read this before modifying `directional-vent.scad`.** |
| `gf-silverware-bin.scad` | (Standalone part — no design doc yet.) |
| `h2d-pen-adapter.scad` | (Standalone part — no design doc yet.) |
| `snapware-lid-holder.scad` | Under-shelf ladder rack for Snapware lids; Costco set presets, auto-split into interlocking pieces. See `snapware-lid-holder.md`. |
| `snapware-lid-holder.json` | Customizer sets: the older and newer Costco sets as measured, plus "New set 1". |
| `snapware-lid-holder-test.scad` | Assertion tests A–S (preset counts, exact stops, hook in front of each stop, clamp ends on hooks, nothing behind a stop, hook gap ≤ clamp contact, bed fit, joints, weight-balanced intermediate screws). |

When adding a new part with non-trivial geometry, follow the **directional-vent pattern**:
1. `<part>.scad` — the model, with multi-part dispatch if needed.
2. `<part>.json` — Customizer parameter sets.
3. `<part>-test.scad` — geometric assertions.
4. `<part>.md` — design contract for future contributors and AI assistants.

## OpenSCAD Patterns Used Here

### Multi-part dispatch

A single `.scad` file can produce multiple printable parts via a top-level `part` variable:

```scad
// [vent, throttle]
part = "vent";

if (part == "vent")          vent_body();
else if (part == "throttle") throttle();
```

The `// [vent, throttle]` annotation makes it a dropdown in the OpenSCAD Customizer.

To render a non-default part from the CLI:

```bash
openscad -D 'part="throttle"' -o throttle.stl directional-vent.scad
```

### Customizer JSON parameter sets

Saved presets live in `<part>.json`. The file format is the OpenSCAD Customizer export. To render with a preset:

```bash
openscad -p directional-vent.json -P "New set 1" -o vent.stl directional-vent.scad
```

A `.json` parameter overrides the `.scad` default but is itself overridden by `-D` flags.

### Geometric tests with assertions

Tests are top-level `assert()` statements in a separate `<part>-test.scad`. Each test echoes its actual/expected values, then asserts the invariant. The runner is OpenSCAD itself — assert failures abort with a non-zero exit code:

```bash
openscad -p directional-vent.json -P "New set 1" -o /tmp/discard.stl directional-vent-test.scad
# RC=0 → all tests passed; RC=1 → failure (see stderr for the failing assertion)
```

Test conventions:
- One test per geometric invariant (slat angle, plate dimensions, channel Z, etc.).
- Letter-prefixed labels (`A:`, `B:`, ...) for easy reference in messages.
- Always emit `echo()` with actual + expected values BEFORE the assert, so failure output is self-explanatory.
- For tests that should still pass at the "printable floor" (e.g. open-area target undercutting min-printable-slot), encode the floor case as an alternative pass condition rather than a hard equality.

### Convention: `// ----` section banners

Long files use `// ----------` rule lines to separate logical sections. Parameter blocks are grouped under `// [Section Name]` headers, also recognized by the OpenSCAD Customizer.

## Print Defaults (Bambu H2D, 0.6 mm nozzle, PETG)

Per-file print settings live at the top of each `.scad` file in a `Print settings:` comment block. Default expectations:

- **Wall multiples of 0.6 mm:** 1.2 (2 perim), 1.8 (3 perim), 2.4 (4 perim).
- **Min printable slot width:** ~1.2 mm (2 perimeters).
- **Min printable bridge:** ~40 mm in PETG without sagging.
- **Overhang limit:** ~50° from vertical without support in PETG.
- **Layer height:** 0.32 mm typical (0.3–0.4 mm range).
- **Brim:** 4–6 mm on parts with wide flanges (>200 mm).
- **Supports:** prefer no-support designs; if needed, document where in the part's header comment.

## When Modifying a Part

1. Read the part's `.md` design contract first (if present).
2. Make the minimal change.
3. Run the test file. If a geometric invariant changes intentionally, update the relevant test.
4. Re-render both the default part and any saved Customizer parameter sets to confirm nothing broke.
5. If the change is non-trivial, update `<part>.md` to reflect the new state.
