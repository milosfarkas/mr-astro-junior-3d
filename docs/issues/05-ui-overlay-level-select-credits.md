# 05 — Start/Death Overlay + Level Select + Credits

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a UI overlay scene (Control) with "Continue" and "Level Select" buttons. Continue loads the highest unlocked level. Level Select shows a grid of buttons for levels 1-4, with locked levels greyed out/unclickable. The overlay is shown on game start (a special "start" scene or autoloaded overlay) and on death. After completing level 4 (portal in level 4 is entered), show a credits/you-win screen instead of loading a next level.

## Acceptance criteria

- [ ] Overlay scene with "Continue" and "Level Select" buttons
- [ ] Continue loads `State.highest_unlocked_level()` scene
- [ ] Level Select shows buttons for levels 1-4; locked levels are visible but disabled
- [ ] Levels unlock in State when the player reaches them (entering a level adds it to unlocked map)
- [ ] Overlay appears on death (kill plane triggers scene reload + show overlay? or a separate intermediary scene?)
- [ ] Credits/you-win screen appears when portal in level 4 is entered
- [ ] Credits screen has a "Back to Level Select" button
- [ ] Level select returns you to the selected level scene, no carry-over state

## Blocked by

- `docs/issues/01-extend-state-portal-killplane.md`

## Further notes

Consider whether the overlay is an autoload that overlays any scene, or a dedicated scene (like `start.tscn`) that loads before any level. The simpler approach: a dedicated `start.tscn` that shows buttons, loads the selected level, and is re-shown on death (kill plane → `change_scene_to_file("start.tscn")` instead of reloading the level directly).
