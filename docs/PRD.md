# PRD: Level Progression System

## Problem Statement

The game currently has a single test level made of hardcoded connected boxes. There is no level progression, no item variety, no inventory, and no way to advance between levels. The portal and death mechanics both reload the same scene. The player needs a structured 4-level campaign that teaches mechanics incrementally.

## Solution

Build a level progression system with 4 levels as separate scene files. Extend the existing `State` autoload to track level progress and inventory. Create distinct item types (key, diamond, screwdriver, hammer, etc.) that open doors and portals via collision. Add a simple HUD for inventory icons and a start/death UI overlay with "Continue" and "Level Select" buttons.

## User Stories

1. As a player, I want to start the game and see a "Continue" and "Level Select" overlay, so that I can resume progress or replay a level
2. As a player, I want to walk through a portal in level 1 and arrive in level 2, so that I progress through the game
3. As a player, I want to complete level 4 and see a credits/you-win screen, so that the game has a satisfying conclusion
4. As a player, I want the portal to automatically know which level comes next, so that I don't have to select it manually
5. As a player, I want my inventory to reset when starting a new level, so that each level is a self-contained puzzle
6. As a player, I want to walk to a door while carrying a key and have it open automatically, so that puzzle solving feels fluid
7. As a player, I want to find a key in level 2 that opens the portal, so that I learn the key mechanic
8. As a player, I want to find a key in level 3 that opens a door between boxes, so that I learn keys can open different things
9. As a player, I want to collect 3 items in level 4 and bring them to a chest, so that I learn the multi-item collection mechanic
10. As a player, I want the chest in level 4 to spawn a key pickup nearby when I approach with 3 items, so that I can then use the key to open the portal
11. As a player, I want to see item icons in a HUD when I pick them up, so that I know what I've collected
12. As a player, I want all items and doors to reset when I die, so that each attempt is fair
13. As a player, I want to fall off the edge and hit a global kill plane, so that falling means death and restart
14. As a player, I want to respawn at the level start when I die, so that I can try again
15. As a player, I want to unlock a level select option after reaching a level, so that I can replay it later
16. As a player, I want world-rotation ramps in levels 3 and 4, so that the puzzles are more complex
17. As a player, I want each item to have a distinct type (key, diamond, screwdriver, hammer), so that items feel different
18. As a player, I want each item to be wired to a specific door or target via the editor, so that the level designer controls what opens what
19. As a player, I want the spawn position to be set per level, so that I start in the right place each time

## Implementation Decisions

- **State autoload**: Extend existing `State` singleton (not create a new one). Add level progression tracking (current level index, level unlock map) and inventory (per-level, resets on level load and on death).
- **Level scenes**: Separate `.tscn` files (`level_1.tscn`, `level_2.tscn`, `level_3.tscn`, `level_4.tscn`), each with its own script that wires box layout, items, and doors.
- **Portal**: Remove hardcoded scene path. Portal reads `State` to determine the next level.
- **Items**: New `PickupItem` scene/script with `@export NodePath target` pointing to the door/portal it unlocks, and `@export String item_type` for HUD icon selection. On player collision, adds to `State` inventory and unlocks the target.
- **Chest**: New `Chest` scene/script with `@export int required_item_count = 3`. On player collision, checks `State` inventory count. If enough, hides itself and spawns a key pickup nearby.
- **Kill plane**: Single `StaticBody3D` with a `Area3D` below the level. On body entered with player → reload current level.
- **HUD**: A `Control` node showing inventory item icons. Reads from `State` inventory.
- **Start/death overlay**: A `Control` scene with "Continue" and "Level Select" buttons. Shown on game start and death.
- **Death behavior**: Reload current level scene. `State` clears inventory for that level. Items respawn, doors close.
- **Level completion**: Level 4 portal triggers a credits/you-win screen.
- **Box.gate doors**: Currently just visibility toggles. Adding unlocking: gate stays hidden until a pickup item with this gate as target unlocks it.
- **Player spawn**: `@export var spawn_position: Vector3` on the player, set per level in the editor. Player teleports there on `_ready`.
- **Remove `Box._on_area_3d_body_entered`** death zone — replace with global kill plane per level.

## Testing Decisions

- This is a Godot project with no CLI test runner. All testing happens in the Godot editor.
- Good tests to verify manually:
  - Pick up an item → HUD shows the icon → walk to the target door → door disappears
  - Pick up key → portal turns green → walk through → next level loads
  - Die (fall off) → level restarts → inventory empty → doors closed → items back
  - Walk into chest area with fewer than 3 items → nothing happens
  - Walk into chest area with 3 items → chest opens → key spawns → pick up key → portal opens
  - Complete level 1 → level 2 unlocks in level select
  - Complete level 4 → credits screen appears
  - Ramps in levels 3/4 → world rotates correctly
- Prior art: No existing test suite in this codebase. Manual testing only.

## Out of Scope

- Enemies and combat (later milestone)
- Sound effects and particles
- Branching paths or non-linear level design
- Save/persistence across game sessions (level unlock state resets on game close)
- Carrying inventory between levels
- Level editor or procedural generation
- Mobile/touch controls
- Sprint mechanic integration with levels

## Further Notes

- Color palette reference: `mr-astro-junior-3d/notes.md` (dark orange #e76c21, orange #ea9335, dark blue #0a4a7b, blue #5377b3, light blue #b6cade, purple #4f2949)
- The world rotation mechanic (Ramp → Box.turn_the_whole_world) must be preserved in levels 3 and 4
- Level layout design (box arrangement, item placement, ramp placement) is content work, not covered by this PRD — this PRD covers the systems needed to express those layouts