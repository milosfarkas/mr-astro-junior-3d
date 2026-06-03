# 06 — Level 1 + Level 2 Scene Content

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create `level_1.tscn` and `level_2.tscn` as playable level scenes using the systems built in previous slices.

**Level 1**: One box. No items, no enemies. Portal at the far end (requires no key). Player spawns at the start of the box. Walking into the portal transitions to level 2.

**Level 2**: One box (different layout from level 1). A key-type `PickupItem` is placed somewhere in the level. Portal is locked (requires_key = true). Player must find the key, then walk through the portal to reach level 3.

## Acceptance criteria

- [x] `level_1.tscn` has one box, portal at end (no key required), player spawn point
- [x] Walking through portal in level 1 → level 2 loads
- [x] `level_2.tscn` has one box, one key pickup item, portal that requires key
- [x] Collecting key in level 2 → HUD shows key icon → portal turns green → enter portal → next level
- [x] Death in either level → start screen, items reset
- [x] Both levels registered in State level progression (index 1 and 2)

## Blocked by

- `docs/issues/03-hud-inventory-portal-key.md`
- `docs/issues/05-ui-overlay-level-select-credits.md`

## Status

**COMPLETED**

## Implementation notes

- `level_1.gd` — one `box_start`, portal at z=-9 (no key required, starts green/open)
- `level_2.gd` — one `box_start`, key PickupItem at (5, 0.5, 5), portal at z=-9 (requires_key=true, auto-opens when key collected via State.inventory_changed)
- Portal `requires_key` bug fixed: was `if not requires_key` (subscribing to inventory_changed), now correctly `if requires_key`
- Portal without `requires_key` now starts open (green) instead of always starting red