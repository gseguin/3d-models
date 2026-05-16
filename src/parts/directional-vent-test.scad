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

// --- Test M: throttle plate is the length of the outer E/W neck distance ---
// Plate spans from the W outer face (seated in W-wall notch) to the E
// outer face (flush with E opening), minus throttle_clearance so it
// doesn't bottom-out on insertion. No finger tab — duct tape over the E
// opening secures it.
_expected_plate_x_total = insert_outer_x - throttle_clearance;
echo(str("M: throttle_plate_x_total=", throttle_plate_x_total,
         " expected=", _expected_plate_x_total));
assert(abs(throttle_plate_x_total - _expected_plate_x_total) < 0.001,
       str("M FAIL: plate x total ", throttle_plate_x_total,
           " != ", _expected_plate_x_total));

// --- Test N: plate N-S spans full interior with clearance, edges captured
// by top/bottom rails ---
// Plate Y = interior_y - 2*clearance. The rails (throttle_rail_depth wide
// each) extend over the outer rail_depth of plate Y on each side, capturing
// the plate vertically.
_expected_plate_y = interior_y - 2*throttle_clearance;
echo(str("N: throttle_plate_y=", throttle_plate_y,
         " expected=", _expected_plate_y));
assert(abs(throttle_plate_y - _expected_plate_y) < 0.001,
       str("N FAIL: plate y ", throttle_plate_y,
           " != ", _expected_plate_y));

// --- Test O: top rail bottom Z sits one channel-gap above the bottom rail
// top (= throttle_ledge_top_z), giving plate Z clearance ---
_expected_top_rail_bottom_z = throttle_ledge_top_z + throttle_channel_gap;
echo(str("O: throttle_top_rail_bottom_z=", throttle_top_rail_bottom_z,
         " expected=", _expected_top_rail_bottom_z));
assert(abs(throttle_top_rail_bottom_z - _expected_top_rail_bottom_z) < 0.001,
       str("O FAIL: top rail bottom z ", throttle_top_rail_bottom_z,
           " != ", _expected_top_rail_bottom_z));

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

// --- Test P: E opening Z range matches the channel ---
// The E wall is removed (subtracted) over a Z range that spans the channel
// so the plate can slide in. Opening Z bottom = bottom rail top; top = top
// rail bottom. (We expose throttle_e_opening_bottom_z / _top_z for testing.)
echo(str("P: e opening z=[", throttle_e_opening_bottom_z, ", ",
         throttle_e_opening_top_z, "]",
         " expected=[", throttle_ledge_top_z, ", ",
         throttle_top_rail_bottom_z, "]"));
assert(abs(throttle_e_opening_bottom_z - throttle_ledge_top_z) < 0.001
       && abs(throttle_e_opening_top_z - throttle_top_rail_bottom_z) < 0.001,
       "P FAIL: E opening Z range doesn't match channel");

echo("ALL TESTS PASSED");
