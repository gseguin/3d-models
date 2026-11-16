# Snapware Lid Holder

An under-shelf rack that hangs Snapware Total Solution plastic lids vertically, one lid per channel. Every channel prints side by side in one piece, so spacing and parallelism come from the print. A selection wider than the bed splits into pieces that join with knuckle joints. Pieces screw to the shelf through countersunk bosses.

Status: prototype, fit not yet validated. Lid lengths are estimates from retailer container dimensions, so measure your lids and override them.

## Configuration

- `Pack`: a preset matching a Costco Snapware 34- or 38-piece set, or `Custom` with your own lid counts.
- `Set_quantity`: how many sets the rack holds.
- `Selection`: all sizes, or a single size.
- `Output`: `Print`, `Fit test` (a small coupon for checking the channel fit first), or `Installed preview`.
- `Piece`: `0` shows every piece; `N` exports piece N alone.

## Files

- `snapware-lid-holder.scad`: the model.
- `snapware-lid-holder.json`: Customizer sets ("Newer Costco set", "Older Costco set").
- `snapware-lid-holder-test.scad`: geometric invariant tests.
- `snapware-lid-holder.md`: design contract.

## Render

```bash
openscad -p snapware-lid-holder.json -P "Newer Costco set" -D Piece=1 -o piece1.stl snapware-lid-holder.scad
openscad -D 'Output="Fit test"' -o fit-test.stl snapware-lid-holder.scad
openscad -o /tmp/x.stl snapware-lid-holder-test.scad   # tests
```

## Print

Print flat, open side down (roof up), which is what `Output = "Print"` produces. PETG or PLA, no supports: only short bridges (~7 mm channel roofs). Walls are multiples of 0.6 mm. A brim is optional.

The channel cross-section derives from a user-supplied STL (`Big+Rectangle+2.stl`). Keep its attribution and original licensing when sharing.
