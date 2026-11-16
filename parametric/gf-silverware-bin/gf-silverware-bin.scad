// ============================================================================
// Gridfinity Parametric Silverware Organizer - V10.38
// ============================================================================
//
// A fully parametric OpenSCAD model for creating custom silverware organizers
// compatible with the Gridfinity storage system. This model allows you to
// create perfectly fitting organizers for your specific cutlery set.
//
// Key Features:
// - Configurable utensil slots (knives, forks, spoons, dessert forks, teaspoons)
// - Parametric shim system for leverage handles (elevates handles for easy access)
// - Central finger cutout trench for easy utensil access (straight or wavy)
// - Gridfinity base compatibility with optional magnets and stacking lip
// - Multiple alignment modes (centered, top, bottom, neck-aligned)
// - Test slice mode for quick fit verification before full print
// - Minimalist mode for reduced material usage
// - 2D footprint projection for paper template printing
// - Support for utensil stacking with configurable stack heights
// - Flexible slot ordering and orientation options
//
// Usage:
// 1. Measure your utensils (length, handle length, widths, thickness)
// 2. Adjust parameters in the Customizer (F5 in OpenSCAD)
// 3. Use test slice mode to verify fit before full print
// 4. Generate full organizer when satisfied
//
// Version History:
// V10.38 - Fixed fractional-edge grid bug: gf_edge_left/right/front/back
//          previously ADDED a fractional grid unit on top of the auto-computed
//          footprint, silently forcing a full extra 42mm Gridfinity base
//          column/row (visually clipped to look partial) — a 5x6 layout with
//          gf_edge_left=0.3 actually needed 6x6 of drawer space. Edges are now
//          TRIMS (0 = full unit, 1 = fully removed) that shrink the footprint,
//          so the physical footprint is always exactly gf_grid_x x gf_grid_y
//          cells. Default gf_edge_left changed from 0.30 to 0.0 so a fresh
//          load doesn't trigger this by default. (Reported by @Rhinous on
//          MakerWorld.)
// V10.37 - Fixed shim length gap: Extended shim geometry start point from -1mm
//          to -10mm to ensure shim covers utensil_margin offset area at handle
//          end, eliminating gap visible in 2D footprint.
// V10.36 - Fixed shim wall gap: Increased lateral overlap (width + 4) for 
//          better wall coverage.
//
// ============================================================================

// ============================================================================
// CONFIGURATION PARAMETERS
// ============================================================================

/* [Mode] */
// Configuration mode: manual allows full control, wizard auto-calculates slots
// Wizard mode automatically calculates slot counts based on items_per_stack
config_mode = "manual"; // [manual:Manual, wizard:Wizard]

// Generate a thin test slice to verify slot dimensions before full print
// Recommended: Use this first to test fit with minimal material usage
generate_test_slice = false;

// If true, resizes bin to minimum bounding box with thinner walls
// Reduces material usage and print time while maintaining functionality
minimalist = true;

// If true, generates a 2D SVG projection for printing on paper to test fit
// Useful for verifying slot dimensions without printing a 3D model
generate_2d_footprint = false;

/* [Fit Settings] */
// Total diametric air gap around utensils (e.g., 3.0mm = 1.5mm clearance on ALL sides)
// This clearance ensures utensils can be easily inserted and removed
utensil_margin = 3.0;

/* [Shim Settings (Leverage Handles)] */
// Shims are wedges placed under utensil handles to elevate them for easier access
// Height of the wedge under the handle end in mm. Set to 0 to disable shim.
// The wedge will be flat for 'flat_length', then taper smoothly to the floor.
// Taper automatically ends at 3/4 of handle length OR the finger cutout, whichever is closer.
// This creates a leverage point making it easier to grab utensils from the bin.

knife_shim_height = 16.7;        // Height of knife handle shim (mm)
knife_shim_flat_length = 15.0;  // Length of flat section before taper (mm)

fork_shim_height = 0;            // Height of fork handle shim (mm)
fork_shim_flat_length = 15.0;   // Length of flat section before taper (mm)

tablespoon_shim_height = 0;     // Height of tablespoon handle shim (mm)
tablespoon_shim_flat_length = 15.0; // Length of flat section before taper (mm)

dessert_fork_shim_height = 0;   // Height of dessert fork handle shim (mm)
dessert_fork_shim_flat_length = 15.0; // Length of flat section before taper (mm)

teaspoon_shim_height = 0;       // Height of teaspoon handle shim (mm)
teaspoon_shim_flat_length = 15.0; // Length of flat section before taper (mm)

/* [Layout Order] */
// Control the left-to-right order of utensil sections (1-5)
// Lower numbers appear first (leftmost), higher numbers appear last (rightmost)
order_knives = 1; 
order_forks = 2; 
order_tablespoons = 3; 
order_dessert_forks = 4;
order_teaspoons = 5;

/* [Retention & Access Style] */
// Controls how utensils align vertically within the bin
// - centered: Utensils centered in available space
// - top: Utensils aligned to top (handles at top)
// - bottom: Utensils aligned to bottom (tips at bottom)
// - neck: Handles aligned at same height (visual neck alignment)
utensil_alignment_y = "centered"; // [centered:Centered, top:Top Aligned, bottom:Bottom Aligned, neck:Neck Aligned]

// Global orientation override: standard, flipped, or individual control
// - auto: Automatically alternates if multiple slots, otherwise standard
// - standard: All utensils in standard orientation
// - flipped: All utensils flipped 180 degrees
// - individual: Use individual utensil orientation settings below
force_orientation = "auto"; // [auto:Auto, standard:Standard, flipped:Flipped, individual:Individual]

// Individual utensil orientations (when force_orientation is "individual")
// Options: "auto" (alternates if multiple slots), "standard", "flipped", "alternate"
knife_orientation = "alternate"; // [auto:Auto, standard:Standard, flipped:Flipped, alternate:Alternate]
fork_orientation = "auto"; // [auto:Auto, standard:Standard, flipped:Flipped, alternate:Alternate]
dessert_fork_orientation = "auto"; // [auto:Auto, standard:Standard, flipped:Flipped, alternate:Alternate]
teaspoon_orientation = "auto"; // [auto:Auto, standard:Standard, flipped:Flipped, alternate:Alternate]
tablespoon_orientation = "auto"; // [auto:Auto, standard:Standard, flipped:Flipped, alternate:Alternate]

// Retention tabs (Collars) - Small tabs at handle ends to prevent utensils from falling out
// Automatically hidden in Test Slice mode for easier testing
enable_handle_collar = true;
collar_length = 15; // Length of retention collar along utensil axis (mm)

/* [Finger Cutout] */
// Central trench cutout for easy utensil access
enable_finger_cutout = false;

// Style of the trench cut: straight (simple) or wavy (decorative sinusoidal pattern)
trench_style = "straight"; // [straight:Straight, wavy:Wavy]

// Width of the finger cutout at the bottom (floor level) in mm
finger_cutout_width = 40;

// Wave amplitude for wavy trench style (vertical offset in mm)
trench_wave_amplitude = 4.0; 

// Wave period for wavy trench style (horizontal distance for one full wave in mm)
trench_wave_period = 110;

// Y-axis offset to shift trench position forward/backward (mm, negative = forward)
trench_y_offset = -10; 

// Wave phase offset for wavy trench (degrees, 0-360)
trench_wave_phase = 0; 

// Angle of trench expansion on south side (degrees, 10-90)
cutout_south_angle = 70; 

// Angle of trench expansion on north side (degrees, 10-90)
cutout_north_angle = 90;

// Fillet radius for rounded corners of the trench (mm)
finger_cutout_radius = 5;

/* [Height Settings] */
// Maximum allowed bin height in millimeters (prevents excessive height)
max_bin_height = 66; 

/* [Stacking Settings] */
// Number of utensils that stack vertically in each slot
// Used to calculate required bin height
items_per_stack = 6;

/* [Utensil Stack Unit Height] */
// Height of one stack unit for each utensil type (measured from your utensils)
// Formula: Measure total height of stacked utensils, divide by number of items
// These values determine the minimum bin height needed
// RE-CALCULATED: Derived from Total Tip Height - ((Count-1) * HandleThickness)
knife_stack_unit_height = 32.47; // Target ~63.1mm total (with shim)
fork_stack_unit_height = 34.0;   // Target 49mm total
dessert_fork_stack_unit_height = 30.85; // Target 50mm total
teaspoon_stack_unit_height = 20.75; // Target 39.5mm total
tablespoon_stack_unit_height = 25.5; // Target 45.5mm total

/* [Knives] */
// Number of knife slots to create
knife_slots = 2;

// Knife dimensions (measure from your actual knives)
knife_blade_length = 120;        // Length of blade portion (mm)
knife_handle_length = 115;       // Length of handle portion (mm)
knife_neck_length = 5;           // Length of neck/bolster section (mm)
knife_neck_width = 12.5;         // Width of neck/bolster (mm)
knife_handle_width_base = 18.9;  // Width of handle at base/widest part (mm)
knife_handle_width_neck = 12;    // Width of handle at neck (narrowest before blade) (mm)
knife_blade_taper_height = 8;    // Height of blade taper section (mm)
knife_blade_flat_length = 55;    // Length of flat blade section before tip curve (mm)
knife_blade_start_width = 21;    // Width of blade where it meets handle (mm)
knife_blade_widest_width = 21;   // Widest width of blade (usually near middle) (mm)
knife_blade_tip_width = 5;      // Width of blade at tip (mm)
knife_handle_thickness = 6.125;  // Thickness of knife handle (vertical dimension) (mm)
knife_blade_curve = 3.8;        // Curvature factor for blade profile (affects blade shape) (mm)

/* [Forks] */
// Number of fork slots to create
fork_slots = 1;

// Fork dimensions (measure from your actual forks)
fork_tines_length = 75;          // Length of tines/head portion (mm)
fork_handle_length = 131;        // Length of handle portion (mm)
fork_neck_length = 5;            // Length of neck section (mm)
fork_handle_width_base = 16.5;   // Width of handle at base/widest part (mm)
fork_handle_width_neck = 6.0;    // Width of handle at neck (narrowest before head) (mm)
fork_head_width = 27.0;          // Width of fork head/tines (mm)
fork_handle_thickness = 3.0;     // Thickness of fork handle (vertical dimension) (mm)
fork_curve_factor = 0.6;        // Curvature factor for fork profile (affects transition smoothness)
fork_head_draft_angle = 0;       // Draft angle for fork head (degrees) - creates tapered ramp at bottom
                                 // Set to 0 to remove the "tab" ramp at the bottom for easier insertion

/* [Table Spoons] */
// Number of tablespoon slots to create
tablespoon_slots = 1; 

// Tablespoon dimensions (measure from your actual spoons)
tablespoon_bowl_length = 65;     // Length of bowl portion (mm)
tablespoon_handle_length = 123;  // Length of handle portion (mm)
tablespoon_neck_length = 5;      // Length of neck section (mm)
tablespoon_handle_width_base = 15.75; // Width of handle at base/widest part (mm)
tablespoon_handle_width_neck = 6.75;  // Width of handle at neck (narrowest before bowl) (mm)
tablespoon_bowl_width = 40.0;    // Maximum width of bowl (mm)
tablespoon_bowl_widest_ratio = 0.45; // Ratio (0-1) where bowl is widest: 0 = at neck, 1 = at tip
                                     // 0.45 means widest point is 45% along bowl length from neck
tablespoon_handle_thickness = 4.0; // Thickness of tablespoon handle (vertical dimension) (mm)
tablespoon_head_draft_angle = 0;  // Draft angle for spoon bowl (degrees) - creates tapered ramp at bottom
                                   // Set to 0 to remove the "tab" ramp at the bottom for easier insertion

/* [Dessert Forks] */
// Number of dessert fork slots to create
dessert_fork_slots = 1;

// Dessert fork dimensions (measure from your actual dessert forks)
dessert_fork_tines_length = 65;  // Length of tines/head portion (mm)
dessert_fork_handle_length = 118; // Length of handle portion (mm)
dessert_fork_neck_length = 5;    // Length of neck section (mm)
dessert_fork_head_width = 27.0;  // Width of fork head/tines (mm)
dessert_fork_handle_width_base = 15.75; // Width of handle at base/widest part (mm)
dessert_fork_handle_width_neck = 5.75; // Width of handle at neck (narrowest before head) (mm)
dessert_fork_handle_thickness = 3.83;   // Thickness of dessert fork handle (vertical dimension) (mm)
dessert_fork_curve_factor = 0.6;       // Curvature factor for fork profile (affects transition smoothness)
dessert_fork_head_draft_angle = 0;     // Draft angle for fork head (degrees) - creates tapered ramp at bottom
                                        // Set to 0 to remove the "tab" ramp at the bottom for easier insertion

/* [Tea Spoons / Dessert Spoons] */
// Number of teaspoon slots to create
teaspoon_slots = 1;

// Teaspoon dimensions (measure from your actual teaspoons)
teaspoon_bowl_length = 59;       // Length of bowl portion (mm)
teaspoon_handle_length = 100;    // Length of handle portion (mm)
teaspoon_neck_length = 5;        // Length of neck section (mm)
teaspoon_handle_width_base = 13.0; // Width of handle at base/widest part (mm)
teaspoon_handle_width_neck = 6;   // Width of handle at neck (narrowest before bowl) (mm)
teaspoon_bowl_width = 34.0;      // Maximum width of bowl (mm)
teaspoon_bowl_widest_ratio = 0.45; // Ratio (0-1) where bowl is widest: 0 = at neck, 1 = at tip
                                    // 0.45 means widest point is 45% along bowl length from neck
teaspoon_handle_thickness = 3.75; // Thickness of teaspoon handle (vertical dimension) (mm)
teaspoon_head_draft_angle = 0;    // Draft angle for spoon bowl (degrees) - creates tapered ramp at bottom
                                   // Set to 0 to remove the "tab" ramp at the bottom for easier insertion

/* [Miscellaneous Bin] */
// Enable an extra bin for miscellaneous items (serving utensils, etc.)
enable_misc_bin = true;

// Minimum width for misc bin in mm (will expand to fill available space)
misc_bin_min_width = 0; 

// Position of misc bin: "left" or "right" of utensil slots
misc_bin_position = "right"; // [left:Left, right:Right]

/* [Construction] */
// Standard wall thickness between slots and outer walls in mm
wall_thickness = 5.0; 

// Thickness of bin bottom in mm
bottom_thickness = 2;

// Fillet radius for rounded corners on slots and bin edges in mm
fillet_radius = 2;

// Slot depth override (0 = auto-calculate based on bin height)
slot_depth = 0;

// Outer wall thickness when in minimalist mode (thinner for material savings)
minimalist_wall_thickness = 2.0;

/* [Gridfinity Base] */
// Enable Gridfinity-compatible base (required for Gridfinity compatibility)
gf_enable_base = true;

// Enable stacking lip for stacking multiple bins
gf_enable_stacking_lip = false;

// Enable magnet holes in base (for magnetic baseplates)
gf_enable_magnets = false;

/* [Fractional Edges] */
// Fractional grid units to TRIM off the outer edge (0-1). 0 = full-size grid
// unit on that side, 1 = that side's unit fully removed. Use this to shave a
// bin down when the drawer isn't an exact multiple of 42mm — it never adds
// footprint, so it never requires an extra Gridfinity base column/row.
gf_edge_left = 0.0; // [0:0.01:1]
gf_edge_right = 0.0; // [0:0.01:1]
gf_edge_front = 0.0; // [0:0.01:1]
gf_edge_back = 0.0; // [0:0.01:1]

/* [Grid Size] */
// Automatically calculate grid size based on content, or use manual values
gf_auto_size = true;

// Manual grid size in X direction (when auto_size is false)
gf_manual_x = 6;

// Manual grid size in Y direction (when auto_size is false)
gf_manual_y = 6;

/* [Build Plate] */
// Build plate dimensions for split calculations (mm)
build_plate_x = 250; 
build_plate_y = 250; 

// Part to render: 0 = full organizer, 1 = left split, 2 = right split
part_to_render = 0; // [0:Full, 1:Left, 2:Right]

// Connector type for split parts (not currently used)
connector_type = "dovetail";
connector_depth = 8;
connector_width = 15;
connector_tolerance = 0.2;

/* [Hidden] */
// OpenSCAD rendering quality (higher = smoother but slower rendering)
// Recommended: 64 for preview, 128+ for final export
$fn = 64;

// Gridfinity system constants (42mm pitch standard)
gf_pitch = 42;              // Grid pitch (center-to-center distance)
gf_clearance = 0.5;        // Clearance between bins
gf_unit = gf_pitch - gf_clearance;
gf_base_height = 5;         // Height of Gridfinity base
gf_z_unit = 7;              // Vertical unit height for stacking
gf_lip_height = 4.4;       // Height of stacking lip
gf_magnet_d = 6.5;         // Magnet hole diameter
gf_magnet_h = 2.4;         // Magnet hole depth
gf_bin_corner_radius = 3.75; // Corner radius for rounded bins

// ============================================================================
// COMPUTED VARIABLES & MODE PROCESSING
// ============================================================================

// Calculate total utensil lengths from component parts
knife_length = knife_handle_length + knife_neck_length + knife_blade_length;
knife_neck_height = knife_neck_length;

fork_length = fork_handle_length + fork_neck_length + fork_tines_length;
tablespoon_length = tablespoon_handle_length + tablespoon_neck_length + tablespoon_bowl_length;
dessert_fork_length = dessert_fork_handle_length + dessert_fork_neck_length + dessert_fork_tines_length;
teaspoon_length = teaspoon_handle_length + teaspoon_neck_length + teaspoon_bowl_length;

// Helper: Check if collar should be active (User wants it AND we are not testing)
// Collars are automatically disabled in test slice mode for easier testing
show_collar = enable_handle_collar && !generate_test_slice;

// Mode Processing: Calculate active slot counts based on wizard/manual mode
// Wizard mode: Automatically calculates slots needed for 12 items per stack
// Manual mode: Uses user-specified slot counts
// Cache wizard slot count calculation to avoid repeated division
_wizard_slot_count = config_mode == "wizard" ? ceil(12 / items_per_stack) : 0;
active_knife_slots = config_mode == "wizard" ? _wizard_slot_count : knife_slots;
active_fork_slots = config_mode == "wizard" ? _wizard_slot_count : fork_slots;
active_dessert_fork_slots = config_mode == "wizard" ? _wizard_slot_count : dessert_fork_slots;
active_teaspoon_slots = config_mode == "wizard" ? _wizard_slot_count : teaspoon_slots;
active_tablespoon_slots = config_mode == "wizard" ? _wizard_slot_count : tablespoon_slots;

// ============================================================================
// WIDTH CALCULATIONS
// Calculate maximum width for each utensil type and add clearance
// This ensures slots are wide enough to accommodate the widest part of each utensil
// ============================================================================

// Knife width calculation: accounts for asymmetric blade profile
k_occupy_left = knife_handle_width_base / 2;
k_occupy_right = max(knife_handle_width_base / 2, (knife_blade_widest_width - (knife_handle_width_neck / 2)));
knife_slot_width = k_occupy_left + k_occupy_right + utensil_margin;
knife_center_offset = k_occupy_left + (utensil_margin / 2);

// Other utensils: simple max width calculation
fork_max_width = max(fork_handle_width_base, fork_head_width);
fork_slot_width = fork_max_width + utensil_margin;

tablespoon_max_width = max(tablespoon_handle_width_base, tablespoon_bowl_width);
tablespoon_slot_width = tablespoon_max_width + utensil_margin;

teaspoon_max_width = max(teaspoon_handle_width_base, teaspoon_bowl_width);
teaspoon_slot_width = teaspoon_max_width + utensil_margin;

dessert_fork_max_width = max(dessert_fork_handle_width_base, dessert_fork_head_width);
dessert_fork_slot_width = dessert_fork_max_width + utensil_margin;

// ============================================================================
// HEIGHT CALCULATIONS
// Calculate required bin height based on stack heights and Gridfinity units
// ============================================================================

// Test Slice Height: Minimum height needed to test slot fit
// Uses handle thickness + small margin to verify slot width and profile
test_slice_height = max(
    active_knife_slots > 0 ? knife_handle_thickness + 2 : 0,
    active_fork_slots > 0 ? fork_handle_thickness + 2 : 0,
    active_tablespoon_slots > 0 ? tablespoon_handle_thickness + 2 : 0,
    active_teaspoon_slots > 0 ? teaspoon_handle_thickness + 2 : 0,
    active_dessert_fork_slots > 0 ? dessert_fork_handle_thickness + 2 : 0
);

// Height Calculations: Calculate stack heights and Gridfinity z-units
// Calculates total height needed for stacked utensils
// Formula: (count * handle_thickness) + (unit_height - handle_thickness)
// This accounts for overlapping handles in a stack
function calc_stack_height(count, unit_height, handle_thickness) = 
    count <= 0 ? 0 : (count * handle_thickness) + (unit_height - handle_thickness);

// Calculate maximum stack height across all utensil types
max_stack_height = max(
    active_knife_slots > 0 ? calc_stack_height(items_per_stack, knife_stack_unit_height, knife_handle_thickness) : 0,
    active_fork_slots > 0 ? calc_stack_height(items_per_stack, fork_stack_unit_height, fork_handle_thickness) : 0,
    active_dessert_fork_slots > 0 ? calc_stack_height(items_per_stack, dessert_fork_stack_unit_height, dessert_fork_handle_thickness) : 0,
    active_teaspoon_slots > 0 ? calc_stack_height(items_per_stack, teaspoon_stack_unit_height, teaspoon_handle_thickness) : 0,
    active_tablespoon_slots > 0 ? calc_stack_height(items_per_stack, tablespoon_stack_unit_height, tablespoon_handle_thickness) : 0
);

// Calculate required height: stack height + bottom + base + small margin
required_mm_height = max_stack_height + bottom_thickness + gf_base_height + 3;

// Calculate Gridfinity z-units needed (rounded up)
gf_calc_grid_z = ceil((required_mm_height - gf_base_height) / gf_z_unit);

// Limit z-units based on maximum bin height constraint
gf_limit_grid_z = floor((max_bin_height - gf_base_height) / gf_z_unit);

// Final z-units: ensure minimum of 6, but don't exceed limit
gf_grid_z = min(max(gf_calc_grid_z, 6), gf_limit_grid_z);

// Final dimensions based on mode
final_total_height = generate_test_slice ? test_slice_height : (gf_base_height + (gf_grid_z * gf_z_unit));
final_floor_z = generate_test_slice ? 0 : (gf_base_height + bottom_thickness);
final_slot_depth = generate_test_slice ? test_slice_height + 2 : (final_total_height - final_floor_z + gf_lip_height + 5);
final_z_pos = generate_test_slice ? -1 : final_floor_z;

// ============================================================================
// SECTION WIDTH CALCULATIONS
// Calculate total width needed for all utensil sections based on order
// Each section width = (number_of_slots * (slot_width + wall_thickness))
// ============================================================================
function calc_section_width(order_pos) = 
    (order_knives == order_pos && active_knife_slots > 0) ? (active_knife_slots * (knife_slot_width + wall_thickness)) :
    (order_forks == order_pos && active_fork_slots > 0) ? (active_fork_slots * (fork_slot_width + wall_thickness)) :
    (order_dessert_forks == order_pos && active_dessert_fork_slots > 0) ? (active_dessert_fork_slots * (dessert_fork_slot_width + wall_thickness)) :
    (order_teaspoons == order_pos && active_teaspoon_slots > 0) ? (active_teaspoon_slots * (teaspoon_slot_width + wall_thickness)) :
    (order_tablespoons == order_pos && active_tablespoon_slots > 0) ? (active_tablespoon_slots * (tablespoon_slot_width + wall_thickness)) : 0;

// Total content width: sum of all sections
w_total_content = calc_section_width(1) + calc_section_width(2) + calc_section_width(3) + calc_section_width(4) + calc_section_width(5);

// ============================================================================
// ALIGNMENT HELPER CALCULATIONS
// Calculate maximum handle/head lengths for alignment modes
// Used to determine bin depth and alignment offsets
// ============================================================================
calc_max_handle = max(
    active_knife_slots > 0 ? knife_handle_length : 0,
    active_fork_slots > 0 ? fork_handle_length : 0,
    active_dessert_fork_slots > 0 ? dessert_fork_handle_length : 0,
    active_teaspoon_slots > 0 ? teaspoon_handle_length : 0,
    active_tablespoon_slots > 0 ? tablespoon_handle_length : 0
);

calc_max_head = max(
    active_knife_slots > 0 ? (knife_length - knife_handle_length) : 0,
    active_fork_slots > 0 ? (fork_length - fork_handle_length) : 0,
    active_dessert_fork_slots > 0 ? (dessert_fork_length - dessert_fork_handle_length) : 0,
    active_teaspoon_slots > 0 ? (teaspoon_length - teaspoon_handle_length) : 0,
    active_tablespoon_slots > 0 ? (tablespoon_length - tablespoon_handle_length) : 0
);

calc_absolute_max_len = max(
    active_knife_slots > 0 ? knife_length : 0,
    active_fork_slots > 0 ? fork_length : 0,
    active_dessert_fork_slots > 0 ? dessert_fork_length : 0,
    active_teaspoon_slots > 0 ? teaspoon_length : 0,
    active_tablespoon_slots > 0 ? tablespoon_length : 0
);

// If neck aligned, we need space for longest handle + longest head
// Otherwise, just use the longest item's total length
max_utensil_length = (utensil_alignment_y == "neck") ? (calc_max_handle + calc_max_head) : calc_absolute_max_len;

// ============================================================================
// GRID SIZE CALCULATIONS
// Calculate required Gridfinity grid dimensions (x, y) based on content size
// Gridfinity uses a 42mm pitch system for modular storage
// ============================================================================

// Total content depth: max utensil length + walls on both sides
total_content_depth = max_utensil_length + 2 * wall_thickness;

// Minimum width needed: content width + misc bin (if enabled) + clearance
min_total_width_required = w_total_content + (enable_misc_bin ? misc_bin_min_width + wall_thickness : 0) + gf_clearance;

// Calculate grid units needed (rounded up)
gf_auto_x = ceil(min_total_width_required / gf_pitch);
gf_auto_y = ceil((total_content_depth + gf_clearance) / gf_pitch);

// Use auto-calculated or manual grid size (minimum 2x2)
gf_grid_x = gf_auto_size ? max(2, gf_auto_x) : gf_manual_x;
gf_grid_y = gf_auto_size ? max(2, gf_auto_y) : gf_manual_y;

// Convert fractional edges to millimeters
gf_edge_left_mm = gf_edge_left * gf_pitch;
gf_edge_right_mm = gf_edge_right * gf_pitch;
gf_edge_front_mm = gf_edge_front * gf_pitch;
gf_edge_back_mm = gf_edge_back * gf_pitch;

// Calculate final bin dimensions: full grid footprint minus any trimmed edges.
// Trimming never grows the footprint, so it never requires an extra base
// column/row (see gridfinity_base(), which draws exactly gf_grid_x x gf_grid_y feet).
total_width = gf_grid_x * gf_pitch - gf_clearance - gf_edge_left_mm - gf_edge_right_mm;
total_depth = gf_grid_y * gf_pitch - gf_clearance - gf_edge_front_mm - gf_edge_back_mm;

// ============================================================================
// EFFECTIVE DIMENSIONS & HELPER VARIABLES
// Calculate actual dimensions accounting for minimalist mode and test slices
// Minimalist mode creates a tight-fitting bin with thinner walls
// ============================================================================
use_minimalist_layout = minimalist && (generate_test_slice || generate_2d_footprint);

// Calculate minimal bounding box for minimalist mode
eff_total_width = use_minimalist_layout ? (w_total_content + wall_thickness) : total_width;
eff_total_depth = use_minimalist_layout ? (max_utensil_length + utensil_margin + 2*wall_thickness) : total_depth;

// Cache available slot depth calculation (used multiple times)
// eff_total_depth already has any trimmed edges subtracted out (see total_depth above),
// so only the walls need to be subtracted here.
_available_slot_depth = eff_total_depth - 2 * wall_thickness;

// Misc Bin Logic
// Calculate available width for misc bin after accounting for utensil slots
usable_width = total_width - 2 * wall_thickness;
remaining_width = usable_width - w_total_content;

// Misc bin is active if enabled, has enough space, and not in minimalist test mode
misc_bin_active = enable_misc_bin && (remaining_width >= misc_bin_min_width) && !use_minimalist_layout;
misc_bin_width = misc_bin_active ? remaining_width : 0;

// Determine if a utensil slot should be flipped based on orientation settings
// Flipped utensils have handles at the opposite end (180° rotation)
function is_flipped(index, orientation, total_slots) = 
    (force_orientation == "standard") ? false :
    (force_orientation == "flipped") ? true :
    orientation == "flipped" ? true :
    orientation == "alternate" ? (index % 2 == 1) :
    orientation == "auto" ? (total_slots > 1 ? (index % 2 == 1) : false) : false;

// ============================================================================
// SPLIT LOGIC
// Handle splitting large bins that exceed build plate dimensions
// Allows printing oversized bins in two parts that can be joined
// ============================================================================
exceeds_x = total_width > build_plate_x;
split_pos = exceeds_x ? total_width / 2 : total_width;

// ============================================================================
// MAIN RENDER LOGIC
// Select which part to render: full organizer, split parts, or 2D footprint
// ============================================================================
if (generate_2d_footprint) {
    // 2D Projection Mode for Paper Printing
    // Creates a flat projection for printing on paper to test slot fit
    // Translates the model down to cut through the slots (at 1mm height from floor)
    projection(cut = true) translate([0, 0, -final_floor_z - 1]) full_organizer();
} else if (part_to_render == 0) {
    // Render full organizer
    full_organizer();
} else if (part_to_render == 1) {
    // Render left half of split organizer
    intersection() {
        full_organizer();
        translate([-1000, -1000, -1000]) cube([split_pos + 1000, 2000, 2000]);
    }
} else if (part_to_render == 2) {
    // Render right half of split organizer
    intersection() {
        full_organizer();
        translate([split_pos, -1000, -1000]) cube([1000, 2000, 2000]);
    }
}

// ============================================================================
// MAIN ORGANIZER MODULE
// Constructs the complete organizer with base, slots, and optional features
// ============================================================================
module full_organizer() {
    difference() {
        union() {
            // Create base: Gridfinity base or simple rounded rectangle
            if (gf_enable_base && !generate_test_slice && !use_minimalist_layout) {
                gridfinity_base();
            } else {
                rounded_rect(eff_total_width, eff_total_depth, final_total_height, gf_bin_corner_radius);
            }
            // Add stacking lip if enabled
            if (gf_enable_stacking_lip && !generate_test_slice && !use_minimalist_layout) {
                translate([0, 0, final_total_height]) stacking_lip();
            }
        }
        
        // Subtract utensil slots
        translate([0, 0, final_z_pos]) linear_slot_layout(type="slots");
        
        // Subtract finger cutout trench if enabled
        if (enable_finger_cutout && !generate_test_slice) {
            if (trench_style == "wavy") render_wavy_trench();
            else render_central_trench();
        }
    }
}

// ============================================================================
// TRENCH MODULES
// Creates central finger cutout trench for easy utensil access
// ============================================================================

// WAVY TRENCH MODULE
// Creates a sinusoidal wave pattern along the finger cutout trench for
// decorative or ergonomic purposes. Uses multiple slices to create smooth waves.
module render_wavy_trench() {
    center_y = (total_depth / 2) + trench_y_offset;
    cut_height = final_total_height - final_floor_z;
    // Calculate expansion at top based on draft angles
    south_expansion = cut_height / tan(cutout_south_angle);
    north_expansion = cut_height / tan(cutout_north_angle);
    floor_w = finger_cutout_width;
    r = finger_cutout_radius;
    top_south = -floor_w/2 - south_expansion;
    top_north = floor_w/2 + north_expansion;
    top_width = top_north - top_south;
    
    // Use small steps for smooth wave pattern
    // 0.4mm is a good balance between smoothness and render speed
    step = 0.4;
    translate([0, center_y, final_floor_z]) {
        render(convexity=6) 
        // Create multiple slices along X-axis with sinusoidal Y-offset
        for (x = [-10 : step : total_width + 10]) {
            trench_slice_instance(x, cut_height, top_south, top_north, floor_w, r, top_width, step);
        }
    }
}

// Create a single slice of the wavy trench at a specific X position
module trench_slice_instance(x_pos, h, ts, tn, fw, r, tw, thickness) {
    // Calculate Y-offset using sine wave for wavy pattern
    y_offset = sin((x_pos * 360 / trench_wave_period) + trench_wave_phase) * trench_wave_amplitude;
    translate([x_pos, y_offset, 0])
    rotate([0, -90, 0]) 
    // Extrude slightly more than the step size to ensure slices overlap and form a solid
    linear_extrude(height = thickness + 0.05) 
    trench_2d_shape(h, ts, tn, fw, r, tw);
}

// Create the 2D profile shape of the trench (trapezoid with rounded corners)
module trench_2d_shape(h, ts, tn, fw, r, tw) {
    // Triple offset technique creates rounded top corners (fillet)
    // Reference: https://www.reddit.com/r/openscad/comments/ut1n7t/quick_tip_simple_fillet_for_2d_shapes/
    // The offset chain creates the fillet at the concave corners
    if (r > 0) {
        offset(r=-r) offset(r=2*r) offset(r=-r)
        union() {
            // Main body polygon: trapezoid from floor to top
            polygon(points=[[0, -fw/2], [0, fw/2], [h, tn], [h, ts]]);
            // Top Cap: WIDER than the trench to create a concave corner
            // This forces the offset to create a flare (roundover) at the bin surface
            translate([h - 0.1, ts - r]) square([r * 4, (tn - ts) + 2 * r]);
        }
    } else {
        // No rounding: simple trapezoid
        polygon(points=[[0, -fw/2], [0, fw/2], [h, tn], [h, ts]]);
    }
}

// Render a straight (non-wavy) central trench cutout
module render_central_trench() {
    center_y = (total_depth / 2) + trench_y_offset;
    floor_w = finger_cutout_width;
    r = finger_cutout_radius;
    cut_height = final_total_height - final_floor_z;

    // Calculate expansion at top based on draft angles
    south_expansion = cut_height / tan(cutout_south_angle);
    north_expansion = cut_height / tan(cutout_north_angle);
    top_south = -floor_w/2 - south_expansion;
    top_north = floor_w/2 + north_expansion;
    top_width = top_north - top_south;
    
    // Extrude trench profile along X-axis
    translate([total_width + 10, center_y, final_floor_z]) 
    rotate([0, -90, 0]) 
    linear_extrude(height = total_width + 20)
    trench_2d_shape(cut_height, top_south, top_north, floor_w, r, top_width);
}

// ============================================================================
// SLOT LAYOUT MODULES
// Arrange utensil slots in linear order with optional misc bin
// ============================================================================

// Layout utensil slots in linear order with optional misc bin
module linear_slot_layout(type="slots") {
    start_x = wall_thickness;
    // Trimmed edges shrink the bin from the outside; interior origin stays at wall_thickness.
    y_pos = wall_thickness;
    
    // Handle misc bin on left side if enabled
    misc_left_w = (misc_bin_active && misc_bin_position == "left") ? misc_bin_width : 0;
    if (misc_left_w > 0 && type=="slots") {
        translate([start_x, y_pos, 0])
            rounded_slot(misc_left_w, _available_slot_depth, final_slot_depth);
    }
    
    // Calculate positions for each utensil section based on order
    cursor_base = start_x + (misc_left_w > 0 ? misc_left_w + wall_thickness : 0);
    pos_1 = cursor_base;
    width_1 = calc_section_width(1);
    pos_2 = pos_1 + width_1;
    width_2 = calc_section_width(2);
    pos_3 = pos_2 + width_2;
    width_3 = calc_section_width(3);
    pos_4 = pos_3 + width_3;
    width_4 = calc_section_width(4);
    pos_5 = pos_4 + width_4;
    width_5 = calc_section_width(5);
    
    // Place each section in order
    translate([pos_1, y_pos, 0]) place_by_order(1, type);
    translate([pos_2, y_pos, 0]) place_by_order(2, type);
    translate([pos_3, y_pos, 0]) place_by_order(3, type);
    translate([pos_4, y_pos, 0]) place_by_order(4, type);
    translate([pos_5, y_pos, 0]) place_by_order(5, type);

    // Handle misc bin on right side if enabled
    if (misc_bin_active && misc_bin_position == "right" && type=="slots") {
        total_utensil_w = width_1 + width_2 + width_3 + width_4 + width_5;
        bin_end_x = eff_total_width - wall_thickness;
        current_x = cursor_base + total_utensil_w;
        actual_misc_width = max(1, bin_end_x - current_x);
        translate([current_x, y_pos, 0])
            rounded_slot(actual_misc_width, _available_slot_depth, final_slot_depth);
    }
}

// Place utensil slots based on their order position
module place_by_order(order_pos, type) {
    if (order_knives == order_pos && active_knife_slots > 0) 
        draw_slots_geometry(active_knife_slots, knife_slot_width, "knife", knife_orientation, type, knife_length);
    if (order_forks == order_pos && active_fork_slots > 0) 
        draw_slots_geometry(active_fork_slots, fork_slot_width, "fork", fork_orientation, type, fork_length);
    if (order_dessert_forks == order_pos && active_dessert_fork_slots > 0) 
        draw_slots_geometry(active_dessert_fork_slots, dessert_fork_slot_width, "dessert_fork", dessert_fork_orientation, type, dessert_fork_length);
    if (order_teaspoons == order_pos && active_teaspoon_slots > 0) 
        draw_slots_geometry(active_teaspoon_slots, teaspoon_slot_width, "teaspoon", teaspoon_orientation, type, teaspoon_length);
    if (order_tablespoons == order_pos && active_tablespoon_slots > 0) 
        draw_slots_geometry(active_tablespoon_slots, tablespoon_slot_width, "tablespoon", tablespoon_orientation, type, tablespoon_length);
}

// Draw multiple slots of the same type in a row
module draw_slots_geometry(count, width, type, orientation, render_type, length) {
    for (i = [0:count-1]) {
        x_loc = i * (width + wall_thickness);
        flipped = is_flipped(i, orientation, count);
        translate([x_loc, 0, 0]) {
            if (render_type == "slots") {
                if (type=="knife") knife_slot(flipped);
                if (type=="fork") fork_slot(flipped);
                if (type=="dessert_fork") dessert_fork_slot(flipped);
                if (type=="teaspoon") teaspoon_slot(flipped);
                if (type=="tablespoon") tablespoon_slot(flipped);
            }
        }
    }
}

// Calculate available slot length accounting for walls and edges
// Ensures slots don't exceed bin depth
function get_slot_len(item_len) = min(item_len, _available_slot_depth);

// ============================================================================
// ALIGNMENT FUNCTIONS
// Calculate Y-offset for utensil slots based on alignment mode
// ============================================================================

// Calculate Y-offset for utensil slots based on alignment mode
// Handles centered, top, bottom, and neck alignment modes
function get_slot_y_offset(item_length, handle_len, is_flipped_item) = 
    let(avail_space = _available_slot_depth)
    let(margin = 0.5) // Small visual gap for top/bottom alignment
    
    (utensil_alignment_y == "top") ?
        // Top aligned: utensils pushed to top, handles at top
        (avail_space - item_length - margin) :
    
    (utensil_alignment_y == "bottom") ?
        // Bottom aligned: utensils pushed to bottom, tips at bottom
        margin :
    
    (utensil_alignment_y == "neck") ?
        // Neck aligned: handles aligned at same height regardless of utensil type
        (
            is_flipped_item ? 
            // If flipped, visual neck is at: Y_pos + (Length - Handle)
            // We want Visual Neck == (Max Handle + Margin)
            // Y_pos = (Max Handle + Margin) - (Length - Handle)
            ((calc_max_handle + margin) - (item_length - handle_len)) :
            // If standard, visual neck is at: Y_pos + Handle
            // Y_pos = (Max Handle + Margin) - Handle
            ((calc_max_handle + margin) - handle_len)
        ) :
    
    // Default: centered
    (avail_space - item_length) / 2;

// ============================================================================
// SHIM LOGIC MODULE (PARAMETRIC & ROUNDED)
// Creates a wedge-shaped shim under utensil handles to elevate them for easier access
// The shim has a flat section followed by a smooth taper to the floor
// ============================================================================

// Render a parametric shim (wedge) under utensil handles
// Parameters:
//   width: Slot width (mm)
//   slot_len: Total slot length (mm)
//   handle_len: Handle length (mm)
//   shim_h: Height of shim at handle end (mm)
//   shim_flat_len: Length of flat section before taper (mm)
//   flipped: Whether utensil is flipped (affects positioning)
//   y_shift: Y-offset of slot (for alignment)
module render_shim(width, slot_len, handle_len, shim_h, shim_flat_len, flipped, y_shift) {
    if (shim_h > 0) {
        // Calculate cutout position only if finger cutout is enabled
        // This optimization prevents unnecessary calculations when cutout is disabled
        cutout_y_center = enable_finger_cutout ? ((total_depth / 2) + trench_y_offset) : 0;
        cutout_half_w = enable_finger_cutout ? (finger_cutout_width / 2) : 0;
        
        // Taper Logic: Determine where the taper should end
        // 1. Target Length by Handle Ratio: Taper ends at 75% of handle length
        target_len_handle = 0.75 * handle_len;
        
        // 2. Target Length by Cutout Intersection: Don't taper into finger cutout
        // Calculate distance from handle end to cutout edge
        cutout_dist = flipped ? 
            (y_shift + slot_len) - (cutout_y_center + cutout_half_w) : 
            (cutout_y_center - cutout_half_w) - y_shift; 

        // Use the closer limit: handle ratio or cutout intersection
        dist_limit = (enable_finger_cutout && cutout_dist > 0) ? cutout_dist : 9999;
        final_taper_len = min(target_len_handle, dist_limit);
        
        // Ensure valid geometry: taper must extend beyond flat section
        valid_taper_end = max(shim_flat_len + 1, final_taper_len);
        
        // Fillet radius for rounded corner at top of flat section
        rad = finger_cutout_radius;
        // Cap radius to avoid inverted geometry if shim is very short
        eff_rad = min(rad, shim_h - 0.1);
        
        // FIX V10.36: Widen the total_w and start from -2 to ensure full wall overlap
        // This prevents gaps between shim and slot walls
        total_w = width + 4; 
        
        // FIX V10.37: Start polygon at -10 to ensure it covers margin area
        // This ensures shim extends into the utensil_margin offset area at handle end
        start_y = -10;

        if (flipped) {
            // Flipped utensils: shim is at opposite end, needs rotation
             translate([width + 2, slot_len, 0]) 
             rotate([0, 0, 180]) 
             translate([-2, 0, 0])
             rotate([90, 0, 90])
             linear_extrude(total_w)
             hull() {
                // 1. Bottom Plate (Foundation): Ensures shim extends to floor
                polygon([[start_y, -1], [valid_taper_end, -1], [valid_taper_end, 0], [start_y, 0]]);
                
                // 2. The Rounded Knuckle (Top-Right of the flat section)
                // Creates a smooth rounded transition from flat to taper
                translate([shim_flat_len, shim_h - eff_rad]) circle(r=eff_rad);
                
                // 3. The Main Flat Body: Flat section at handle end
                polygon([
                    [start_y, 0], 
                    [shim_flat_len, 0], 
                    [shim_flat_len, shim_h - eff_rad], 
                    [start_y, shim_h]
                ]);
             }
        } else {
            // Standard orientation: shim at handle end
             translate([-2, 0, 0])
             rotate([90, 0, 90])
             linear_extrude(total_w)
             hull() {
                // 1. Bottom Plate (Foundation): Ensures shim extends to floor
                polygon([[start_y, -1], [valid_taper_end, -1], [valid_taper_end, 0], [start_y, 0]]);
                
                // 2. The Rounded Knuckle (Top-Right of the flat section)
                // Creates a smooth rounded transition from flat to taper
                translate([shim_flat_len, shim_h - eff_rad]) circle(r=eff_rad);
                
                // 3. The Main Flat Body: Flat section at handle end
                polygon([
                    [start_y, 0], 
                    [shim_flat_len, 0], 
                    [shim_flat_len, shim_h - eff_rad], 
                    [start_y, shim_h]
                ]);
             }
        }
    }
}

// ============================================================================
// UTENSIL SLOT MODULES
// Create 3D slots for each utensil type with proper profiles and optional features
// ============================================================================

// KNIFE SLOT MODULE
// Creates a slot for knives with asymmetric blade profile
// Parameters:
//   flipped: If true, knife is rotated 180° (handle at opposite end)
module knife_slot(flipped = false) {
    slot_len = get_slot_len(knife_length);
    h_len = knife_handle_length;
    b_len = slot_len - h_len - knife_neck_height; // Blade length
    center_x = knife_center_offset; // X-offset for asymmetric blade
    y_shift = get_slot_y_offset(knife_length, h_len, flipped);

    translate([0, y_shift, 0]) {
        difference() {
            union() {
                // Create slot profile with optional retention collar
                if (show_collar) {
                    collar_z = final_slot_depth - wall_thickness;
                    if (flipped) {
                        // Flipped: collar at opposite end
                        difference() {
                            translate([knife_slot_width, slot_len]) rotate(180) linear_extrude(final_slot_depth) knife_2d_profile(center_x, h_len, b_len);
                            translate([-10, slot_len - collar_length, collar_z]) cube([knife_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                        }
                    } else {
                        // Standard: collar at handle end
                        difference() {
                            linear_extrude(final_slot_depth) knife_2d_profile(center_x, h_len, b_len);
                            translate([-10, -10, collar_z]) cube([knife_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                        }
                    }
                } else {
                    // No collar: simple slot
                    linear_extrude(final_slot_depth) {
                        if (flipped) translate([knife_slot_width, slot_len]) rotate(180) knife_2d_profile(center_x, h_len, b_len);
                        else knife_2d_profile(center_x, h_len, b_len);
                    }
                }
            }
            // Subtract shim (wedge) from slot to elevate handle
            render_shim(knife_slot_width, slot_len, h_len, knife_shim_height, knife_shim_flat_length, flipped, y_shift);
        }
    }
}

// KNIFE 2D PROFILE MODULE
// Creates the 2D profile of a knife slot (handle + neck + blade)
// The blade profile uses a mathematical curve for smooth tip transition
// Parameters:
//   center_x: X-center offset for asymmetric blade
//   h_len: Handle length
//   b_len: Blade length
module knife_2d_profile(center_x, h_len, b_len) {
    w_base = knife_handle_width_base / 2;
    w_handle_neck = knife_handle_width_neck / 2;
    w_bolster = knife_neck_width / 2;
    
    // Calculate blade profile dimensions
    profile_len = max(1, b_len - knife_blade_taper_height);
    eff_flat_len = min(profile_len, knife_blade_flat_length);
    eff_curve_len = max(0.1, profile_len - eff_flat_len);

    // Apply margin and fillet radius using triple offset technique
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius) union() {
        blade_spine_x = center_x - w_handle_neck;
        steps = 60; // Number of points for smooth blade curve
        
        // Generate blade edge points using mathematical curve
        // Blade has flat section, then curves to tip
        blade_edge_points = [for(i=[0:steps]) 
            let(t = i/steps)
            let(current_y_rel = t * profile_len) 
            // Cache calculations to optimize performance
            let(knife_blade_widest_width = knife_blade_widest_width)
            let(knife_blade_tip_width = knife_blade_tip_width)
            let(width_diff = knife_blade_widest_width - knife_blade_tip_width)
            let(current_width = (current_y_rel <= eff_flat_len) ? 
                knife_blade_widest_width : 
                let(curve_t = (current_y_rel - eff_flat_len) / eff_curve_len)
                // Use sine curve for smooth transition from widest to tip
                knife_blade_tip_width + width_diff * sin(90 + curve_t * 90)
            )
            let(blade_y_base = h_len + knife_neck_height + knife_blade_taper_height)
            [blade_spine_x + current_width, blade_y_base + current_y_rel]
        ];
        
        // Construct polygon: handle -> neck -> blade spine -> blade edge -> tip -> neck -> handle
        polygon(points=concat(
            [[center_x - w_base, 0], [center_x - w_handle_neck, h_len]],
            [[blade_spine_x, h_len], [blade_spine_x, h_len + knife_neck_height + b_len]],
            reverse(blade_edge_points),
            [[blade_spine_x + knife_blade_start_width, h_len + knife_neck_height + knife_blade_taper_height]],
            [[center_x + w_bolster, h_len + knife_neck_height], [center_x + w_bolster, h_len]],
            [[center_x + w_handle_neck, h_len], [center_x + w_base, 0]]
        ));
    }
}

// FORK SLOT MODULE
// Creates a slot for forks with handle and tines/head profile
// Supports draft angle for tapered insertion ramp
module fork_slot(flipped = false) {
    slot_len = get_slot_len(fork_length);
    h_len = fork_handle_length;
    head_len = slot_len - h_len;
    y_shift = get_slot_y_offset(fork_length, h_len, flipped);
    draft_extension = final_slot_depth * tan(fork_head_draft_angle);
    translate([0, y_shift, 0]) {
        difference() {
            union() {
                if (flipped) {
                    // Flipped fork: handle at opposite end
                    translate([0, draft_extension, 0])
                    linear_extrude(height = final_slot_depth) {
                        translate([fork_slot_width/2, slot_len/2]) rotate(180) translate([-fork_slot_width/2, -slot_len/2]) fork_handle_profile();
                    }
                    // Head with optional draft angle (tapered ramp)
                    if (fork_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) {
                                translate([fork_slot_width/2, slot_len/2]) rotate(180) translate([-fork_slot_width/2, -slot_len/2]) fork_head_profile(max(1, head_len - draft_extension));
                            }
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) {
                                translate([fork_slot_width/2, slot_len/2]) rotate(180) translate([-fork_slot_width/2, -slot_len/2]) fork_head_profile(head_len);
                            }
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) {
                            translate([fork_slot_width/2, slot_len/2]) rotate(180) translate([-fork_slot_width/2, -slot_len/2]) fork_head_profile(head_len);
                        }
                    }
                } else {
                    // Standard fork: handle at base
                    linear_extrude(height = final_slot_depth) fork_handle_profile();
                    // Head with optional draft angle (tapered ramp)
                    if (fork_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) fork_head_profile(max(1, head_len - draft_extension));
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) fork_head_profile(head_len);
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) fork_head_profile(head_len);
                    }
                }
            }
            // Retention collar if enabled
            if (show_collar) {
                collar_z = final_slot_depth - wall_thickness;
                if (flipped) {
                    translate([-10, slot_len - collar_length, collar_z]) cube([fork_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                } else {
                    translate([-10, -10, collar_z]) cube([fork_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                }
            }
            // Subtract shim (wedge) from slot to elevate handle
            render_shim(fork_slot_width, slot_len, h_len, fork_shim_height, fork_shim_flat_length, flipped, y_shift);
        }
    }
}

// FORK HANDLE PROFILE MODULE
// Creates the 2D profile of a fork handle (trapezoid: wide at base, narrow at neck)
module fork_handle_profile() {
    center_x = fork_slot_width/2;
    h_len = fork_handle_length;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius)
        polygon(points=[[center_x - fork_handle_width_base/2, 0], [center_x + fork_handle_width_base/2, 0], [center_x + fork_handle_width_neck/2, h_len+0.1], [center_x - fork_handle_width_neck/2, h_len+0.1]]);
}

// FORK HEAD PROFILE MODULE
// Creates the 2D profile of fork tines/head with smooth shoulder transition
// Parameters:
//   head_len: Length of fork head/tines
module fork_head_profile(head_len) {
    center_x = fork_slot_width/2;
    h_len = fork_handle_length;
    neck_w = fork_handle_width_neck;
    head_w = fork_head_width;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius) {
        // Shoulder transition: smooth curve from neck to head width
        shoulder_len = head_len / 5;
        steps = 8;
        
        // Cache calculations for optimization
        neck_w_half = neck_w / 2;
        head_w_half = head_w / 2;
        width_transition = head_w_half - neck_w_half;
        
        // Generate shoulder points on right side using quadratic easing
        shoulder_points = [for(i=[0:steps]) 
            let(t=i/steps) 
            [center_x + neck_w_half + width_transition * (1 - pow(1-t, 2)), h_len + shoulder_len*t]
        ];
        // Generate shoulder points on left side
        shoulder_points_left = [for(i=[0:steps]) 
            let(t=i/steps) 
            [center_x - (neck_w_half + width_transition * (1 - pow(1-t, 2))), h_len + shoulder_len*t]
        ];
        
        // Construct polygon: neck -> shoulder -> head tip -> shoulder -> neck
        polygon(points=concat(
            [[center_x - neck_w_half, h_len], [center_x + neck_w_half, h_len]], 
            shoulder_points, 
            [[center_x + head_w_half, h_len + head_len]], 
            [[center_x - head_w_half, h_len + head_len]], 
            reverse(shoulder_points_left)
        ));
    }
}

// TABLESPOON SLOT MODULE
// Creates a slot for tablespoons with handle and bowl profile
// Supports draft angle for tapered insertion ramp
module tablespoon_slot(flipped = false) {
    slot_len = get_slot_len(tablespoon_length);
    h_len = tablespoon_handle_length;
    bowl_len = slot_len - h_len;
    y_shift = get_slot_y_offset(tablespoon_length, h_len, flipped);
    draft_extension = final_slot_depth * tan(tablespoon_head_draft_angle);
    translate([0, y_shift, 0]) {
        difference() {
            union() {
                if (flipped) {
                    // Flipped spoon: handle at opposite end
                    translate([0, draft_extension, 0])
                    linear_extrude(height = final_slot_depth) {
                        translate([tablespoon_slot_width/2, slot_len/2]) rotate(180) translate([-tablespoon_slot_width/2, -slot_len/2]) tablespoon_handle_profile();
                    }
                    // Bowl with optional draft angle (tapered ramp)
                    if (tablespoon_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) {
                                translate([tablespoon_slot_width/2, slot_len/2]) rotate(180) translate([-tablespoon_slot_width/2, -slot_len/2])
                                    tablespoon_bowl_profile(max(1, bowl_len - draft_extension));
                            }
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) {
                                translate([tablespoon_slot_width/2, slot_len/2]) rotate(180) translate([-tablespoon_slot_width/2, -slot_len/2])
                                    tablespoon_bowl_profile(bowl_len);
                            }
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) {
                            translate([tablespoon_slot_width/2, slot_len/2]) rotate(180) translate([-tablespoon_slot_width/2, -slot_len/2])
                                tablespoon_bowl_profile(bowl_len);
                        }
                    }
                } else {
                    // Standard spoon: handle at base
                    linear_extrude(height = final_slot_depth) tablespoon_handle_profile();
                    // Bowl with optional draft angle (tapered ramp)
                    if (tablespoon_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) tablespoon_bowl_profile(max(1, bowl_len - draft_extension));
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) tablespoon_bowl_profile(bowl_len);
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) tablespoon_bowl_profile(bowl_len);
                    }
                }
            }
            // Retention collar if enabled
            if (show_collar) {
                collar_z = final_slot_depth - wall_thickness;
                if (flipped) {
                    translate([-10, slot_len - collar_length, collar_z]) cube([tablespoon_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                } else {
                    translate([-10, -10, collar_z]) cube([tablespoon_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                }
            }
            // Subtract shim (wedge) from slot to elevate handle
            render_shim(tablespoon_slot_width, slot_len, h_len, tablespoon_shim_height, tablespoon_shim_flat_length, flipped, y_shift);
        }
    }
}

// TABLESPOON HANDLE PROFILE MODULE
// Creates the 2D profile of a tablespoon handle (trapezoid: wide at base, narrow at neck)
module tablespoon_handle_profile() {
    center_x = tablespoon_slot_width/2;
    h_len = tablespoon_handle_length;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius)
        polygon(points=[[center_x - tablespoon_handle_width_base/2, 0], [center_x + tablespoon_handle_width_base/2, 0], [center_x + tablespoon_handle_width_neck/2, h_len+0.1], [center_x - tablespoon_handle_width_neck/2, h_len+0.1]]);
}

// TABLESPOON BOWL PROFILE MODULE
// Creates the 2D profile of a spoon bowl using ovoid (ellipse-based) geometry
// The bowl profile uses two semi-ellipses: one from neck to widest point, one from widest to tip
// Parameters:
//   b_len: Length of bowl portion
module tablespoon_bowl_profile(b_len) {
    center_x = tablespoon_slot_width/2;
    h_len = tablespoon_handle_length;
    h_neck = tablespoon_handle_width_neck;
    bowl_w = tablespoon_bowl_width;
    widest_ratio = tablespoon_bowl_widest_ratio;
    spoon_tip_width = 3.0;
    
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius) {
        steps = 50; // Number of points for smooth bowl curve
        
        // Cache common calculations for optimization
        h_neck_half = h_neck / 2;
        bowl_w_half = bowl_w / 2;
        widest_to_tip_ratio = 1.0 - widest_ratio;
        
        // Generate right side points using ovoid (semi-ellipse) mathematics
        points_right = [for(i=[0:steps]) let(t=i/steps) 
            let(y = h_len + b_len * t)
            let(rel_t = t) 
            let(width_at_t = 
                (rel_t <= widest_ratio) ? 
                // First semi-ellipse: neck to widest point
                (h_neck_half + (bowl_w_half - h_neck_half) * sqrt(1 - pow((rel_t - widest_ratio)/widest_ratio, 2))) :
                // Second semi-ellipse: widest point to tip
                (spoon_tip_width/2 + (bowl_w_half - spoon_tip_width/2) * sqrt(1 - pow((rel_t - widest_ratio)/widest_to_tip_ratio, 2)))
            )
            [center_x + width_at_t, y]
        ];
        
        // Generate left side points (mirror of right side)
        points_left = [for(i=[0:steps]) let(t=i/steps) 
            let(y = h_len + b_len * t)
            let(rel_t = t)
            let(width_at_t = 
                (rel_t <= widest_ratio) ? 
                (h_neck_half + (bowl_w_half - h_neck_half) * sqrt(1 - pow((rel_t - widest_ratio)/widest_ratio, 2))) :
                (spoon_tip_width/2 + (bowl_w_half - spoon_tip_width/2) * sqrt(1 - pow((rel_t - widest_ratio)/widest_to_tip_ratio, 2)))
            )
            [center_x - width_at_t, y]
        ];
        
        // Construct polygon: neck -> right side -> tip -> left side -> neck
        polygon(points=concat(
            [[center_x - h_neck_half, h_len], [center_x + h_neck_half, h_len]],
            points_right,
            reverse(points_left)
        ));
    }
}

// TEASPOON SLOT MODULE
// Creates a slot for teaspoons with handle and bowl profile
// Supports draft angle for tapered insertion ramp
// Similar structure to tablespoon but with smaller dimensions
module teaspoon_slot(flipped = false) {
    slot_len = get_slot_len(teaspoon_length);
    h_len = teaspoon_handle_length;
    bowl_len = slot_len - h_len;
    y_shift = get_slot_y_offset(teaspoon_length, h_len, flipped);
    draft_extension = final_slot_depth * tan(teaspoon_head_draft_angle);
    translate([0, y_shift, 0]) {
        difference() {
            union() {
                if (flipped) {
                    // Flipped spoon: handle at opposite end
                    translate([0, draft_extension, 0])
                    linear_extrude(height = final_slot_depth) {
                        translate([teaspoon_slot_width/2, slot_len/2]) rotate(180) translate([-teaspoon_slot_width/2, -slot_len/2]) teaspoon_handle_profile();
                    }
                    // Bowl with optional draft angle (tapered ramp)
                    if (teaspoon_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) {
                                translate([teaspoon_slot_width/2, slot_len/2]) rotate(180) translate([-teaspoon_slot_width/2, -slot_len/2]) teaspoon_bowl_profile(max(1, bowl_len - draft_extension));
                            }
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) {
                                translate([teaspoon_slot_width/2, slot_len/2]) rotate(180) translate([-teaspoon_slot_width/2, -slot_len/2]) teaspoon_bowl_profile(bowl_len);
                            }
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) {
                            translate([teaspoon_slot_width/2, slot_len/2]) rotate(180) translate([-teaspoon_slot_width/2, -slot_len/2]) teaspoon_bowl_profile(bowl_len);
                        }
                    }
                } else {
                    // Standard spoon: handle at base
                    linear_extrude(height = final_slot_depth) teaspoon_handle_profile();
                    // Bowl with optional draft angle (tapered ramp)
                    if (teaspoon_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) teaspoon_bowl_profile(max(1, bowl_len - draft_extension));
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) teaspoon_bowl_profile(bowl_len);
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) teaspoon_bowl_profile(bowl_len);
                    }
                }
            }
            // Retention collar if enabled
            if (show_collar) {
                collar_z = final_slot_depth - wall_thickness;
                if (flipped) {
                    translate([-10, slot_len - collar_length, collar_z]) cube([teaspoon_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                } else {
                    translate([-10, -10, collar_z]) cube([teaspoon_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                }
            }
            // Subtract shim (wedge) from slot to elevate handle
            render_shim(teaspoon_slot_width, slot_len, h_len, teaspoon_shim_height, teaspoon_shim_flat_length, flipped, y_shift);
        }
    }
}

// TEASPOON HANDLE PROFILE MODULE
// Creates the 2D profile of a teaspoon handle (trapezoid: wide at base, narrow at neck)
module teaspoon_handle_profile() {
    center_x = teaspoon_slot_width/2;
    h_len = teaspoon_handle_length;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius)
        polygon(points=[[center_x - teaspoon_handle_width_base/2, 0], [center_x + teaspoon_handle_width_base/2, 0], [center_x + teaspoon_handle_width_neck/2, h_len+0.1], [center_x - teaspoon_handle_width_neck/2, h_len+0.1]]);
}

// TEASPOON BOWL PROFILE MODULE
// Creates the 2D profile of a teaspoon bowl using ovoid (ellipse-based) geometry
// Uses same mathematical approach as tablespoon but with smaller dimensions
// Parameters:
//   b_len: Length of bowl portion
module teaspoon_bowl_profile(b_len) {
    center_x = teaspoon_slot_width/2;
    h_len = teaspoon_handle_length;
    h_neck = teaspoon_handle_width_neck;
    bowl_w = teaspoon_bowl_width;
    widest_ratio = teaspoon_bowl_widest_ratio;
    spoon_tip_width = 3.0;
    
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius) {
        steps = 50; // Number of points for smooth bowl curve
        
        // Cache common calculations for optimization
        h_neck_half = h_neck / 2;
        bowl_w_half = bowl_w / 2;
        widest_to_tip_ratio = 1.0 - widest_ratio;
        
        // Generate right side points using ovoid (semi-ellipse) mathematics
        points_right = [for(i=[0:steps]) let(t=i/steps) 
            let(y = h_len + b_len * t)
            let(rel_t = t) 
            let(width_at_t = 
                (rel_t <= widest_ratio) ? 
                // First semi-ellipse: neck to widest point
                (h_neck_half + (bowl_w_half - h_neck_half) * sqrt(1 - pow((rel_t - widest_ratio)/widest_ratio, 2))) :
                // Second semi-ellipse: widest point to tip
                (spoon_tip_width/2 + (bowl_w_half - spoon_tip_width/2) * sqrt(1 - pow((rel_t - widest_ratio)/widest_to_tip_ratio, 2)))
            )
            [center_x + width_at_t, y]
        ];
        
        // Generate left side points (mirror of right side)
        points_left = [for(i=[0:steps]) let(t=i/steps) 
            let(y = h_len + b_len * t)
            let(rel_t = t)
            let(width_at_t = 
                (rel_t <= widest_ratio) ? 
                (h_neck_half + (bowl_w_half - h_neck_half) * sqrt(1 - pow((rel_t - widest_ratio)/widest_ratio, 2))) :
                (spoon_tip_width/2 + (bowl_w_half - spoon_tip_width/2) * sqrt(1 - pow((rel_t - widest_ratio)/widest_to_tip_ratio, 2)))
            )
            [center_x - width_at_t, y]
        ];
        
        // Construct polygon: neck -> right side -> tip -> left side -> neck
        polygon(points=concat(
            [[center_x - h_neck_half, h_len], [center_x + h_neck_half, h_len]],
            points_right,
            reverse(points_left)
        ));
    }
}

// DESSERT FORK SLOT MODULE
// Creates a slot for dessert forks with handle and tines/head profile
// Supports draft angle for tapered insertion ramp
// Similar structure to regular fork but with different dimensions
module dessert_fork_slot(flipped = false) {
    slot_len = get_slot_len(dessert_fork_length);
    h_len = dessert_fork_handle_length;
    head_len = slot_len - h_len;
    y_shift = get_slot_y_offset(dessert_fork_length, h_len, flipped);
    draft_extension = final_slot_depth * tan(dessert_fork_head_draft_angle);
    translate([0, y_shift, 0]) {
        difference() {
            union() {
                if (flipped) {
                    // Flipped fork: handle at opposite end
                    translate([0, draft_extension, 0])
                    linear_extrude(height = final_slot_depth) {
                        translate([dessert_fork_slot_width/2, slot_len/2]) rotate(180) translate([-dessert_fork_slot_width/2, -slot_len/2]) dessert_fork_handle_profile();
                    }
                    // Head with optional draft angle (tapered ramp)
                    if (dessert_fork_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) {
                                translate([dessert_fork_slot_width/2, slot_len/2]) rotate(180) translate([-dessert_fork_slot_width/2, -slot_len/2]) dessert_fork_head_profile(max(1, head_len - draft_extension));
                            }
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) {
                                translate([dessert_fork_slot_width/2, slot_len/2]) rotate(180) translate([-dessert_fork_slot_width/2, -slot_len/2]) dessert_fork_head_profile(head_len);
                            }
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) {
                            translate([dessert_fork_slot_width/2, slot_len/2]) rotate(180) translate([-dessert_fork_slot_width/2, -slot_len/2]) dessert_fork_head_profile(head_len);
                        }
                    }
                } else {
                    // Standard fork: handle at base
                    linear_extrude(height = final_slot_depth) dessert_fork_handle_profile();
                    // Head with optional draft angle (tapered ramp)
                    if (dessert_fork_head_draft_angle > 0) {
                        hull() {
                            linear_extrude(height = 0.01) dessert_fork_head_profile(max(1, head_len - draft_extension));
                            translate([0, 0, final_slot_depth - 0.01]) linear_extrude(height = 0.01) dessert_fork_head_profile(head_len);
                        }
                    } else {
                        linear_extrude(height = final_slot_depth) dessert_fork_head_profile(head_len);
                    }
                }
            }
            // Retention collar if enabled
            if (show_collar) {
                collar_z = final_slot_depth - wall_thickness;
                if (flipped) {
                    translate([-10, slot_len - collar_length, collar_z]) cube([dessert_fork_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                } else {
                    translate([-10, -10, collar_z]) cube([dessert_fork_slot_width + 20, collar_length + 10, wall_thickness + 1]);
                }
            }
            // Subtract shim (wedge) from slot to elevate handle
            render_shim(dessert_fork_slot_width, slot_len, h_len, dessert_fork_shim_height, dessert_fork_shim_flat_length, flipped, y_shift);
        }
    }
}

// DESSERT FORK HANDLE PROFILE MODULE
// Creates the 2D profile of a dessert fork handle (trapezoid: wide at base, narrow at neck)
module dessert_fork_handle_profile() {
    center_x = dessert_fork_slot_width/2;
    h_len = dessert_fork_handle_length;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius)
        polygon(points=[[center_x - dessert_fork_handle_width_base/2, 0], [center_x + dessert_fork_handle_width_base/2, 0], [center_x + dessert_fork_handle_width_neck/2, h_len+0.1], [center_x - dessert_fork_handle_width_neck/2, h_len+0.1]]);
}

// DESSERT FORK HEAD PROFILE MODULE
// Creates the 2D profile of dessert fork tines/head with smooth shoulder transition
// Parameters:
//   head_len: Length of fork head/tines
module dessert_fork_head_profile(head_len) {
    center_x = dessert_fork_slot_width/2;
    h_len = dessert_fork_handle_length;
    neck_w = dessert_fork_handle_width_neck;
    head_w = dessert_fork_head_width;
    offset(r=utensil_margin/2) offset(r=fillet_radius) offset(r=-fillet_radius) {
        // Shoulder transition: smooth curve from neck to head width
        shoulder_len = head_len / 5;
        steps = 8;
        
        // Cache calculations for optimization
        neck_w_half = neck_w / 2;
        head_w_half = head_w / 2;
        width_transition = head_w_half - neck_w_half;
        
        // Generate shoulder points on right side using quadratic easing
        shoulder_points = [for(i=[0:steps]) 
            let(t=i/steps) 
            [center_x + neck_w_half + width_transition * (1 - pow(1-t, 2)), h_len + shoulder_len*t]
        ];
        // Generate shoulder points on left side
        shoulder_points_left = [for(i=[0:steps]) 
            let(t=i/steps) 
            [center_x - (neck_w_half + width_transition * (1 - pow(1-t, 2))), h_len + shoulder_len*t]
        ];
        
        // Construct polygon: neck -> shoulder -> head tip -> shoulder -> neck
        polygon(points=concat(
            [[center_x - neck_w_half, h_len], [center_x + neck_w_half, h_len]], 
            shoulder_points, 
            [[center_x + head_w_half, h_len + head_len]], 
            [[center_x - head_w_half, h_len + head_len]], 
            reverse(shoulder_points_left)
        ));
    }
}

// ============================================================================
// UTILITY MODULES
// Reusable geometric primitives for creating rounded shapes
// ============================================================================

// ROUNDED RECTANGLE MODULE
// Creates a 3D rounded rectangle using hull of cylinders at corners
// Parameters:
//   w: Width (X dimension)
//   d: Depth (Y dimension)
//   h: Height (Z dimension)
//   r: Corner radius
module rounded_rect(w, d, h, r) {
    hull() {
        translate([r, r, 0]) cylinder(r = r, h = h);
        translate([w - r, r, 0]) cylinder(r = r, h = h);
        translate([r, d - r, 0]) cylinder(r = r, h = h);
        translate([w - r, d - r, 0]) cylinder(r = r, h = h);
    }
}

// ROUNDED SQUARE MODULE (2D)
// Creates a 2D rounded square/rectangle using hull of circles at corners
// Parameters:
//   w: Width (X dimension)
//   d: Depth (Y dimension)
//   r: Corner radius
module rounded_square(w, d, r) {
    hull() {
        translate([r, r]) circle(r=r);
        translate([w-r, r]) circle(r=r);
        translate([r, d-r]) circle(r=r);
        translate([w-r, d-r]) circle(r=r);
    }
}

// ROUNDED SLOT MODULE
// Creates a 3D rounded slot/box with automatic radius limiting
// Radius is automatically limited to prevent geometry errors
// Parameters:
//   w: Width (X dimension)
//   l: Length (Y dimension)
//   h: Height (Z dimension)
module rounded_slot(w, l, h) {
    // Limit radius to prevent geometry errors (radius can't exceed half of smallest dimension)
    r = min(fillet_radius, w/2 - 0.1, l/2 - 0.1);
    if (r > 0) {
        hull() {
            translate([r, r, 0]) cylinder(r = r, h = h);
            translate([w - r, r, 0]) cylinder(r = r, h = h);
            translate([r, l - r, 0]) cylinder(r = r, h = h);
            translate([w - r, l - r, 0]) cylinder(r = r, h = h);
        }
    } else {
        // Fallback to simple cube if radius is too small
        cube([w, l, h]);
    }
}

// ============================================================================
// GRIDFINITY BASE MODULES
// Create Gridfinity-compatible base with optional magnets and stacking lip
// Gridfinity is a modular storage system using 42mm grid units
// ============================================================================

// GRIDFINITY BASE MODULE
// Creates the base structure compatible with Gridfinity storage system
// Includes stepped pyramid base units, optional magnet holes, and bin walls
module gridfinity_base() {
    // The bin body (walls, bottom plate, slots, trench, lip — everything else in
    // full_organizer()) keeps its local origin at world [0,0]. Base feet always tile
    // exactly gf_grid_x x gf_grid_y full 42mm cells — trimming never adds a cell — so
    // here we shift the FEET by -gf_edge_left/front instead of shifting the bin body:
    // a left/front trim removes that much bin material on that side while the feet
    // stay a fixed gf_grid_x x gf_grid_y block, now offset to still sit under the bin.
    //
    // A right/back trim shrinks total_width/total_depth from that side instead (the
    // origin-anchored wall rect naturally pulls its right/back edge inward), so the
    // last foot column/row can now stick out past the trimmed wall on that side —
    // intersect against the wall footprint to clip it flush.
    foot_offset_x = -gf_edge_left_mm;
    foot_offset_y = -gf_edge_front_mm;
    difference() {
        union() {
            // Bin walls above base
            translate([0, 0, gf_base_height + bottom_thickness])
                rounded_rect(total_width, total_depth, final_total_height - gf_base_height - bottom_thickness, gf_bin_corner_radius);

            // Bottom plate
            translate([0, 0, gf_base_height])
                rounded_rect(total_width, total_depth, bottom_thickness, gf_bin_corner_radius);

            // Base units: stepped pyramid structure for Gridfinity compatibility
            intersection() {
                rounded_rect(total_width, total_depth, gf_base_height, gf_bin_corner_radius);
                translate([foot_offset_x, foot_offset_y, 0]) {
                    for (x = [0:gf_grid_x-1]) {
                        for (y = [0:gf_grid_y-1]) {
                            translate([x * gf_pitch + gf_clearance/2, y * gf_pitch + gf_clearance/2, 0])
                                gridfinity_base_unit();
                        }
                    }
                }
            }
        }
        // Subtract magnet holes if enabled
        if (gf_enable_magnets) {
            translate([foot_offset_x, foot_offset_y, 0]) {
                for (x = [0:gf_grid_x-1]) {
                    for (y = [0:gf_grid_y-1]) {
                        translate([x * gf_pitch + gf_clearance/2, y * gf_pitch + gf_clearance/2, 0])
                            magnet_holes();
                    }
                }
            }
        }
    }
}

// MAGNET HOLES MODULE
// Creates four magnet holes in a Gridfinity base unit (one per corner)
// Standard Gridfinity magnet size: 6.5mm diameter, 2.4mm depth
module magnet_holes() {
    base_size = gf_unit - gf_clearance;
    magnet_offset = 4.8; // Distance from edge to magnet center
    for (corner = [
        [magnet_offset, magnet_offset], 
        [base_size - magnet_offset, magnet_offset], 
        [magnet_offset, base_size - magnet_offset], 
        [base_size - magnet_offset, base_size - magnet_offset]
    ]) {
        translate([corner[0], corner[1], -0.01]) 
            cylinder(d = gf_magnet_d, h = gf_magnet_h + 0.02);
    }
}

// GRIDFINITY BASE UNIT MODULE
// Creates a single Gridfinity base unit (stepped pyramid structure)
// The stepped pyramid allows bins to snap into place on Gridfinity baseplates
module gridfinity_base_unit() {
    base_size = gf_unit - gf_clearance;
    // Create stepped pyramid using hull of progressively larger rounded rectangles
    hull() {
        translate([2.15, 2.15, 0]) rounded_rect(base_size - 4.3, base_size - 4.3, 0.8, 1.6);
        translate([1.15, 1.15, 0.8]) rounded_rect(base_size - 2.3, base_size - 2.3, 1.8, 0.8);
        translate([0.75, 0.75, 2.6]) rounded_rect(base_size - 1.5, base_size - 1.5, 2.15, 0.8);
        translate([0, 0, 4.75]) rounded_rect(base_size, base_size, 0.25, 0.8);
    }
    // Top section: solid cube to complete the base unit
    translate([0, 0, 4.75]) cube([base_size, base_size, gf_base_height - 4.75 + 0.01]);
}

// STACKING LIP MODULE
// Creates a lip around the top edge of the bin for stacking multiple bins
// The lip allows bins to nest securely when stacked
module stacking_lip() {
    lip_inset = 2.6; // Distance lip extends inward from bin edge
    difference() {
        // Outer lip shape
        linear_extrude(height = gf_lip_height) 
            offset(r = -lip_inset) 
            rounded_square(total_width, total_depth, gf_bin_corner_radius);
        // Subtract inner shape to create lip thickness
        translate([0, 0, -0.01]) 
            linear_extrude(height = gf_lip_height + 0.02) 
            offset(r = -(lip_inset + 1.9)) 
            rounded_square(total_width, total_depth, gf_bin_corner_radius);
    }
}

// REVERSE FUNCTION
// Utility function to reverse a list (used for polygon point ordering)
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];