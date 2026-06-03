# 07 — Level 3 + Level 4 Scene Content

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create `level_3.tscn` and `level_4.tscn` as playable level scenes.

**Level 3**: Two connected boxes. Key pickup in the first box targets a gate between the two boxes. Portal is in the second box. Ramps with world-rotation mechanic included. Player spawns in the first box.

**Level 4**: Four boxes. Player spawns in the box containing the portal (portal locked, requires key). Three items (distinct types: screwdriver, hammer, diamond) are placed in three separate boxes. A chest in one box (not the spawn box) requires 3 items and spawns a key pickup. Ramps included. Player must explore all boxes to collect items, return to chest, get key, then go to portal.

## Acceptance criteria

- [ ] Level 3: key in first box opens gate between boxes → portal in second box → next level
- [ ] Level 3: ramps trigger world rotation
- [ ] Level 4: 4 boxes arranged, player spawns in portal box
- [ ] Level 4: 3 items in 3 different boxes, distinct types with distinct icons
- [ ] Level 4: chest in a box (not spawn box) requires 3 items → opens → spawns key
- [ ] Level 4: key pickup spawns at chest location → targets portal → portal opens → enter portal → credits screen
- [ ] Level 4: ramps trigger world rotation
- [ ] Death in either level → full reset (items, chest, doors, ramps all reset)
- [ ] Both levels registered in State progression

## Blocked by

- `docs/issues/04-chest-system.md`
- `docs/issues/06-level-1-level-2-content.md`

## Further notes

Level 3 and 4 are content-heavy slices — the systems (items, gates, chests, portals, ramps) are all built in prior slices. These scenes primarily wire them together in the editor.
