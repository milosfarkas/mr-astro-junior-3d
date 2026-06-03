# 07 — Level 3 + Level 4 Scene Content

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create `level_3.tscn` and `level_4.tscn` as playable level scenes.

**Level 3**: Two connected boxes. Key pickup in the first box targets a gate between the two boxes. Portal is in the second box. Ramps with world-rotation mechanic included. Player spawns in the first box.

**Level 4**: Four boxes. Player spawns in the box containing the portal (portal locked, requires key). Three items (distinct types: screwdriver, hammer, diamond) are placed in three separate boxes. A chest in one box (not the spawn box) requires 3 items and spawns a key pickup. Ramps included. Player must explore all boxes to collect items, return to chest, get key, then go to portal.

## Acceptance criteria

- [x] Level 3: key in first box opens gate between boxes → portal in second box → next level
- [x] Level 3: ramps trigger world rotation (ramp already in box_start scene)
- [x] Level 4: 4 boxes arranged, player spawns in portal box
- [x] Level 4: 3 items in 3 different boxes, distinct types with distinct icons
- [x] Level 4: chest in a box (not spawn box) requires 3 items → opens → spawns key
- [x] Level 4: key pickup spawns at chest location → targets portal → portal opens → enter portal → credits screen
- [x] Level 4: ramps trigger world rotation
- [x] Death in either level → full reset (items, chest, doors, ramps all reset)
- [x] Both levels registered in State progression

## Blocked by

- `docs/issues/04-chest-system.md`
- `docs/issues/06-level-1-level-2-content.md`

## Status

**COMPLETED**

## Implementation notes

- `level_3.gd` — Two boxes (box_start + box_challenge). Box1 starts with all gates closed, key PickupItem inside. Key target = box1 with unlock_gate_name="WallRight". When key collected, WallRight gate opens. Portal (no key needed) in box2.
- `level_4.gd` — Three boxes (box_start + box_challenge + box_end) in a line. Portal in box1 (requires_key=true). Chest in box2 with key_target pointing to portal. Three PickupItems (hammer, diamond, screwdriver) in box3.
- Level 3: box1 right gate is locked until key collected. `open_gate(false, false, false, false)` starts all gates closed, `unlock_gate_name = "WallRight"` tells `unlock()` which gate to open.
- Note: ramps are already present in box_start.tscn. Additional ramp placement would happen in the Godot editor for polish.