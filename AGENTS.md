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

- **Autoload singleton `State`** (`scene/state.gd`) holds global signals. Access via `State.some_signal` everywhere — do not create new singletons for global state without adding them to `project.godot` `[autoload]`.
- **Player class_name is `PlayerCharacter`** (not "Player"). `Player` is the scene node name.
- **`Box.create(tscn_path)`** is a static factory for instancing box scenes. Follow this pattern for new scene-loading scripts rather than calling `instantiate()` directly.
- **Character animations** go through `AnimationTree` with a `MoveStateMachine` and `AttackOneShot`. Set states via `skin.set_move_state("idle"/"running"/"jump")` and trigger attack via `skin.attack()`.
- **World rotation mechanic**: `Ramp` emits `should_turn` → `Box.turn_the_whole_world()` rotates all `"level"` group nodes and counter-rotates `"player"` group nodes.
- **Color palette** is in `mr-astro-junior-3d/notes.md` (dark orange #e76c21, orange #ea9335, dark blue #0a4a7b, blue #5377b3, light blue #b6cade, purple #4f2949).

## Engine Config

- Renderer: GL Compatibility (mobile)
- Physics: JoltPhysics3D (not default Godot physics)
- Input: WASD + arrows (left/right/forward/backward), Space (jump), Left click (attack), Shift (sprint)

## No Build/Test/Lint CLI

This is a Godot project — run and test via the Godot editor. No CI, no CLI test runner, no linter configured.