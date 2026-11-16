# Gridfinity Silverware Bin

A parametric silverware organiser on a Gridfinity base. Measure your cutlery and the model sizes one slot per utensil type (knives, forks, spoons, dessert forks, teaspoons).

## Features

- Configurable slots with ordering, orientation, alignment (centred, top, bottom, neck-aligned), and stacking.
- Shims: wedges under the handles that lift them for an easy grab.
- A central finger trench, straight or wavy.
- A Gridfinity base with optional magnets and stacking lip; fractional edges trim the footprint to fit a drawer.
- Minimalist mode for less material.
- Split into left and right halves (`part_to_render`) when the bin exceeds the build plate.

## Workflow

1. Measure each utensil: length, handle length, widths, thickness.
2. Set the parameters in the Customizer (or `config_mode = "wizard"` to derive slot counts from `items_per_stack`).
3. Check the fit cheaply: print a paper template (`generate_2d_footprint`) or a thin slice (`generate_test_slice`).
4. Print the full bin.

## Files

- `gf-silverware-bin.scad`: the model; its header holds the version history.
- `gf-silverware-bin.json`: Customizer sets.

## Render

```bash
openscad -o bin.stl gf-silverware-bin.scad
openscad -p gf-silverware-bin.json -P "New set 1" -o bin.stl gf-silverware-bin.scad
openscad -D part_to_render=1 -o bin-left.stl gf-silverware-bin.scad
```
