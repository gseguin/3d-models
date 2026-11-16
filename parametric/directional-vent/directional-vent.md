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
- **Supports:** none. The slats print at 49° from vertical (41° from horizontal), within PETG's ~50°-from-vertical no-support limit, so they are self-supporting. The shoulder that the throttle plate seats on is a downward step in the wall but is backed by the lower wall section, not an unsupported overhang.

## Parts

The file produces **two** printable parts, selected by the `part` parameter:

| `part` | Module | What it is |
|---|---|---|
| `"vent"` (default) | `vent_body()` | The main vent. Lip plate + rim + insert walls + slats + dividers + throttle channel rails + W-notch. |
| `"throttle"` | `throttle()` | A flat removable plate that slides into the vent body's channel from the E side. Sets the airflow restriction via slot dimensions. |

To swap the open-area setting, print a new throttle (cheap, ~10 minutes) and replace the old one — no need to reprint the vent body.

## Hard Constraints

These are **load-bearing** design choices. Don't change them without re-deriving the affected geometry.

1. **Lip-down print orientation.** Slats overhang at 41° from horizontal (49° from vertical); printing slats-down would require supports through the slat channels.
2. **Slat angle is FIXED (`fixed_slat_angle = 49°`), independent of the open-area target, AND capped at ≤ 50° from vertical for printability.** Two separate reasons: (a) The previous design solved for slat angle as a function of `*_open_area`, which produced welded slats at low open-area targets (≤5%); the current design decouples direction (slats) from restriction (throttle plate slots) — **do not re-introduce an open-area solver on the slat angle.** (b) The slats print lip-down and their bodies are a continuous overhang at this angle; PETG holds ≤50° from vertical without support, so a steeper angle fills the airflow openings with unremovable support. The angle was **65°** until it was found to clog the vent with support; it was lowered to 49° (1° safety margin under the limit). The ~17% loss of lateral throw (12.7 → 10.6 mm) was accepted in exchange for a no-support print. **Do not raise it above 50°.**
3. **Throttle plate sits BELOW the slats** (deeper into the duct). Airflow chain: `duct → throttle → slats → lip → room`. The throttle meters; the slats steer the metered air. This is also why the plate needs no positive *upward* retention: a supply vent pushes the plate up toward the lip, where the dividers/slats (bottoming out at the plate's top face) act as the up-stop.
4. **Throttle plate is a separate printed part that drops onto a shoulder.** The insert walls are thick in the upper section and thin in the lower section; the step between them is the **shoulder**. The plate drops in from the duct side into the wider lower cavity and rests on the shoulder. It is sized off the LOWER cavity (`lower_inner − 2·throttle_clearance`), which makes it (a) `throttle_clearance` smaller than the lower cavity per side → drops in, and (b) `(throttle_ledge_width − throttle_clearance) ≈ 2.6 mm` larger than the upper shoulder hole per side → **seats on the shoulder instead of falling through.** HVAC aluminum foil tape from the duct side spans the plate-edge → lower-wall-inner-face joint, sealing the perimeter and securing the plate. (Earlier sizing subtracted `throttle_ledge_width` from the plate too, making it *smaller* than the shoulder hole — the "plate too small, won't sit on the shoulder" bug.)
5. **No clip retention on the throttle plate.** Previous designs used cantilever fingers + groove undercuts; this caused floating-bump geometry and CSG manifold issues, and was hard to remove for swapping. Drop-on shoulder + tape is mechanically simpler and lets the user re-tape after each swap.
6. **Dividers terminate at the throttle plate's TOP face (z = -12.6).** Going lower causes them to collide with the plate; going higher leaves an air leak between zones above the plate. The current value is `throttle_ledge_top_z + throttle_plate_thickness`.

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
| `-slat_drop·cos(angle)` | ~-9.2 | Bottom of slat tips (at 49°) |
| `dividers_bottom_z` | -12.6 | Divider bottoms = throttle plate TOP face = shoulder face |
| `throttle_ledge_top_z` | -13.8 | Plate BOTTOM face (= shoulder face − plate thickness) |
| `-lip_thickness - insert_height` | -21.8 | Bottom of insert (duct end) |

(The slide-in rail/channel Z values from the previous design are gone — the
plate now drops onto the shoulder rather than sliding through a channel.)

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

## Drop-On-Shoulder Mechanism

The throttle plate **drops into the insert from the duct side** and rests on a shoulder formed by the insert walls. There is no slide-in channel, no rails, no E-side opening, and no W-notch (all removed — see Alternatives Considered).

How the shoulder is formed (`insert_walls()`):

- **Upper section** (lip bottom → shoulder, room side of plate): walls thickened inward by `throttle_ledge_width = 3 mm`. The bottom face of this thick section is the **shoulder** the plate seats against. Inner hole here = `insert_outer − 2·insert_wall_thickness − 2·throttle_ledge_width` ≈ **231.4 × 129.4 mm**.
- **Lower section** (shoulder → insert bottom, duct side of plate): thin walls (`insert_wall_thickness`). Inner cavity here = `insert_outer − 2·insert_wall_thickness` ≈ **237.4 × 135.4 mm** — wider, so the plate drops in from the duct end.

Plate footprint: `throttle_plate_x_total × throttle_plate_y = lower_inner − 2·throttle_clearance` ≈ **236.6 × 134.6 mm**.

This sits in the band between the two inner sizes:
- **0.4 mm smaller** than the lower cavity per side (`throttle_clearance`) → drops in from the duct.
- **2.6 mm larger** than the upper shoulder hole per side (`throttle_ledge_width − throttle_clearance`) → seats on the shoulder, cannot fall through.

HVAC aluminum foil tape applied from the duct side spans the plate-edge → lower-wall-inner-face joint, sealing the perimeter and securing the plate. A 15 mm `throttle_tape_margin` band around the plate perimeter is kept slot-free for tape grip.

To swap throttles: peel tape, push the plate down/out the duct side, drop a new one in, re-tape.

## Material Optimization History

The current design has been optimized for minimum filament. Key reductions:

| Param | Before | After | Reason |
|---|---|---|---|
| `slat_thickness` | 1.8 mm | **1.2 mm** | Slats anchored at both Y ends + top, 2 perimeters in PETG is plenty |
| `divider_wall` | 2.4 mm | **1.2 mm** | Dividers are air-seals, not load-bearing; tied at lip & throttle plate |
| `lip_overhang_short` | 15 mm | **10 mm** | N/S overhang has no mount holes; 10 mm covers ceiling cutout slop |
| `dividers_bottom_z` | -23 (full depth) | **-12.6** (plate top) | Below plate is undifferentiated duct air; dividers there waste filament |
| slat support pillars | present | **removed** | Were in-print supports for the 65° slats; at 49° the slats self-support, so the pillars (and the support *they* drew, which clogged the openings) are gone |

Current vent body PETG mass: **~181 g** at 100% volume (real slicer output ~150 g with infill). Throttle: ~49 g.

## Change-Impact Map

If you change one of these parameters, expect cascading effects:

| Change | What else moves |
|---|---|
| `insert_width` or `insert_depth` | All Y/X-derived dimensions: interior, lip_outer, throttle plate footprint, opening sizes. Test all four open-area settings after. |
| `insert_height` | `throttle_ledge_top_z` (via `-lip_thickness - insert_height + throttle_ledge_z_offset`); below-throttle wall remains the same. |
| `lip_thickness` | All Z values shift by the same delta. |
| `throttle_ledge_z_offset` | Shoulder + divider bottom Z shift; slats unaffected. |
| `fixed_slat_angle` | Lateral throw, slat tip depth, and divider-wedge shape change. **Hard cap at ≤ 50° from vertical** — above that the slats stop self-supporting and the slicer clogs the airflow openings with unremovable support. Lower = shallower throw but safer overhang. |
| `slat_body_length` | Slat tip depth changes; affects how far slats hang into the air path. Must keep slat tips above `dividers_bottom_z` (currently 3.4 mm of clearance at 49°). |
| `min_printable_slot` | Reduces if nozzle gets smaller; recompute every part's printable-floor message. |
| `wall` (structural margin, NOT a print wall) | Affects interior dimensions, slot lengths, slat anchoring depth. |
| `divider_wall` | Only affects divider shell thickness; safe to tune independently. |
| `insert_wall_thickness` | Sets both inner cavity sizes, so it moves the throttle plate footprint AND the shoulder seat depth. Larger = thicker walls and a deeper seat. |
| `throttle_ledge_width` | Shoulder seat depth = `throttle_ledge_width − throttle_clearance` per side. Larger = more bearing for the plate but a smaller upper opening; must stay below the half-zone width so it doesn't intrude on slots. |
| `throttle_clearance` | Drop-in slop against the lower cavity per side; also reduces the shoulder seat by the same amount. Too large → plate rattles and seat shrinks; too small → won't drop in after PETG shrinkage. |

## Alternatives Considered and Rejected

These came up during design and were ruled out. Documented here so future agents don't re-propose them:

1. **Open-area solver on slat angle** — produced welded slats at low open-area (≤5%). Replaced by fixed-angle slats + throttle plate.
2. **Snap-clip retention on throttle plate** (cantilever fingers + groove undercuts in the insert walls) — produced floating-bump geometry that didn't fully manifold; also hard to remove for swapping. Replaced by drop-on shoulder + tape.
3. **Slide-in throttle from the E side** (top/bottom rails forming a channel, E-wall opening, W-wall notch) — the rails and the E opening left an unsupported wall strip needing support, and the channel was fiddly. Replaced by the drop-on-shoulder mechanism: the plate drops in from the duct side onto a shoulder formed by the two-thickness insert wall. Simpler geometry, no support.
4. **65° slats + permanent support pillars** — at 65° from vertical the slats overhang past PETG's no-support limit, so permanent 1.2 mm pillars were added between slats to give them something to print onto. But the pillars themselves floated mid-air and drew slicer support, and that support filled the airflow openings and could not be removed (it clogged the vent). Replaced by simply lowering the slat angle to 49° (self-supporting) and deleting the pillars entirely.
5. **Throttle plate sized off the upper shoulder hole** (`upper_inner − 2·clearance`) — made the plate *smaller* than the shoulder opening, so it fell straight through instead of seating. Fixed by sizing off the lower cavity (`lower_inner − 2·clearance`) so the plate overhangs the shoulder by ~2.6 mm per side. (This was the "plate too small, won't sit on the shoulder" report.)
6. **Throttle plate ABOVE the slats** (between slats and lip) — would compress airflow into a thin laminar stream emerging right at the room face; mixing/deflection is poorer. Throttle now sits BELOW the slats so the metered jet has the full `insert_height` to develop and hit the slats.
7. **Dividers running full insert height** — wasted ~18 g of filament below the throttle plate where there's no zone separation needed. Truncated to plate top.
8. **Smaller `lip_overhang_short` (5 mm)** — too aggressive; relies on a clean ceiling cutout. Settled on 10 mm.
9. **Thinner `divider_wall` (0.6 mm)** — 1 perimeter at 0.6 nozzle is too flimsy at 130 mm length. 1.2 mm (2 perimeters) is the practical floor.

## Test Inventory

`directional-vent-test.scad` defines these geometric invariants (letter-labeled):

| Test | Asserts |
|---|---|
| E | `side_slat_angle == fixed_slat_angle` (no solver) |
| F | `center_slat_angle == fixed_slat_angle` |
| F2 | `fixed_slat_angle ≤ 50°` from vertical (self-supporting in PETG; no clogging support) |
| A | Side throttle open area matches target (or pinned to printable floor) |
| B | Side throttle slot width ≥ `min_printable_slot` |
| C | Center throttle open area matches target (or pinned to printable floor) |
| D | Center throttle slot width ≥ `min_printable_slot` |
| G | `part` parameter is one of "vent" or "throttle" |
| J | Shoulder/plate-bottom Z = `-lip_thickness - insert_height + throttle_ledge_z_offset` |
| L | Dividers bottom Z = throttle plate top Z (no collision) |
| M | Plate X = `lower_inner_x - 2 × throttle_clearance` (drops into lower cavity) |
| M2 | Plate seats on the shoulder by ≥ 1 mm per side (does NOT fall through the shoulder hole) |
| N | Plate Y = `lower_inner_y - 2 × throttle_clearance` (drops into lower cavity) |
| O | Plate top Z is flush with dividers' duct-side ends (pneumatic seal) |
| P | Shoulder inward width (`throttle_ledge_width`) is 1.2–10 mm (supports plate, doesn't block airflow) |
| Q | `slat_thickness == 1.2 mm` (printable minimum, filament-optimized) |
| R | `divider_wall == 1.2 mm` (printable minimum, filament-optimized) |
| S | `lip_overhang_short == 10 mm` (filament-optimized while still covering cutout slop) |
| W | Throttle slots respect the 15 mm tape-margin band around the plate perimeter |

(Tests T and V — slat support pillars — were removed when the pillars were deleted.)

Run via:

```bash
openscad -p directional-vent.json -P "New set 1" -o /tmp/discard.stl directional-vent-test.scad
```

Tests are also run across open-area settings 0.01, 0.05, 0.10, 0.25 to verify the design works across the full range.

## Known Print Issues

- **No supports needed.** The previous design needed support in two places (a strip of E perimeter wall above the slide-in opening, and under the 65° slats via permanent pillars). Both are gone: the slide-in mechanism was replaced by drop-on-shoulder (no E opening), and the slats were lowered to 49° (self-supporting). If you raise `fixed_slat_angle` above 50°, the slicer will start filling the airflow openings with support that you cannot remove — Test F2 guards against this.

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
