# 01 — Extend State Autoload + Portal Navigation + Kill Plane

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Extend the existing `State` autoload singleton to manage level progression and inventory. Modify the Portal to read the next level destination from State instead of using a hardcoded scene path. Add a global kill plane below each level that reloads the current scene on player fall. Remove the old per-box death zone. Create two test level scenes to verify portal progression and death restart work end-to-end.

## Acceptance criteria

- [x] `State` tracks `current_level: int`, unlocked levels map, and inventory array (cleared on level load and on death)
- [x] Portal calls `State.go_to_next_level()` which triggers `change_scene_to_file` to the correct next level scene
- [x] Portal no longer has a hardcoded scene path
- [x] Global kill plane exists in a level scene — player falling through it reloads the current level
- [x] Death clears inventory in State, doors and items reset (via scene reload)
- [x] `Box._on_area_3d_body_entered` death-zone logic removed
- [x] Two test level scenes confirm: portal A→B works, death on B reloads B

## Blocked by

None — can start immediately.

## Status

**COMPLETED**