# NEON COAST — polished vertical-slice build notes
## Build pass: 24 November 2026

This pass adds a more complete front end and a stylized art pass while keeping the project free of paid assets and external generation services.

## Implemented in the Godot project

- **Title screen:** New Game, Continue (enabled when a save exists), Mission Journal, Character Files, Graphics Settings and Exit.
- **Pause flow:** Resume, journal, character files, settings, save and return to title. The SceneTree pauses behind UI; the UI continues to process.
- **Mission journal:** Lists the existing 20 campaign entries, grouped into five chapters, and shows briefs, contacts, districts, objectives and completion state from `MissionManager`.
- **Alex:** A new original stylized human player model with layered clothes, hair, facial features, eye details, shoes and accessories.
- **Maya:** A distinct anime-inspired human model used for the story NPC, with long dark hair, turquoise eyes, coastal jacket, skirt and separate silhouette.
- **Character files:** In-game descriptions explain Alex's search for Leo and Maya's personal secret and changing trust arc.
- **Coastal environment:** Batched vertex-coloured building meshes with window frames, glass, sills, balconies, roof units and facade accents; plaza, sidewalks, street markings, trees, lamps, boardwalk, beach, water and a neon diner.
- **Minimap and HUD:** Framed minimap with player heading, objective marker, boardwalk landmark, coastline and street grid; objective and campaign HUD panels.
- **Performance foundation:** Compatibility renderer, low-cost materials, no realtime shadows, no MSAA/SSAO/SSR, low-poly character primitives and one batched mesh per detailed building. The LOW profile uses a 30 FPS cap and reduced 3D render scale.

## Controls

- **W A S D:** move
- **Shift:** sprint
- **Space:** jump
- **E:** interact / advance context
- **Mouse click on the world:** capture mouse for camera
- **Esc:** pause / release the mouse
- **J or Tab:** mission journal
- **C:** character files
- **Mouse:** menu buttons and camera after capture

## Cost and asset policy

The character and building geometry in this pass is generated at runtime by GDScript. It uses no paid image/3D generator, no external model pack and no Blender step. All project additions in this pass are text source files; no paid service or credit balance is needed.

## Important scope and validation notes

This is a substantial playable-slice upgrade, **not a finished commercial release**. The initial Boardwalk story encounter and core player/camera systems are wired. The campaign JSON already contains 20 mission records, but later `mission_event` objectives still need authored gameplay scenes, unique triggers, interactions, full character dialogue and consequence testing. The current human models are lightweight stylized meshes, not rigged production characters: they do not yet have full walk cycles, facial animation, voice acting or detailed texture maps. The world is still a compact procedural district/blockout, not seven finished streamed districts.

The game has not been launched or profiled in this build environment. The 30 FPS setting is a design target, not a measured guarantee on the Intel UHD 610 / 4 GB laptop. Run the project in Godot 4.7.2 and inspect the Output/Debugger panel before treating this pass as validated. If a parser/runtime error appears, send the exact message and file/line so it can be corrected against the current commit.

## Technical reference

Building meshes are combined from per-vertex attributes using Godot's `SurfaceTool`; the StandardMaterial3D uses vertex colours as albedo. The menu uses `PROCESS_MODE_ALWAYS` so it remains interactive while `SceneTree.paused` freezes the world. See the Godot 4.7 SurfaceTool and SceneTree/Node process-mode documentation.
