// Parametric Snapware Lid Holder, v5 (lean). Units: mm. Channel fit validated on v4 (both Costco sets
// printed and installed); the v5 short hooks and hollow pillars are not print-validated yet.
// Hangs Snapware Total Solution plastic lids vertically under a shelf, one lid
// per channel, all channels side by side in ONE printed piece so spacing and
// parallelism come from the print. If the selection is wider than the bed it
// is split into pieces that interlock with knuckle joints (see Joints below).
//
// Source cross-section: user-supplied Big+Rectangle+2.stl (one 20 mm pitch,
// 30 mm deep channel). Retain attribution and original licensing when sharing.
//
// Design (see snapware-lid-holder.md):
//  - Material-minimal ladder frame: the full channel profile exists only at
//    short crossbar "hooks" (stations), tied together by ledge rails on the
//    open (lid) side. Each lid hangs by its LONGEST side (rectangles too, to
//    save vertical space) and rests with both clamp ends on a hook: one under
//    the clamp's front end, one under its rear end ending at the stop.
//  - All lid fronts are flush on one front line; only the stop varies. Nothing
//    is built behind a channel's stop. Clear gaps between hooks stay within
//    the shortest clamp hook - 2 x Clamp_min_engagement.
//  - Stop hooks and gap fills are screwed at both ends through vertical
//    countersunk bosses (driver goes up the boss bore); clamp-front hooks of
//    longer lids are webbed at roof level to the nearest screwed hook.
//  - Lean: hooks are only Station_length long (plus the stop wall) and grow to
//    one screw-tube diameter just at the pillars that hold a screw; every
//    pillar is a hollow box (Void_wall walls) with a pocket in its foot.
//  - Prints without supports in PETG or PLA: only short bridges (cavity
//    roofs ~7 mm, pillar voids ~9 mm, webs/step-boss bridges < 6 mm, socket
//    caps ~13 mm).
//
// Axes (mounted): X across channels, Y down from shelf (Y=0 on shelf), Z along
// lid insertion; open front at Z=0, each size's stop at Z = its lid length.
// Print settings: PRINT FLAT, OPEN SIDE DOWN (roof up) - this is what the
// "Print" output produces. No supports (PETG or PLA). Roof bridges the ~7 mm
// channel cavity and the ~9.5 mm pillar voids; boss seats bridge their bore. Wall multiples of 0.6 mm. Brim optional.
//
// Counts are catalog facts (sources below); lid lengths are ESTIMATES from
// retailer container dimensions - measure your lids and override.
// Current: https://www.costco.com/p/-/snapware-38-piece-plastic-food-storage-set/100502268
// 2016-17: https://www.frugalhotspot.com/2016/08/snapware-38-pc-plastic-set/
// 2015:    https://www.frugalhotspot.com/2015/01/snapware-34-piece-plastic-food-keeper-set/
// 2014:    https://www.frugalhotspot.com/2014/12/snapware-38-piece-plastic-food-storage-set/

/* [Configuration and output] */
Pack = "Plastic 38 current 1298037"; // [Plastic 38 current 1298037,Plastic 38 2016-17 1044330,Plastic 34 2015 940442,Plastic 38 2014 819340 reported,Custom]
Set_quantity = 1; // [1:1:4]
Selection = "All sizes"; // [All sizes,Small round,Medium round,Large round,Extra large round,Small rectangle,Medium rectangle,Large rectangle,Small square,Medium square,Large square]
// Print = print orientation; Installed preview = as mounted, with ghost lids.
Output = "Print"; // [Print,Fit test,Installed preview]
// 0 = all pieces laid out side by side; N = only piece N (for export).
Piece = 0; // [0:1:6]
// Channels on the fit-test coupon.
Fit_test_channels = 1; // [1:1:3]
// Deepest stops on the left (default) or, reversed, on the right. The rack is
// mirrored, so lids go in turned around (their clamp is centred, so they fit the same).
Reverse_order = false;

/* [Lid counts - used with Custom preset] */
Small_round_slots = 4; // [0:1:16]
Medium_round_slots = 3; // [0:1:16]
Large_round_slots = 2; // [0:1:16]
Extra_large_round_slots = 0; // [0:1:16]
Small_rectangle_slots = 4; // [0:1:16]
Medium_rectangle_slots = 2; // [0:1:16]
Large_rectangle_slots = 2; // [0:1:16]
Small_square_slots = 0; // [0:1:16]
Medium_square_slots = 2; // [0:1:16]
Large_square_slots = 0; // [0:1:16]

/* [Lid length along insertion direction (mm) - estimates, measure yours] */
// 1.2/2 cup rounds share the orange lid (~4.25 in dia).
Small_round_lid_length = 108; // [60:1:300]
Medium_round_lid_length = 108; // [60:1:300]
// 3.8/4 cup yellow lid (~6.75 in dia).
Large_round_lid_length = 171; // [60:1:300]
// 7.5 cup (2014 only) - rough guess.
Extra_large_round_lid_length = 200; // [60:1:300]
// 3 and 5 cup rectangles share the teal lid (6.75 x 4.75 in); long side.
Small_rectangle_lid_length = 171; // [60:1:300]
Medium_rectangle_lid_length = 171; // [60:1:300]
// 8.2/8.5 cup blue lid (9 x 7.25 in); long side.
Large_rectangle_lid_length = 229; // [60:1:300]
// 1.2/1.34 cup pink square - rough guess.
Small_square_lid_length = 108; // [60:1:300]
// 5.4/5.5 and 10.5 cup squares share the green lid (~6.75 in).
Medium_square_lid_length = 171; // [60:1:300]
Large_square_lid_length = 171; // [60:1:300]

/* [Clamp hook length (mm) - centred on the long side; measure yours] */
// The clamp's hook is what rides on the rail and carries the lid. It sets
// where each lid's two hooks and its stop go; the shortest clamp in the
// selection caps the open gap between hooks (clamp - 2 x 5 mm engagement).
// Estimates: ~half the side, except the measured 60 mm squares.
Small_round_clamp = 54; // [20:1:300]
Medium_round_clamp = 54; // [20:1:300]
Large_round_clamp = 85; // [20:1:300]
Extra_large_round_clamp = 100; // [20:1:300]
Small_rectangle_clamp = 85; // [20:1:300]
Medium_rectangle_clamp = 85; // [20:1:300]
Large_rectangle_clamp = 115; // [20:1:300]
Small_square_clamp = 54; // [20:1:300]
Medium_square_clamp = 60; // [20:1:300]
Large_square_clamp = 60; // [20:1:300]

/* [Screws] */
Screw_hole_diameter = 4.4; // [3:0.1:6]
Screw_head_diameter = 8.5; // [6:0.1:12]
// Included angle; match the screws (82 or 90 typical).
Countersink_angle = 82; // [82,90,100]
// Max lids between screws across a crossbar; intermediate screws go up through
// the divider walls, placed so each screw carries about the same lid weight.
Channels_per_screw = 5; // [2:1:10]

/* [Print bed] */
// Pieces are split only when the bed is too small; width goes on the long axis.
Printer = "Bambu H2D single nozzle"; // [Bambu H2D single nozzle,Bambu H2D both nozzles,Bambu X1/P1/A1,Bambu A1 mini,Prusa MK4/MK4S,Prusa Core One,Prusa XL,Creality K1 Max,Custom]
Custom_bed_x = 256; // [100:1:500]
Custom_bed_y = 256; // [100:1:500]

/* [Joint fit] */
Joint_clearance = 0.25; // [0.1:0.05:0.5]

/* [Hidden] */
// Design constants (not Customizer settings; override with -D if needed).
// All lids = one channel per lid; One per size = one channel per size.
Copies = "All lids";
Channel_pitch = 20;
Channel_depth = 30;
// Roof (shelf side) over the lid cavities and lightening voids; the source
// profile has 5 (scaled by Channel_depth/30). Thinned from below, so the shelf
// face, bosses and joint sockets are unchanged. 6 perimeters at 0.6 mm.
Roof_thickness = 3.6;
Stop_thickness = 2.4;
// Hook length behind the stop wall (0 = the piece ends at the wall; the clamp
// only touches the Station_length in front of it).
Stop_tail = 0;
// Length of each crossbar station along Z (the hook under the clamp; must be
// >= Clamp_min_engagement). Pillars that hold a screw stay one tube long.
Station_length = 6;
// Walls around the lightening voids in each pillar (3 perimeters at 0.6 mm;
// 1.2 is the printable floor).
Void_wall = 1.8;
// Each channel's rail ends this far short of its lid's clamp edge.
Front_overhang = 0;
Clamp_min_engagement = 5;
// Clamp end: stop catches the clamp's rear end (rail as long as needed for
// the clamp; the lid's rear part hangs past it). Lid end: stop at lid edge.
Stop_at = "Clamp end";
// Chamfer on every station's front (entry) face. 0 = plain vertical fronts.
Lead_in = 0;
// Ledge rail under each clamp, flush with the station ledge top, running the
// full rail length: the clamp rides on it all the way in (cannot droop and
// miss the next station) and it ties the stations together.
Strip_width = 2.4;
// Fit coupon gap = max hook gap minus this (default 44 - 5 = 39 mm).
Fit_test_gap_margin = 5;
Max_mount_spacing = 200;
Mount_thickness = 5;
// Bore for the driver; must clear the screw head.
Driver_bore_diameter = 10;
Boss_wall = 1.2;
// Gap between the neighbour slot (its lid panel) and a step boss.
Step_clearance = 0.5;
// Kept clear around each piece (brim, skirt, wipe tower clearance).
Bed_margin = 5;
Socket_wall = 1.8;
Socket_cap = 2.4;
Layout_gap = 10;
// Hooks closer than this along Z are joined into one.
Min_hook_gap = 2;
$fn = 48;
eps = 0.01;
names = ["Small round","Medium round","Large round","Extra large round","Small rectangle","Medium rectangle","Large rectangle","Small square","Medium square","Large square"];
current = [4,3,2,0,4,2,2,0,2,0];
old2016 = [4,2,2,0,4,2,2,0,2,0];
old2015 = [0,0,2,0,3,1,2,4,2,1];
old2014 = [4,0,2,1,2,2,2,4,2,0];
custom = [Small_round_slots,Medium_round_slots,Large_round_slots,Extra_large_round_slots,Small_rectangle_slots,Medium_rectangle_slots,Large_rectangle_slots,Small_square_slots,Medium_square_slots,Large_square_slots];
// Hanging height below the clamp edge, for the preview only. Lids hang by
// their LONG side; rectangles' short side from catalog proportions.
lid_widths = [Small_round_lid_length,Medium_round_lid_length,Large_round_lid_length,Extra_large_round_lid_length,
  Small_rectangle_lid_length*4.75/6.75,Medium_rectangle_lid_length*4.75/6.75,Large_rectangle_lid_length*7.25/9,
  Small_square_lid_length,Medium_square_lid_length,Large_square_lid_length];
lid_clamps = [Small_round_clamp,Medium_round_clamp,Large_round_clamp,Extra_large_round_clamp,Small_rectangle_clamp,Medium_rectangle_clamp,Large_rectangle_clamp,Small_square_clamp,Medium_square_clamp,Large_square_clamp];
lid_lengths = [Small_round_lid_length,Medium_round_lid_length,Large_round_lid_length,Extra_large_round_lid_length,Small_rectangle_lid_length,Medium_rectangle_lid_length,Large_rectangle_lid_length,Small_square_lid_length,Medium_square_lid_length,Large_square_lid_length];
base_counts = Pack=="Plastic 38 current 1298037" ? current :
              Pack=="Plastic 38 2016-17 1044330" ? old2016 :
              Pack=="Plastic 34 2015 940442" ? old2015 :
              Pack=="Plastic 38 2014 819340 reported" ? old2014 : custom;
counts = [for (n = base_counts) n*Set_quantity];
cups = Pack=="Plastic 38 current 1298037" ? [1.2,2,4,0,3,5,8.5,0,5.5,0] :
       Pack=="Plastic 38 2016-17 1044330" ? [1.2,2,3.8,0,3,5,8.2,0,5.4,0] :
       Pack=="Plastic 34 2015 940442" ? [0,0,3.8,0,3,5,8.2,1.34,5.4,10.5] :
       Pack=="Plastic 38 2014 819340 reported" ? [1.34,0,3.8,7.5,3,5,8.2,1.2,5.4,0] :
       [for (i = [0:9]) 0];

p = Channel_pitch; d = Channel_depth;
Stop_top = 18;                            // lid-end stop: source Y 18..30 (ledge, slot)
Clamp_stop_y = [12, 26];                  // clamp-end stop: source Y range above ledge
Clamp_stop_x = [10.5, 18];                // ... and X range (slot X 5..10 stays open)
clamp_mode = Stop_at == "Clamp end";
sx = p/20; sy = d/30;
fit = Output == "Fit test";

// ---------- Derived mounting geometry ----------
cs_depth = (Screw_head_diameter - Screw_hole_diameter) / (2*tan(Countersink_angle/2));
boss_r = Driver_bore_diameter/2 + Boss_wall;
col_extra = max(0, 2*boss_r + 2*Step_clearance - 7*sx);   // screw column spacing (see Intermediate screws)
boss_overlap = Boss_wall;                 // tube wall fused into station wall
boss_off = boss_r - boss_overlap;         // tube centre beyond piece edge
sock_ri = boss_r + Joint_clearance;
sock_ro = sock_ri + Socket_wall;
sock_off = sock_ro - boss_overlap;        // socket centre beyond piece edge
sock_cut = -(boss_off - 0.4);             // socket opening plane (rel. centre)
sock_open_hw = sqrt(sock_ri*sock_ri - sock_cut*sock_cut);
joint_gap = boss_off + sock_off;          // edge-to-edge gap of joined pieces

// ---------- Helpers ----------
function sum(v, k=0) = k >= len(v) ? 0 : v[k] + sum(v, k+1);
function qsort_desc(v) = len(v) <= 1 ? v :
  let(pv = v[floor(len(v)/2)][0])
  concat(qsort_desc([for (e = v) if (e[0] > pv) e]),
         [for (e = v) if (e[0] == pv) e],
         qsort_desc([for (e = v) if (e[0] < pv) e]));
function reverse(v) = [for (k = [len(v)-1:-1:0]) v[k]];
function core_width(n) = (n + 0.25)*p;

// ---------- Channels and pieces ----------
// Fit test: front hook, fit_gap (max gap - Fit_test_gap_margin) of open
// space, then the stop hook.
chosen = [for (i = [0:9]) if (counts[i] > 0 && (Selection=="All sizes" || Selection==names[i])) i];
// Shortest clamp hook in the selection: caps the open gap between hooks.
min_clamp = min([for (i = chosen) lid_clamps[i]]);
max_gap = min_clamp - 2*Clamp_min_engagement;
fit_gap = max_gap - Fit_test_gap_margin;
// Each lid only has to bridge the gaps along its own channel: its own clamp
// sets its limit, so a short clamp doesn't add hooks behind its stop.
function gap_max(c) = c[2] - 2*Clamp_min_engagement;
// The coupon's front hook is long enough for the whole clamp to sit on the coupon.
fit_front = max(Station_length, 2*Clamp_min_engagement + Fit_test_gap_margin - Station_length);
fit_rail = fit_front + fit_gap + Station_length + Stop_thickness;
// Channel record [lid length L, size index, clamp length C]. Sorted by stop
// depth (deepest left), ties by lid length, so the rear edge is a staircase.
function stop_key(c) = Stop_thickness + (clamp_mode ? (c[0] + c[2])/2 : c[0]) - Front_overhang;
function qsort_stop(v) = len(v) <= 1 ? v :
  let(pv = v[floor(len(v)/2)])
  concat(qsort_stop([for (e = v) if (gt(e, pv)) e]), [for (e = v) if (!gt(e, pv) && !gt(pv, e)) e],
         qsort_stop([for (e = v) if (gt(pv, e)) e]));
function gt(a, b) = stop_key(a) > stop_key(b) + 1e-9 || (abs(stop_key(a) - stop_key(b)) <= 1e-9 &&
  (a[0] > b[0] || (a[0] == b[0] && a[1] < b[1])));
fit_C = min_clamp;
channels = fit ? [for (k = [0:Fit_test_channels-1]) [2*(fit_rail - Stop_thickness + Front_overhang) - fit_C, chosen[0], fit_C]] :
  qsort_stop([for (i = chosen) for (c = [1:(Copies=="One per size" ? 1 : counts[i])]) [lid_lengths[i], i, lid_clamps[i]]]);
n_ch = len(channels);
edge_ext = sock_ro + sock_off;            // worst-case overhang past an edge
// Usable bed [x, y] (mm). H2D: 350x320 single nozzle, 325x320 both nozzles.
bed = Printer == "Bambu H2D single nozzle" ? [350, 320] :
      Printer == "Bambu H2D both nozzles" ? [325, 320] :
      Printer == "Bambu X1/P1/A1" ? [256, 256] :
      Printer == "Bambu A1 mini" ? [180, 180] :
      Printer == "Prusa MK4/MK4S" ? [250, 210] :
      Printer == "Prusa Core One" ? [250, 220] :
      Printer == "Prusa XL" ? [360, 360] :
      Printer == "Creality K1 Max" ? [300, 300] : [Custom_bed_x, Custom_bed_y];
bed_long = max(bed) - 2*Bed_margin;
bed_short = min(bed) - 2*Bed_margin;
// Longest footprint along Z (longest rail + socket overhang).
max_piece_depth = rail(channels[0]) + sock_ro;
// Piece width on the long bed axis if its depth fits the short one, else swap.
max_print_width = max_piece_depth <= bed_short ? bed_long : bed_short;
max_print_depth = max_piece_depth <= bed_short ? bed_short : bed_long;
// Reserve one screw column per Channels_per_screw lids (weight-driven extra
// columns are caught by the bed-fit assert).
function fits_bed(n) = core_width(n) + (ceil(n / Channels_per_screw) - 1)*col_extra + 2*edge_ext <= max_print_width;
function max_fit(n = 1) = fits_bed(n + 1) && n < 200 ? max_fit(n + 1) : n;
per_piece_max = max_fit();
// A gap may also carry at most the weight of Channels_per_screw average lids,
// so runs of heavy lids get extra screws (see inner_screws).
gap_w_max = Channels_per_screw * sum([for (c = channels) ch_w(c)]) / n_ch;
function split(pp) = let(np = ceil(n_ch/pp), per = ceil(n_ch/np))
  [for (k = [0:np-1]) [for (j = [k*per:min(n_ch, (k+1)*per)-1]) channels[j]]];
function core_w(pc) = core_width(len(pc)) + len(cols(pc))*col_extra;
// Fewer lids per piece until every piece (with its screw columns) fits.
function fit_split(pp) = let(ps = split(pp))
  pp <= 1 || max([for (pc = ps) core_w(pc)]) + 2*edge_ext <= max_print_width ? ps : fit_split(pp - 1);
pieces = fit_split(per_piece_max);
n_pieces = len(pieces);

// ---------- Rails and stations, shared by all pieces ----------
// Z = 0 is the FRONT (user side); every lid's front edge sits on that line
// (minus Front_overhang). The clamp hook (length C) is centred on
// the lid's long side. Each channel's rail ends at its stop: behind the
// clamp's rear end (Clamp end) or the lid's rear edge (Lid end). Channels are
// sorted by stop depth, deepest first, so the REAR edge steps down left to right.
// Hooks (stations) are placed so that a lid AT REST sits with both clamp
// ends on a hook: the clamp's front end lies on a hook for Station_length,
// and its rear end runs Station_length over the stop hook up to the stop.
// So the clamp is centred between its two hooks and neither end hangs.
// A station spans only channels whose rail reaches it: nothing is ever
// built behind a channel's stop. Hooks closer than min_step merge into one
// longer, stepped hook (each channel still ends at its own stop). Fill
// hooks keep every clear gap <= gap_lim (shortest clamp riding past it) and screws within Max_mount_spacing.
// Partial stations are screwed at the step through a full-height boss set in
// the shorter neighbour channel, right of its slot (that lid's panel hangs in
// the slot), and bridged to the station at roof level over the panel.
min_step = 2*sock_ro + 1;
// Screw rows only need that spacing where joint sockets may sit (multi-piece
// racks); on a single piece two tubes just must not touch.
min_screw_step = n_pieces > 1 ? min_step : 2*boss_r + 1;
function dedup(v) = [for (k = [0:len(v)-1]) if (k == 0 || v[k] != v[k-1]) v[k]];
// stop_z: rear face of the stop wall. Station_length of hook sits in front
// of it (under the clamp's rear end); Stop_tail behind it (default 0).
// rail: end of the channel's material (= stop_z + Stop_tail).
// All take a channel record c = [L, size, C].
function stop_z(c) = stop_key(c);
function rail(c) = stop_z(c) + Stop_tail;
function reach(c) = max(rail(c), c[0] - Front_overhang);          // lid rear end
// Clamp hook span along Z: centred on the lid's long side.
function clamp_span(c) = [(c[0] - c[2])/2, (c[0] + c[2])/2] - [1, 1]*Front_overhang;
function qsort_lo(v) = len(v) <= 1 ? v :
  let(pv = v[floor(len(v)/2)][0])
  concat(qsort_lo([for (e = v) if (e[0] < pv) e]), [for (e = v) if (e[0] == pv) e],
         qsort_lo([for (e = v) if (e[0] > pv) e]));
SL = Station_length;
// Required hook coverage [lo, hi] per lid size: clamp front end, clamp rear
// end (lid-end mode: it is not at the stop) and the stop hook.
// Third element: stop depth of the shallowest lid needing it (deeper
// channels pass through).
// Fourth: end of the hook body for channels passing through (the part
// behind a stop wall belongs only to the channels that stop there).
sizes = dedup([for (c = channels) [c[0], c[2]]]);
function ch_of(key) = [key[0], 0, key[1]];
// Entrance hook under the front end of the earliest clamp, plus each size's
// clamp-rear and stop hooks.
// It sits as far back as every clamp allows (ending Clamp_min_engagement past
// the latest clamp front, starting that much before the earliest clamp rear),
// so it carries every size's clamp front and no extra front hooks are needed.
cf_min = min([for (key = sizes) max(0, clamp_span(ch_of(key))[0])]);
cf_max = max([for (key = sizes) max(0, clamp_span(ch_of(key))[0])]);
cr_min = min([for (key = sizes) clamp_span(ch_of(key))[1]]);
cf_z = let(z = cf_max + Clamp_min_engagement - SL) z > cf_min && z <= cr_min - Clamp_min_engagement - SL ? z : cf_min;
base_reqs = concat([[cf_z, cf_z + SL, 0, cf_z + SL, []]],
  [for (key = sizes) let(ch = ch_of(key), cs = clamp_span(ch), cf = max(0, cs[0]), r = stop_z(ch))
    each [[max(cf, cs[1] - SL), cs[1], r, cs[1], [key]], [max(cf, r - Stop_thickness - SL), r + Stop_tail, r, r, [key]]]]);
all_rails = [for (c = channels) rail(c)];
// Clear-gap limit for a gap ending at z: the shortest clamp among the
// channels that ride past it.
function gap_lim(z) = fit ? max_gap : min(concat([1e9], [for (c = channels) if (rail(c) > z + eps) gap_max(c)]));
// Spanning threshold of a station [z0, z1]: channels whose rail ends inside it
// still own the part in front of their stop, so the common part (screws)
// runs from z0 to the first rail inside, or to z1.
function thr_of(z0, z1) = min(concat([z1], [for (r = all_rails) if (r > z0 + eps) r]));
// Overlapping requirements (or ones closer than Min_hook_gap, which would
// leave an unprintable slit) become one hook segment [a, b].
function union_iv(v, k=1, cur=undef) = let(c = cur == undef ? v[0] : cur)
  k >= len(v) ? [c] :
  v[k][0] < c[1] + Min_hook_gap ? union_iv(v, k+1, [c[0], max(c[1], v[k][1]), min(c[2], v[k][2]), max(c[3], v[k][3]), concat(c[4], v[k][4])]) : concat([c], union_iv(v, k+1, v[k]));
// Station record: [z0, z1, threshold, full, [[z0, z1, Lmin]], screwed].
// FULL stations (the first one, every stop hook, gap fills) span every
// channel whose rail passes z0; the clamp-end hooks of longer lids span only
// those lids (and deeper channels) and are tied to the nearest screwed
// station by a roof-level web.
function st_zc(st) = (st[0] + min(st[4][0][3], st[2]))/2;
// keys: [L, C] of the lid sizes a narrow hook serves.
function mk(z0, z1, full, Lmin, body = undef, keys = []) = [z0, z1, thr_of(z0, z1), full, [[z0, z1, Lmin, body == undef ? z1 : body, keys]], false];
function seg_sts_of(sa) = [for (k = [0:len(sa)-1]) let(g = sa[k],
  full = k == 0 || len([for (r = all_rails) if (r > g[0] + eps && r <= g[1] + eps) 1]) > 0) mk(g[0], g[1], full, g[2], g[3], g[4])];
// Extra FULL stations so the clear gap between full stations (which every
// passing channel rides on) stays within gap_lim and their spacing within
// Max_mount_spacing. Fills are spread so all clear gaps are equal.
function fills(lo, hi, m) = let(g = (hi - lo - (m-1)*SL)/m)
  [for (j = [1:1:m-1]) let(z0 = lo + j*g + (j-1)*SL) mk(z0, z0 + SL, true, 0)];
function fill_ok(s0, s1, f) = let(v = concat([s0], f, [s1]))
  len([for (j = [1:len(v)-1]) if (st_zc(v[j]) - st_zc(v[j-1]) > Max_mount_spacing + eps) 1]) == 0;
function fill_m(s0, s1, m) = fill_ok(s0, s1, fills(s0[4][0][3], s1[0], m)) ? m : fill_m(s0, s1, m+1);
function fill(v, k=0) = k >= len(v)-1 ? [v[len(v)-1]] :
  let(lo = v[k][4][0][3], hi = v[k+1][0],   // passing channels ride to the body end
      m = fill_m(v[k], v[k+1], max(1, ceil((hi - lo + SL)/(gap_lim(hi) + SL)))))
  concat([v[k]], fills(lo, hi, m), fill(v, k+1));
// A fill landing on a narrow hook would overlap it: promote that hook to a
// full station instead and recompute the fills.
function hits(p, fs) = len([for (q = fs) if (p[0] < q[1] + eps && p[1] > q[0] - eps) 1]) > 0;
function solve(fv, pv) = let(fs = fill(sort_z(fv)), bad = [for (q = pv) if (hits(q, fs)) q])
  len(bad) == 0 ? [fs, pv] :
  solve(concat(fv, [for (q = bad) mk(q[0], q[1], true, 0, q[4][0][3])]), [for (q = pv) if (!hits(q, fs)) q]);
// Screw rows: greedily on full stations, at least min_screw_step apart, and never
// where a step boss would sit on a shorter lid's clamp/stop.
function boss_ok(st) = len([for (r = all_rails) if (r > st_zc(st) - boss_r - 0.5 && r <= st[0] + eps) 1]) == 0;
function pick(v, k=0, last=undef) = k >= len(v) ? [] :
  let(ok = boss_ok(v[k]) && (last == undef || st_zc(v[k]) - last >= min_screw_step - eps),
      st = [v[k][0], v[k][1], v[k][2], v[k][3], v[k][4], ok])
  concat([st], pick(v, k+1, ok ? st_zc(v[k]) : last));
function sort_z(v) = len(v) <= 1 ? v :
  let(pv = v[floor(len(v)/2)][0])
  concat(sort_z([for (e = v) if (e[0] < pv) e]), [for (e = v) if (e[0] == pv) e], sort_z([for (e = v) if (e[0] > pv) e]));
// Hooks, fills and screw rows from a requirement list.
function build(rq) = let(ss = seg_sts_of(union_iv(qsort_lo(rq))),
  sv = solve([for (st = ss) if (st[3]) st], [for (st = ss) if (!st[3]) st]))
  sort_z(concat(pick(sv[0]), sv[1]));
stations0 = build(fit ? [[0, fit_front, 0, fit_front, []], [fit_rail - Stop_thickness - SL, fit_rail + Stop_tail, 0, fit_rail, []]] : base_reqs);
// A size gets its own clamp-front hook only if, at rest, its clamp would not
// otherwise sit on another hook (entrance, a shallower stop hook or a gap
// fill) by at least Clamp_min_engagement besides its own stop hook.
function second_hook(key) = let(ch = ch_of(key), cs = clamp_span(ch), r = rail(ch))
  len([for (st = stations0) if (st[3] && r > st[0] + eps && !(r <= st[1] + eps) &&
        min(st[4][0][3], cs[1]) - max(st[0], cs[0]) >= Clamp_min_engagement - eps) 1]) > 0;
extra_reqs = fit ? [] : [for (key = sizes) if (!second_hook(key)) let(cf = max(0, clamp_span(ch_of(key))[0]))
  [cf, cf + SL, stop_z(ch_of(key)), cf + SL, [key]]];
reqs = concat(base_reqs, extra_reqs);
stations1 = len(extra_reqs) == 0 ? stations0 : build(reqs);
// Screwed hooks are made at least one boss diameter long, so every screw tube
// (cut flush with the hook faces at a column) keeps a Boss_wall in front of
// and behind its driver bore. They grow forward, never into the previous
// hook. Only the pillars that hold a screw are built that long (see
// hook_relief); the rest of the hook keeps its own front, hz0, which is what
// the clamp rides on and what every gap rule measures.
function lengthen(v, k = 0, prev_end = -1e9) = k >= len(v) ? [] :
  let(st = v[k], e = min(st[4][0][3], st[2]),
      z0 = st[5] && !fit && e - st[0] < 2*boss_r ? max(0, prev_end, e - 2*boss_r) : st[0],
      n = [z0, st[1], st[2], st[3], [[z0, st[4][0][1], st[4][0][2], st[4][0][3], st[4][0][4], st[0]]], st[5]])
  concat([n], lengthen(v, k + 1, st[1]));
stations = lengthen(stations1);
// Front of a hook's body (its front before lengthen).
function hz0(st) = len(st[4][0]) > 5 ? st[4][0][5] : st[0];
mount_sts = [for (st = stations) if (st[5]) st];
// Channels (from the left) spanned by a station.
// Channel k is on station st: full stations take every channel whose rail
// passes z0; narrow (clamp-front) hooks only the lid sizes they serve.
function member(pc, st, k) = rail(pc[k]) > st[0] + eps && (len(st) < 7 || k >= st[6]) &&
  (st[3] || len([for (key = st[4][0][4]) if (key == [pc[k][0], pc[k][2]]) 1]) > 0);
function span(pc, st) = st[3] ? nspan(pc, st[0]) : len([for (k = [0:len(pc)-1]) if (member(pc, st, k)) 1]);
// Channels (from the left) whose rail runs past z.
function nspan(pc, z) = len([for (c = pc) if (rail(c) > z + eps) 1]);
// Channels spanned by segment i of station st.
function seg_n(pc, st, i) = span(pc, st);
// Rear end of channel k's part of station st (never past its stop).
function seg_end(pc, st, k) = let(r = rail(pc[k]))
  r > st[0] + eps && r <= st[1] + eps ? r : min(st[4][0][3], r);
// A piece only needs stations that start in front of its deepest stop.
function piece_stations(pc) = [for (st = stations) if (span(pc, st) > 0) st];
function piece_mounts(pc) = [for (st = piece_stations(pc)) if (st[5]) st];
// Left trim (single-piece racks): a full hook's lids left of a screw column
// that don't need it are dropped, and the column screw ends the hook (like
// any end tube). A lid needs hook st if it holds its stop, if dropping it
// would leave a clear gap > trim_gap between that lid's hooks, or if the clamp
// at rest would no longer rest on a hook besides its stop hook. Decided back
// to front (rear hooks first): each check uses the hooks kept so far behind
// and all in front.
// Largest clear gap a lid may be left with after a trim: 2/3 of its clamp
// (at least the set's max_gap, at most its own clamp's limit). Long lids then
// keep a middle hook: 102 mm under a 117 mm clamp (Newer large rectangles)
// and 75 mm under a 108 mm one (Older medium rectangles) were too wide;
// 52 mm under an 82 mm clamp was fine.
function trim_gap(c) = min(gap_max(c), max(max_gap, 2*c[2]/3));
function needs(pc, sts, i, k) = let(st = sts[i], r = rail(pc[k]), cs = clamp_span(pc[k]),
    others = [for (j = [0:len(sts)-1]) if (j != i && member(pc, sts[j], k)) [hz0(sts[j]), seg_end(pc, sts[j], k)]],
    prv = max(concat([-1e9], [for (o = others) if (o[1] <= st[0] + eps) o[1]])),
    nxt = min(concat([1e9], [for (o = others) if (o[0] >= st[1] - eps) o[0]])),
    held = [for (o = others) if (!(o[0] <= cs[1] - SL + eps && o[1] >= cs[1] - eps))
            if (min(o[1], cs[1]) - max(o[0], cs[0]) >= Clamp_min_engagement - eps) 1])
  r <= st[1] + eps || (prv > -1e8 && nxt < 1e8 && nxt - prv > trim_gap(pc[k]) + eps) || len(held) == 0;
function trims(pc, sts, i = undef) = let(i0 = i == undef ? len(sts) - 1 : i) i0 < 0 ? [for (st = sts) len(st) > 6 ? st[6] : 0] :
  let(st = sts[i0],
      cand = i0 == 0 || !st[3] || n_pieces > 1 || fit ? 0 :
        max(concat([0], [for (b = cols(pc)) if (b < span(pc, st) && len([for (k = [0:b-1]) if (needs(pc, sts, i0, k)) 1]) == 0) b])),
      // hooks in front see this one only over the lids it keeps
      sts2 = [for (j = [0:len(sts)-1]) j == i0 ? concat([for (q = [0:5]) st[q]], [cand]) : sts[j]])
  trims(pc, sts2, i0 - 1);
function trim_of(pc, st) = let(sts = piece_stations(pc), t = trims(pc, sts),
    m = [for (j = [0:len(sts)-1]) if (abs(sts[j][0] - st[0]) < eps && abs(sts[j][1] - st[1]) < eps) t[j]]) len(m) ? m[0] : 0;
// Channel k on hook st, after the left trim.
function kept(pc, st, k) = member(pc, st, k) && k >= trim_of(pc, st);
// Nearest screwed station of the piece (by centre) for an unscrewed one.
function anchor(pc, st) = let(m = piece_mounts(pc), dz = [for (b = m) abs(st_zc(b) - st_zc(st))], best = min(dz))
  [for (j = [0:len(m)-1]) if (dz[j] == best) m[j]][0];
function piece_length(pc) = max([for (st = piece_stations(pc)) for (k = [0:len(pc)-1]) if (kept(pc, st, k)) seg_end(pc, st, k)]);

// ---------- Checks ----------
assert(len(chosen) > 0, "No nonzero slots selected");
assert(Set_quantity >= 1 && Set_quantity == floor(Set_quantity));
assert(Screw_head_diameter > Screw_hole_diameter);
assert(Driver_bore_diameter >= Screw_head_diameter + 1, "Driver bore must clear screw head");
assert(cs_depth <= Mount_thickness - 1.5, "Countersink leaves insufficient seat");
assert(sock_open_hw < boss_r - 0.5, "Socket opening would not capture the boss");
assert(max_gap >= 10, "Shortest clamp too short for the minimum engagement");
// Step boss sits right of the shorter neighbour's slot and inside its cell.
step_off = boss_off;   // step bosses sit like edge bosses, against the last pillar
assert(step_off + boss_r <= 13*sx + eps, "Step boss reaches past the shorter lid's cavity: raise Channel_pitch or shrink the boss");
assert(Mount_thickness <= 10*sy - 1, "Step boss bridge would reach into the neighbour lid space");
// Intermediate screws: the same boss as the piece edges (tube, seat at the
// shelf end, driver bore from the open side). The 7*sx divider is too thin
// for it, so the piece is split into channel groups at each screw column and
// the groups are spaced col_extra apart: the tube then sits between the last
// lid's clamp cavity and the next group's slot, clear of both by
// Step_clearance, and is trimmed to each hook's length.
// Relative lid weight ~ lid area.
function ch_w(c) = c[0] * lid_widths[c[1]];
function cum_w(pc, n) = [for (b = [0:n]) b == 0 ? 0 : sum([for (k = [0:b-1]) ch_w(pc[k])])];
function nearest_b(cw, t, b = 0, best = 0) = b >= len(cw) ? best :
  nearest_b(cw, t, b + 1, abs(cw[b] - t) < abs(cw[best] - t) ? b : best);
// Divider positions b (screw between channels b-1 and b) for a crossbar over
// channels 0..n-1 screwed at both ends: ceil(n / Channels_per_screw) - 1 of
// them (more if heavy, see gap_w_max) at the equal-weight points, nudged so
// no gap exceeds Channels_per_screw.
function inner_screws(pc, n) = let(cw = cum_w(pc, n)) n <= 1 ? [] :
  inner_fit(cw, n, ceil(n / Channels_per_screw));
// Smallest screw count m whose equal-weight placement keeps every gap of
// two or more lids within gap_w_max.
function inner_fit(cw, n, m) = let(bs = m <= 1 ? [] : inner_rec(cw, n, m, Channels_per_screw, 1, 0),
    bd = concat([0], bs, [n]),
    ok = len([for (j = [1:len(bd)-1]) if (bd[j] - bd[j-1] > 1 && cw[bd[j]] - cw[bd[j-1]] > gap_w_max + eps) 1]) == 0)
  ok || m >= n ? bs : inner_fit(cw, n, m + 1);
function inner_rec(cw, n, m, C, i, prev) = i >= m ? [] :
  let(t = nearest_b(cw, i*cw[n]/m),
      b = min(n - (m - i), max(prev + 1, n - (m - i)*C, min(prev + C, t))))
  concat([b], inner_rec(cw, n, m, C, i + 1, b));
for (pc = pieces) assert(piece_length(pc) + sock_ro <= max_print_depth + eps, str("Longest rail (", max_piece_depth, " mm) does not fit the ", Printer, " bed"));

// ---------- 2D profile ----------
source_outline=[[7.0, 5.0], [10.41209, 5.0], [10.89593, 5.05941], [11.35103, 5.2341], [11.75035, 5.51371], [12.07017, 5.88161], [12.29148, 6.31596], [17.87938, 21.66861], [18.0, 22.35265], [18.0, 24.0], [17.93185, 24.51764], [17.73205, 25.0], [17.41421, 25.41421], [17.0, 25.73205], [16.51764, 25.93185], [16.0, 26.0], [10.5, 26.0], [10.0, 26.5], [10.0, 29.5], [10.5, 30.0], [20.17157, 30.0], [20.68921, 29.93185], [21.17157, 29.73205], [21.58579, 29.41421], [24.41421, 26.58579], [24.73205, 26.17157], [24.93185, 25.68921], [25.0, 25.17157], [25.0, 1.0], [4.23607, 1.0], [3.6099, 0.93393], [3.01132, 0.73861], [2.46669, 0.42267], [2.0, 0.0], [0.0, -0.0], [0.0, 29.0], [1.0, 30.0], [4.0, 30.0], [5.0, 29.0], [5.0, 7.0], [5.06815, 6.48236], [5.26795, 6.0], [5.58579, 5.58579], [6.0, 5.26795], [6.48236, 5.06815]];
// Lightening voids of a pillar (source coords): the pillar is a hollow box.
// Main void: Void_wall from the slanted cavity wall and from the next slot's
// face, from the roof down to Y 19. Foot pocket below it (X >= 20.3, right of
// the column foot stretch), Void_wall from the bed and the bottom chamfer.
// Both are bridged when printed (roof up): ~9.5 mm and ~3 mm.
vw = Void_wall / sx;
assert(Void_wall >= 1.2 - eps && vw <= 2.2, "Void_wall must be 1.2 .. 2.2*Channel_pitch/20");
void_m = (17.87938 - 12.29148)/(21.66861 - 6.31596);   // cavity wall slope dx/dy
// The main void's top is the thinned roof line itself, so whatever is built
// from this shape (the column tube's fill) reaches the roof.
module source_void_shapes() {
  x0 = 12.29148 + vw*sqrt(1 + void_m*void_m); xr = 25 - vw; yb = 19; yt = min(5, Roof_thickness/sy);
  polygon([[x0, yt], [xr, yt], [xr, yb], [x0 + (yb - 6.31596)*void_m, yb], [x0, 6.31596]]);
  intersection() {
    translate([20.3, yb + vw]) square([xr - 20.3, 30 - 2*vw - yb]);
    polygon([[0, 0], [51 - vw*sqrt(2), 0], [0, 51 - vw*sqrt(2)]]);   // bottom chamfer is x + y = 51
  }
}
module source_cell() difference() { polygon(source_outline); source_void_shapes(); }
// Roof thinning (source coords): the cavity and void tops (Y 5) raised to
// the Roof_thickness line, within the cell's X 0..25.
roof_s = Roof_thickness / sy;
assert(Roof_thickness >= 1.2 && roof_s <= 5 + eps, "Roof_thickness must be 1.2 .. 5*Channel_depth/30");
// Left of the slanted wall's fillet (X 10.41209) the tops move straight up;
// the fillet itself slides up along the slanted wall's own line, so that wall
// stays one straight face up to the roof (no step where the cut ends).
module roof_cut() if (roof_s < 5 - eps) intersection() {
  translate([0, roof_s]) square([25, 8 - roof_s]);   // covers the rounded cavity corners (to Y 7)
  union() {
    minkowski() {
      union() { intersection() { source_air(); translate([-1, 0]) square([11.41209, 40]); } source_void_shapes(); }
      translate([0, -(5 - roof_s)]) square([0.01, 5 - roof_s]);
    }
    minkowski() {
      intersection() { source_air(); translate([10.41209, 0]) square([8, 40]); }
      polygon([[-0.01, 0], [0, 0], [-dr*void_m, -dr], [-dr*void_m - 0.01, -dr]]);
    }
  }
  dr = 5 - roof_s;
}
module source_air() difference() { translate([-1, 1.5]) square([27, 40]); polygon(source_outline); }
module channel_section(n) difference() {
  union() {
    for (k = [0:n-1]) translate([k*p, 0]) scale([sx, sy]) intersection() {
      source_cell();
      // Shared divider belongs to the preceding cell.
      translate([k == 0 ? 0 : 5, 0]) square([k == 0 ? 25 : 20, 30]);
    }
    square([core_width(n), 5*sy]);         // flat roof against the shelf
  }
  for (k = [0:n-1]) translate([k*p, 0]) scale([sx, sy]) intersection() {
    roof_cut();
    translate([k == 0 ? 0 : 5, -1]) square([k == 0 ? 25 : 20, 32]);
  }
}
// Lid space of each channel (used for lead-in chamfers).
module cavity(n) difference() {
  intersection() {
    difference() { translate([-1, -1]) square([core_width(n)+2, d+2]); channel_section(n); }
    for (k = [0:n-1]) translate([k*p + 5*sx, 0]) square([13*sx, d + 1]);
  }
  // The pillar voids reach left of X 18: they are not lid space.
  for (k = [0:n-1]) translate([k*p, 0]) scale([sx, sy]) offset(delta = 0.02) source_void_shapes();
}

// ---------- 3D parts (mounted coordinates) ----------
// Station over channels 0..n-1 from z0 to z1; lead-in on its front (z0) face.
// stops: list of [channel index, stop depth] (stop occupies depth-Stop..depth).
module station(n, z0, z1, stops) {
  difference() {
    translate([0, 0, z0]) linear_extrude(height = z1 - z0, convexity = 12) channel_section(n);
    steps = 3;
    if (Lead_in > 0) for (s = [1:steps])
      translate([0, 0, z0 + (s-1)*Lead_in/steps - eps])
        linear_extrude(height = Lead_in/steps + eps, convexity = 12)
          offset(delta = Lead_in*(steps - s + 1)/steps) cavity(n);
  }
  // Stop plugs the slot and lower cavity (the lid panel must pass there);
  // the roof-side cavity stays open to save material.
  // Clamp-end stop blocks only the clamp above the ledge (the lid panel's
  // rear part passes on through the open slot); lid-end stop plugs the slot.
  for (sk = stops) translate([0, 0, sk[1] - Stop_thickness])
    linear_extrude(height = Stop_thickness, convexity = 12) intersection() {
      cavity(n);
      if (clamp_mode)
        translate([sk[0]*p + Clamp_stop_x[0]*sx, Clamp_stop_y[0]*sy])
          square([(Clamp_stop_x[1] - Clamp_stop_x[0])*sx, (Clamp_stop_y[1] - Clamp_stop_y[0])*sy + eps]);
      else translate([sk[0]*p + 2*sx, Stop_top*sy]) square([p, d - Stop_top*sy]);
    }
}
// Group [k, end] pairs (k ascending) into runs [k0, k1, end] of consecutive
// channels with the same end.
function runs(v, i=1, cur=undef) = len(v) == 0 ? [] : let(c = cur == undef ? [v[0][0], v[0][0], v[0][1]] : cur)
  i >= len(v) ? [c] :
  (v[i][0] == c[1] + 1 && abs(v[i][1] - c[2]) < eps) ? runs(v, i+1, [c[0], v[i][0], c[2]])
                                                      : concat([c], runs(v, i+1, [v[i][0], v[i][0], v[i][1]]));
// Station over channels k0..n-1 only (k0 > 0 keeps the shared wall on its left).
module station_range(k0, n, z0, z1, stops) intersection() {
  station(n, z0, z1, stops);
  if (k0 > 0) translate([k0*p, -1, z0 - 1]) cube([(n - k0 + 1)*p, d + 2, z1 - z0 + 2]);
  else translate([-1, -1, z0 - 1]) cube([(n + 1)*p, d + 2, z1 - z0 + 2]);
}
function qsort_desc_v(v) = len(v) <= 1 ? v : let(pv = v[floor(len(v)/2)])
  concat(qsort_desc_v([for (e = v) if (e > pv) e]), [for (e = v) if (e == pv) e], qsort_desc_v([for (e = v) if (e < pv) e]));
// Ledge rails: one per channel, a continuous strip of the hooks' ledge: its
// slot-side face is flush with the ledge edge (source X 10, set back only by
// Lead_in if a chamfer is used), from the bed up to the ledge top (source
// Y 26), running from the first hook to that channel's stop.
ledge_top = 26*sy;
rail_x = 10*sx + Lead_in + Strip_width/2;
module strips(pc) let(z0 = hz0(piece_stations(pc)[0])) for (k = [0:len(pc)-1])
  translate([k*p + rail_x - Strip_width/2, ledge_top, z0]) cube([Strip_width, d - ledge_top, stop_z(pc[k]) - z0]);
// Vertical screw boss; top = Y of its shelf-side face (Socket_cap for a male joint boss).
module boss_solid(top) translate([0, top, 0]) rotate([-90, 0, 0]) cylinder(r = boss_r, h = d - top);
module boss_hole(top) {
  translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = Screw_hole_diameter, h = top + Mount_thickness + 2);
  translate([0, top + Mount_thickness - cs_depth, 0]) rotate([-90, 0, 0])
    cylinder(d1 = Screw_hole_diameter, d2 = Screw_head_diameter, h = cs_depth + eps);
  translate([0, top + Mount_thickness, 0]) rotate([-90, 0, 0]) cylinder(d = Driver_bore_diameter, h = d);
}
// Step boss (origin on the station's right edge): the same complete,
// full-height tube as a piece edge, against the last pillar. It stands in the
// shorter neighbour's channel, behind that lid's stop (boss_ok).
module step_boss() translate([step_off, 0, 0]) boss_solid(0);
// Socket wrapping the neighbour's male boss; opening faces -X; cap sits between
// the male boss and the shelf so one screw clamps both pieces.
module socket_solid() difference() {
  rotate([-90, 0, 0]) cylinder(r = sock_ro, h = d);
  translate([0, Socket_cap, 0]) rotate([-90, 0, 0]) cylinder(r = sock_ri, h = d);
  translate([0, -1, 0]) rotate([-90, 0, 0]) cylinder(d = Screw_hole_diameter, h = Socket_cap + 2);
  translate([sock_cut - 2*sock_ro, -1, -2*sock_ro]) cube([2*sock_ro, d + 2, 4*sock_ro]);
}

// left: "boss" | "socket" | "none"; right: "boss" | "step" (step bosses
// only, for a group inside a piece) | "none".
// Each station spans the channels whose rail reaches it; a partial station
// has a step boss at its step, a full-width one a boss at the piece edge.
// nxt: the piece joined on the right ([] if none); full-width stations it
// shares get male (joint) bosses.
function is_male(pc, st, nxt) = span(pc, st) == len(pc) && span(nxt, st) > 0;
function station_stops(pc, st) = !st[3] ? [] :
  [for (k = [0:len(pc)-1]) let(r = rail(pc[k])) if (r > st[0] + eps && r <= st[1] + eps) [k, stop_z(pc[k]), r]];
// Part of a pillar kept one tube long where it holds a screw (source coords,
// pillar after channel i at X i*p; i = -1 is the piece's left wall). Its left
// edge runs through the cavity's air 1 mm off the slanted wall, from the
// roof down, and cuts the ledge at X 17; the right edge stops at the next
// slot's roof fillet, so no roof overhangs.
pillar_keep = [[7.18, -5], [16.88, 21.67], [17, 24], [17, 40], [26.8, 40], [26.8, -5]];
// Cut that shortens screwed hook f (over n channels) to its body front hz0,
// except at the pillars in longs. Two long pillars in a row keep the cell
// between them (no notch in a one-lid hook).
module hook_relief(n, f, longs) translate([0, 0, f[0] - eps])
  linear_extrude(height = hz0(f) - f[0] + eps, convexity = 12) difference() {
    translate([-1, -1]) square([core_width(n) + 2, d + 2]);
    for (i = longs) translate([i*p, 0]) scale([sx, sy]) {
      polygon(pillar_keep);
      if (len([for (j = longs) if (j == i + 1) 1]) > 0) translate([26, -5]) square([12, 45]);
    }
  }
// lcol / rcol: the group has a screw column on its left / right.
module piece_core(pc, left, right, nxt, skip = [], lcol = false, rcol = false) {
  // Pillars of screwed hook f that hold a screw tube (or a joint socket).
  function longs(f) = let(sp = span(pc, f)) concat(
    (left != "none" || lcol) && member(pc, f, 0) ? [-1] : [],
    right != "none" && (sp < len(pc) || right == "boss") ? [sp - 1] : [],
    rcol && member(pc, f, len(pc) - 1) ? [len(pc) - 1] : []);
  function live(f) = len([for (z = skip) if (abs(z - f[0]) < eps) 1]) == 0;
  fs = [for (f = piece_stations(pc)) if (live(f)) f];
  ms = [for (f = piece_mounts(pc)) if (live(f)) f];
  function male(f) = is_male(pc, f, nxt);
  difference() {
    union() {
      for (f = fs) let(rs = runs([for (k = [0:len(pc)-1]) if (member(pc, f, k)) [k, seg_end(pc, f, k)]])) {
        difference() {
          for (r = rs) station_range(r[0], r[1] + 1, f[0], r[2],
                                     [for (sk = station_stops(pc, f)) if (sk[0] >= r[0] && sk[0] <= r[1] && abs(sk[2] - r[2]) < eps) sk]);
          if (f[5] && hz0(f) > f[0] + eps) hook_relief(len(pc), f, longs(f));
        }
        // Unscrewed station: roof-level web to the nearest screwed one, only
        // over channels on both (so never behind a stop).
        if (!f[5]) let(b = anchor(pc, f), a = b[0] < f[0] ? min(b[1], b[2]) : f[1], z = b[0] < f[0] ? f[0] : hz0(b))
          if (z > a && live(b)) for (k = [0:len(pc)-1]) if (member(pc, f, k) && member(pc, b, k))
            translate([k*p, 0, a - eps]) cube([p + 5*sx, Roof_thickness, z - a + 2*eps]);
      }
      strips(pc);
      for (f = ms) translate([0, 0, st_zc(f)]) {
        if (left == "boss") translate([-boss_off, 0, 0]) boss_solid(0);
        if (left == "socket") translate([-sock_off, 0, 0]) socket_solid();
        if (right != "none") translate([core_width(span(pc, f)), 0, 0])
          if (span(pc, f) < len(pc)) step_boss();
          else if (right == "boss") translate([boss_off, 0, 0]) boss_solid(male(f) ? Socket_cap : 0);
      }
    }
    for (f = ms) translate([0, 0, st_zc(f)]) {
      if (left == "boss") translate([-boss_off, 0, 0]) boss_hole(0);
      if (span(pc, f) < len(pc) ? right != "none" : right == "boss")
        translate([core_width(span(pc, f)) + (span(pc, f) < len(pc) ? step_off : boss_off), 0, 0])
          boss_hole(span(pc, f) < len(pc) ? 0 : male(f) ? Socket_cap : 0);
    }
  }
}
// Screw columns of a piece: channel indices b with a column between lids b-1
// and b. Groups of channels between columns are spaced col_extra apart.
function cols(pc) = fit || len(pc) < 2 ? [] : inner_screws(pc, len(pc));
function n_cols_le(pc, k) = len([for (b = cols(pc)) if (b <= k) 1]);
function ch_x(pc, k) = k*p + n_cols_le(pc, k)*col_extra;   // channel origin in the piece
function group_bounds(pc) = concat([0], cols(pc), [len(pc)]);
// Column tube centre (between lid b-1's cavity and lid b's slot).
function col_x(pc, b) = ch_x(pc, b - 1) + 18*sx + Step_clearance + boss_r;
// Mount stations that get a column screw: the station reaches lid b-1.
function col_screws(pc, st) = [for (b = cols(pc)) if (kept(pc, st, b - 1) || (st[5] && kept(pc, st, b))) b];

// 2D profile of the pillar at column b (piece coords): a regular divider
// pillar widened by col_extra. The cross-section mid-way through the solid
// wall right of the void) is stretched across the column, and the rest is
// shifted so it ends at lid b's slot like every other pillar. Lid b-1's void
// stays whole, so the pillar is just a fatter one.
col_xs = (25 - vw/2)*sx;   // mid-wall right of the void (which ends at 25 - Void_wall): voids keep their shape
// solid = true fills the void (outer outline only): the tube runs roof to bed.
module col_cell(solid) scale([sx, sy]) if (solid) polygon(source_outline); else source_cell();
// Stretch at xs within the band Y y0..y1 (source units): the slice at xs
// fills col_extra and the part right of it shifts (the part left of it is the
// group's own pillar).
module col_band(xs, y0, y1, solid) intersection() {
  union() {
    translate([xs, 0]) scale([col_extra/0.01, 1]) translate([-xs, 0])
      intersection() { col_cell(solid); translate([xs, -1]) square([0.01, d + 2]); }
    translate([col_extra, 0]) intersection() { col_cell(solid); translate([xs, -1]) square([25*sx - xs, d + 2]); }
  }
  translate([-1, y0*sy]) square([25*sx + col_extra + 2, (y1 - y0)*sy]);
}
// Above Y 20 the stretch is at col_xs (right of the void); the foot below it
// is stretched at X 20, where it is flat on the bed, so the column foot keeps
// the same bottom chamfer as every other pillar. The column foot is solid (no
// foot pocket: the driver bore runs through it).
module col_profile(pc, b, solid = false) translate([ch_x(pc, b - 1), 0]) {
  col_band(col_xs, -1, 20, solid);
  col_band(20*sx, 20, 31, true);
}
module col_roof(pc, b) translate([ch_x(pc, b - 1) + col_xs, 0]) square([col_extra + 25*sx - col_xs, Roof_thickness]);
// A piece = its channel groups, each built as a sub-piece, joined at every
// column by a gap filler (each hook both groups share) and, on screwed hooks,
// by a full boss trimmed to the hook's length.
// A piece = its channel groups, each built as a sub-piece. At every column
// the pillar between the groups is replaced, on each hook it shares, by the
// widened pillar profile; on screwed hooks the edge-boss tube takes its place,
// solid from the roof down, cut by that profile's outline (bottom chamfers)
// and flush with the hook's faces.
module piece(pc, left, right, nxt) {
  gb = group_bounds(pc); ng = len(gb) - 1;
  difference() {
    union() {
      difference() {
        for (g = [0:ng-1]) translate([ch_x(pc, gb[g]), 0, 0])
          piece_core([for (k = [gb[g]:gb[g+1]-1]) pc[k]], g == 0 ? left : "none",
                     g == ng - 1 ? right : right == "none" ? "none" : "step", g == ng - 1 ? nxt : [],
                     [for (f = piece_stations(pc)) if (gb[g+1] <= trim_of(pc, f)) f[0]], g > 0, g < ng - 1);
        for (b = cols(pc)) for (f = piece_stations(pc)) if (col_here(pc, f, b) && kept(pc, f, b))
          translate([ch_x(pc, b - 1) + col_xs + 0.01, -1, f[0] - eps])
            cube([ch_x(pc, b) + 5*sx - ch_x(pc, b - 1) - col_xs, d + 2, col_zb(pc, f, b) - f[0] + 2*eps]);
      }
      // Roof webs (unscrewed hooks) across the column gap, where the lids on
      // both sides have one.
      if (ng > 1) for (gi = [1:ng-1]) let(b = gb[gi], L = grp(pc, gi - 1), R = grp(pc, gi))
        for (f = piece_stations(pc)) if (!f[5] && kept(pc, f, b - 1) && kept(pc, f, b))
          let(wl = web_z(L, f, len(L) - 1), wr = web_z(R, f, 0)) if (wl != undef && wr != undef)
            let(a = max(wl[0], wr[0]), z = min(wl[1], wr[1])) if (z > a)
              translate([ch_x(pc, b - 1) + p, 0, a - eps]) cube([ch_x(pc, b) + 5*sx - ch_x(pc, b - 1) - p, Roof_thickness, z - a + 2*eps]);
      // Hook trimmed to start at lid b: the column screw's tube is its left end.
      for (b = cols(pc)) for (f = piece_mounts(pc)) if (!kept(pc, f, b - 1) && kept(pc, f, b))
        translate([col_x(pc, b), 0, st_zc(f)]) boss_solid(0);
      for (b = cols(pc)) for (f = piece_stations(pc)) if (col_here(pc, f, b))
        translate([0, 0, f[0]]) let(h = col_zb(pc, f, b) - f[0]) {
          if (kept(pc, f, b)) linear_extrude(height = h, convexity = 8) col_roof(pc, b);
          // Hook ends at lid b-1 but carries the column's screw: a step boss
          // (complete end tube) against lid b-1's last pillar.
          if (!kept(pc, f, b)) translate([ch_x(pc, b - 1) + 25*sx, 0, st_zc(f) - f[0]]) step_boss();
          else {
          // The widened pillar (no void in it: lid b-1's void stays whole).
          scr = f[5] && len([for (c = col_screws(pc, f)) if (c == b) 1]) > 0;
          linear_extrude(height = h, convexity = 8) col_profile(pc, b);
          // Where the tube reaches into that void, it fills it, so the bore
          // stays walled (hidden inside the hook; flush at its faces).
          if (scr) intersection() {
            translate([col_x(pc, b), 0, st_zc(f) - f[0]]) rotate([0, 180/$fn, 0]) boss_solid(0);
            // Lid b-1's void, grown a hair so the fill overlaps its walls
            // (touching faces would leave non-manifold edges).
            linear_extrude(height = h, convexity = 8) translate([ch_x(pc, b - 1), 0])
              intersection() { col_cell(true); scale([sx, sy]) offset(delta = 0.05) source_void_shapes(); }
          }
          }
        }
    }
    // Half-facet turn: the bore's polygon would otherwise touch the faces of
    // a hook exactly one bore long along a line (non-manifold).
    for (f = piece_mounts(pc)) for (b = col_screws(pc, f)) translate([col_sx(pc, f, b), 0, st_zc(f)]) rotate([0, 180/$fn, 0]) boss_hole(0);
  }
}
// Screw position of column b on hook f: in the column, or as a step boss when
// the hook ends at lid b-1.
function col_sx(pc, f, b) = kept(pc, f, b) ? col_x(pc, b) : ch_x(pc, b - 1) + 25*sx + step_off;
// Column b is built on hook f only where the hook reaches both lids beside
// it (or carries the column's screw); elsewhere lid b-1's own pillar ends it.
function col_here(pc, f, b) = kept(pc, f, b - 1) &&
  (kept(pc, f, b) || (f[5] && len([for (c = col_screws(pc, f)) if (c == b) 1]) > 0));
function grp(pc, g) = let(gb = group_bounds(pc)) [for (k = [gb[g]:gb[g+1]-1]) pc[k]];
// Z range of lid k's roof web on unscrewed hook f within channel group g
// (same rule as piece_core), or undef.
function web_z(g, f, k) = let(b = anchor(g, f), a = b[0] < f[0] ? min(b[1], b[2]) : f[1], z = b[0] < f[0] ? f[0] : hz0(b))
  z > a && member(g, f, k) && member(g, b, k) ? [a, z] : undef;
// Rear end of hook f where both lids beside column b ride on it.
function col_zb(pc, f, b) = kept(pc, f, b) ? min(seg_end(pc, f, b - 1), seg_end(pc, f, b)) : seg_end(pc, f, b - 1);

// Ghost lid panel plus its clamp (sitting on the ledge).
module ghost_lids(pc) for (k = [0:len(pc)-1]) let(L = pc[k][0], cs = clamp_span(pc[k])) {
  %translate([ch_x(pc, k) + 7.5*sx - 1, 10*sy, -Front_overhang]) cube([2, d - 10*sy + lid_widths[pc[k][1]], L]);
  %translate([ch_x(pc, k) + 10.5*sx, 16*sy, cs[0]]) cube([5*sx, 10*sy, cs[1] - cs[0]]);
}

// ---------- Layout ----------
function piece_width(k) = core_w(pieces[k]);
// Installed X origin of piece k (joined edge to edge).
function installed_x(k) = k == 0 ? 0 : installed_x(k-1) + piece_width(k-1) + joint_gap;
function print_x(k) = k == 0 ? 0 : print_x(k-1) + piece_width(k-1) + 2*edge_ext + Layout_gap;

echo(preset = Pack, printer = Printer, bed = bed, total_lids = sum(counts), channels = n_ch, pieces = n_pieces);
for (k = [0:n_pieces-1]) {
  pc = pieces[k];
  bf = piece_mounts(pc);
  echo(str("Piece ", k+1, ": ", len(pc), Reverse_order ? " channels R->L " : " channels L->R ",
           [for (c = pc) str(names[c[1]], " stop ", stop_z(c))],
           " width=", piece_width(k), " length=", piece_length(pc),
           " mount stations(z0..z1)=", [for (st = bf) str(st[0], "..", st[1])],
           " screws=",
           fit ? 0 : (k == 0 ? len(bf) : 0) + len(bf), " + intermediate ",
           fit ? 0 : sum([for (st = bf) len(col_screws(pc, st))]),
           " in columns after lids ", cols(pc)));
}
echo(str("Rack front edge sits ", stations[0][0], " mm behind the lid fronts (+ Front_overhang): mount it that far back for flush lids"));
echo(str("Hangs ", d + max([for (c = channels) lid_widths[c[1]]]), " mm below the shelf (rack depth + tallest hanging lid)"));
echo(str("Stop at ", Stop_at, "; clamp hooks centred on the long side; shortest clamp ", min_clamp, " mm -> max hook gap ", max_gap, " mm (each lid: its own clamp - ", 2*Clamp_min_engagement, ")"));
echo(str("Screws: countersunk #8/M4, length >= ", Mount_thickness + Socket_cap, " mm + shelf engagement"));

module oriented() if (Reverse_order) mirror([1, 0, 0]) children(); else children();

oriented() for (k = [0:n_pieces-1]) if (Piece == 0 || Piece == k+1) {
  pc = pieces[k];
  left = fit ? "none" : k == 0 ? "boss" : "socket";
  right = fit ? "none" : "boss";
  nxt = k < n_pieces-1 ? pieces[k+1] : [];
  if (Output == "Installed preview")
    translate([installed_x(k), 0, 0]) rotate([-90, 0, 0]) { piece(pc, left, right, nxt); ghost_lids(pc); }
  else
    translate([Piece == 0 ? print_x(k) : 0, 0, d]) rotate([-90, 0, 0]) piece(pc, left, right, nxt);
}
