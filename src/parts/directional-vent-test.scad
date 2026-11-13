// Tests for directional-vent.scad
// Run: openscad -o /tmp/x.stl directional-vent-test.scad
// Non-zero exit = at least one test failed (assert aborts on first failure).
//
// Tests are top-level asserts in order. To find ALL failures, comment out
// passing ones and rerun.

include <directional-vent.scad>

// --- Test E: side slats use a FIXED angle, not solver-derived ---
echo(str("E: side_slat_angle=", side_slat_angle,
         " fixed_slat_angle=", fixed_slat_angle));
assert(side_slat_angle == fixed_slat_angle,
       str("E FAIL: side_slat_angle (", side_slat_angle,
           ") != fixed_slat_angle (", fixed_slat_angle, ")"));

// --- Test F: center slats use a FIXED angle ---
echo(str("F: center_slat_angle=", center_slat_angle,
         " fixed_slat_angle=", fixed_slat_angle));
assert(center_slat_angle == fixed_slat_angle,
       str("F FAIL: center_slat_angle (", center_slat_angle,
           ") != fixed_slat_angle (", fixed_slat_angle, ")"));

// --- Test F2: slat angle is PRINTABLE WITHOUT SUPPORT in PETG ---
// fixed_slat_angle is measured from vertical. The repo's documented PETG
// overhang limit is ~50° from vertical without support. The slats are
// anchored at the top (lip) and at both Y ends, but their bodies are a
// continuous overhang at this angle — so the angle itself must stay at or
// below the limit, otherwise the slicer fills the airflow openings with
// support that cannot be removed. This is the constraint that replaced the
// (removed) permanent support pillars.
petg_overhang_limit_from_vertical = 50;
echo(str("F2: fixed_slat_angle=", fixed_slat_angle,
         " (from vertical) limit=", petg_overhang_limit_from_vertical));
assert(fixed_slat_angle <= petg_overhang_limit_from_vertical,
       str("F2 FAIL: slat angle ", fixed_slat_angle,
           "° from vertical exceeds the ", petg_overhang_limit_from_vertical,
           "° PETG no-support limit — openings will clog with support"));

// --- Test A: side throttle delivers requested open-area ratio ---
// At target ratios above the printable floor: actual ratio is within 20%.
// At/below the printable floor: actual ratio may exceed target (one slot
// pinned to min_printable_slot), but slot count must be exactly 1 and slot
// width must equal min_printable_slot — i.e. we are at the printable floor.
_side_footprint = side_zone_width * insert_depth;
_side_open = side_throttle_slot_count
           * side_throttle_slot_width
           * side_throttle_slot_length;
_side_ratio = _side_open / _side_footprint;
_side_tol = side_open_area * 0.2;
_side_at_floor = (side_throttle_slot_count == 1
                  && side_throttle_slot_width == min_printable_slot
                  && _side_ratio >= side_open_area);
echo(str("A: side open ratio=", _side_ratio,
         " target=", side_open_area, " tol=", _side_tol,
         " at_floor=", _side_at_floor,
         " (slots=", side_throttle_slot_count,
         " w=", side_throttle_slot_width,
         " L=", side_throttle_slot_length, ")"));
assert(abs(_side_ratio - side_open_area) <= _side_tol || _side_at_floor,
       str("A FAIL: side ratio ", _side_ratio,
           " not within ", _side_tol, " of ", side_open_area,
           " and not at printable floor"));

// --- Test B: side throttle slots are printable ---
echo(str("B: side slot width=", side_throttle_slot_width,
         " min_printable_slot=", min_printable_slot));
assert(side_throttle_slot_width >= min_printable_slot,
       str("B FAIL: side slot width ", side_throttle_slot_width,
           " < ", min_printable_slot));

// --- Test C: center throttle delivers requested open-area ratio ---
_center_footprint = center_zone_length * insert_depth;
_center_open = center_throttle_slot_count
             * center_throttle_slot_width
             * center_throttle_slot_length;
_center_ratio = _center_open / _center_footprint;
_center_tol = center_open_area * 0.2;
_center_at_floor = (center_throttle_slot_count == 1
                    && center_throttle_slot_width == min_printable_slot
                    && _center_ratio >= center_open_area);
echo(str("C: center open ratio=", _center_ratio,
         " target=", center_open_area, " tol=", _center_tol,
         " at_floor=", _center_at_floor,
         " (slots=", center_throttle_slot_count,
         " w=", center_throttle_slot_width,
         " L=", center_throttle_slot_length, ")"));
assert(abs(_center_ratio - center_open_area) <= _center_tol || _center_at_floor,
       str("C FAIL: center ratio ", _center_ratio,
           " not within ", _center_tol, " of ", center_open_area,
           " and not at printable floor"));

// --- Test D: center throttle slots are printable ---
echo(str("D: center slot width=", center_throttle_slot_width,
         " min_printable_slot=", min_printable_slot));
assert(center_throttle_slot_width >= min_printable_slot,
       str("D FAIL: center slot width ", center_throttle_slot_width,
           " < ", min_printable_slot));

// --- Test G: `part` parameter exists and defaults to "vent" ---
// (We can't easily inspect what was rendered, but we can check the parameter
// is wired up and the defaults make sense.)
echo(str("G: part=", part));
assert(part == "vent" || part == "throttle",
       str("G FAIL: part must be 'vent' or 'throttle', got ", part));

// --- Test J: bottom rail top sits at the expected Z ---
// The plate rests on top of the bottom rail. (Variable name kept as
// throttle_ledge_top_z for continuity.)
_expected_ledge_top_z = -lip_thickness - insert_height
                      + throttle_ledge_z_offset;
echo(str("J: throttle_ledge_top_z=", throttle_ledge_top_z,
         " expected=", _expected_ledge_top_z));
assert(abs(throttle_ledge_top_z - _expected_ledge_top_z) < 0.001,
       str("J FAIL: bottom rail top z ", throttle_ledge_top_z,
           " != ", _expected_ledge_top_z));

// --- Test L: dividers end at the throttle plate's TOP face ---
// The dividers exist to pneumatically isolate the three zones ABOVE the
// throttle plate. They must rest ON TOP of the plate without intersecting
// it. So divider bottom Z = plate top Z = ledge top + plate thickness.
_expected_dividers_bottom_z = throttle_ledge_top_z + throttle_plate_thickness;
echo(str("L: dividers_bottom_z=", dividers_bottom_z,
         " expected=", _expected_dividers_bottom_z));
assert(abs(dividers_bottom_z - _expected_dividers_bottom_z) < 0.001,
       str("L FAIL: divider bottom z ", dividers_bottom_z,
           " != ", _expected_dividers_bottom_z));

// --- Test M: throttle plate X drops into the LOWER cavity with clearance ---
// The plate is sized off the LOWER (thin-wall) cavity, not the upper shoulder
// hole: plate X = lower_inner_x - 2*clearance. This is what lets it drop in
// from the duct side with throttle_clearance of slop per side AND still be
// wider than the upper shoulder hole so it seats on the shoulder (see M2).
_lower_inner_x = insert_outer_x - 2*insert_wall_thickness;
_expected_plate_x_total = _lower_inner_x - 2*throttle_clearance;
echo(str("M: throttle_plate_x_total=", throttle_plate_x_total,
         " expected=", _expected_plate_x_total));
assert(abs(throttle_plate_x_total - _expected_plate_x_total) < 0.001,
       str("M FAIL: plate x total ", throttle_plate_x_total,
           " != ", _expected_plate_x_total));

// --- Test N: throttle plate Y drops into the LOWER cavity with clearance ---
_lower_inner_y = insert_outer_y - 2*insert_wall_thickness;
_expected_plate_y = _lower_inner_y - 2*throttle_clearance;
echo(str("N: throttle_plate_y=", throttle_plate_y,
         " expected=", _expected_plate_y));
assert(abs(throttle_plate_y - _expected_plate_y) < 0.001,
       str("N FAIL: plate y ", throttle_plate_y,
           " != ", _expected_plate_y));

// --- Test M2: the plate actually SEATS on the shoulder (does not fall through) ---
// The upper (thick) wall section's inner hole is the shoulder opening. For the
// plate to rest ON the shoulder rather than drop through it, the plate must be
// LARGER than the shoulder hole on every side. Overlap per side must be > 0;
// we require a meaningful seat (>= 1 mm, ~2 perimeters of bearing).
_upper_inner_x = insert_outer_x - 2*insert_wall_thickness - 2*throttle_ledge_width;
_upper_inner_y = insert_outer_y - 2*insert_wall_thickness - 2*throttle_ledge_width;
_seat_x = (throttle_plate_x_total - _upper_inner_x) / 2;
_seat_y = (throttle_plate_y       - _upper_inner_y) / 2;
echo(str("M2: shoulder seat per side X=", _seat_x, " Y=", _seat_y,
         " (must be > 0; plate must overhang the shoulder hole)"));
assert(_seat_x >= 1.0,
       str("M2 FAIL: plate seats on shoulder by only ", _seat_x,
           " mm in X — plate would fall through the shoulder hole"));
assert(_seat_y >= 1.0,
       str("M2 FAIL: plate seats on shoulder by only ", _seat_y,
           " mm in Y — plate would fall through the shoulder hole"));

// --- Test O: plate top Z is flush with the dividers' duct-side ends ---
// Plate top = ledge_top + plate_thickness; dividers extend down to that
// same Z (dividers_bottom_z). So plate top and divider bottom should be
// equal — the dividers pneumatically seal against the plate top.
_plate_top_z = throttle_ledge_top_z + throttle_plate_thickness;
echo(str("O: plate top z=", _plate_top_z,
         " dividers_bottom_z=", dividers_bottom_z));
assert(abs(_plate_top_z - dividers_bottom_z) < 0.001,
       str("O FAIL: plate top z ", _plate_top_z,
           " != divider bottom z ", dividers_bottom_z));

// --- Test Q: slat thickness optimized to minimum printable (2 perimeters
// at 0.6 mm nozzle = 1.2 mm) ---
// Going thinner saves filament on the largest material contributor (slats
// account for ~39% of vent volume).
echo(str("Q: slat_thickness=", slat_thickness, " expected=1.2"));
assert(abs(slat_thickness - 1.2) < 0.001,
       str("Q FAIL: slat_thickness ", slat_thickness, " != 1.2"));

// --- Test R: divider shell wall optimized to 2 perimeters (1.2 mm) ---
// Dividers are hollow boxes serving as zone air-seals only — not load
// bearing. Anchored at the lip (bottom) and throttle plate (top), so 2
// perimeters of PETG is plenty for stiffness.
echo(str("R: divider_wall=", divider_wall, " expected=1.2"));
assert(abs(divider_wall - 1.2) < 0.001,
       str("R FAIL: divider_wall ", divider_wall, " != 1.2"));

// --- Test S: lip short-side overhang trimmed to 10 mm ---
// The N/S overhang has no mount holes (those are on E/W). 10 mm gives
// enough visual coverage of a typical ceiling cutout without wasting
// filament on extra flange material.
echo(str("S: lip_overhang_short=", lip_overhang_short, " expected=10"));
assert(abs(lip_overhang_short - 10) < 0.001,
       str("S FAIL: lip_overhang_short ", lip_overhang_short, " != 10"));

// --- Test P: ledge inward width is 3 mm (~5 perimeters at 0.6 mm nozzle) ---
// The ledge protrudes inward from the perimeter walls by throttle_ledge_
// width. It's just enough to support the plate edge without intruding
// into the slat zone above.
echo(str("P: throttle_ledge_width=", throttle_ledge_width,
         " (plate sits on the step at z=", throttle_ledge_top_z, ")"));
assert(throttle_ledge_width >= 1.2,
       str("P FAIL: ledge width ", throttle_ledge_width,
           " < 1.2 mm — too narrow to support plate edge"));
assert(throttle_ledge_width <= 10,
       str("P FAIL: ledge width ", throttle_ledge_width,
           " > 10 mm — intrudes too far into airflow path"));

// (Tests T and V — slat support pillars — removed. The pillars were a
// permanent in-print support for the old 65° slats. At the current
// printable slat angle (<= 50° from vertical, Test F2) the slats are
// self-supporting, so the pillars were deleted along with their geometry.)

// --- Test W: slot dimensions respect the tape margin ---
// A non-slotted band of throttle_tape_margin width must remain around
// the plate perimeter so HVAC tape has somewhere to grip without
// covering airflow slots. Validates that:
//   • Side slot length (along Y) ≤ plate_y - 2*tape_margin
//   • Center slot length (along X) ≤ plate_x - 2*tape_margin
//   • Center slot array Y span (count × pitch) ≤ plate_y - 2*tape_margin
_side_slot_y_extent = side_throttle_slot_length;
_center_slot_x_extent = center_throttle_slot_length;
_max_y_extent = throttle_plate_y - 2*throttle_tape_margin;
_max_x_extent = throttle_plate_x_total - 2*throttle_tape_margin;
echo(str("W: side slot Y=", _side_slot_y_extent, " max=", _max_y_extent,
         " | center slot X=", _center_slot_x_extent, " max=", _max_x_extent,
         " | tape_margin=", throttle_tape_margin));
assert(_side_slot_y_extent <= _max_y_extent + 0.001,
       str("W FAIL: side slot Y extent ", _side_slot_y_extent,
           " exceeds plate_y - 2*tape_margin = ", _max_y_extent));
assert(_center_slot_x_extent <= _max_x_extent + 0.001,
       str("W FAIL: center slot X extent ", _center_slot_x_extent,
           " exceeds plate_x - 2*tape_margin = ", _max_x_extent));
// Center slot array Y span: count slots of width center_throttle_slot_width
// spaced over center_span = plate_y - 2*tape_margin. The outermost slot
// centers sit at ±(center_span - slot_width)/2; outer edges at ±center_span/2.
assert(throttle_plate_y - 2*throttle_tape_margin >= center_throttle_slot_width - 0.001,
       str("W FAIL: tape margin leaves no room for center slot width"));

echo("ALL TESTS PASSED");
