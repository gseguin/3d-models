# parametric/AGENTS.md

One directory per printable part: `parametric/<part>/`. A part with non-trivial geometry holds:

1. `<part>.scad`: the model.
2. `<part>.json`: Customizer parameter sets.
3. `<part>-test.scad`: geometric assertions.
4. `<part>.md`: the **design contract**: constraints, decisions, alternatives ruled out, change-impact map.
5. `README.md`: the human-facing summary: what the part is, its outputs, how to print it.
6. `AGENTS.md` (plus a `CLAUDE.md` holding `@AGENTS.md`): what is specific to this part: its production set, its modes, its gotchas.

`directional-vent/` is the reference example.

## Modifying a part

1. Read the part's `AGENTS.md`, then its design contract (`<part>.md`) when one exists.
2. Make the minimal change.
3. Run `<part>-test.scad`. When an invariant changes on purpose, update its test in the same change.
4. Re-render the default part and every set in `<part>.json`. Done when each one renders cleanly.
5. Bring `<part>.md`, `README.md`, and the part's `AGENTS.md` in line with the new state whenever the change touches a constraint, a decision, the change-impact map, an output, or a print setting.

## Adding a part

Create `parametric/<part>/` with at least `<part>.scad`, `README.md`, `AGENTS.md`, and `CLAUDE.md`. Add the test file and design contract once the geometry carries invariants worth guarding.

## Multi-part dispatch

A file that yields several printables selects one with a top-level `part` dropdown:

```scad
// [vent, throttle]
part = "vent";

if (part == "vent")          vent_body();
else if (part == "throttle") throttle();
```

Render a non-default part with `openscad -D 'part="throttle"' -o throttle.stl directional-vent.scad`.

## Tests

Top-level `assert()` statements in `<part>-test.scad`, which `include`s the model from the same directory; OpenSCAD itself is the runner, and a failed assert exits non-zero with the failing assertion on stderr.

- One test per geometric invariant (slat angle, plate dimensions, channel Z, ...).
- Letter-prefix each label (`A:`, `B:`, ...) so messages can cite it.
- `echo()` actual and expected values before each `assert()`, so a failure explains itself.
- Where a target can fall below the printable floor (e.g. open area undercutting the minimum slot), encode the floor as an alternative pass condition.

## File layout

`// ----------` rule lines separate logical sections. Parameters group under `// [Section Name]` headers, which the Customizer shows as tabs. Print settings sit in a `Print settings:` comment block at the top of each file.

## Print limits

Limits scale with nozzle diameter `n`; a part's `Print settings:` block names the nozzle it was designed for and the filaments it recommends.

- Walls in multiples of `n`: 2n (2 perimeters) is the practical floor.
- Narrowest printable slot: ~2n.
- Longest clean bridge: ~40 mm.
- Unsupported overhang: up to ~50° from vertical.
- Layer height: ~0.5n typical (0.5n–0.67n range).
- Brim: 4–6 mm on wide flanges (>200 mm).
- Design support-free; a part that needs supports names where in its header comment.
