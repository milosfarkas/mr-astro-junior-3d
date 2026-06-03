# 03 — HUD Inventory Display + Portal Key Requirement

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Add a HUD overlay (Control node) that displays collected item icons by reading from State inventory. Make the Portal configurable to require a key — it stays red and blocked until a key-type item is in the player's inventory. When the player approaches with the required item, the portal turns green and becomes traversable.

## Acceptance criteria

- [ ] HUD `Control` node shows item icons for each item in State inventory (grid or horizontal bar)
- [ ] HUD updates dynamically when items are picked up
- [ ] HUD clears when inventory resets (death, new level)
- [ ] Portal has `@export requires_key: bool` — if true, stays red until a key-type item is in inventory
- [ ] Portal turns green when key is collected
- [ ] Portal only transitions to next level when open (green) and player enters collision area
- [ ] Works end-to-end: pick up key → HUD shows key icon → portal turns green → walk through → next level

## Blocked by

- `docs/issues/02-pickup-item-gate-unlocking.md`
