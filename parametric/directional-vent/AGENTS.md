# directional-vent/AGENTS.md

Read `directional-vent.md` (the design contract) before any non-trivial change: its hard constraints (lip-down orientation, the fixed 49° slat angle, throttle below the slats) are load-bearing for printability and airflow.

- **Production set**: "New set 1" in `directional-vent.json` is the current print. Run the tests against it:
  `openscad -p directional-vent.json -P "New set 1" -o /tmp/x.stl directional-vent-test.scad`
- **Two outputs** via `part`: `vent` (default) and `throttle`. Re-render both after a change.
- **Open-area sweep**: the throttle tests must also pass with `side_open_area` and `center_open_area` each at 0.01, 0.05, 0.10, and 0.25; set them with `-D`.
