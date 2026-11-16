# h2d-pen-adapter/AGENTS.md

This part has no design contract, no tests, and no `.json` sets, so the header comment and the Customizer defaults in `h2d-pen-adapter.scad` are the authority. The header title carries the version (`v111`); bump it with each behaviour change.

- **Pen presets** live in one table, `[enabled_flag, shape, pen_length, diameter_bottom, diameter_middle, diameter_top]`, toggled by the `gen_*` booleans. A new pen is a new row plus a new `gen_*` toggle.
- **Fixed interface**: `collar_diameter` and `collar_height` fit the Bambu H2D pen holder. A fit change belongs in `pen_cavity_tolerance` or the collet parameters.
- **Verification**: render the defaults (the batch grid) and `generate_test_slice = true`, which switches the engraving to wrapped horizontal text.
