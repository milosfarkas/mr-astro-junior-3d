# 02 — PickupItem System + Gate Unlocking

## Parent

`docs/PRD.md` — Level Progression System

## What to build

Create a new `PickupItem` scene and script that replaces the old `diamond.gd`. Each item has an `@export NodePath target` pointing to a door, gate, portal, or chest it unlocks, and an `@export String item_type` for HUD icon selection. When the PlayerCharacter walks into the item's collision area, the item adds itself to State inventory and calls an `unlock()` method on its target (e.g. sets gate visibility). The gate system is extended to support being unlocked by an item rather than being set at scene start.

## Acceptance criteria

- [ ] `PickupItem` scene with `Area3D` collision, `@export target: NodePath`, `@export item_type: String`
- [ ] On PlayerCharacter enters area → item added to State inventory → target receives unlock signal/call
- [ ] Gate supports "locked until unlocked by item" state (stays hidden after unlock even on scene reload? No — full reset on death means gate is visible again after reload)
- [ ] Gate accepts an unlock method that sets `visible = false`
- [ ] Item becomes invisible and stops colliding after pickup
- [ ] Works with any target node that has an `unlock()` method (gate, portal, chest)

## Blocked by

- `docs/issues/01-extend-state-portal-killplane.md`

## Further notes

The old `diamond.gd` (which directly calls `State.open_portal()`) should be removed or replaced. The target-based wiring makes items reusable across levels without per-item scripting.
