# AGENTS.md

Parametric OpenSCAD models for FDM printing. Each model lives in its own directory, `parametric/<part>/`. Read `parametric/AGENTS.md` for the part workflow, test conventions, and print limits before touching any part.

## Conventions

- Millimetres and degrees. Right-handed, Z up from the bed, unless a part's header comment says otherwise.
- Target OpenSCAD 2021.01. A file that needs a dev-snapshot feature says so in its header.
- Parameters carry Customizer annotations (`// [a, b, c]` dropdown, `// [0:0.1:1]` slider); concrete parameter sets go in a sibling `<part>.json`.

## Render and test

Run from the part's directory:

```bash
openscad -o <part>.stl <part>.scad                                # defaults
openscad -p <part>.json -P "<set name>" -o <part>.stl <part>.scad # saved Customizer set
openscad -D 'param=value' -o <part>.stl <part>.scad               # override one parameter
openscad -o /tmp/discard.stl <part>-test.scad                     # tests: exit 0 = pass
```

Precedence: `-D` beats the `.json` set, which beats the `.scad` default.

## Commits

Conventional Commits, scoped by part name: `feat(directional-vent): add slide-in throttle plate`. Repo-wide changes go unscoped: `docs: ...`, `refactor: ...`.
