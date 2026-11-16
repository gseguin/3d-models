# H2D Pen Adapter

A parametric adapter that fits ordinary pens and markers into the Bambu H2D pen holder. A flexible collet with internal friction ribs grips the pen, and a chamfered flange eases insertion into the holder. Each adapter is engraved with its pen's diameter and shape.

## Pens

Presets cover Sharpie Felt Tip, Fine Point, and Ultra Fine; Staedtler Lumicolor and Triplus (triangular); and Stabilo (hexagonal). Toggle the `gen_*` parameters to batch-print several adapters on one plate, or add a custom pen.

## Fit

- `pen_cavity_tolerance` (default 0.6 mm): raise it if the pen is too tight, lower it if too loose.
- `generate_test_slice`: print a short slice to check the fit before the full adapter.
- `pen_protrusion_length`: how far the pen extends past the adapter.

## Render

```bash
openscad -o adapters.stl h2d-pen-adapter.scad
openscad -D generate_test_slice=true -o slice.stl h2d-pen-adapter.scad
```
