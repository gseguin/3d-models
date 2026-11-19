# snapware-lid-holder/AGENTS.md

Read `snapware-lid-holder.md` (the design contract) before any change. The channel fit is validated: racks for both sets in `snapware-lid-holder.json` have been printed and installed (v4). The v5 lean geometry (6 mm hook bodies that stay 12.4 mm only at screw pillars, hollow pillars) is not print-validated yet; say so until a fit-test print confirms it. Treat the validated fit as a baseline: a change to the channel profile, hook spacing, or joints needs a fit-test print before it counts as done. Default lid and clamp lengths remain estimates for other users' lids.

- **Sets**: "Newer Costco set" and "Older Costco set" in `snapware-lid-holder.json`. Re-render both after a change.
- **Outputs**: `Output` picks `Print` (print orientation), `Fit test` (coupon), or `Installed preview` (as mounted, with ghost lids). `Piece = 0` lays out every piece; `Piece = N` exports one.
- **Tests** set `Piece = 99` to skip geometry, so they run fast. Exercise other configurations with `-D 'Pack="..."'` and `-D Set_quantity=2`.
- **Pack presets** cite catalog listings in the header. Preset counts are checked by test A, so a preset change updates the test in the same change.
- **Attribution**: the channel cross-section derives from a user-supplied STL. Keep the header's attribution and licensing note.
