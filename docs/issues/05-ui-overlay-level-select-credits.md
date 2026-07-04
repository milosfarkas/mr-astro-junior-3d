# 05 — Start/Death Overlay + Level Select + Credits

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a UI overlay scene (Control) with "Continue" and "Level Select" buttons. Continue loads the highest unlocked level. Level Select shows a grid of buttons for levels 1-4, with locked levels greyed out/unclickable. The overlay is shown on game start (a special "start" scene or autoloaded overlay) and on death. After completing level 4 (portal in level 4 is entered), show a credits/you-win screen instead of loading a next level.

## Acceptance criteria

- [x] Overlay scene with "Continue" and "Level Select" buttons
- [x] Continue loads `State.highest_unlocked_level()` scene
- [x] Level Select shows buttons for levels 1-4; locked levels are visible but disabled
- [x] Levels unlock in State when the player reaches them (entering a level adds it to unlocked map)
- [x] Overlay appears on death — kill plane triggers `State.reload_current_level()` which loads `start.tscn`
- [x] Credits/you-win screen appears when portal in level 4 is entered
- [x] Credits screen has a "Back to Level Select" button
- [x] Level select returns you to the selected level scene, no carry-over state

## Blocked by

- `docs/issues/01-extend-state-portal-killplane.md`

## Status

**COMPLETED**

## Implementation notes

- `start.tscn` / `start_screen.gd` — Start screen with "Continue" and "Level Select" (4 buttons, locked ones disabled). Continue calls `State.start_level(State.highest_unlocked_level())`.
- `credits.tscn` / `credits.gd` — "You Win!" screen with "Back to Level Select" button. Triggered by `State.go_to_next_level()` when level 4 is completed (no level 5 exists).
- `State.reload_current_level()` now loads `start.tscn` instead of the current level — death always goes to start screen.
- `State.highest_unlocked_level()` returns the highest unlocked level number.
- `project.godot` main scene changed from `level_1.tscn` to `start.tscn`.