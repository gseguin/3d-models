# Directional Vent — Design Contract

> **Read this before modifying `directional-vent.scad`.** It captures the design decisions, constraints, and rationale that the code alone doesn't make obvious. Inline comments in the SCAD file describe *what* each module does; this document describes *why* the design is the way it is.

## Purpose

A highly restrictive directional HVAC ceiling vent for a 242 × 140 mm rectangular duct opening. Used to throttle airflow into a room down to ~1–5% of the duct's natural capacity while still directing the metered air laterally (East/West) and forward (North).

## Print Target

- **Printer:** Bambu H2D
- **Nozzle:** 0.6 mm
- **Material:** PETG (compatibility with duct temperatures up to ~60 °C; PLA softens at 50 °C)
- **Layer height:** 0.32 mm
- **Orientation:** lip face **down** on the bed; insert walls rise upward.
- **Supports:** required only for a small 1.8 × 5 × 135 mm strip of the E perimeter wall above the throttle opening. Auto-detected by Bambu Studio. All other features are no-support.

## Parts

The file produces **two** printable parts, selected by the `part` parameter:

| `part` | Module | What it is |
|---|---|---|
| `"vent"` (default) | `vent_body()` | The main vent. Lip plate + rim + insert walls + slats + dividers + throttle channel rails + W-notch. |
| `"throttle"` | `throttle()` | A flat removable plate that slides into the vent body's channel from the E side. Sets the airflow restriction via slot dimensions. |

To swap the open-area setting, print a new throttle (cheap, ~10 minutes) and replace the old one — no need to reprint the vent body.

## Hard Constraints

These are **load-bearing** design choices. Don't change them without re-deriving the affected geometry.

1. **Lip-down print orientation.** Slats overhang at ~25° from horizontal; printing slats-down would require supports through the slat channels.
2. **Slat angle is FIXED (`fixed_slat_angle = 65°`), independent of the open-area target.** The previous design solved for slat angle as a function of `*_open_area`, which produced welded slats at low open-area targets (≤5%). The current design decouples direction (slats) from restriction (throttle plate slots). **Do not re-introduce an open-area solver on the slat angle.**
3. **Throttle plate sits BELOW the slats** (deeper into the duct). Airflow chain: `duct → throttle → slats → lip → room`. The throttle meters; the slats steer the metered air.
4. **Throttle plate is a separate printed part.** It slides into a channel formed by top + bottom rails on the N/S/W walls. The E perimeter wall has a horizontal opening through which the plate slides in. Aluminum duct tape over the E opening secures the plate.
5. **No clip retention on the throttle plate.** Previous designs used cantilever fingers + groove undercuts; this caused floating-bump geometry and CSG manifold issues, and was hard to remove for swapping. Slide-in + tape is mechanically simpler and lets the user re-tape after each swap.
6. **Dividers terminate at the throttle plate's TOP face (z = -13.8).** Going lower causes them to collide with the plate; going higher leaves an air leak between zones above the plate. The current value is `throttle_ledge_top_z + throttle_plate_thickness`.

## Coordinate System

- **X axis** = 242 mm direction = East (+) / West (−)
- **Y axis** = 140 mm direction = North (+) / South (−)
- **Z axis** = +Z into the room (away from the duct), −Z into the duct
- **z = 0** is the lip's top face (the surface against the room ceiling)
- **z = −lip_thickness** is the lip's underside
- **z = −lip_thickness − insert_height** is the deepest point of the insert (the duct end)

## Key Derived Z Values (with current params)

| Name | Z value | Meaning |
|---|---:|---|
| `0` | 0 | Lip top (room-facing surface) |
| `-lip_thickness` | -1.8 | Lip bottom |
| `slat_top_z` | 0 | Top of slats (anchored to lip) |
| `-slat_drop·cos(angle)` | ~-5.9 | Bottom of slat tips |
| `dividers_bottom_z` | -13.8 | Divider bottoms; rests on throttle plate top |
| `throttle_top_rail_top_z` | -12.4 | Top of top rail |
| `throttle_top_rail_bottom_z` | -13.6 | Bottom of top rail = top of channel |
| `throttle_ledge_top_z` | -15.0 | Top of bottom rail = plate bottom face |
| `throttle_ledge_top_z - rail_h` | -17.0 | Bottom of bottom rail |
| `-lip_thickness - insert_height` | -23.0 | Bottom of insert (duct end) |

## Zones and Slot Sizing

The vent has three pneumatically isolated zones:

| Zone | X extent | Slat tilt direction | Slot orientation |
|---|---|---|---|
| West (left) | `-interior_x/2` to `-(interior_x/2 - side_zone_width)` | tilted to throw air West | slots run along Y |
| Center | `-center_zone_length/2` to `+center_zone_length/2` | tilted to throw air North | slots run along X |
| East (right) | `interior_x/2 - side_zone_width` to `interior_x/2` | tilted to throw air East | slots run along Y |

Between zones are hollow rectangular **dividers** (`divider_width = 15 mm` wide along X) that prevent inter-zone air leakage above the throttle plate.

**Slot-sizing algorithm** (in `throttle_slot_count()` / `throttle_slot_width()`):

```
required_total_slot_width = open_area * zone_width * zone_length / slot_length
slot_count = max(1, round(required_total_slot_width / min_printable_slot))
slot_width = max(min_printable_slot, required_total_slot_width / count)
```

At the **printable floor** (typically 1–2% open area), the algorithm pins to one slot at `min_printable_slot = 1.2 mm` width. The effective open area then *exceeds* the target — the user cannot achieve a lower restriction without enlarging the zone. This is reported via `echo()` at render time and is allowed by Tests A and C.

## Open-Area Range

| `*_open_area` | Side zone effective | Center zone effective | Notes |
|---|---|---|---|
| 0.01 (1%) | ~1.5% | ~1% | Side at printable floor (1 × 1.2 mm slot) |
| 0.05 (5%) | ~5.8% | ~5.1% | Side approaching floor (3 × 1.2 mm slots) |
| 0.10 (10%) | 10% | 10.1% | Full range |
| 0.25 (25%) | 25% | 25.4% | Full range |

Verified by `directional-vent-test.scad` running across these settings.

## Slide-In Mechanism

The throttle plate enters the vent body through an **E-side opening** that spans the full Y width of the insert interior (`interior_y = 135.2 mm`) over the 1.4 mm channel Z height.

- **Bottom rail** (`throttle_bottom_rail()`): U-shape on N/S/W walls, protruding inward by `throttle_rail_depth = 2 mm` from each wall. Plate rests on top of it.
- **Top rail** (`throttle_top_rail()`): U-shape on N/S/W walls at the channel's top. Captures the plate from above.
- **W-wall notch** (`throttle_w_notch()`): 1.2 mm deep slot in the inside face of the W wall; the plate's W edge seats into this notch for an air seal.
- **E-side opening** (`throttle_e_opening()`): the E perimeter wall is removed over the channel Z range across the full interior_y. The plate slides in here. Sealed with aluminum duct tape post-installation.

Plate footprint: `throttle_plate_x_total × throttle_plate_y = 241 × 134.8 mm` (insert_outer_x − clearance, by interior_y − 2×clearance).

## Material Optimization History

The current design has been optimized for minimum filament. Key reductions:

| Param | Before | After | Reason |
|---|---|---|---|
| `slat_thickness` | 1.8 mm | **1.2 mm** | Slats anchored at both Y ends + top, 2 perimeters in PETG is plenty |
| `divider_wall` | 2.4 mm | **1.2 mm** | Dividers are air-seals, not load-bearing; tied at lip & throttle plate |
| `lip_overhang_short` | 15 mm | **10 mm** | N/S overhang has no mount holes; 10 mm covers ceiling cutout slop |
| `dividers_bottom_z` | -23 (full depth) | **-13.8** (plate top) | Below plate is undifferentiated duct air; dividers there waste filament |

Current vent body PETG mass: **~181 g** at 100% volume (real slicer output ~150 g with infill). Throttle: ~49 g.

## Change-Impact Map

If you change one of these parameters, expect cascading effects:

| Change | What else moves |
|---|---|
| `insert_width` or `insert_depth` | All Y/X-derived dimensions: interior, lip_outer, throttle plate footprint, opening sizes. Test all four open-area settings after. |
| `insert_height` | `throttle_ledge_top_z` (via `-lip_thickness - insert_height + throttle_ledge_z_offset`); below-throttle wall remains the same. |
| `lip_thickness` | All Z values shift by the same delta. |
| `throttle_ledge_z_offset` | Channel + divider bottom Z shift; slats unaffected. |
| `fixed_slat_angle` | Slat sweep + body length stay the same, but visual appearance and airflow direction change. Below 50° = mild deflection; above 75° = nearly horizontal slats and printability concerns. |
| `slat_body_length` | Slat tip depth changes; affects how far slats hang into the air path. |
| `min_printable_slot` | Reduces if nozzle gets smaller; recompute every part's printable-floor message. |
| `wall` (structural margin, NOT a print wall) | Affects interior dimensions, slot lengths, slat anchoring depth. |
| `divider_wall` | Only affects divider shell thickness; safe to tune independently. |
| `insert_wall_thickness` | Affects W-notch outer wall thickness remaining after cut (currently 0.6 mm); going thicker leaves more outer wall, thinner is risky. |

## Alternatives Considered and Rejected

These came up during design and were ruled out. Documented here so future agents don't re-propose them:

1. **Open-area solver on slat angle** — produced welded slats at low open-area (≤5%). Replaced by fixed-angle slats + throttle plate.
2. **Snap-clip retention on throttle plate** (cantilever fingers + groove undercuts in the insert walls) — produced floating-bump geometry that didn't fully manifold; also hard to remove for swapping. Replaced by slide-in + duct tape.
3. **Finger pull tab on throttle plate** — initially added for grip; redundant once we accepted that the E opening would be taped shut anyway. Removed.
4. **Snap-in throttle from the duct side (perpendicular insertion)** — required pushing the plate past the slats, which the slats blocked. Replaced by lateral slide-in from the E side.
5. **Throttle plate ABOVE the slats** (between slats and lip) — would compress airflow into a thin laminar stream emerging right at the room face; mixing/deflection is poorer. Throttle now sits BELOW the slats so the metered jet has the full `insert_height` to develop and hit the slats.
6. **Dividers running full insert height** — wasted ~18 g of filament below the throttle plate where there's no zone separation needed. Truncated to plate top.
7. **Smaller `lip_overhang_short` (5 mm)** — too aggressive; relies on a clean ceiling cutout. Settled on 10 mm.
8. **Thinner `divider_wall` (0.6 mm)** — 1 perimeter at 0.6 nozzle is too flimsy at 130 mm length. 1.2 mm (2 perimeters) is the practical floor.

## Test Inventory

`directional-vent-test.scad` defines these geometric invariants (letter-labeled):

| Test | Asserts |
|---|---|
| E | `side_slat_angle == fixed_slat_angle` (no solver) |
| F | `center_slat_angle == fixed_slat_angle` |
| A | Side throttle open area matches target (or pinned to printable floor) |
| B | Side throttle slot width ≥ `min_printable_slot` |
| C | Center throttle open area matches target (or pinned to printable floor) |
| D | Center throttle slot width ≥ `min_printable_slot` |
| G | `part` parameter is one of "vent" or "throttle" |
| J | Bottom rail top Z = `-lip_thickness - insert_height + throttle_ledge_z_offset` |
| L | Dividers bottom Z = throttle plate top Z (no collision) |
| M | Plate X length = `insert_outer_x - throttle_clearance` (full neck length, no tab) |
| N | Plate Y width = `interior_y - 2 × throttle_clearance` (full interior, edges captured by rails) |
| O | Top rail bottom Z = bottom rail top + channel gap (correct channel height) |
| P | E opening Z range = channel Z range |
| Q | `slat_thickness == 1.2 mm` (printable minimum, filament-optimized) |
| R | `divider_wall == 1.2 mm` (printable minimum, filament-optimized) |
| S | `lip_overhang_short == 10 mm` (filament-optimized while still covering cutout slop) |

Run via:

```bash
openscad -p directional-vent.json -P "New set 1" -o /tmp/discard.stl directional-vent-test.scad
```

Tests are also run across open-area settings 0.01, 0.05, 0.10, 0.25 to verify the design works across the full range.

## Known Print Issues

- **Support needed** for an 1.8 × 5 × 135 mm strip of E perimeter wall above the throttle channel opening. The strip starts at z=-15 (top of channel) with no material below to print on. Bambu Studio auto-detects; the support sits inside the duct cavity and is easy to peel off.

## When Modifying

1. Read this document end-to-end.
2. Identify which "Hard Constraint" your change touches (if any). If it touches one, plan to update both the code AND the rationale in this doc.
3. Write or update tests in `directional-vent-test.scad` BEFORE changing code (TDD).
4. Make the minimal code change.
5. Run tests across all four open-area settings (0.01, 0.05, 0.10, 0.25).
6. Visually verify by rendering `vent` and `throttle` separately.
7. Re-measure volume if material cost is in scope:
   ```bash
   python3 /tmp/stlvol.py /tmp/vent.stl /tmp/throttle.stl   # see below
   ```
8. Update this document if the change affects a "Hard Constraint", "Alternatives Considered", or "Material Optimization History" section.

### Volume measurement helper

```python
# stlvol.py — measures mesh volume of a closed STL via signed tetrahedra.
import struct, sys, os
def read_stl(path):
    with open(path, 'rb') as f: chunk = f.read(1024)
    if b'facet normal' in chunk:
        tris, verts = [], []
        with open(path) as f:
            for line in f:
                p = line.strip().split()
                if p and p[0] == 'vertex':
                    verts.append(tuple(float(x) for x in p[1:4]))
                    if len(verts) == 3: tris.append(tuple(verts)); verts = []
        return tris
    with open(path, 'rb') as f:
        f.read(80); n = struct.unpack('<I', f.read(4))[0]
        return [(*struct.unpack('<12fH', f.read(50))[3:12],)[:3] for _ in range(n)]
def vol(tris):
    s = sum(a[0]*(b[1]*c[2]-b[2]*c[1]) + a[1]*(b[2]*c[0]-b[0]*c[2]) + a[2]*(b[0]*c[1]-b[1]*c[0]) for a,b,c in tris)
    return abs(s) / 6.0
for p in sys.argv[1:]:
    v = vol(read_stl(p))
    print(f"{os.path.basename(p)}: {v:.0f} mm^3 ({v/1000:.1f} cm^3, PETG {v/1000*1.27:.1f} g)")
```
