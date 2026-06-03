# 02 — PickupItem System + Gate Unlocking

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a new `PickupItem` scene and script that replaces the old `diamond.gd`. Each item has an `@export NodePath target` pointing to a door, gate, portal, or chest it unlocks, and an `@export String item_type` for HUD icon selection. When the PlayerCharacter walks into the item's collision area, the item adds itself to State inventory and calls an `unlock()` method on its target (e.g. sets gate visibility). The gate system is extended to support being unlocked by an item rather than being set at scene start.

## Acceptance criteria

- [x] `PickupItem` scene with `Area3D` collision, `@export target: NodePath`, `@export item_type: String`
- [x] On PlayerCharacter enters area → item added to State inventory → target receives unlock signal/call
- [x] Gate supports "locked until unlocked by item" state (full reset on death means gate is visible again after reload)
- [x] Gate accepts an unlock method that sets `visible = false`
- [x] Item becomes invisible and stops colliding after pickup
- [x] Works with any target node that has an `unlock()` method (gate, portal, chest)

## Blocked by

- `docs/issues/01-extend-state-portal-killplane.md`

## Status

**COMPLETED**

## Implementation notes

- `pickup_item.gd` — on collision with PlayerCharacter, adds `item_type` to State inventory, calls `unlock()` on `target` node, then hides self and disables collision
- `pickup_item.tscn` — scene with Area3D + CollisionShape3D + MeshInstance3D placeholder
- `Box.unlock()` — opens gate specified by `@export unlock_gate_name` (e.g. "WallFront" → hides `Walls/WallFront/Gate`)
- `Portal.unlock()` — alias for `open_portal()`
- `diamond.gd` kept for legacy compatibility, but new items should use PickupItem