# Snapware lid holder — design contract

Under-shelf rack that hangs Snapware Total Solution plastic lids vertically,
one lid per channel. Each lid hangs by its clamp edge, always its **longest**
side (rectangles too, so only the short side hangs below: ~214 mm below the
shelf for the current set), and slides in from the front until it hits its stop.

## Constraints
- **Lid fronts flush.** Z = 0 is the front line for every channel. Only the
  stop depth varies between sizes.
- **Two numbers per lid.** The *lid length* (long side) aligns every lid
  front on one line, so they are equally easy to grab, and it is the side the
  lid hangs by, which keeps the drop below the shelf small. The *clamp hook
  length* C (per size, centred on that side) is what rides on the rail and
  carries the lid. Defaults are estimates (~half the side; the squares are
  measured at 60 mm). The stop
  catches the clamp's rear end at `Stop + (L + C)/2`, so each rail is only as
  long as its clamp needs. The
  lid's rear quarter hangs out past the rail. "Lid end" puts the stop at the
  lid edge instead.
- **Clamp held by two hooks at rest.** One entrance hook sits as far back as
  every clamp allows: it ends `Clamp_min_engagement` past the latest clamp
  front, so it carries every size's clamp front (placed under the earliest
  clamp front instead, the medium squares needed a hook of their own at Z 72
  on the Newer set). It falls back to the earliest clamp front when no such
  spot exists. Each size gets a stop hook under its clamp's rear
  end. A size gets its own clamp-front hook only if its clamp would otherwise
  rest on no hook besides its stop hook (≥ `Clamp_min_engagement` overlap);
  the continuous ledge rail carries the clamp in between. Per-size front
  hooks for every size were tried: they made the entrance a 40 mm-deep block. The hook runs Station_length (6 mm, just over the 5 mm
  minimum engagement) in front of the stop wall (under the clamp's
  rear end, the only part the clamp touches) and **ends at the wall**
  (`Stop_tail` = 0). A tail behind the wall was tried: +63 cm³, no contact
  with the clamp. `Stop_tail` > 0 adds it back for the stopping channels only.
  `rail(L)` is the channel's material end = `stop_z(L) + Stop_tail`. The clamp is centred
  between its two hooks, so neither end hangs. Lid-end mode adds the stop hook
  at the lid edge as well.
- **Nothing behind a stop.** A station only spans channels whose rail
  reaches it, so the shortest lids get exactly front + stop stations (plus
  gap fills, below).
- **Hook gap ≤ each lid's own clamp.** The clear gap between consecutive
  hooks along a channel is at most `C − 2·Clamp_min_engagement` for that
  channel's lid (`gap_max`). A sliding clamp then always reaches the next hook
  before it leaves the last one. Gap fills use the shortest clamp among the
  channels that ride past the gap (`gap_lim`), so a short clamp (small square,
  40 mm → 30 mm) only crowds the hooks in front of its own stop. Using the
  shortest clamp of the whole selection everywhere gave 7 hooks on a 245 mm
  rack instead of 5. Extra screwed stations are added where needed, evenly
  spaced.
- **Sorted by stop depth** (L + C)/2, deepest on the left, so the rear edge is a staircase.
  `Reverse_order` puts the deepest on the right by mirroring the whole rack
  (pieces, joints, ghost lids). The profile mirrors too, so lids go in turned
  around. That is fine because the clamp is centred on the long side.
- **One printed piece** where the bed allows, so spacing and parallelism come
  from the print. `Printer` presets set the bed (default H2D single nozzle,
  350 × 320). If the selection is too wide (19 lids × 20 mm ≈ 400 mm), it splits
  into balanced, interlocking pieces, longest lids first.
- **No supports** in PETG or PLA. Printed open side down; every downward
  face is a bridge between two walls (cavity roof ~7 mm, roof webs and step
  bridges < 6 mm) or within ~1 mm of the bed.
- **Minimum filament.** The full channel profile exists only at short
  crossbar stations. Lids are light, stiff panels. v5 cut the two Costco
  racks from 147.5 / 140.4 cm³ to 94.6 / 95.8 cm³ (−36 % / −32 %) with the
  two measures below; the roof and the ledge rails were left alone.
  - **Short hooks, long only at screws.** A hook body is `Station_length`
    (6 mm; 8.4 mm with the stop wall), was 10 (12.4). Every screwed hook is
    still one screw-tube diameter (12.4 mm) long, but only at the pillars
    that hold a tube or a joint socket (edge walls, step-boss pillars, screw
    columns): `hook_relief` cuts the rest back to the body front `hz0`. The
    long pillar serves the screw: it walls the driver bore front and back and
    welds the tube to the hook over its full diameter. All gap rules, the
    trim and the tests measure from `hz0`, since that is where the ledge
    under the clamp starts. Two long pillars in a row keep the cell between
    them (a one-lid hook is a plain block, no roof notch).
  - **Hollow pillars.** Each pillar is a box: `Void_wall` (1.8 mm, 3
    perimeters; 1.2 is the floor and saves ~7 cm³ more) from the slanted
    cavity wall and from the next slot's face, roof to source Y 19, plus a
    pocket in the foot (X ≥ 20.3, `Void_wall` from the bed and the bottom
    chamfer). No lid-contact surface moves. The void top is the thinned roof
    line, so the column tube's fill meets the roof (a gap showed there when
    the void top stayed at Y 5). The column foot has no pocket (the driver
    bore runs through it), and the column stretch line sits mid-wall right of
    the void (`col_xs`).
- Channel cross-section is the user-supplied `Big+Rectangle+2.stl` profile
  (20 × 30), scaled by `Channel_pitch`/`Channel_depth`. Channel fit validated on v4: racks for both Costco sets printed and installed.
  The v5 short hooks and hollow pillars change no lid-contact surface but have **not been printed yet**: print the fit coupon or one piece first.
- **Roof** (shelf side, over the lid cavities and voids) is `Roof_thickness`
  3.6 mm (6 perimeters; the source profile has 5). It is the weak link for sag
  (the only member that crosses the 7 mm cavities), so v5 did not thin it. It is thinned from below,
  so the shelf face and the boss screw seats
  (`Mount_thickness` 5, needed for the countersink) are unchanged. Roof webs
  and column roofs use the same thickness.
- Print **flat, open side down**, no supports (roof bridges ~7 mm over the
  cavities, ~9.5 mm over the pillar voids).

## Geometry
- **Hooks**: requirements (clamp front end, clamp rear end, stop) per lid
  size; overlapping ones merge. *Full* hooks (the frontmost, every hook that
  holds a stop, gap fills) span every channel whose rail passes them.
  Clamp-front hooks of longer lids span **only the channels of the lid
  sizes they serve** (not deeper channels; an earlier version did, which
  made the entrance a solid block 40 mm deep). Each is joined by a roof-level
  web (Y 0..5·sy) to the nearest screwed hook, over its own channels. Gap fills keep clear gaps between full hooks ≤ `gap_lim`
  and screw rows ≤ `Max_mount_spacing`. A fill landing on a narrow hook
  promotes that hook to full instead. Hook fronts are vertical (no lead-in by default).
- **Rack front** sits at the first hook (its screw pillars 49.6 mm behind the lid fronts for the
  current set). The `.scad` echoes the setback for mounting flush lids.
- **Ledge rails**: one 2.4 mm strip per channel, a continuous piece of the
  hooks' ledge: slot-side face flush with the ledge edge (source X 10), from
  the bed up to the ledge top (source Y 26), running from the first hook to the
  stop. The clamp rides on it all the way in, so it can't droop and miss the
  next hook. The strips also tie the hooks together. Hook fronts are plain
  vertical faces (`Lead_in` = 0; a chamfer would set the rail back by that much).
- **Stop**: in clamp-end mode it is a block above the ledge (source X 10.5–18,
  Y 12–26) that catches only the clamp. The slot stays open so the panel's
  rear part passes through. In lid-end mode it plugs the slot and lower cavity
  (Y 18–30).
- **Step bosses**: where a full hook ends partway across a piece, it ends
  like a piece edge: the **same complete, full-height tube against its last
  pillar**. The tube stands in the shorter neighbour's channel, behind that
  lid's stop (screw rows are only placed where no rail or stop is within
  reach). Tried and dropped: the tube right of that lid's slot on a
  roof-level neck (looked detached), and the slot slit through the tube
  (looked truncated; the user confirmed the panel doesn't need it). Screw
  rows are spaced ≥ `min_screw_step`: tube-to-tube (~13 mm); a joint is no
  longer than its tube. So close hooks get their own screws instead of a roof web
  to a screwed neighbour, which made a wide double plate.
- **Bosses**: every screwed hook is screwed at both ends. Piece edges use vertical
  tubes: screws go in from the open side, the driver goes up the bore, and the
  countersunk seat is at the shelf end.
- **Intermediate screws**: wide crossbars get extra screws so they don't sag
  between the end bosses. Each uses the **same boss as the piece edges** (tube,
  countersunk seat at the shelf end, driver bore from the open side). The
  7 mm divider is too thin for a 12.4 mm tube, so each screw gets a **screw
  column**: the piece is built as channel groups spaced `col_extra` (6.4 mm)
  apart. At a column, the pillar between the groups is rebuilt on every hook
  as the **regular pillar profile, widened**: the cross-section at source X 23
  (solid divider, right of the void and left of the bottom chamfer) is
  stretched across the column, and the rest is shifted to end at the next
  lid's slot. Below source Y 20 the stretch is at X 20 instead, where the
  foot is flat on the bed, so the column foot has the same bottom chamfer as
  every other pillar (X 23 crosses the chamfer: the foot floated 2 mm up, and
  filling it flat lost the chamfer). Every void keeps its normal shape (stretching at X 20 cut
  through the void and drew it out into a flat-topped band, which looked
  wrong). On screwed hooks the tube sits inside that fatter pillar, driver
  bore up the middle; inside the hook it fills into the neighbouring void
  where it reaches it, so the bore stays walled, and it is flush with the
  hook's front and back faces. The roof stays continuous. A column is built only on hooks that reach
  the lids on both sides of it (or carry its screw); a hook that ends at the
  lid left of a column ends with that lid's normal pillar, and if it is
  screwed its column screw becomes a step boss on that pillar (see Step
  bosses; the slit is the next lid's slot, past the column gap). Roof webs of
  unscrewed hooks are bridged across the column gap. Screwed hooks are made at least one tube diameter
  (12.4 mm) long when the rack has columns, so the bore keeps a 1.2 mm wall in
  front and behind. They grow forward, never into the previous hook. Columns
  are chosen per piece by lid weight (≈ L × width): at most
  `Channels_per_screw` (5) lids and at most the weight of 5 average lids of the
  selection between screws. The fewest columns that meet both are placed at
  equal-weight points, so the heavy large rectangles get screws closer
  together. A screwed hook gets the column's screw if it reaches the lid left
  of the column. Columns widen the piece. The bed split re-checks the real
  width and moves lids to more pieces if needed. Current set: columns after
  lids 2 and 6 of the 10-lid piece (+12.8 mm).
- **Left trim** (single-piece racks): a full hook drops the lids left of a
  screw column that don't need it. A lid needs a hook if it is its stop hook,
  if its clamp would no longer rest on another hook besides the stop hook, or
  if its largest clear gap would exceed `trim_gap` = ⅔ of its clamp (at least
  `max_gap`, at most its own clamp's limit), so long lids keep a middle hook.
  Calibrated on the user's calls: 102 mm under a 117 mm clamp and 75 mm under
  108 mm were too wide, 52 mm under 82 mm was fine. Tried: `max_gap` alone
  (kept hooks long lids didn't need) and each lid's own clamp (left long lids
  only end hooks). Hooks can only end at a column (the end tube would
  otherwise stand in the next lid's path). The column screw's tube becomes
  the hook's left end. Gaps are measured to hook bodies (`hz0`). Decided rear hooks first. Not done on multi-piece
  racks, where a piece's left edge may be a joint.
- **Joints**: neighbouring pieces share one row of screws, on piece *k*'s
  right bosses (complete tubes). At each station they share, that boss carries
  a dovetail tail that fits a socket in piece *k+1*'s left wall, which has no
  boss. The tail stands on the bed (`Joint_height` 15 mm at its head); the
  socket is open at the bed and closed above, so piece *k+1*'s edge rests on
  the tails. The socket's ceiling slopes 45° from its back up to the wall face
  (an overhang, no bridge; a flat ceiling was tried first), the tail's top
  slopes the same, and the load wedges the dovetail tight. `Joint_clearance` (0.2 mm)
  on every face, plus 0.2 mm over the first 0.6 mm for elephant's foot; the
  socket leaves 1.8 mm of the 5 mm wall (the tail gets shallower as the clearance grows). It slides together along Y: mount
  piece *k+1*, lift piece *k* into it, screw it. At least two joints per seam
  lock spacing and parallelism. Seam 11.4 mm. Tried and dropped: a C-socket on
  piece *k+1* wrapping piece *k*'s shortened boss (read as a broken cylinder;
  thin open sleeve, 13 mm bridged cap), and full bosses on both pieces with a
  dovetail between them (two tubes side by side, 26 mm seam, double screws).

## Structure
Each stop row carries the rear half of its lids. The ledge rails sit at the
bottom of the profile and are too flexible to carry a row on their own (an
estimated 2–3 mm sag at 220 mm span), so every station stays screwed.
Station spans of ~200 mm between screws estimate at < 1.5 mm deflection
(counting only the roof). Real stiffness is higher because of the dividers.

Across a hook, the pillars are stiff boxes (roof, two walls, foot) and the
roof over each 7 mm cavity is the flexible part. For a 5-lid span between
screws carrying half of five ~50 g lids, a 3.6 × 6 mm roof strip estimates at
~0.15 mm sag (~0.4 mm allowing 3× for PETG creep); the v4 12.4 mm hooks were
about half that. Estimates, not measurements.

## Data
Counts were checked against the cited Costco/frugalhotspot listings
(19/18/15/19 containers). Lid lengths are **estimates** from retailer
container dimensions (long side). Clamp hook lengths are estimates (~half the
side) except the squares, measured at 60 mm. In clamp-end mode the stop position scales with
(L + C)/2, so a 10 mm error in L or C moves the stop 5 mm. **Measure your lids
and clamps.**

## Ruled out
- Intermediate screws through the 7 mm divider: a long screw countersunk in
  the open face (not the edge-boss design), or an edge-size boss trimmed to the
  divider (its 10 mm driver bore hollowed out the divider). Also tried: a
  full round tube sticking out past the hook faces, and a plain round post in
  a filled block. Neither matched the other pillars.
- One rail per lid (v3): no shared spacing, ~6× the filament.
- Stops at a common rear line (v4 draft): lid fronts end up uneven.
- Spanning stations by lid reach (so step bosses miss overhanging rears):
  builds crossbars behind shorter lids' stops for nothing.
- Roof-level screw tabs at steps: unsupported cantilevers when printed.
- Merging nearby hooks into one solid crossbar: +120 cm³. Narrow hooks
  plus roof webs instead.
- Boss-less guide crossbars: attached only by thin bottom strips. Ledge rails
  guide better and are structural.
- Printing upright on the rear end: can't print a ladder frame, and it's tall and unstable.

## Fit test
The coupon is a front hook, `max_gap − Fit_test_gap_margin` of open space
(default 44 − 5 = 39 mm), then a stop hook. Its front hook is `fit_front`
(9 mm) long, so the whole clamp sits on the coupon. The rack's own gaps are capped at
`gap_max` per lid and are at most ~36 mm for the current set.

## Change impact
- Profile changes affect `Stop_top`, `ledge_top`, `rail_x` and the lead-in
  (all in source coordinates scaled by `sx`/`sy`).
- Station logic changes must keep tests C (flush fronts, exact stops),
  G (joints), S (intermediate screws), N (nothing behind a stop), O (hook gap), P (clamp ends on hooks), R (hook around the stop) and L (screw pillars one tube long) passing.
- Void changes: keep the main void above source Y 20 and the pocket right of
  X 20 (the column foot is stretched there), and `col_xs` right of the void
  (test V). `cavity()` subtracts the voids, since they reach left of X 18.
- Run `snapware-lid-holder-test.scad` for every preset in the `.json`.
