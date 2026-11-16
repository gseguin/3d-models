# gf-silverware-bin/AGENTS.md

This part has no design contract and no test file, so the header comment of `gf-silverware-bin.scad` is the authority: feature list, usage, and version history.

- **Versioning**: the header title carries the version (`V10.38`). Every behaviour change bumps it and adds a `Version History` entry describing the bug or feature, and the commit subject cites it: `fix(gf-silverware-bin): ... (V10.38)`.
- **Published model**: users report issues from MakerWorld, so keep defaults that load and render cleanly on a fresh Customizer open.
- **Verification**: render the defaults and "New set 1" in `gf-silverware-bin.json`, plus each mode a change touches: `config_mode` (`manual` / `wizard`), `generate_test_slice`, `generate_2d_footprint`, and `part_to_render` (`0` full, `1` / `2` split halves for beds smaller than the footprint).
