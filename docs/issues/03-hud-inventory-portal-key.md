# 03 — HUD Inventory Display + Portal Key Requirement

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Add a HUD overlay (Control node) that displays collected item icons by reading from State inventory. Make the Portal configurable to require a key — it stays red and blocked until a key-type item is in the player's inventory. When the player approaches with the required item, the portal turns green and becomes traversable.

## Acceptance criteria

- [x] HUD `Control` node shows item icons for each item in State inventory (grid or horizontal bar)
- [x] HUD updates dynamically when items are picked up
- [x] HUD clears when inventory resets (death, new level)
- [x] Portal has `@export requires_key: bool` — if true, stays red until a key-type item is in inventory
- [x] Portal turns green when key is collected
- [x] Portal only transitions to next level when open (green) and player enters collision area
- [x] Works end-to-end: pick up key → HUD shows key icon → portal turns green → walk through → next level

## Blocked by

- `docs/issues/02-pickup-item-gate-unlocking.md`

## Status

**COMPLETED**

## Implementation notes

- `hud.gd` + `hud.tscn` — CanvasLayer with MarginContainer/HBoxContainer, dynamically creates colored Labels for each inventory item. Responds to `State.inventory_changed` signal.
- `State` now emits `inventory_changed` signal on every mutation (`add_item`, `clear_inventory`, level transitions).
- Portal has `@export requires_key: bool`. When true, subscribes to `State.inventory_changed` and auto-opens when `State.has_item("key")` becomes true.
- HUD is instanced inside `level_1.tscn` and `level_2.tscn` (will be added to all levels).