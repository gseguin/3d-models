# 3d-models
A collection of parametric 3D models for FDM printing, written in OpenSCAD.

| Model | What it is |
|---|---|
| [directional-vent](parametric/directional-vent/) | Restrictive, directional HVAC ceiling vent insert with a swappable throttle plate. |
| [gf-silverware-bin](parametric/gf-silverware-bin/) | Gridfinity silverware organiser sized to your cutlery. |
| [h2d-pen-adapter](parametric/h2d-pen-adapter/) | Adapters that fit common pens into the Bambu H2D pen holder. |
| [snapware-lid-holder](parametric/snapware-lid-holder/) | Under-shelf rack that hangs Snapware lids vertically. |

Each model directory has a `README.md` with its options, render commands, and print settings.

Agent guidance lives in `AGENTS.md` at the root, in `parametric/`, and in each model directory. The GitHub Actions workflows in `.github/workflows/` (`@claude` assistant, automated PR review) need a `CLAUDE_CODE_OAUTH_TOKEN` repository secret.
