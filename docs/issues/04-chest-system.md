# 04 — Chest System

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a new `Chest` scene with `@export int required_item_count` (default 3). When the PlayerCharacter walks into the chest collision area with enough items in State inventory, the chest hides itself and spawns a `PickupItem` (key type) at a nearby spawn point. If the player has fewer than the required count, nothing happens.

## Acceptance criteria

- [ ] `Chest` scene with visible mesh, `Area3D` collision, `@export required_item_count: int`, `@export key_spawn_offset: Vector3`
- [ ] PlayerCharacter enters chest area with enough items → chest hides → `PickupItem` key spawns at offset position
- [ ] PlayerCharacter enters chest area with not enough items → nothing happens (no message, no effect)
- [ ] Spawned key uses the `PickupItem` system from Slice 2 (has `@export target` pointing to a portal)
- [ ] Chest resets on level reload (death) — reappears, key despawns
- [ ] Works end-to-end: collect 3 items → approach chest → chest opens, key spawns → pick up key → portal opens

## Blocked by

- `docs/issues/02-pickup-item-gate-unlocking.md`

## Further notes

The chest does not need animation or sound — just hide the mesh. The key that spawns is a standard `PickupItem` with target wired to a portal, so no special chest-to-portal logic is needed.
