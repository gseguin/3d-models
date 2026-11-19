// Tests for snapware-lid-holder.scad
// Run: openscad -o /tmp/x.stl snapware-lid-holder-test.scad
//      (add -D 'Pack="..."' / -D Set_quantity=2 etc. to test other configs)
// Non-zero exit = a test failed (assert aborts on first failure).

include <snapware-lid-holder.scad>
Piece = 99;   // suppress model geometry; tests only

// --- A: preset counts match the cited catalog listings (container totals) ---
echo(str("A: totals current=", sum(current), " 2016=", sum(old2016),
         " 2015=", sum(old2015), " 2014=", sum(old2014), " expected 19/18/15/19"));
assert(sum(current) == 19 && sum(old2016) == 18 && sum(old2015) == 15 && sum(old2014) == 19,
       "A FAIL: preset totals differ from catalog listings");

// --- B: every channel exists exactly once across pieces ---
echo(str("B: channels=", n_ch, " in pieces=", sum([for (pc = pieces) len(pc)])));
assert(sum([for (pc = pieces) len(pc)]) == n_ch, "B FAIL: channels lost or duplicated");

// --- C: lid fronts flush at Z=0; each channel has a stop exactly at its rail
// depth (Stop + L - Front_overhang) in some stop station of its piece ---
for (pc = pieces) for (k = [0:len(pc)-1]) let(r = stop_z(pc[k]),
    hits = [for (st = piece_stations(pc)) for (sk = station_stops(pc, st)) if (sk[0] == k) sk[1]]) {
  echo(str("C: ", names[pc[k][1]], " L=", pc[k][0], " stop at ", hits, " expected ", r));
  assert(len(hits) == 1 && abs(hits[0] - r) < eps, str("C FAIL: ", names[pc[k][1]], " stop missing/duplicated"));
  assert(abs(r - Stop_thickness - (clamp_mode ? (pc[k][0] + pc[k][2])/2 : pc[k][0]) + Front_overhang) < eps, "C FAIL: lid front not on the front line");
  // Whole clamp sits over this channel's ledge rail (front station .. stop).
  cs = clamp_span(pc[k]);
  echo(str("C: clamp ", cs, " rail support 0..", r - Stop_thickness));
  assert(cs[0] >= -Front_overhang - eps && cs[1] <= r - Stop_thickness + eps, "C FAIL: clamp not fully on rail");
}

// --- R: Station_length of hook in front of the stop wall (under the clamp's
// rear end) and exactly Stop_tail behind it ---
for (pc = pieces) for (k = [0:len(pc)-1]) let(sz = stop_z(pc[k]),
    st = [for (st = piece_stations(pc)) if (len([for (sk = station_stops(pc, st)) if (sk[0] == k) 1]) > 0) st][0],
    front = sz - Stop_thickness - hz0(st), behind = seg_end(pc, st, k) - sz) {
  echo(str("R: ", names[pc[k][1]], " hook ", front, " | stop ", Stop_thickness, " | ", behind));
  assert(front >= Station_length - eps && abs(behind - Stop_tail) < eps, "R FAIL: hook around the stop wall");
}

// --- C2: channels sorted by stop depth, deepest first, within and across pieces ---
if (n_ch > 1) for (k = [1:n_ch-1]) assert(stop_z(channels[k]) <= stop_z(channels[k-1]) + eps, "C2 FAIL: channels not sorted by stop depth");

// --- D: pieces fit on the print bed ---
for (k = [0:n_pieces-1]) {
  W = piece_width(k) + 2*edge_ext; Lp = piece_length(pieces[k]);
  echo(str("D: piece ", k+1, " footprint ", W, " x ", Lp, " max ", max_print_width, " x ", max_print_depth));
  assert(W <= max_print_width && Lp <= max_print_depth, "D FAIL: piece exceeds bed");
}

// --- E: screw (mount station) spacing along Z within Max_mount_spacing ---
for (k = [1:len(mount_sts)-1]) let(g = st_zc(mount_sts[k]) - st_zc(mount_sts[k-1])) {
  echo(str("E: mount gap ", g, " max ", Max_mount_spacing));
  assert(g <= Max_mount_spacing + eps, "E FAIL: mounts too far apart");
}

// --- O: along every channel, the clear gap between consecutive hooks it
// rides on is <= Clamp_contact_length - 2*Clamp_min_engagement ---
for (pc = pieces) for (k = [0:len(pc)-1]) let(r = rail(pc[k]),
    sts = [for (st = piece_stations(pc)) if (kept(pc, st, k)) [hz0(st), seg_end(pc, st, k)]])
  for (j = [1:len(sts)-1]) let(g = sts[j][0] - sts[j-1][1]) {
    echo(str("O: ", names[pc[k][1]], " gap ", g, " max ", gap_max(pc[k])));
    assert(g <= gap_max(pc[k]) + eps, "O FAIL: clamp can't bridge the gap between hooks");
  }

if (fit) let(sts = piece_stations(pieces[0])) {
  echo(str("O: fit test stations ", len(sts), " gap ", sts[1][0] - sts[0][1], " = ", fit_gap, " (max ", max_gap, " - margin)"));
  assert(len(sts) == 2 && abs(hz0(sts[1]) - sts[0][1] - fit_gap) < eps, "O FAIL: fit test gap");
}

// --- F: stations disjoint and in order; front station at Z=0 ---
assert(stations[0][0] >= -eps, "F FAIL: station in front of Z=0");
for (k = [1:len(stations)-1]) assert(stations[k][0] >= stations[k-1][1] - eps, "F FAIL: stations overlap");

// --- M: ledge rail top is flush with the station ledge (clamp rides on it),
// and its slot-side face is flush with the hooks' ledge edge ---
echo(str("M: rail x ", rail_x - Strip_width/2, "..", rail_x + Strip_width/2,
         " slot edge ", 10*sx + Lead_in, " ledge tip ", 16*sx, " top ", ledge_top, " = ", 26*sy));
assert(abs(rail_x - Strip_width/2 - (10*sx + Lead_in)) < eps && rail_x + Strip_width/2 <= 16*sx, "M FAIL: rail not flush with the ledge edge");

// --- G: joined pieces share their joint stations (spacing + parallelism) ---
if (n_pieces > 1) for (k = [0:n_pieces-2]) let(a = piece_mounts(pieces[k]), b = piece_mounts(pieces[k+1])) {
  echo(str("G: piece ", k+1, " mounts ", len(a), " piece ", k+2, " mounts ", len(b)));
  assert(len(b) >= 2, "G FAIL: fewer than 2 joints -> parallelism not guaranteed");
  assert(len(b) <= len(a) && [for (j = [0:len(b)-1]) a[j]] == b, "G FAIL: joint stations misaligned");
  for (st = b) assert(span(pieces[k], st) == len(pieces[k]), "G FAIL: joint station not full width on left piece");
}

// --- K: step bosses sit against the last pillar like edge bosses, within the
// shorter neighbour's slot + cavity, behind its clamp/stop ---
echo(str("K: step boss x ", step_off - boss_r, "..", step_off + boss_r, " from station edge; neighbour cavity ends at ", 13*sx));
assert(step_off - boss_r < 0 && step_off + boss_r <= 13*sx + eps, "K FAIL: step boss x");
for (pc = pieces) for (st = piece_mounts(pc)) let(n = span(pc, st)) if (n < len(pc)) {
  clear = st_zc(st) - boss_r - rail(pc[n]);
  echo(str("K: step boss at z ", st_zc(st), " clears neighbour stop (", rail(pc[n]), ") by ", clear));
  assert(clear >= 0.5 - eps, "K FAIL: step boss hits neighbour clamp/stop");
}
for (k = [1:len(mount_sts)-1]) let(g = st_zc(mount_sts[k]) - st_zc(mount_sts[k-1])) {
  // Tubes (and the joints on them, no longer than a tube) must not touch.
  echo(str("K: boss zc gap ", g, " >= ", min_screw_step));
  assert(g >= min_screw_step - eps && min_screw_step >= 2*boss_r + 1 - eps, "K FAIL: bosses overlap");
}

// --- N: nothing behind a stop: every station part of a channel starts in front
// of that channel's stop and ends at or before it; the shortest channel of the
// selection gets exactly front + stop stations (plus spacing fills) ---
for (pc = pieces) for (k = [0:len(pc)-1]) let(r = rail(pc[k]),
    sts = [for (st = piece_stations(pc)) if (kept(pc, st, k)) st]) {
  for (st = sts) assert(st[0] < r - eps && seg_end(pc, st, k) <= r + eps, "N FAIL: station behind a stop");
  // A full station skips only channels that already stopped.
  for (st = piece_stations(pc)) if (st[3] && k >= span(pc, st)) assert(r <= st[0] + eps, "N FAIL: full station skips a passing channel");
}

// --- P: at rest the clamp's rear end sits Station_length on its stop hook,
// and the clamp also rests on at least one other hook by >= Clamp_min_engagement ---
if (!fit) for (pc = pieces) for (k = [0:len(pc)-1]) let(cs = clamp_span(pc[k]),
    segs = [for (st = piece_stations(pc)) if (kept(pc, st, k)) [hz0(st), seg_end(pc, st, k)]],
    rr = [for (sg = segs) if (sg[0] <= cs[1] - SL + eps && sg[1] >= cs[1] - eps) sg],
    other = [for (sg = segs) if (rr == [] || sg != rr[0]) let(o = min(sg[1], cs[1]) - max(sg[0], cs[0])) if (o >= Clamp_min_engagement - eps) o]) {
  echo(str("P: ", names[pc[k][1]], " clamp ", cs, " stop hook ", len(rr), " other hooks under clamp ", other));
  assert(len(rr) == 1 && len(other) >= 1, "P FAIL: clamp not held by its stop hook plus another hook");
}

// --- S: intermediate screws: <= Channels_per_screw lids and <= gap_w_max lid
// weight between screws on every screwed crossbar; each column boss sits
// between lid b-1's clamp cavity and lid b's slot (Step_clearance from both)
// and inside the crossbar's length ---
if (!fit) for (pc = pieces) {
  for (b = cols(pc)) let(lo = col_x(pc, b) - boss_r, hi = col_x(pc, b) + boss_r,
      cav = ch_x(pc, b - 1) + 18*sx, slot = ch_x(pc, b) + 5*sx) {
    echo(str("S: column after lid ", b, " boss x ", lo, "..", hi, " cavity ends ", cav, " slot starts ", slot));
    assert(lo >= cav + Step_clearance - eps && hi <= slot - Step_clearance + eps, "S FAIL: column boss in lid space");
  }
  for (st = piece_mounts(pc)) let(n = span(pc, st), cs = col_screws(pc, st),
      bounds = concat([trim_of(pc, st)], [for (b = cs) if (b < n && b > trim_of(pc, st)) b], [n]), cw = cum_w(pc, n)) {
    echo(str("S: crossbar ", st[0], "..", st[1], " over ", n, " lids, screws after lid ", cs));
    for (j = [1:len(bounds)-1]) {
      g = bounds[j] - bounds[j-1];
      assert(g >= 1 && g <= Channels_per_screw, "S FAIL: too many lids between screws");
      assert(g == 1 || cw[bounds[j]] - cw[bounds[j-1]] <= gap_w_max + eps, "S FAIL: too much weight between screws");
    }
    for (b = cs) let(zb = kept(pc, st, b) ? min(seg_end(pc, st, b - 1), seg_end(pc, st, b)) : seg_end(pc, st, b - 1))
      assert(st_zc(st) - Screw_head_diameter/2 >= st[0] - eps && st_zc(st) + Screw_head_diameter/2 <= zb + eps,
             "S FAIL: column screw outside its crossbar");
  }
}

// --- H: dovetail joint: the tail is held, clears its socket, and leaves the wall and tube whole ---
echo(str("H: tail head ", joint_head, " neck ", joint_neck, " depth ", Joint_depth, " clearance ", Joint_clearance,
         " wall behind socket ", 5*sx - Joint_depth - Joint_clearance, " seam gap ", joint_gap));
assert(joint_head - joint_neck >= 4*Joint_clearance + 1, "H FAIL: tail can pull out of its socket");
assert(joint_neck >= 3, "H FAIL: tail neck too thin");
// The socket keeps Socket_wall beside it (the wall is one tube long there) and behind it (lid slot).
assert(boss_r - joint_head/2 - Joint_clearance >= Socket_wall - eps, "H FAIL: wall beside the socket too thin");
assert(5*sx - Joint_depth - Joint_clearance >= Socket_wall - eps, "H FAIL: socket too close to the lid slot");
// The socket's ceiling climbs 45 deg from Joint_height (back) to the wall face; the tail's top on to the tube.
assert(Joint_height + Joint_depth <= d - max(Roof_thickness, Mount_thickness) - 5, "H FAIL: joint reaches the roof or the screw seat");
// Joined pieces: the neighbour's wall stands Joint_clearance off the tube.
assert(abs(joint_gap - (boss_off + boss_r + Joint_clearance)) < eps, "H FAIL: seam gap");
// Every screwed hook of a right-hand piece hangs on a tail of its left neighbour.
if (n_pieces > 1) for (k = [1:n_pieces-1]) for (st = piece_mounts(pieces[k]))
  assert(is_male(pieces[k-1], st, pieces[k]), "H FAIL: hook without a joint on its left end");

// --- I: fasteners ---
echo(str("I: countersink depth ", cs_depth, " seat ", Mount_thickness, " bore ", Driver_bore_diameter,
         " head ", Screw_head_diameter));
assert(cs_depth <= Mount_thickness - 1.5 && Driver_bore_diameter >= Screw_head_diameter + 1, "I FAIL");

// --- J: walls are 0.6 mm nozzle multiples ---
for (t = [Boss_wall, Socket_wall, Strip_width, Stop_thickness, Void_wall]) {
  echo(str("J: wall ", t));
  assert(abs(t/0.6 - round(t/0.6)) < 1e-6, str("J FAIL: ", t, " not a 0.6 multiple"));
}
// --- L: lean hooks: the hook under the clamp is Station_length long (enough
// for the minimum engagement); every screwed hook is one tube long at its
// screw pillars, and its body front is never in front of them ---
echo(str("L: Station_length ", Station_length, " >= engagement ", Clamp_min_engagement));
assert(Station_length >= Clamp_min_engagement - eps, "L FAIL: hook shorter than the clamp engagement");
if (!fit) for (k = [0:len(mount_sts)-1]) let(st = mount_sts[k], e = min(st[4][0][3], st[2]),
    room = k == 0 ? e : e - max([for (q = stations) if (q[1] <= st[0] + eps) q[1], 0])) {
  echo(str("L: screwed hook ", st[0], "..", st[1], " body front ", hz0(st), " screw pillar ", e - st[0], " tube ", 2*boss_r));
  assert(hz0(st) >= st[0] - eps && (e - st[0] >= 2*boss_r - eps || room < 2*boss_r + eps), "L FAIL: screw pillar shorter than its tube");
}
// --- V: pillar voids keep printable walls and stay clear of the column stretch lines ---
echo(str("V: void wall ", Void_wall, " right edge ", 25 - vw, " column stretch at ", col_xs/sx));
assert(Void_wall >= 1.2 - eps && 25 - vw < col_xs/sx, "V FAIL: void walls");
echo("ALL TESTS PASSED");
cube(0.1);   // non-empty output so the exit code reflects the asserts
