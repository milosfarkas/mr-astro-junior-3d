# Handover — `ramps` branch

## Goal

Investigate and prototype the world-rotation ramp mechanic for a dice cube (a 6×6×6 room the player walks inside). Each of the 12 edges of the dice gets a ramp that, when triggered, rotates the world 90° around that edge so the player can move between two adjacent faces of the dice.

## Background context (failed attempts, reverted)

Earlier work tried to add a second ramp to `box_explore.tscn` (ceiling ramp) that cycled the world between ceiling and side wall. Multiple approaches were tried and reverted:

- Per-ramp `rotation_axis` export on `ramp.gd`, with `box.gd` reading it.
- Per-ramp `default_state` (alternating ±) on `ramp.gd`.
- A `ceiling_ramp` export on `Box` and a separate `turn_ceiling_to_side()` method.

None produced the expected rotation direction (player kept ending up sideways on a wall instead of on the ceiling). All these changes were reverted via `git stash drop` and `box.gd` / `ramp.gd` are back to their committed state on `92618a6`.

The leftover artifact from that work is `box_explore.tscn`, which still contains a `ceilingRamp` Marker3D the user added in Godot, but no ceiling ramp node and no extra exports on the Box.

## New approach (this branch's actual work)

Instead of editing the existing box scenes, the user pivoted to a fresh, isolated test scene — a 6×6×6 dice cube — to figure out the ramp orientation rule empirically. The plan: place 12 ramps (one per dice edge) with the correct orientation, then later wire the rotation mechanic.

### Files added

- **`mr-astro-junior-3d/scene/dice_cube.tscn`** — a 6×6×6 cube (floor + 4 walls + ceiling, all CSGBox3D with collision), with dice-dot CSGSphere3Ds on each face inset into the inner surface, two DirectionalLight3Ds for default lighting, an OmniLight3D at the cube center (added later to illuminate the ceiling), and an `Axes` node with three colored CSGBox3D arrows (red=X, green=Y, blue=Z, unshaded materials) at the cube origin as a visual gizmo.
- **`mr-astro-junior-3d/scene/level_dice.gd`** — minimal loader that instantiates `dice_cube.tscn` and procedurally spawns 12 ramp instances (one per dice edge) with computed positions and orientations.
- **`mr-astro-junior-3d/scene/level_dice.tscn`** — standalone playable scene wrapping the dice cube with Player, KillPlane, HUD, and a WorldEnvironment (ambient + tonemap). Run this in Godot (`F6`) to test.

### Files still present from earlier exploration

- `mr-astro-junior-3d/scene/box_explore.tscn` — copy of `box_start.tscn` with a `ceilingRamp` Marker3D the user added. No ceiling ramp node wired. Can be deleted once the dice prototype is the source of truth, or kept as a sandbox.
- `mr-astro-junior-3d/scene/level_explore.gd` / `level_explore.tscn` — the level wrapper that loads `box_explore.tscn`. Same status as above.

## Ramp placement rule (current understanding)

Each ramp sits at an edge of the dice, with:
- **local X** = along the edge direction (this is the rotation axis the ramp will eventually use to flip the world)
- **local Y** = perpendicular to one of the two meeting faces (the "XZ-face")
- **local Z** = perpendicular to the other meeting face (the "XY-face")

The monorail mesh inside `ramp.tscn` is already tilted 45° around its local X (basis has 0.707 on Y/Z components), so the tilted surface visually connects the XZ-face to the XY-face. The user's mental model:

```
Floor ramp (good):       Ceiling ramp (good):
|                       __
|                       /
\__                      |
                          |
```

The ramp's tilted surface must lead from one **inside** surface of the dice to the other **inside** surface — not from an inside surface outward through the wall.

### Helper code in `level_dice.gd`

```gdscript
func _basis_for(xz_normal: Vector3, xy_normal: Vector3) -> Basis:
    var local_y: Vector3 = xz_normal.normalized()
    var local_z: Vector3 = xy_normal.normalized()
    var local_x: Vector3 = local_z.cross(local_y)
    return Basis(local_x, local_y, local_z)
```

Convention: `xz_normal` is the normal of the XZ-face (the face the ramp's flat side flushes with); `xy_normal` is the normal of the XY-face (the face the ramp's side flushes with). `local X = local Z × local Y` (right-handed so length points "up" on vertical edges).

### Approved extra rotations

The base `_basis_for(...)` call gives a starting orientation. For most ramps an extra rotation around the edge axis (= world axis parallel to local X) is needed to make the monorail's 45° tilt slope the correct way (into the cube, not outward).

**Floor ramps** (XZ-face = floor, XY-face = wall):

| Edge | Position | Length axis | `_basis_for` args | Extra rotation |
|---|---|---|---|---|
| Back (Z=−3) | `(0, 0.5, −2.5)` | X | `(UP, BACK)` | 180° around X |
| Front (Z=+3) | `(0, 0.5, 2.5)` | X | `(UP, FORWARD)` | 180° around X |
| Left (X=−3) | `(−2.5, 0.5, 0)` | Z | `(UP, LEFT)` | 90° around Z |
| Right (X=+3) | `(2.5, 0.5, 0)` | Z | `(UP, RIGHT)` | 270° around Z |

All 4 floor ramps **verified correct by user**.

**Ceiling ramps** (XZ-face = ceiling, XY-face = wall):

| Edge | Position | Length axis | `_basis_for` args | Extra rotation |
|---|---|---|---|---|
| Back (Z=−3) | `(0, 5.5, −2.5)` | X | `(DOWN, BACK)` | 0° (no extra) |
| Front (Z=+3) | `(0, 5.5, 2.5)` | X | `(DOWN, FORWARD)` | 0° (no extra) |
| Left (X=−3) | `(−2.5, 5.5, 0)` | Z | `(DOWN, LEFT)` | 270° around Z (= 90° + 180°) |
| Right (X=+3) | `(2.5, 5.5, 0)` | Z | `(DOWN, RIGHT)` | 90° around Z |

**Verified:** Left ceiling, Right ceiling.
**Not yet verified by user:** Back ceiling, Front ceiling (both at 0° extra rotation).

Observed pattern (not yet applied universally): **ceiling rotation = floor rotation + 180° around the edge axis**, modulo 360°. This explains:
- Back ceiling: floor 180° + 180° = 360° = 0° ✓ (matches what's set)
- Front ceiling: same → 0° ✓
- Left ceiling: floor 90° + 180° = 270° ✓
- Right ceiling: floor 270° + 180° = 450° = 90° ✓

So if the pattern holds, Back and Front ceiling at 0° should already be correct — but they need visual verification because the user couldn't see them clearly before the OmniLight was added.

**Vertical edges** (ramp stands on a wall, length along Y):

| Edge | Position | `_basis_for` args | Extra rotation |
|---|---|---|---|
| Back-left (X=−3, Z=−3) | `(−2.5, 3, −2.5)` | `(LEFT, BACK)` | none yet |
| Back-right (X=+3, Z=−3) | `(2.5, 3, −2.5)` | `(BACK, RIGHT)` | none yet |
| Front-left (X=−3, Z=+3) | `(−2.5, 3, 2.5)` | `(FORWARD, LEFT)` | none yet |
| Front-right (X=+3, Z=+3) | `(2.5, 3, 2.5)` | `(RIGHT, FORWARD)` | none yet |

**None verified yet.** The vertical-edge ramp orientations are guesses; the XZ/XY face assignments were picked ad-hoc to make `local X = UP` (so the ramp length goes up, not down). They will need the same empirical rotation pass the floor ramps went through.

## What's NOT done

1. **Rotation mechanic not wired.** The ramps in `level_dice.tscn` are just visual + collision. `ramp.gd` still has the original `should_turn` signal, but nothing connects it to a world-rotation function in `level_dice.gd` (there is no `Box` here, and `box.gd`'s `turn_the_whole_world` rotates the `"level"` group + counter-rotates the `"player"` group — that logic would need to be reusable from the dice context, or a new function written).
2. **Back and Front ceiling ramps unverified.** User needs to look at them now that the OmniLight is in.
3. **All 4 vertical-edge ramps unverified and likely wrong.** Need the same iterative rotation pass.
4. **The `box_explore.tscn` / `level_explore.tscn` sandbox** is still in the working tree from earlier. Decide whether to keep or delete.
5. **`AGENTS.md` not updated** with the dice-cube prototype or the eventual ramp mechanic, if it becomes the new convention.

## How to run / verify

1. Open `mr-astro-junior-3d/` in Godot 4.4.
2. Open `scene/level_dice.tscn`.
3. `F6` to play the scene.
4. Walk around the inside of the cube with WASD. Look at each of the 12 ramps:
   - 4 on the floor (visible, walkable)
   - 4 on the ceiling (visible now with the OmniLight; not reachable without the rotation mechanic)
   - 4 on the vertical corners (visible; not reachable without the rotation mechanic)
5. To inspect a specific ramp's orientation without playing, open `scene/level_dice.gd` and find the corresponding `# <edge>` comment. Adjust the `Quaternion(<axis>, <angle>)` extra rotation line, save, and re-run.

## Key conventions to preserve

- **No comments in code** unless asked (AGENTS.md rule). The current `level_dice.gd` has comments for each edge — these were added for the user's clarity during the iterative rotation pass. If the user wants them removed, do so.
- **`Box.create(tscn_path)`** static factory pattern (AGENTS.md). The dice prototype does NOT use `Box` — it instantiates scenes directly. If the dice becomes a real game element, consider wrapping it in the `Box` convention or a new convention.
- **Autoload `State`** manages level progression. The dice prototype is not wired into `State.LEVEL_PATHS` and is not reachable from the start screen. Add it to `state.gd` `LEVEL_PATHS` if it should become a real level.