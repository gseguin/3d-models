// ============================================================================
// Directional Vent — 242 x 140 insert, 29 mm lip
// ============================================================================
//
// DESIGN CONTRACT: see `directional-vent.md` (sibling file) for the full
// design rationale, hard constraints, change-impact map, alternatives ruled
// out, and test inventory. READ THAT FILE BEFORE MAKING NON-TRIVIAL CHANGES.
//
// HARD CONSTRAINTS (summary — full details in .md):
//   1. Lip-DOWN print orientation. Reversing breaks slat printability.
//   2. Slat angle is FIXED. Do NOT reintroduce an open-area solver on the
//      slat angle — that produced welded slats at low open-area targets.
//   3. Throttle plate sits BELOW the slats (duct → throttle → slats → room).
//   4. Throttle is a SEPARATE part, slides in from the E side, sealed with
//      aluminum duct tape. No clips, no detents.
//   5. Dividers terminate at the throttle plate's TOP face (no collision).
//
// TESTS: run `openscad -p directional-vent.json -P "New set 1" -o /tmp/x.stl
// directional-vent-test.scad`. Sweep open-area in {0.01, 0.05, 0.10, 0.25}.
//
// Print settings (Bambu H2D, 0.6 mm nozzle, PETG):
//   • Orientation: lip face DOWN on the bed (slats and dividers point up).
//   • Layer height: 0.32 mm (0.3-0.4 mm range).
//   • Line width: 0.6 mm. Wall thicknesses below are multiples of 0.6 mm.
//   • Walls: 3 perimeters (3 × 0.6 = 1.8 mm matches insert_wall_thickness).
//   • Brim: 4-6 mm recommended — the 240+ mm lip is wide enough to lift at the
//     corners as PETG cools.
//   • Bed temp: 70-80 °C. Nozzle: 235-245 °C.
//   • Supports: needed only for a small 1.8 × 5 × 135 mm strip of the E
//     perimeter wall above the throttle opening. Bambu Studio auto-detects;
//     support sits inside the duct cavity and peels off easily.
// ============================================================================
// Highly restrictive vent. Lip sits flush against the wall (faces the room);
// slats and a throttle plate hang down into the duct opening below.
//
// Airflow chain (duct → room):
//
//   duct ──► throttle plate ──► slats ──► lip opening ──► room
//
// The throttle plate sits at the BOTTOM of the insert (deepest into the duct).
// It is a solid flat plate with narrow slots cut through it; the slot total
// open area sets the airflow restriction. The slats sit ABOVE the throttle
// plate (between throttle and lip) and steer the metered air E/W or N at a
// FIXED angle (not derived from the open-area target). This decouples
// restriction from direction: open-area can be dialed down to ~1% without
// changing slat geometry or causing slats to fuse together at print time.
//
// Zones (looking from the duct side, i.e. from below the lip):
//   • Left zone  (side_zone_width along X)  : slats tilted to push air West
//   • Right zone (side_zone_width along X)  : slats tilted to push air East
//   • Center    (center_zone_length along X): slats tilted to push air North
//   Each zone has its own throttle plate slots sized to its open_area target.
//
// Coordinate system:
//   • X axis = 242 mm direction = East/West
//   • Y axis = 140 mm direction = North/South
//   • +Z points into the room (out of the duct), -Z points into the duct
//   • Lip top face is at Z = 0; insert extends into the duct (negative Z).
//   • Throttle plate top face is at z = -lip_thickness - insert_height +
//     throttle_plate_thickness (i.e. the plate caps the bottom of the insert).
// ============================================================================

// ----------------------------------------------------------------------------
// [Opening]
// ----------------------------------------------------------------------------
// Opening width along the long axis (East-West).
insert_width  = 242;
// Opening depth along the short axis (North-South).
insert_depth  = 140;
// How far the insert walls extend into the opening (downward).
insert_height = 20;
// Clearance per side so the insert slides in.
// 0.5 mm gives a reliable slide-fit in PETG (which shrinks ~0.5-0.8% on cool).
insert_clearance = 0.5;

// ----------------------------------------------------------------------------
// [Lip / Flange]
// ----------------------------------------------------------------------------
// Lip overhang along the long (East-West, X) axis — wider here because the
// mount holes go in this overhang.
lip_overhang = 29;
// Lip overhang along the short (North-South, Y) axis — narrower here to save
// filament; no mount holes on this side. Set equal to lip_overhang for a
// uniform 29 mm border. 10 mm gives enough visual coverage of a typical
// ceiling cutout without spending filament on extra flange material.
lip_overhang_short = 10;
// Thickness of the flat lip plate.
// 1.8 mm = 3 clean perimeters at 0.6 mm nozzle (~6 layers at 0.32 mm).
// On a 242 mm PETG flange this is at the thin end — print with a 4-6 mm
// brim and slow first-layer cooling to keep the corners from lifting.
lip_thickness = 1.8;
// Outer corner rounding of the lip.
lip_corner_radius = 6;
// Total height of the lip assembly (flat plate + perimeter rim) measured
// from the lip's underside (the surface that sits against the ceiling)
// up to the top of the rim. The rim height is lip_total_height - lip_thickness.
lip_total_height = 7;
// Thickness of the perimeter rim wall (the wall standing up around the outer
// edge of the lip plate).
lip_rim_wall = 2.5;

// ----------------------------------------------------------------------------
// [Walls]
// ----------------------------------------------------------------------------
// Structural margin / anchoring-overlap thickness. Used for slat anchor
// overlap into perimeter walls, slot-end material margin on the throttle
// plate, and similar structural offsets. NOT a print wall thickness — see
// `divider_wall` and `insert_wall_thickness` for actual print walls.
// 2.4 mm = generous structural overlap.
wall = 2.4;
// Slat thickness — slats are short (~14 mm long along their own axis),
// anchored at both Y ends in the perimeter walls AND tied at z=0 to the
// lip plate, so they're stiff in bending. Set to the printable minimum to
// save filament (slats are the largest material contributor by volume).
// 1.2 mm = 2 clean perimeters at 0.6 mm nozzle.
slat_thickness = 1.2;
// Insert perimeter wall thickness. 1.8 mm = 3 clean perimeters at 0.6 mm
// nozzle. Holds the insert against the duct opening and supports the
// lip; 3 perimeters in PETG is sturdy enough.
insert_wall_thickness = 1.8;
// Divider shell wall thickness. Dividers are hollow rectangular boxes that
// serve as zone air-seals — they're not load-bearing and they're tied at
// the lip (bottom) and against the throttle plate (top), so 2 perimeters
// of PETG is plenty for stiffness.
// 1.2 mm = 2 clean perimeters at 0.6 mm nozzle.
divider_wall = 1.2;

// ----------------------------------------------------------------------------
// [Slats — fixed angle, both zones]
// ----------------------------------------------------------------------------
// Slats are purely directional now: they deflect metered air toward their
// target direction (E/W for side zones, N for center). They do NOT set the
// airflow restriction — that's the throttle plate's job (see below). So the
// slat angle is a fixed constant, independent of the open-area targets.
//
// Angle measured from VERTICAL (the slat plane's normal direction). At 0°
// the slat is vertical (no deflection). At 90° the slat is horizontal
// (fully closed). 60–70° gives a strong sideways throw without making the
// slats too horizontal to print cleanly.
fixed_slat_angle = 65;

// Slat body length along the slat's own axis (mm). At 65° this gives a
// visible-from-the-room drop of ~5.9 mm and a sideways sweep of ~12.7 mm,
// which fits comfortably inside the zone widths.
slat_body_length = 14;

// Slat target pitch (mm) — used to derive slat count per zone. Slats are then
// evenly distributed across the zone with the array anchored at both walls.
target_slat_pitch = 14;

// ----------------------------------------------------------------------------
// [Side slats — East / West deflection]
// ----------------------------------------------------------------------------
// Width of each side zone along X (the 242 mm axis).
side_zone_width = 60;
// Target open area ratio (0..1) for each side zone. Fraction of the zone
// footprint that is open passage. With the throttle-plate design this is
// satisfied EXACTLY by the throttle slot sizing, independent of slat
// geometry. Practical floor: enough open area for at least one slot of
// width >= min_printable_slot to fit within the zone footprint. Below that
// floor, the slot count drops to 1 at the minimum printable width and the
// effective open area exceeds the target (you cannot print finer).
//   0.01 = 1%    very restrictive (~1.3 mm slot width in a typical zone).
//   0.05 = 5%    moderate.
//   0.25 = 25%   open.
side_open_area = 0.05;

// ----------------------------------------------------------------------------
// [Dividers — flat solid surface between side and center zones]
// ----------------------------------------------------------------------------
// Solid flat floor of this width (along X) sits between each side slat zone
// and the center slat zone. Blocks airflow in those bands.
divider_width = 15;

// ----------------------------------------------------------------------------
// [Center slats — North deflection]
// ----------------------------------------------------------------------------
// Slats spanning the center zone along X (each slat is center_zone_length mm
// long along X). Slats are stacked along Y across the full insert depth and
// tilted around the X axis so air gets redirected North.
//
// Length of the open center zone along X (88 mm). The slats themselves
// extend slightly into the flanking dividers — see center_slat_overlap.
center_zone_length = 88;
// How far each center slat buries into each divider for anchoring.
center_slat_overlap = 3;
// Target open area ratio (0..1) for the center zone. See side_open_area for
// the definition and printable-floor caveats.
center_open_area = 0.05;

// ----------------------------------------------------------------------------
// [Throttle plate — airflow restriction (SEPARATE PRINTED PART)]
// ----------------------------------------------------------------------------
// The throttle plate is a SEPARATE part that slides into the vent body
// through an opening on the E (+X) side and seats into a notch on the W
// (-X) wall. Top and bottom rails on the N/S walls capture the plate
// vertically. No clips — duct tape over the E opening secures it.
//
// To swap throttles: peel tape, slide plate out E side, slide new one in.
//
// Each zone has its own set of slots cut through the plate; total slot area
// / zone footprint = open_area ratio. Slats above the plate steer the
// metered air; the throttle plate just meters.
//
// Plate thickness: 1.2 mm = 4 top layers at 0.3 mm = clean bridge.
throttle_plate_thickness = 1.2;
// Minimum slot width (mm). Below this, a 0.6 mm nozzle cannot reliably
// extrude two perimeters and the slot fuses shut. 1.2 mm = 2 line widths.
min_printable_slot = 1.2;

// ---- Slide-in channel geometry ----
// Per-side slop between the throttle plate edges and the rails / W-notch.
// 0.2 mm gives a clean slide-fit in PETG.
throttle_clearance = 0.2;
// How far the bottom rail (the support shelf) and the top rail (the cap
// that captures the plate from above) protrude inward from the N/S/W
// insert walls. 2 mm gives a generous channel without blocking too much
// of the interior airflow path.
throttle_rail_depth = 2;
// Distance from the insert's BOTTOM (deepest into the duct) up to the TOP
// of the bottom rail. The plate's bottom face rests here.
throttle_ledge_z_offset = 8;
// Vertical gap between bottom rail top and top rail bottom. Must be
// >= plate_thickness + clearance for the plate to slide freely.
//   1.2 + 0.2 = 1.4 mm.
throttle_channel_gap = 1.4;
// Top rail height (vertical thickness). 1.2 mm = 4 layers at 0.3 mm = clean
// bridge spanning the channel gap below it.
throttle_top_rail_thickness = 1.2;
// Depth of the W-wall notch (how deep the W edge of the plate seats into
// the W perimeter wall). The W perimeter wall is insert_wall_thickness
// (1.8 mm); cutting 1.2 mm leaves 0.6 mm of outer wall (1 perimeter at a
// 0.6 mm nozzle).
throttle_w_notch_depth = 1.2;

// ---- Part selector ----
// "vent"     — render the vent body (lip, walls, slats, dividers, channel
//              rails, W notch, E opening). Print this once.
// "throttle" — render the throttle plate (separate part). Print one per
//              open-area setting you want to keep on hand. Sized to slide
//              into the vent body printed from the SAME parameter set.
part = "vent"; // [vent, throttle]

// ----------------------------------------------------------------------------
// [Mounting holes]
// ----------------------------------------------------------------------------
// Two through-holes in the lip, one on each East/West side, centered on Y
// and in the middle of the 29 mm lip overhang.
// Sized for #8 sheet-metal screws (standard US HVAC vent screw).
// Major diameter ~4.17 mm; clearance hole 4.0 mm.
// 4.2 mm = #8 sheet metal screw clearance + PETG shrinkage allowance.
mount_hole_diameter = 4.2;

// ----------------------------------------------------------------------------
// [Render]
// ----------------------------------------------------------------------------
$fa = 2;
$fs = 0.4;

eps = 0.01;

// Derived dimensions
insert_outer_x = insert_width  - 2 * insert_clearance;
insert_outer_y = insert_depth  - 2 * insert_clearance;
lip_outer_x    = insert_outer_x + 2 * lip_overhang;
lip_outer_y    = insert_outer_y + 2 * lip_overhang_short;

// Z layout
// z =  0                      : top of lip (faces the room) / top of slats
// z = -lip_thickness           : bottom of lip
// z = -slat_drop               : bottom of a slat (drop measured from top of lip)
slat_top_z = 0;

// Interior usable footprint (inside the perimeter walls)
interior_x = insert_outer_x - 2 * wall;
interior_y = insert_outer_y - 2 * wall;

// Side zone X bounds (interior coordinates)
left_zone_xmax  = -interior_x/2 + side_zone_width;
right_zone_xmin =  interior_x/2 - side_zone_width;

// Slat counts derived from target_slat_pitch so both zones produce
// proportional openings. count = round(span / target_pitch) + 1, min 2.
side_slat_count   = max(2, round(side_zone_width / target_slat_pitch) + 1);
center_slat_count = max(2, round(interior_y      / target_slat_pitch) + 1);

// ============================================================================
// Slat angles — FIXED (not solver-derived)
// ============================================================================
// Both zones share the same tilt magnitude (fixed_slat_angle). The side zones
// mirror this around X via the `side` parameter in side_slats(). The center
// zone uses the angle directly to tilt around X for North deflection.
side_slat_angle   = fixed_slat_angle;
center_slat_angle = fixed_slat_angle;

// Slat hang lengths along the slat's own axis (mm). With fixed angle, a
// single global parameter drives both zones.
side_slat_drop   = slat_body_length;
center_slat_drop = slat_body_length;

// ============================================================================
// Throttle plate slot sizing
// ============================================================================
// Per-zone goal: total slot area / zone footprint == open_area_target.
//   slot_length = interior_y - 2*wall   (anchored at N/S edges)
//   required_total_slot_width = (open_area * footprint) / slot_length
//   slot_count = max(1, round(required_total_slot_width / min_printable_slot))
//   slot_width = max(min_printable_slot, required_total_slot_width / count)
//
// If even one minimum-width slot would over-deliver open area for the target,
// we still print that one slot (the only printable option) and warn that the
// effective open area exceeds the target — restriction cannot go below the
// printable floor.
//
// Slot orientation: parallel to the slats' long axis (Y for side zones,
// X for center zone) so air emerging from each slot enters a slat channel
// cleanly rather than crossing multiple channels.

function throttle_slot_count(zone_width, zone_length, r, slot_length, min_w) =
    let (req_total_w = (r * zone_width * zone_length) / slot_length,
         n = max(1, round(req_total_w / min_w)))
    n;

function throttle_slot_width(zone_width, zone_length, r, slot_length, min_w, count) =
    let (req_total_w = (r * zone_width * zone_length) / slot_length,
         w = req_total_w / count)
    max(min_w, w);

// Side zones: slots run along Y (parallel to side slats' Y axis).
side_throttle_slot_length = interior_y - 2*wall;
side_throttle_slot_count  = throttle_slot_count(side_zone_width, interior_y,
                                                side_open_area,
                                                side_throttle_slot_length,
                                                min_printable_slot);
side_throttle_slot_width  = throttle_slot_width(side_zone_width, interior_y,
                                                side_open_area,
                                                side_throttle_slot_length,
                                                min_printable_slot,
                                                side_throttle_slot_count);

// Center zone: slots run along X (parallel to center slats' X axis). The
// "zone width" here (the dimension perpendicular to slots) is interior_y;
// the "zone length" (parallel to slots) is center_zone_length.
center_throttle_slot_length = center_zone_length - 2*wall;
center_throttle_slot_count  = throttle_slot_count(interior_y, center_zone_length,
                                                  center_open_area,
                                                  center_throttle_slot_length,
                                                  min_printable_slot);
center_throttle_slot_width  = throttle_slot_width(interior_y, center_zone_length,
                                                  center_open_area,
                                                  center_throttle_slot_length,
                                                  min_printable_slot,
                                                  center_throttle_slot_count);

// Effective achieved open area (after clamping to min_printable_slot).
_side_eff_open   = (side_throttle_slot_count * side_throttle_slot_width
                    * side_throttle_slot_length)
                 / (side_zone_width * interior_y);
_center_eff_open = (center_throttle_slot_count * center_throttle_slot_width
                    * center_throttle_slot_length)
                 / (interior_y * center_zone_length);

// ---- Throttle slide-in channel geometry (derived) ----
// Z coordinates (consistent with the rest of the file: z=0 is lip top,
// z=-lip_thickness is lip bottom / room face of insert, z=-lip_thickness
// -insert_height is duct face / bottom of insert).

// Bottom rail top Z = where the plate's bottom face rests. (Kept named
// `throttle_ledge_top_z` for backward compatibility with code that references
// the previous design's ledge.)
throttle_ledge_top_z = -lip_thickness - insert_height
                     + throttle_ledge_z_offset;

// Top rail (cap) Z range — bottom of top rail is one channel_gap above the
// bottom rail top, so a plate of throttle_plate_thickness slides through
// with throttle_clearance to spare. Top of top rail = bottom + thickness.
throttle_top_rail_bottom_z = throttle_ledge_top_z + throttle_channel_gap;
throttle_top_rail_top_z    = throttle_top_rail_bottom_z
                           + throttle_top_rail_thickness;

// E-side opening Z range — the E perimeter wall is removed over this Z so
// the plate can slide in. Spans from the bottom rail top up to the top rail
// bottom (the full channel gap).
throttle_e_opening_bottom_z = throttle_ledge_top_z;
throttle_e_opening_top_z    = throttle_top_rail_bottom_z;

// Throttle plate footprint:
//   - X: spans the full insert outer X (from W outer face — seated in the
//     W notch — to E outer face, flush with the E opening), minus
//     throttle_clearance so it doesn't bottom out against the W notch
//     on insertion. The E end is sealed with aluminum duct tape after
//     installation, so no finger tab is needed.
//   - Y: spans the full insert interior Y minus per-side clearance. The
//     plate's Y edges sit UNDER the top rail (which extends inward by
//     throttle_rail_depth from each N/S wall), capturing the plate from
//     above. The bottom rail supports the plate from below across the same
//     Y range. So the plate is captured top-and-bottom over a strip of
//     width `throttle_rail_depth` along each Y edge.
throttle_plate_x_total = insert_outer_x - throttle_clearance;
throttle_plate_y       = interior_y - 2*throttle_clearance;

// Dividers extend from the lip down to the throttle plate's TOP face (so
// they rest on top of the plate without intersecting it). Below the plate
// is undifferentiated duct air — dividers there would waste filament AND
// collide with the plate.
dividers_bottom_z = throttle_ledge_top_z + throttle_plate_thickness;

// Echo derived geometry.
echo(str("Side   angle=", side_slat_angle, "° (fixed), slats=", side_slat_count,
         ", throttle slots=", side_throttle_slot_count,
         " x ", side_throttle_slot_width, " mm",
         " (target open=", side_open_area*100, "%",
         ", effective=", _side_eff_open*100, "%)",
         _side_eff_open > side_open_area * 1.1
             ? " *** Note: effective open area exceeds target — at the printable floor."
             : ""));
echo(str("Center angle=", center_slat_angle, "° (fixed), slats=", center_slat_count,
         ", throttle slots=", center_throttle_slot_count,
         " x ", center_throttle_slot_width, " mm",
         " (target open=", center_open_area*100, "%",
         ", effective=", _center_eff_open*100, "%)",
         _center_eff_open > center_open_area * 1.1
             ? " *** Note: effective open area exceeds target — at the printable floor."
             : ""));

// ============================================================================
// Build — dispatch on `part`
// ============================================================================
// part = "vent"     → render the vent body (no throttle plate, but with the
//                     ledge and clip grooves that the throttle clicks into).
// part = "throttle" → render the throttle plate as a separate, removable
//                     part. Prints flat at Z=0 for easy slicer setup.

if (part == "vent") {
    vent_body();
} else if (part == "throttle") {
    throttle();
} else {
    echo(str("ERROR: unknown part '", part,
             "' — must be \"vent\" or \"throttle\""));
}

module vent_body() {
    difference() {
        union() {
            lip();
            lip_rim();
            insert_walls();
            // Slats and dividers union together. The center slats overlap
            // into each divider for structural anchoring; the side slats
            // overlap into the perimeter walls along Y for the same reason.
            // The interior_volume intersection trims any geometry that pokes
            // outside the duct opening (mainly slat ends sticking past the
            // outer walls).
            intersection() {
                interior_volume();
                union() {
                    side_slats(side = -1);
                    side_slats(side = +1);
                    center_slats();
                    dividers();
                }
            }
            // Bottom and top rails of the slide-in channel for the throttle
            // plate. Rails live on N/S/W walls only — the E wall has an
            // opening so the plate can slide in.
            throttle_bottom_rail();
            throttle_top_rail();
        }
        // E-side opening: remove the E perimeter wall over the channel Z
        // range so the throttle plate can slide in horizontally.
        throttle_e_opening();
        // W-wall notch: small horizontal slot cut into the inside face of
        // the W perimeter wall, into which the plate's W edge seats for a
        // tight pneumatic seal.
        throttle_w_notch();
        mount_holes();
    }
}

// Bounding volume of the dividers — used to trim slats so they don't poke
// into the divider regions. Slightly taller (eps) so the cut is clean.
module divider_footprint() {
    side_inner_x   = interior_x/2 - side_zone_width;
    center_outer_x = center_zone_length/2;
    div_x_center = (side_inner_x + center_outer_x) / 2;
    total_depth = lip_thickness + insert_height;

    for (side = [-1, +1]) {
        translate([side * div_x_center, 0, -total_depth/2])
            cube([divider_width, interior_y + 2*eps, total_depth + 2*eps],
                 center = true);
    }
}

// The interior volume the slats may occupy: inside the perimeter walls,
// at or below the lip's underside, at or above the insert's bottom.
module interior_volume() {
    // Allow slats to bury into the perimeter walls and dividers (overlap
    // for structural anchoring). The bound here is the OUTER footprint of
    // the insert; only geometry poking past the actual physical perimeter
    // walls of the part gets clipped.
    translate([0, 0, slat_top_z - (insert_height + lip_thickness)/2])
        cube([insert_outer_x, insert_outer_y, insert_height + lip_thickness],
             center = true);
}

// ----------------------------------------------------------------------------
// Lip (flange) — flat plate at the top with the interior cut out, so air can
// pass through the opening. Only the slats, dividers, and perimeter walls
// occupy the interior; the rest is open air.
// ----------------------------------------------------------------------------
module lip() {
    translate([0, 0, -lip_thickness])
        linear_extrude(height = lip_thickness)
            difference() {
                rounded_rect(lip_outer_x, lip_outer_y, lip_corner_radius);
                // Open the interior so air can pass through.
                square([interior_x, interior_y], center = true);
            }
}

module rounded_rect(w, d, r) {
    offset(r = r) offset(r = -r)
        square([w, d], center = true);
}

// ----------------------------------------------------------------------------
// Lip rim — perimeter wall around the lip plate. Extends downward from the
// lip's underside so total assembly height (lip + rim) = lip_total_height.
// The rim hugs the outer edge of the lip; its inner edge is offset inward by
// lip_rim_wall thickness.
// ----------------------------------------------------------------------------
module lip_rim() {
    rim_height = lip_total_height - lip_thickness;
    if (rim_height > 0) {
        translate([0, 0, -lip_thickness - rim_height])
            linear_extrude(height = rim_height)
                difference() {
                    rounded_rect(lip_outer_x, lip_outer_y, lip_corner_radius);
                    rounded_rect(lip_outer_x - 2 * lip_rim_wall,
                                 lip_outer_y - 2 * lip_rim_wall,
                                 max(0, lip_corner_radius - lip_rim_wall));
                }
    }
}

// ----------------------------------------------------------------------------
// Insert walls — perimeter walls that extend into the duct opening
// ----------------------------------------------------------------------------
module insert_walls() {
    // Inner cavity is sized by `wall` (used everywhere else for slat anchoring
    // math), but the actual perimeter wall thickness can be thinner.
    inner_w = insert_outer_x - 2 * insert_wall_thickness;
    inner_d = insert_outer_y - 2 * insert_wall_thickness;
    translate([0, 0, -lip_thickness - insert_height])
        linear_extrude(height = insert_height)
            difference() {
                square([insert_outer_x, insert_outer_y], center = true);
                square([inner_w, inner_d], center = true);
            }
}

// ----------------------------------------------------------------------------
// Dividers — vertical solid walls between each side slat zone and the center
// slat zone. They extend the full depth of the insert so the three zones are
// pneumatically isolated below the lip (otherwise air entering one zone
// would just flow under the lip and exit through another).
// ----------------------------------------------------------------------------
module dividers() {
    side_inner_x   = interior_x/2 - side_zone_width;   // e.g. 119 - 60 = 59
    center_outer_x = center_zone_length/2;             // e.g. 44
    div_x_center = (side_inner_x + center_outer_x) / 2;

    // Walls span from the top of the lip (z=0) down to the throttle plate's
    // seating level (z = dividers_bottom_z). Below the throttle plate is just
    // undifferentiated duct air, so material there would be wasted.
    // Hollowed: a 6-walled shell of thickness `divider_wall`. The cavity is
    // fully enclosed so airflow can't leak between zones and the print is
    // clean (no blind pockets, no trapped support).
    div_depth = -dividers_bottom_z;  // positive height from z=0 down
    div_center_z = dividers_bottom_z / 2;
    for (side = [-1, +1]) {
        translate([side * div_x_center, 0, div_center_z])
            difference() {
                cube([divider_width, interior_y, div_depth], center = true);
                cube([divider_width - 2*divider_wall,
                      interior_y    - 2*divider_wall,
                      div_depth     - 2*divider_wall],
                     center = true);
            }
    }
    // Wedge extensions on the outer (side-zone-facing) face of each divider.
    // Each wedge replaces the innermost side slat by making the divider's
    // upper-outer face the angled deflection surface. The wedge is a right
    // triangle in the X-Z plane, extruded along Y for the full insert depth.
    divider_outer_x = side_inner_x;   // e.g. +59 East, -59 West
    sweep_x = side_slat_drop * sin(side_slat_angle);
    slat_vert_drop = side_slat_drop * cos(side_slat_angle);
    for (side = [-1, +1]) {
        // Triangle vertices in X-Z (East side, side=+1):
        //   A = (divider_outer_x, 0)                    top-inner (divider's top corner)
        //   B = (divider_outer_x + sweep_x, 0)          top-outer (replaces slat top)
        //   C = (divider_outer_x, -slat_vert_drop)      bottom-inner (slat tip)
        // West mirror: x sign flipped.
        translate([0, 0, 0])
            rotate([90, 0, 0])
                linear_extrude(height = interior_y + 2*wall, center = true)
                    polygon(points = [
                        [side * divider_outer_x,                          0],
                        [side * (divider_outer_x + sweep_x),              0],
                        [side * divider_outer_x,                          -slat_vert_drop]
                    ]);
    }
}

// ----------------------------------------------------------------------------
// Side slats — angled blades hanging from the lip's underside.
//
// Layout mirrors the center zone, rotated 90°:
//   - Outermost slat (closest to outer perimeter wall): top edge AT the
//     outer wall. Body sweeps inward (toward the divider) and down. The
//     deflection-direction "origin wall" is the outer wall.
//   - Innermost slat (closest to the divider): BOTTOM edge AT the
//     divider's outer face. Top centerline sits at divider_face + sweep
//     (inward, i.e. away from the divider). Body fully outside the divider.
//   - Middle slats: top-anchored at intermediate positions.
// All slats sweep their bottoms toward the divider (the "deflection
// destination" is the outer wall; air is redirected outward).
// ----------------------------------------------------------------------------
// side = -1 (left, West), +1 (right, East)
module side_slats(side) {
    // Zone outer/inner edges (in interior coords). For side=+1 (East):
    //   x_outer = +interior_x/2 = +119  (East perimeter wall, interior face)
    //   x_inner = +interior_x/2 - side_zone_width = +59 (divider outer face)
    x_outer = side * (interior_x/2);
    x_inner = side * (interior_x/2 - side_zone_width);

    // Slat tilt about Y. For East side (+1) with positive tilt, the top
    // edge leans toward +X (outer wall). The body sweeps from top toward
    // -X (inner / divider). The mirror image holds for West.
    tilt = side * side_slat_angle;

    // The slat body length IS side_slat_drop (along the slat's own axis).
    pre_tilt_height = side_slat_drop;

    // Sweep along X (centerline-to-bottom-edge displacement). The bottom
    // edge of a slat with top at x_top sits at:
    //     x_bottom = x_top - side * sweep_x
    sweep_x = pre_tilt_height * sin(side_slat_angle);

    // Length along Y: extends past the interior into the N/S perimeter walls
    // so each slat is anchored at both Y ends (1 mm of overlap per side).
    slat_y = interior_y + 2 * wall;

    // The "top span" of the array runs from the outer wall (x_outer) to
    // the position where the innermost slat's top sits (x_inner + side*sweep).
    // Length: zone_width - sweep.
    x_top_inner_slat = x_inner + side * sweep_x;
    top_span = abs(x_outer - x_top_inner_slat);
    inner_pitch_x = top_span / (side_slat_count - 1);

    // The innermost slat (i = side_slat_count - 1) is now replaced by the
    // divider wedge — its angled outer face IS that slat. So we only place
    // slats i = 0 .. side_slat_count - 2.
    for (i = [0 : side_slat_count - 2]) {
        // Walk from the outer wall toward the divider as i increases.
        // For side=+1 (East): outer is at i=0 (x_top = x_outer = +119).
        // For side=-1 (West): outer is at i=0 (x_top = x_outer = -119).
        x_top = x_outer - side * inner_pitch_x * i;

        translate([x_top, 0, slat_top_z])
            rotate([0, tilt, 0])
                translate([0, 0, -pre_tilt_height/2])
                    cube([slat_thickness, slat_y, pre_tilt_height], center = true);
    }
}

// ----------------------------------------------------------------------------
// Center slats — 10 angled blades hanging from the lip's underside, stacked
// along Y across the 140 mm insert depth. Each slat spans center_zone_length
// (88 mm) along X. Rotated around X so top edges lean North, redirecting
// upward airflow toward +Y.
// ----------------------------------------------------------------------------
module center_slats() {
    tilt = center_slat_angle;
    // Slat body length: capped so the slat's North-sweep doesn't exceed one
    // pitch (otherwise the northernmost slat would extend past the wall).
    sweep_y_per_body = sin(tilt);
    pitch = interior_y / (center_slat_count - 1);
    max_body_for_fit = pitch / sweep_y_per_body;
    pre_tilt_height = min(center_slat_drop, max_body_for_fit);

    // Louver layout:
    //   - Southernmost slat (i=0): top at South wall. Body sweeps north/down
    //     into the zone. Wall-anchored at top.
    //   - Northernmost slat (i=count-1): bottom (after sweep) at North wall.
    //     So top centerline sits at y_north - body*sin(tilt). Wall-anchored
    //     at bottom — slat's projected footprint reaches the wall.
    //   - Middle slats: evenly spaced between south top edge and the
    //     northernmost slat's top edge.
    y_south = -interior_y/2;
    y_north =  interior_y/2;
    y_top_north = y_north - pre_tilt_height * sweep_y_per_body;
    inner_pitch = (y_top_north - y_south) / (center_slat_count - 1);

    slat_x_length = center_zone_length + 2 * center_slat_overlap;

    for (i = [0 : center_slat_count - 1]) {
        y_center = y_south + inner_pitch * i;
        translate([0, y_center, slat_top_z])
            rotate([tilt, 0, 0])
                translate([0, 0, -pre_tilt_height/2])
                    cube([slat_x_length, slat_thickness, pre_tilt_height],
                         center = true);
    }
}

// ----------------------------------------------------------------------------
// Throttle bottom rail — inward shelf on the N, S, and W interior walls (NO
// E wall — E is open so the plate can slide in). Plate's bottom face rests
// on top of this rail.
//
// Implementation: a U-shape (three connected strips) at the rail height,
// each `throttle_rail_depth` thick (radially inward).
// ----------------------------------------------------------------------------
module throttle_bottom_rail() {
    rail_h = throttle_rail_depth;  // height of the rail in Z
    z_lo = throttle_ledge_top_z - rail_h;

    // Wall inner faces
    n_y =  insert_outer_y/2 - insert_wall_thickness;  // N wall inner face
    s_y = -insert_outer_y/2 + insert_wall_thickness;  // S wall inner face
    w_x = -insert_outer_x/2 + insert_wall_thickness;  // W wall inner face
    e_x =  insert_outer_x/2 - insert_wall_thickness;  // E wall inner face

    // N and S rails: run E-W along the long walls, full length minus a bit
    // at the E end so they don't poke into the E opening.
    n_rail_y = n_y - throttle_rail_depth/2;  // centerline
    s_rail_y = s_y + throttle_rail_depth/2;
    // Length: from W inner face to E inner face (full interior).
    rail_x_length = e_x - w_x;
    rail_x_center = (e_x + w_x) / 2;

    // W rail: runs N-S along the W wall.
    w_rail_x = w_x + throttle_rail_depth/2;
    w_rail_y_length = n_y - s_y;
    w_rail_y_center = 0;

    translate([0, 0, z_lo])
        linear_extrude(height = rail_h)
            union() {
                // N rail
                translate([rail_x_center, n_rail_y])
                    square([rail_x_length, throttle_rail_depth], center = true);
                // S rail
                translate([rail_x_center, s_rail_y])
                    square([rail_x_length, throttle_rail_depth], center = true);
                // W rail
                translate([w_rail_x, w_rail_y_center])
                    square([throttle_rail_depth, w_rail_y_length], center = true);
            }
}

// ----------------------------------------------------------------------------
// Throttle top rail — inward cap on the N, S, and W interior walls, above
// the bottom rail. Together with the bottom rail it forms a horizontal
// channel that captures the throttle plate's edges.
// ----------------------------------------------------------------------------
module throttle_top_rail() {
    rail_h = throttle_top_rail_thickness;
    z_lo = throttle_top_rail_bottom_z;

    n_y =  insert_outer_y/2 - insert_wall_thickness;
    s_y = -insert_outer_y/2 + insert_wall_thickness;
    w_x = -insert_outer_x/2 + insert_wall_thickness;
    e_x =  insert_outer_x/2 - insert_wall_thickness;

    n_rail_y = n_y - throttle_rail_depth/2;
    s_rail_y = s_y + throttle_rail_depth/2;
    rail_x_length = e_x - w_x;
    rail_x_center = (e_x + w_x) / 2;

    w_rail_x = w_x + throttle_rail_depth/2;
    w_rail_y_length = n_y - s_y;

    translate([0, 0, z_lo])
        linear_extrude(height = rail_h)
            union() {
                translate([rail_x_center, n_rail_y])
                    square([rail_x_length, throttle_rail_depth], center = true);
                translate([rail_x_center, s_rail_y])
                    square([rail_x_length, throttle_rail_depth], center = true);
                translate([w_rail_x, 0])
                    square([throttle_rail_depth, w_rail_y_length], center = true);
            }
}

// ----------------------------------------------------------------------------
// Throttle E-side opening — subtract the E perimeter wall over the channel
// Z range so the throttle plate can slide in horizontally from the E side.
// Width along Y matches the plate's full Y extent (plus clearance) so the
// plate BODY (not just the tab) fits through. This means the E wall is
// effectively removed across the full insert interior Y over the 1.4 mm
// channel height.
// ----------------------------------------------------------------------------
module throttle_e_opening() {
    // Opening Y width: full plate Y plus clearance per side (equals the
    // insert interior Y by construction).
    opening_y = throttle_plate_y + 2*throttle_clearance;
    // Opening Z range: full channel gap. Slightly oversized by eps for
    // clean CSG.
    z_lo = throttle_e_opening_bottom_z - eps;
    z_hi = throttle_e_opening_top_z + eps;
    opening_z = z_hi - z_lo;
    // Cut all the way through the E wall (and a tiny bit further for clean CSG).
    cut_x_depth = insert_wall_thickness + 2*eps;
    cut_x_center = insert_outer_x/2 - insert_wall_thickness/2;

    translate([cut_x_center, 0, z_lo + opening_z/2])
        cube([cut_x_depth, opening_y, opening_z], center = true);
}

// ----------------------------------------------------------------------------
// Throttle W-wall notch — a horizontal slot cut into the inside face of the
// W perimeter wall, at the channel Z range. The throttle plate's W edge
// slides into this notch and seats against the back of it for a pneumatic
// seal.
// ----------------------------------------------------------------------------
module throttle_w_notch() {
    // Slot Z: same as the channel.
    z_lo = throttle_e_opening_bottom_z - eps;
    z_hi = throttle_e_opening_top_z + eps;
    notch_z = z_hi - z_lo;
    // Slot Y: full interior Y minus rail material at top/bottom (the rails
    // extend into the slot from above and below — we don't need to cut them
    // away, but the slot itself needs to be Y-wide enough to clear the rail
    // depth).
    notch_y = insert_outer_y - 2*insert_wall_thickness;
    // Slot cuts into the W wall by throttle_w_notch_depth from the inside
    // face inward (i.e. outward in the global -X direction).
    cut_x_depth = throttle_w_notch_depth + eps;
    w_inner_x = -insert_outer_x/2 + insert_wall_thickness;
    // Cube center X: starts at the W inner face and extends OUTWARD (toward -X).
    cut_x_center = w_inner_x - cut_x_depth/2;

    translate([cut_x_center, 0, z_lo + notch_z/2])
        cube([cut_x_depth, notch_y, notch_z], center = true);
}

// ----------------------------------------------------------------------------
// Throttle (the separate, removable part)
// ----------------------------------------------------------------------------
// A flat rectangle that slides into the vent body's channel from the E side
// until the W edge seats into the W-wall notch. The E edge ends flush with
// the E outer face of the insert. Aluminum duct tape over the E opening
// secures the plate against vibration and seals against air leakage.
//
// Prints flat at Z=0 (XY plane). The plate is symmetric across both axes,
// so it can be installed either way around.
// ----------------------------------------------------------------------------
module throttle() {
    // Per-zone slot positions are anchored to the vent body's zone layout,
    // which is defined in interior_x/y coordinates. The plate is centered
    // on the origin so its X positions match the vent body's zone X
    // positions exactly.
    side_inner_x = interior_x/2 - side_zone_width;

    side_span = side_zone_width - 2*wall;
    side_pitch = side_throttle_slot_count > 1
        ? (side_span - side_throttle_slot_width)
          / (side_throttle_slot_count - 1)
        : 0;

    center_span = interior_y - 2*wall;
    center_pitch = center_throttle_slot_count > 1
        ? (center_span - center_throttle_slot_width)
          / (center_throttle_slot_count - 1)
        : 0;

    // 2D plate profile (with airflow slots cut). Extruded by plate_thickness.
    module plate_profile() {
        difference() {
            square([throttle_plate_x_total, throttle_plate_y], center = true);

            // Side zone slots (E and W).
            for (side = [-1, +1]) {
                zone_outer_x = side * interior_x/2;
                zone_inner_x = side * side_inner_x;
                zone_center_x = (zone_outer_x + zone_inner_x) / 2;
                array_x0 = zone_center_x
                         - (side_throttle_slot_count - 1) * side_pitch / 2;
                for (i = [0 : side_throttle_slot_count - 1]) {
                    translate([array_x0 + i * side_pitch, 0])
                        square([side_throttle_slot_width,
                                side_throttle_slot_length],
                               center = true);
                }
            }

            // Center zone slots.
            array_y0 = -(center_throttle_slot_count - 1) * center_pitch / 2;
            for (j = [0 : center_throttle_slot_count - 1]) {
                translate([0, array_y0 + j * center_pitch])
                    square([center_throttle_slot_length,
                            center_throttle_slot_width],
                           center = true);
            }
        }
    }

    linear_extrude(height = throttle_plate_thickness)
        plate_profile();
}

// ----------------------------------------------------------------------------
// Mounting holes — one on each E/W side of the lip, centered on Y and in the
// middle of the 29 mm lip overhang.
// ----------------------------------------------------------------------------
module mount_holes() {
    hole_x = insert_outer_x/2 + lip_overhang/2;

    for (side = [-1, +1]) {
        translate([side * hole_x, 0, -lip_thickness - eps])
            cylinder(h = lip_thickness + 2*eps, d = mount_hole_diameter);
    }
}
