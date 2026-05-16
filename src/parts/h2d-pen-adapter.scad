// ============================================================================
// Parametric H2D Pen Adapter - Final Verified (v111)
// ============================================================================
// A parametric adapter for converting various pens to fit H2D pen holders.
// Features a flexible collet system with internal friction ribs for secure
// pen retention.
//
// FEATURES:
// - Prod Mode: Vertical text column (3 positions, 120° apart)
// - Test Slice Mode: 
//    * Horizontal text wrapped Left-to-Right around cylinder
//    * Text vertically centered manually (offset) so decimal point stays at baseline
//    * Icon centered at Z=0
// - Internal friction ribs for improved grip
// - Tapered collet slits for better pen retention
// - Chamfered flange for easier insertion into H2D holder
// ============================================================================

// ============================================================================
// USER PARAMETERS (Customizable via OpenSCAD Customizer)
// ============================================================================

/* [Batch Generation] */
// Enable/disable presets for batch printing multiple adapters
gen_sharpie_felt      = true;   // Sharpie Felt Tip (10.0mm diameter)
gen_sharpie_fine      = false;  // Sharpie Fine Point (11.0mm diameter)
gen_sharpie_ultra_fine = true;  // Sharpie Ultra Fine (11.0mm tapered to 10.0mm)
gen_staedtler_lumicolor = true; // Staedtler Lumicolor (9.4mm diameter)
gen_staedtler_triplus = true;   // Staedtler Triplus (9.0mm, triangular profile)
gen_stabilo           = false;  // Stabilo (9.4mm, hexagonal profile)

/* [Grip Zone Settings] */
// How much the pen extends beyond the adapter (in mm)
pen_protrusion_length = 30.0;

/* [Collet System] */
// Number of flexible flaps in the collet system (typically 4 or 8)
collet_flap_count = 4;
// Width of slits between collet flaps (1.6mm prevents binding/locking)
collet_slit_width = 1.6;

/* [Geometry Settings] */
// Height of the mounting collar/flange
collar_height = 2.7;
// Outer diameter of the mounting collar (fits H2D holder)
collar_diameter = 18.0;
// Main body diameter (neck section)
body_diameter = 14.45;
// Total height of the adapter from collar to tip
total_adapter_height = 62.0;

/* [User Constraints] */
// Height above flange where collet fins/slits begin
fins_start_above_flange = 34.0;

/* [Test Slice Mode] */
// Enable to print only a slice of the model for testing dimensions
// When enabled, engraving switches to horizontal wrapped text mode
generate_test_slice = false;
// Height of test slice (in mm)
slice_height = 5;

/* [Printer Tolerance] */
// Additional clearance added to pen cavity diameter (0.6mm for smooth fit)
// Increase if pen is too tight, decrease if too loose
pen_cavity_tolerance = 0.6;

/* [Advanced Settings] */
// Enable engraved labels showing pen diameter and shape
enable_label_engraving = true;
// Surface resolution for curves (higher = smoother, slower rendering)
surface_resolution = 50;
// Spacing between parts in batch printing grid (in mm)
part_spacing = body_diameter + 10.0;

// ============================================================================
// RENDERING SETTINGS
// ============================================================================
$fa = 1;      // Minimum angle for fragments
$fs = 0.4;    // Minimum size for fragments
$fn = $preview ? 24 : surface_resolution;  // Fragment number (preview vs render)

// ============================================================================
// PEN PRESET DEFINITIONS
// ============================================================================
// Format: [enabled_flag, shape, pen_length, diameter_bottom, diameter_middle, diameter_top]
// - enabled_flag: true/false to include in batch
// - shape: "circle", "hexagon", "staedtler_triplus", "reuleaux_triangle", "triangle_rounded"
// - pen_length: Total pen length in mm
// - diameter_bottom: Pen diameter at bottom in mm
// - diameter_middle: Pen diameter at middle (0 = no taper, use bottom diameter)
// - diameter_top: Pen diameter at top in mm
preset_definitions = [
    [gen_sharpie_felt,      "circle",            129.0,  10.0, 0, 10.2],
    [gen_sharpie_fine,      "circle",            138.0,  11.0, 0, 11.2],
    [gen_sharpie_ultra_fine,"circle",            132.0,  11.0, 10.5, 10.0],
    [gen_staedtler_lumicolor,"circle",           130.0,  9.4, 0, 9.7],
    [gen_staedtler_triplus, "staedtler_triplus", 160.0,  9.0, 0, 9.0],
    [gen_stabilo,           "hexagon",           165.0,  9.4, 0, 9.4]
];

// Custom pen profiles for batch printing
// Format: [diameter_bottom, diameter_middle, diameter_top, shape, pen_length]
// Example: [10.5, 0, 10.5, "circle", 140]
custom_batch_list = [];

// ============================================================================
// MAIN EXECUTION
// ============================================================================
// Generates all enabled presets and custom profiles in a grid layout
union() {
    active_presets = [ for (p = preset_definitions) if (p[0]) p ];
    total_items = len(active_presets) + len(custom_batch_list);

    // Generate all enabled preset adapters
    for (i = [0 : len(active_presets) - 1]) {
        grid_position(i, total_items)
            maybe_slice() 
            h2d_pen_adapter(
                shape               = active_presets[i][1],
                pen_length          = active_presets[i][2],
                pen_diameter_bottom = active_presets[i][3],
                pen_diameter_middle = active_presets[i][4],
                pen_diameter_top    = active_presets[i][5]
            );
    }

    // Generate custom batch adapters if any are defined
    if (len(custom_batch_list) > 0) {
        base_index = len(active_presets);
        for (i = [0 : len(custom_batch_list) - 1]) {
            grid_position(base_index + i, total_items)
                maybe_slice() 
                h2d_pen_adapter(
                    pen_diameter_bottom = custom_batch_list[i][0],
                    pen_diameter_middle = custom_batch_list[i][1],
                    pen_diameter_top    = custom_batch_list[i][2],
                    shape               = custom_batch_list[i][3],
                    pen_length          = custom_batch_list[i][4]
                );
        }
    }
}

// ============================================================================
// HELPER MODULES
// ============================================================================

// Arranges parts in a grid layout for batch printing
// Parameters:
//   idx: Index of current part (0-based)
//   total_count: Total number of parts to arrange
module grid_position(idx, total_count) {
    cols = ceil(sqrt(total_count));  // Calculate grid columns
    row = floor(idx / cols);         // Calculate row position
    col = idx % cols;                // Calculate column position
    translate([col * part_spacing, row * part_spacing, 0])
        children();
}

// Conditionally applies a test slice for dimension verification
// When enabled, slices the model horizontally at the engraving location
// This allows testing cavity dimensions and label visibility without printing full adapter
module maybe_slice() {
    if (generate_test_slice) {
        // Calculate center Z for slicing so text is centered in the block
        // Base collar (2.7) + neck (5) + gap (2) + half font (1.75) = ~11.45mm
        engrave_z_center = collar_height + 5.0 + 2.0 + 1.75; 
        
        cut_z_start = engrave_z_center - (slice_height / 2);
        intersection() {
            children();
            translate([-25, -25, cut_z_start])
                cube([50, 50, slice_height]);
        }
    } else {
        children();
    }
}

// ============================================================================
// GEOMETRY ENGINE
// ============================================================================

// Generates the outer shell profile of the adapter
// The adapter has multiple zones: flange (with chamfer), neck, thin body, 
// bulge transition, thickened slit body, and tip taper
// Parameters:
//   internal_diameter_at_taper: Pen cavity diameter at the taper zone
//   internal_diameter_at_top: Pen cavity diameter at the top
module outer_profile_geometry(internal_diameter_at_taper, internal_diameter_at_top) {
    min_wall_thickness = 0.8;  // Minimum wall thickness to maintain structural integrity
    
    // Z-Height definitions (all relative to bottom of adapter)
    z_flange_top = collar_height;
    z_neck_end = z_flange_top + 5.0;
    z_bulge_end   = collar_height + fins_start_above_flange;
    z_bulge_start = z_bulge_end - 3.0;
    z_top = total_adapter_height;
    tip_taper_len = 3.0;
    z_tip_taper_start = z_top - tip_taper_len;

    // Diameter calculations
    od_base = body_diameter;
    target_reduced_od = od_base - 2.0;  // Reduced for flexibility
    safe_reduced_od = max(target_reduced_od, internal_diameter_at_taper + (2 * min_wall_thickness));
    thickened_slit_od = safe_reduced_od + 1.0;  // Extra material where slits are cut
    target_tip_od = internal_diameter_at_top + (2 * 1.5);
    final_tip_od = target_tip_od;

    // Construct geometry (bottom to top)
    
    // 1. Flange - mounting collar with chamfer for easier insertion
    chamfer_size = 1.0;
    translate([0,0,0])
        cylinder(h = chamfer_size, d1 = collar_diameter - (chamfer_size*2), d2 = collar_diameter);
    translate([0,0,chamfer_size])
        cylinder(h = collar_height - chamfer_size, d = collar_diameter);
    
    // 2. Neck - transition from flange to body
    translate([0,0,z_flange_top])
        cylinder(h = z_neck_end - z_flange_top, d = od_base);
    
    // 3. Main Body - flexible section before collet
    translate([0,0,z_neck_end])
        cylinder(h = z_bulge_start - z_neck_end, d = safe_reduced_od);
    
    // 4. Bulge - gradual increase to thickened section
    translate([0,0,z_bulge_start])
        cylinder(h = z_bulge_end - z_bulge_start, d1 = safe_reduced_od, d2 = thickened_slit_od);
    
    // 5. Slit Body - thickened section where collet slits are cut
    translate([0,0,z_bulge_end])
        cylinder(h = z_tip_taper_start - z_bulge_end, d = thickened_slit_od);
    
    // 6. Tip - smooth transition to tip diameter
    translate([0,0,z_tip_taper_start])
        cylinder(h = tip_taper_len, d1 = thickened_slit_od, d2 = final_tip_od);
}

// Main adapter module - generates a complete pen adapter
// Parameters:
//   pen_diameter_bottom: Pen diameter at bottom (mm)
//   pen_diameter_middle: Pen diameter at middle, 0 = no taper (mm)
//   pen_diameter_top: Pen diameter at top (mm)
//   shape: Cross-section shape ("circle", "hexagon", "staedtler_triplus", etc.)
//   pen_length: Total pen length (mm)
module h2d_pen_adapter(pen_diameter_bottom = 10, pen_diameter_middle = 0, pen_diameter_top = 10, shape = "circle", pen_length = 150) {
    
    // Calculate effective diameters (handle zero values)
    eff_mid = (pen_diameter_middle > 0) ? pen_diameter_middle : pen_diameter_bottom; 
    eff_top = (pen_diameter_top > 0) ? pen_diameter_top : eff_mid;
    
    // Add tolerance to pen diameters for fit
    cut_bot = pen_diameter_bottom + pen_cavity_tolerance;
    cut_mid = (pen_diameter_middle > 0) ? pen_diameter_middle + pen_cavity_tolerance : 0;
    cut_top = eff_top + pen_cavity_tolerance;
    
    // Safety check: ensure cavity doesn't exceed body diameter
    min_wall = 0.8;  // Minimum wall thickness
    max_safe = body_diameter - (2 * min_wall);  // Maximum safe cavity diameter
    peak_dia = max(cut_bot, max((cut_mid>0?cut_mid:0), cut_top));  // Largest diameter needed
    
    // Triangular shapes need extra clearance (16% more)
    peak_req = (shape == "reuleaux_triangle" || shape == "staedtler_triplus" || shape == "triangle_rounded") 
               ? peak_dia * 1.16 : peak_dia;

    // Scale down if exceeds safe diameter
    safety_scale = (peak_req > max_safe) ? (max_safe / peak_req) : 1.0;
    final_bot = cut_bot * safety_scale;
    final_mid = (cut_mid > 0) ? cut_mid * safety_scale : 0;
    final_top = cut_top * safety_scale;

    // Calculate cavity depth and diameters
    cavity_stop_height = pen_length - pen_protrusion_length;
    dia_check_height = collar_height + 5.0;
    dia_at_taper = get_interpolated_diameter(dia_check_height, final_bot, final_mid, final_top, total_adapter_height);
    
    // Collet slit parameters
    slit_z_start = collar_height + fins_start_above_flange;
    slit_height = total_adapter_height - slit_z_start;
    target_reduced_od = body_diameter - 2.0;
    engraving_od = max(target_reduced_od, dia_at_taper + (2 * min_wall));

    // Inner module: generates the complete adapter shell
    module main_body_shell() {
        difference() {
            union() {
                // Outer shell with pen cavity subtracted
                difference() {
                    outer_profile_geometry(dia_at_taper, final_top);
                    pen_cavity_sequence(final_bot, final_mid, final_top, shape, cavity_stop_height);
                }
                // Internal friction ribs for improved pen grip
                rib_start_z = collar_height + fins_start_above_flange;
                internal_friction_ribs(rib_start_z, total_adapter_height - 1, final_top);
            }
            
            // Collet Slits - creates flexible flaps
            // Relief holes at base prevent stress concentration
            calculated_relief_dia = collet_slit_width * 1.5;
            final_relief_dia = max(calculated_relief_dia, 1.6);
            relief_r = final_relief_dia / 2;

            // Create slits evenly spaced around the adapter
            for (i = [0 : collet_flap_count - 1]) {
                rotate([0, 0, (i * (360 / collet_flap_count)) + (360/collet_flap_count/2)]) {
                    cut_len = body_diameter + 5;
                    half_h = slit_height / 2;
                    
                    // Bottom half: straight slit for structural integrity
                    translate([-cut_len / 2, -collet_slit_width / 2, slit_z_start])
                        cube([cut_len, collet_slit_width, half_h + 0.01]);
                    
                    // Top half: tapered slit (wider at top = narrower flaps = better grip)
                    top_slit_width = collet_slit_width + 1.0;
                    hull() {
                        translate([-cut_len / 2, -collet_slit_width / 2, slit_z_start + half_h])
                            cube([cut_len, collet_slit_width, 0.01]);
                        translate([-cut_len / 2, -top_slit_width / 2, slit_z_start + slit_height + 1])
                            cube([cut_len, top_slit_width, 0.01]);
                    }

                    // Relief hole at base of slit for smooth flexing
                    translate([0, 0, slit_z_start])
                        rotate([0, 90, 0])
                        cylinder(r = relief_r, h = body_diameter + 5, center = true);
                }
            }

            // Engraving Logic
            if (enable_label_engraving) {
                // Determine Z height for engraving
                // For Test Slice, adjust to match slice center for alignment
                engrave_z_base = collar_height + 5.0 + 2.0;
                engrave_z = (generate_test_slice) ? engrave_z_base + 1.75 : engrave_z_base;
                
                engraving_full_mode(engrave_z, (pen_diameter_bottom + eff_top) / 2, shape, engraving_od);
            }
        }
    }
    main_body_shell();
}

// Interpolates pen diameter at a given height
// Handles both linear taper (middle=0) and three-point taper (middle>0)
// Parameters:
//   height: Z-height to calculate diameter at
//   diameter_bottom: Diameter at bottom
//   diameter_middle: Diameter at middle (0 = linear taper)
//   diameter_top: Diameter at top
//   total_height: Total height of adapter
function get_interpolated_diameter(height, diameter_bottom, diameter_middle, diameter_top, total_height) = 
    let(mid_point = total_height / 2)
    (diameter_middle == 0)
    ? diameter_bottom + (diameter_top - diameter_bottom) * (height / total_height)  // Linear interpolation
    : (height <= mid_point) 
        ? diameter_bottom + (diameter_middle - diameter_bottom) * (height / mid_point)  // Bottom to middle
        : diameter_middle + (diameter_top - diameter_middle) * ((height - mid_point) / (total_height - mid_point));  // Middle to top

// Creates the pen cavity with smooth diameter transitions
// Uses hull() operations to create smooth tapers between diameter points
// Parameters:
//   diameter_bottom: Cavity diameter at bottom
//   diameter_middle: Cavity diameter at middle (0 = no middle point)
//   diameter_top: Cavity diameter at top
//   pen_shape: Cross-section shape
//   stop_height: Height where cavity stops (pen length - protrusion)
module pen_cavity_sequence(diameter_bottom, diameter_middle, diameter_top, pen_shape, stop_height) {
    is_through_hole = (stop_height > total_adapter_height);
    effective_stop_height = (is_through_hole) ? total_adapter_height + 1 : stop_height;
    mid_height = total_adapter_height / 2;
    diameter_at_mid = (diameter_middle > 0) 
                     ? diameter_middle 
                     : get_interpolated_diameter(mid_height, diameter_bottom, 0, diameter_top, total_adapter_height);
    diameter_at_stop = get_interpolated_diameter(effective_stop_height, diameter_bottom, diameter_middle, diameter_top, total_adapter_height);
    
    chamfer_h = 1.0;  // Height of bottom chamfer for smooth pen insertion
    translate([0, 0, -0.5]) {
        // Bottom chamfer - smooth entry for pen insertion
        hull() {
            translate([0,0,0]) linear_extrude(0.01) get_2d_shape(diameter_bottom + 0.5, pen_shape);
            translate([0,0,chamfer_h]) linear_extrude(0.01) get_2d_shape(diameter_bottom, pen_shape);
        }
        
        // Main cavity body - handle short and long pens differently
        if (effective_stop_height < mid_height) {
            // Short pen: single taper from bottom to stop
            hull() {
                translate([0,0,chamfer_h]) linear_extrude(0.01) get_2d_shape(diameter_bottom, pen_shape);
                translate([0,0,effective_stop_height]) linear_extrude(0.01) get_2d_shape(diameter_at_stop, pen_shape);
            }
        } else {
            // Long pen: two-segment taper (bottom->middle, middle->top)
            hull() {
                translate([0,0,chamfer_h]) linear_extrude(0.01) get_2d_shape(diameter_bottom, pen_shape);
                translate([0,0,mid_height]) linear_extrude(0.01) get_2d_shape(diameter_at_mid, pen_shape);
            }
            hull() {
                translate([0,0,mid_height]) linear_extrude(0.01) get_2d_shape(diameter_at_mid, pen_shape);
                translate([0,0,effective_stop_height]) linear_extrude(0.01) get_2d_shape(diameter_at_stop, pen_shape);
            }
        }
    }
}

// Generates 2D cross-section shape for pen cavity
// Supports multiple pen cross-section shapes
// Parameters:
//   diameter: Diameter/size of the shape
//   pen_shape: Shape type ("circle", "hexagon", "staedtler_triplus", etc.)
module get_2d_shape(diameter, pen_shape) {
    if (pen_shape == "circle") {
        circle(d = diameter);
    } else if (pen_shape == "hexagon") {
        circle(d = diameter, $fn = 6);
    } else if (pen_shape == "reuleaux_triangle") {
        reuleaux_profile(width = diameter);
    } else if (pen_shape == "staedtler_triplus") {
        staedtler_profile(width = diameter);
    } else if (pen_shape == "triangle_rounded") {
        rounded_triangle_profile(diameter = diameter, corner_r = 2);
    } else {
        circle(d = diameter);  // Default to circle
    }
}

// ============================================================================
// LABEL ENGRAVING SYSTEM
// ============================================================================

// Engraves labels at multiple positions around the adapter
// Prod Mode: 3 positions (120° apart) with vertical text column
// Test Mode: Single position (0°) with horizontal wrapped text
// Parameters:
//   z_position: Z-height for engraving
//   nominal_diameter: Average pen diameter for label
//   pen_shape: Shape type for icon
//   surface_dia: Outer diameter at engraving location
module engraving_full_mode(z_position, nominal_diameter, pen_shape, surface_dia) {
    // If Test Slice, only engrave at Angle 0. Else, 3 positions.
    angles = (generate_test_slice) ? [0] : [0, 120, 240];
    
    for (angle = angles) {
        rotate([0, 0, angle])
            apply_engraving_cut(z_position, nominal_diameter, pen_shape, surface_dia);
    }
}

// Applies a single engraving cut (subtracts from surface)
// Switches between vertical (prod) and horizontal wrapped (test) modes
// Parameters:
//   z_position: Z-height for engraving
//   nominal_diameter: Average pen diameter
//   pen_shape: Shape type for icon
//   surface_dia: Outer diameter at engraving location
module apply_engraving_cut(z_position, nominal_diameter, pen_shape, surface_dia) {
    shank_radius = surface_dia / 2;
    current_wall_thickness = (surface_dia - (nominal_diameter + pen_cavity_tolerance)) / 2;
    safe_depth = min(0.8, max(0.2, current_wall_thickness * 0.5));  // Safe engraving depth
    cut_clearance = 1.0;
    epsilon = 0.1; 

    is_vertical = !generate_test_slice;  // Vertical mode for production, horizontal for test
    
    // This translate sets the BASE Z for the engraving block
    translate([0, 0, z_position]) {
        if (is_vertical) {
            // PROD MODE (Vertical Column) - text reads vertically down the adapter
            translate([0, -shank_radius - cut_clearance, 0])
            rotate([-90, 0, 0]) 
            linear_extrude(height = cut_clearance + safe_depth + epsilon)
            translate([0, 0, 0]) 
            rotate([0, 0, 90])
            mirror([1, 0])
            label_2d_profile_vertical(nominal_diameter, pen_shape);
        } else {
            // TEST MODE (Horizontal Wrapped) - text wraps around cylinder
            engrave_text_wrapped(
                text_str = str(nominal_diameter), 
                pen_shape = pen_shape,
                radius = shank_radius, 
                depth = safe_depth,
                clearance = cut_clearance,
                epsilon = epsilon
            );
        }
    }
}

// Wraps text/icon horizontally around the cylinder for Test Mode
// Text is positioned left-to-right with manual vertical centering
// Parameters:
//   text_str: Text string to engrave (pen diameter)
//   pen_shape: Shape type for icon
//   radius: Radius of cylinder at engraving location
//   depth: Engraving depth
//   clearance: Clearance from surface
//   epsilon: Small value for clean cuts
module engrave_text_wrapped(text_str, pen_shape, radius, depth, clearance, epsilon) {
    font_size = 3.5;
    
    // VISUAL CENTERING:
    // With valign="baseline", the text sits at Y=0 (which maps to Cylinder Z=0).
    // The "body" of a number (0-9) rises from 0 to approx 0.72*font_size.
    // To center this "body" on Z=0, we must shift the baseline DOWN by half the body height.
    // Body Height ~ 0.72 * 3.5mm = 2.52mm.
    // Half Height ~ 1.26mm.
    // 1.26 / 3.5 = 0.36.
    // So we shift down by 0.36 * font_size.
    optical_z_offset = -font_size * 0.36; 

    // ANGULAR CALCULATIONS:
    // Calculate angular width of characters and icon based on font size and radius
    char_angle_width = (font_size * 0.7) / (2 * PI * radius) * 360;
    icon_angle_width = (font_size * 1.2) / (2 * PI * radius) * 360;
    
    total_arc = icon_angle_width + (len(text_str) * char_angle_width);
    
    // STARTING ANGLE (LEFT SIDE):
    start_angle = -total_arc / 2; // Start at "Left" relative to center

    // 1. DRAW ICON (First item, Leftmost)
    // Icon is centered at (0,0) by default, so it needs NO vertical offset.
    icon_center_angle = start_angle + (icon_angle_width / 2);
    
    rotate([0, 0, icon_center_angle]) 
    translate([0, -radius - clearance, 0]) 
    rotate([90, 0, 0]) // Upright orientation
    mirror([0, 0, 1]) // Z-Mirror forces inward cut
    linear_extrude(height = clearance + depth + epsilon)
    draw_shape_icon(font_size, pen_shape);

    // 2. DRAW TEXT (Moving Right -> Increasing Angle)
    text_start_angle = start_angle + icon_angle_width;
    
    for (i = [0 : len(text_str) - 1]) {
        // Move Right (Increase Angle) for each character
        char_center_angle = text_start_angle + (char_angle_width / 2) + (i * char_angle_width);
        
        rotate([0, 0, char_center_angle]) 
        translate([0, -radius - clearance, optical_z_offset]) // Manual vertical centering
        rotate([90, 0, 0]) // Upright orientation
        mirror([0, 0, 1]) // Z-Mirror forces inward cut
        linear_extrude(height = clearance + depth + epsilon)
        text(
            text_str[i], 
            size = font_size, 
            halign = "center", 
            valign = "baseline", // Ensures flat baseline for decimal point
            font = "Liberation Sans"
        );
    }
}

// Creates 2D profile for vertical label (shape icon + diameter text)
// Used in production mode
// Parameters:
//   nominal_diameter: Average pen diameter for label
//   pen_shape: Shape type for icon
module label_2d_profile_vertical(nominal_diameter, pen_shape) {
    font_size = 3.5;
    label_text = str(nominal_diameter);
    translate([font_size / 2, 0]) {
        draw_shape_icon(font_size, pen_shape);
    }
    translate([font_size + 1.2, 0]) {
        text(label_text, size = font_size, valign = "center", halign = "left", font = "Liberation Sans");
    }
}

// Draws a simple icon representing the pen shape
// Parameters:
//   font_size: Size of the icon
//   pen_shape: Shape type ("circle", "hexagon", or triangle variant)
module draw_shape_icon(font_size, pen_shape) {
    icon_fn = $preview ? 16 : 24;
    if (pen_shape == "circle") {
        circle(d = font_size * 0.75, $fn = icon_fn);
    } else if (pen_shape == "hexagon") {
        rotate([0, 0, 30]) circle(d = font_size * 0.85, $fn = 6);
    } else {
        // Triangle shapes
        rotate([0, 0, 90]) circle(d = font_size * 0.85, $fn = 3);
    }
}

// ============================================================================
// SPECIALIZED PEN SHAPE PROFILES
// ============================================================================

// Reuleaux triangle profile - constant-width triangle shape
// Created by intersecting three circles
// Parameter: width - width of the Reuleaux triangle
module reuleaux_profile(width) {
    offset_dist = width / sqrt(3);
    reuleaux_fn = $preview ? 24 : 64;
    intersection_for(a = [0, 120, 240]) {
        rotate([0, 0, a])
            translate([0, offset_dist, 0]) 
            circle(r = width, $fn = reuleaux_fn);
    }
}

// Staedtler Triplus profile - specialized triangular pen shape
// Based on actual Staedtler Triplus measurements (9.0mm x 8.6mm)
// Scales proportionally and adds clearance
// Parameter: width - target width of the profile
module staedtler_profile(width) {
    meas_w = 9.0;   // Measured width of Staedtler Triplus
    meas_h = 8.6;   // Measured height of Staedtler Triplus
    s = width / meas_w;  // Scale factor
    clearance = 0.25;    // Additional clearance
    target_w = (meas_w * s) + clearance;
    target_h = (meas_h * s) + clearance;
    
    // Calculate triangle geometry
    roughly_sqrt3_over_2 = 0.866025;  // sqrt(3)/2 approximation
    tri_offset = (target_w - target_h) / (1 - roughly_sqrt3_over_2);
    corner_rad = (target_w - tri_offset) / 2;
    corner_fn = $preview ? 24 : 48;

    // Create rounded triangle using hull of three circles
    hull() {
        translate([tri_offset/2, -tri_offset * roughly_sqrt3_over_2 / 3, 0])
            circle(r=corner_rad, $fn=corner_fn);
        translate([-tri_offset/2, -tri_offset * roughly_sqrt3_over_2 / 3, 0])
            circle(r=corner_rad, $fn=corner_fn);
        translate([0, tri_offset * roughly_sqrt3_over_2 * 2/3, 0])
            circle(r=corner_rad, $fn=corner_fn);
    }
}

// Rounded triangle profile - triangle with rounded corners
// Parameters:
//   diameter: Overall size
//   corner_r: Corner radius
module rounded_triangle_profile(diameter, corner_r) {
    offset_fn = $preview ? 16 : 24;
    offset(r = corner_r, $fn = offset_fn)
        circle(r = (diameter / 2) - corner_r, $fn = 3);
}

// ============================================================================
// INTERNAL FRICTION RIBS
// ============================================================================

// Creates internal friction ribs inside the pen cavity
// These ribs improve grip and prevent pens from slipping
// Parameters:
//   z_start: Starting Z-height for ribs
//   z_end: Ending Z-height for ribs
//   base_diameter: Base diameter of the cavity at rib location
module internal_friction_ribs(z_start, z_end, base_diameter) {
    rib_count = 6;  // Number of ribs evenly spaced around cavity
    rib_protrusion = 0.25;  // How much ribs protrude into cavity (mm)
    rib_base_radius = base_diameter / 2;
    
    for (i = [0 : rib_count-1]) {
        rotate([0, 0, i * (360/rib_count)])
            translate([rib_base_radius, 0, z_start])
                linear_extrude(height = z_end - z_start)
                    polygon([[0, -0.3], [0, 0.3], [-rib_protrusion, 0]]);
    }
}
