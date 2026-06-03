# 04 — Chest System

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a new `Chest` scene with `@export int required_item_count` (default 3). When the PlayerCharacter walks into the chest collision area with enough items in State inventory, the chest hides itself and spawns a `PickupItem` (key type) at a nearby spawn point. If the player has fewer than the required count, nothing happens.

## Acceptance criteria

- [x] `Chest` scene with visible mesh, `Area3D` collision, `@export required_item_count: int`, `@export key_spawn_offset: Vector3`
- [x] PlayerCharacter enters chest area with enough items → chest hides → `PickupItem` key spawns at offset position
- [x] PlayerCharacter enters chest area with not enough items → nothing happens (no message, no effect)
- [x] Spawned key uses the `PickupItem` system from Slice 2 (has `@export target` pointing to a portal)
- [x] Chest resets on level reload (death) — reappears, key despawns
- [x] Works end-to-end: collect 3 items → approach chest → chest opens, key spawns → pick up key → portal opens

## Blocked by

- `docs/issues/02-pickup-item-gate-unlocking.md`

## Status

**COMPLETED**

## Implementation notes

- `chest.gd` — on collision with PlayerCharacter, checks `State.item_count() >= required_item_count`. If enough: hides, disables Area3D monitoring, spawns PickupItem key at `global_position + key_spawn_offset`. Uses `get_path_to()` to resolve `key_target` NodePath from the spawned key's perspective.
- `chest.tscn` — scene with BoxMesh placeholder, Area3D + CollisionShape3D
- Chest and spawned key both reset on scene reload (death)