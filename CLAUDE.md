# CLAUDE.md

Guidance for Claude Code (claude.ai/code) and other AI assistants working in this repository.

## Repository Overview

A collection of parametric 3D models authored in **OpenSCAD**. Models target FDM printing, primarily on a Bambu H2D with a 0.6 mm nozzle, PETG filament.

## Repository Layout

```
.
├── CLAUDE.md            (this file — repo-wide guidance)
├── README.md            (user-facing)
├── LICENSE              (MIT)
├── .github/workflows/   (Claude Code GitHub Actions)
└── src/
    ├── lib/             (reusable OpenSCAD modules, currently empty)
    ├── parts/           (individual printable parts — see src/parts/CLAUDE.md)
    └── assemblies/      (multi-part assemblies, currently empty)
```

Most active work is in **`src/parts/`** — see `src/parts/CLAUDE.md` for OpenSCAD conventions, test patterns, and per-part design docs.

## Authoring Conventions

- **Units:** millimeters everywhere. Angles in degrees.
- **Coordinate system:** right-handed. Z points up (away from the print bed) by convention, unless a part's header comment states otherwise.
- **Parameterization:** use Customizer-annotated parameters (`// [a, b, c]` for dropdowns, `// [0:0.1:1]` for sliders). Save concrete parameter sets in a sibling `<part>.json` Customizer file.
- **Multi-part files:** when a single SCAD file produces multiple printable parts (e.g. body + insert), dispatch with a top-level `part` variable. See `src/parts/directional-vent.scad` for the pattern.
- **Tests:** when a part has non-trivial derived geometry (solvers, geometric invariants), accompany it with a `<part>-test.scad` file using top-level `assert()` and `echo()`. Run via `openscad -o /tmp/x.stl <part>-test.scad`; non-zero exit = test failure.

## OpenSCAD Version

Target **OpenSCAD 2021.01** (the stable release). Avoid features only in the development snapshots unless documented per-file.

## Rendering and Testing

From any directory containing a `<part>.scad`:

```bash
# Render to STL (uses default parameter values)
openscad -o <part>.stl <part>.scad

# Render with a saved Customizer parameter set
openscad -p <part>.json -P "<set name>" -o <part>.stl <part>.scad

# Override individual parameters
openscad -D 'param_name=value' -o <part>.stl <part>.scad

# Run assertion-based tests (exits non-zero on failure)
openscad -o /tmp/discard.stl <part>-test.scad
```

## GitHub Actions Integration

Two workflows are configured (`.github/workflows/`):

1. **claude.yml** — PR assistant triggered by `@claude` mentions in issues/PRs.
2. **claude-code-review.yml** — automated code review on PR open/synchronize.

Both require `CLAUDE_CODE_OAUTH_TOKEN` to be set in repository secrets.

## Commit Conventions

Conventional Commits:
- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation only
- `chore:` maintenance
- `refactor:` code restructuring (no behavior change)
- `test:` test additions or changes

Example: `feat(directional-vent): add slide-in throttle plate`

## License

MIT. See `LICENSE`.
