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

## No Build/Test/Lint CLI

This is a Godot project — run and test via the Godot editor. No CI, no CLI test runner, no linter configured.