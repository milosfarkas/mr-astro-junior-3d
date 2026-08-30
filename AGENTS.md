# AGENTS.md

## Project

Mr. Astro Junior 3D — a Godot 4.4 3D platformer/adventure game. GDScript only, no C#.

## Structure

- **Godot project root** is `mr-astro-junior-3d/` (not the repo root). Open this folder in Godot, not the repo root.
- `mr-astro-junior-3d/scene/` — all game scenes and scripts
- `mr-astro-junior-3d/scene/character/` — player, camera controller, animation tree
- `mr-astro-junior-3d/addons/` — third-party (proto_controller by Brackeys, CC0)
- `mr-astro-junior-3d/assets/` — imported models and textures (KayKit, Kenney packs)
- `blender/` — source .blend files and exported .glb models

## Key Conventions

- **Autoload singleton `State`** (`scene/state.gd`, class `GameState`) manages level progression and inventory. Access via `State.some_method()` everywhere — do not create new singletons for global state without adding them to `project.godot` `[autoload]`. Key methods: `go_to_next_level()`, `reload_current_level()`, `start_level(n)`, `add_item(type)`, `has_item(type)`, `item_count()`, `clear_inventory()`.
- **Level scenes** are `level_1.tscn` through `level_4.tscn`. Portal navigation uses `State.go_to_next_level()`, not hardcoded paths. Main scene is `start.tscn` (start/death overlay).
- **Kill plane** (`kill_plane.tscn`) is an instanced `Area3D` placed below each level. Player falling into it calls `State.reload_current_level()`, which loads `start.tscn` (not the level directly). Box death zones have been removed.
- **Player class_name is `PlayerCharacter`** (not "Player"). `Player` is the scene node name.
- **`Box.create(tscn_path)`** is a static factory for instancing box scenes. Follow this pattern for new scene-loading scripts rather than calling `instantiate()` directly.
- **`PickupItem`** (`scene/pickup_item.gd`) is the collectible item. Has `@export target: NodePath` (what it unlocks) and `@export item_type: String`. On player collision: adds to `State` inventory, calls `unlock()` on target, then hides itself. Target can be a Box, Portal, or any node with `unlock()`.
- **`Box.unlock()`** opens a gate specified by `@export unlock_gate_name`. Gate name must match a wall child: `WallFront`, `WallRight`, `WallBack`, or `WallLeft`. `Portal.unlock()` opens the portal — same as `open_portal()`.
- **Portal** has `@export requires_key: bool`. If true, stays red until `State.has_item("key")` is true, then turns green automatically via `inventory_changed` signal.
- **HUD** (`scene/hud.gd`) is an instanced `CanvasLayer` in each level scene. Shows item labels from `State.inventory`. Responds to `State.inventory_changed` signal. Currently uses text labels; icons to be added later.
- **`diamond.gd`** is legacy — use `PickupItem` for new items.
- **`Chest`** (`scene/chest.gd`) requires N items to open. Has `@export required_item_count: int`, `@export key_spawn_offset: Vector3`, `@export key_target: NodePath`. On player collision with enough items in inventory: hides itself, spawns a `PickupItem` (key) at offset position, wires key's target to `key_target`. Resets on level reload via scene reload.
- **Start screen** (`scene/start.tscn`) is the main scene. Shows "Continue" (loads highest unlocked level) and "Level Select" (buttons for levels 1-4, locked ones disabled). Death loads this screen via `State.reload_current_level()`.
- **Credits screen** (`scene/credits.tscn`) shows "You Win!" after completing level 4. Has "Back to Level Select" button that loads `start.tscn`.
- **Character animations** go through `AnimationTree` with a `MoveStateMachine` and `AttackOneShot`. Set states via `skin.set_move_state("idle"/"running"/"jump")` and trigger attack via `skin.attack()`.
- **World rotation mechanic (die-roll model)**: a `Ramp` (`scene/ramp.gd`) is a trigger that rolls the whole `Level` node 90° across a box edge, like rolling a die from one face to an adjacent face. The player is counter-rotated to stay upright.
  - **`Ramp`** is a pure trigger. It has `@export var faces: Array[Box.Face]` (the edge — exactly 2 faces the ramp sits between, e.g. `[BOTTOM, FRONT]`) and `@export var box: Box` (the parent box whose die geometry applies). On player contact + `emittable`: emits `should_turn(faces, box)`, starts a per-ramp 0.1s debounce `Timer`, plays the whoosh. Self-registers in the `"ramp"` group on `_ready`. No references to Level or player.
  - **`Box`** (`scene/box.gd`) owns the die geometry: `enum Face { FRONT, BACK, LEFT, RIGHT, BOTTOM, TOP }`, a `FACE_NORMALS` dict, and `roll_basis(from_face, to_face) -> Dictionary` returning `{axis: Vector3, angle: float}` for the 90° roll that takes `from_face` onto `to_face`.
  - **`LevelBase`** (`scene/level_base.gd`, `class_name LevelBase`) is the base class all level scripts extend. Has `@export var player: Node3D` (must be set in each `level_N.tscn` to the `Player` node), a `turning` lock, and `_on_should_turn(edge, box)`. Derives the current floor face from the level's own basis each press (`_current_floor_face()`), picks the edge face that isn't current floor as the target, calls `box.roll_basis(current_floor, target_face)`, rotates the level and counter-rotates the player. In `_ready`: awaits one frame, then connects every node in the `"ramp"` group's `should_turn` signal to `_on_should_turn`. Ignored silently with `push_warning` if the edge doesn't include the current floor face.
  - **To author a ramp in a box scene**: place a `Ramp` instance, set `faces` to the two `Box.Face` values for the edge (e.g. `[BOTTOM, BACK]`), and set `box` to the parent `Box` node. The ramp only fires when one of its two faces is currently the floor.
  - **To wire a level**: ensure the `Level` node's `player` export is set to the `Player` node (already set in `level_1.tscn`–`level_5.tscn` and `level.tscn`). Ramps are discovered automatically via the `"ramp"` group — no manual signal wiring needed.
  - **Multiple ramps per box are supported** — each declares its own edge. All ramps in the level fire through the same `_on_should_turn` handler on `LevelBase`.
- **Color palette** is in `mr-astro-junior-3d/notes.md` (dark orange #e76c21, orange #ea9335, dark blue #0a4a7b, blue #5377b3, light blue #b6cade, purple #4f2949).

## Engine Config

- Renderer: GL Compatibility (mobile)
- Physics: JoltPhysics3D (not default Godot physics)
- Input: WASD + arrows (left/right/forward/backward), Space (jump), Left click (attack), Shift (sprint)

## Level 7 — 2x2x2 Cube (Die-Roll Level)

Level 7 (`scene/level_7.tscn`, `scene/level_7.gd`) is a 2×2×2 cube of 8 boxes forming a giant die. Boxes are 20×20×10 (floor size 20×20, ceiling at y=10), spaced 20 in X/Z and 20 in Y (so ceilings/floors meet).

### Box layout

Ground floor (y=0):
```
a(0,0,0)  b(20,0,0)
c(0,0,20) d(20,0,20)
```
Top floor (y=20, all flipped 180° X so they hang upside down):
```
e(0,20,0)   f(20,20,0)
g(0,20,20)  h(20,20,20)
```
- `box_a` and `box_e` use `box_start.tscn` (same as level 6 start/end box).
- `box_b`, `box_c`, `box_d`, `box_g` are plain boxes (`box_b/c/d/g.tscn`). The chest and three diamonds (blue/yellow/green) are spawned in `level_7.gd` (`_spawn_diamonds` + `CHEST.instantiate()`), not baked into the box scenes. The chest's `key_target` is wired to the portal; collecting all 3 diamonds opens the chest, which spawns a key whose pickup turns the display walls green and opens the portal.
- `box_f` is a lava challenge box (`box_f.tscn`) — lava on faces 1 (Floor) and 2 (WallFront).
- `box_h` is a plain box (`box_h.tscn`).
- Top boxes (e,f,g,h) are placed via `Transform3D(Basis.IDENTITY.rotated(Vector3(1, 0, 0), PI), position)` — rotated 180° X, so local TOP points down.

### Dice face mapping

The 2×2×2 cube is named like a die. Opposite faces sum to 7.

| Dice # | Side of the 2×2×2 cube | `Box.Face` enum | enum value |
|--------|------------------------|-----------------|------------|
| 1 | floor (a,b,c,d bottom) | `BOTTOM` | 4 |
| 2 | front (+Z, c,d,g,h side) | `FRONT` | 0 |
| 3 | right (+X, b,d,f,h side) | `RIGHT` | 3 |
| 4 | left (−X, a,c,e,g side) | `LEFT` | 2 |
| 5 | back (−Z, a,b,e,f side) | `BACK` | 1 |
| 6 | ceiling (a,b,c,d top) | `TOP` | 5 |

Opposite pairs: 1↔6 (BOTTOM↔TOP), 2↔5 (FRONT↔BACK), 3↔4 (RIGHT↔LEFT). Opposite faces cannot form a ramp edge (no shared edge to roll across).

### Doors (open gates between boxes)

- A↔E: ceiling gate on both (vertical shaft, face 6)
- E↔F: e's right (+X) + f's left (−X)
- F↔H: f's back (−Z, local "front" under flip) + h's front (+Z, local "back" under flip)
- H↔D: ceiling gate on both (vertical shaft, face 6)
- D↔C: d's left (−X) + c's right (+X)
- D↔B: d's front (−Z) + b's back (−Z)
- Box G is closed (no doors).

### Ramps

Each ramp has `faces = Array[int]([faceA, faceB])` using `Box.Face` enum values. The `_on_should_turn` handler in `level_base.gd` requires one of the two faces to be the player's current floor face; it rolls the level from current floor → the other face. Ramp edges must be adjacent faces (not opposite).

- **Box A ceiling ramp**: `[TOP, BACK]` = `[5, 1]` (dice 6→5)
- **Box D ceiling ramp**: `[TOP, BACK]` = `[5, 1]` (dice 6→5)
- **Box E ceiling ramp**: `[BACK, BOTTOM]` = `[1, 4]` (dice 5→1)
- **Box H ceiling ramp**: `[TOP, BACK]` = `[5, 1]` (dice 6→5)
- **Box F Ramp1**: `[FRONT, BOTTOM]` = `[0, 4]` (dice 2→1)
- **Box F Ramp2**: `[FRONT, TOP]` = `[0, 5]` (dice 2→6)

### Flipped boxes (top floor)

Top boxes (e,f,g,h) are rotated 180° X. This means:
- Local `TOP` (dice 6) points DOWN → player stands on local TOP
- Local `FRONT` (+Z) points to world −Z, local `BACK` (−Z) points to world +Z
- Left/right are unchanged
- `open_gate(front, right, back, left)` calls use LOCAL axes; world directions are swapped for front/back

### Lava in Box F

`box_f.tscn` has lava (orange emissive material + `Area3D` trigger → `State.die_on_lava()`) on:
- Face 1 (Floor / `BOTTOM`) — the floor CSG box has the lava material, Area3D covers it
- Face 2 (WallFront / `FRONT`) — the front wall CSG box has lava material, Area3D covers it
Rocks and lava sound emitters are placed in-scene for editor adjustment.

### Debug logging

`level_base.gd` `_on_should_turn` prints `[RAMP]` logs with before/after floor face and the declared edge, using `_face_name()` which includes dice numbers (e.g. `TOP(6)`, `BOTTOM(1)`).

## No Build/Test/Lint CLI

This is a Godot project — run and test via the Godot editor. No CI, no CLI test runner, no linter configured.