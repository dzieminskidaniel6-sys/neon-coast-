# NEON COAST: The Lost Signal — Godot 4

A third-person coastal-city action/adventure project built with Godot 4 Compatibility renderer. This repository milestone adds the Phase 2 gameplay framework and Phase 3 campaign/content package.

## Open and run
Open the `godot/` folder in Godot 4.7.x, or run from the repository root:

```bash
godot --path godot
```

The project targets the Compatibility renderer (OpenGL), 960×540 base viewport and a 30 FPS low preset.

## Controls
- WASD — move
- Mouse — camera
- Shift — sprint
- Space — jump
- E — interact / advance / enter or exit vehicle
- F5 — save
- F9 — load
- Esc — release mouse

## Phase 2 — gameplay systems
- Persistent game state: cash, inventory, relationships, story flags, evidence and public support.
- Data-driven mission progression, prerequisites, objectives, rewards and save/load.
- Dialogue choices with relationship, cash, inventory and story-flag effects.
- Campaign HUD and lightweight canvas minimap (no extra camera or SubViewport).
- Vehicle driving controller and garage upgrade registry.
- Interaction targets and mission trigger volumes.
- Side-activity progression and rewards.
- District metadata, district streaming hooks, distance LOD controller and quality profiles.
- Conditional ending resolver.

## Phase 3 — content package
- 20 main mission definitions across five chapters.
- Seven named districts plus the outskirts.
- Ten side activities.
- Five conditional endings.
- Character dialogue scenes for Maya, Nico, Vesper, Leo and Adrian Vale.
- Campaign content lock, character/world asset pipeline and performance plan.

## Graphics direction
Stylized realism with human-proportioned characters, expressive faces, hair, layered clothing and a shared animation skeleton. The current capsule/sphere people are temporary blockout placeholders. The import-ready character wrapper is in `scripts/characters/character_visual.gd`; the final cast still needs authored GLB models, rigs, materials and animation clips.

## Low-end hardware target
Primary baseline: Intel Celeron 4205U, Intel UHD Graphics 610 and 4 GB RAM.
- Compatibility renderer, no mandatory real-time shadows, no MSAA on Low.
- Shared materials, modular buildings, simple collision and bounded simulation.
- Distance LOD and district chunk activation foundations.
- Target 30 FPS on Low is a design goal, not a measured guarantee.
- Avoid mandatory SSAO, SSR, volumetric fog, depth of field and heavy post-processing.

See `docs/GRAPHICS_AND_PERFORMANCE_PIPELINE.md` for asset budgets and profiling guidance.

## Important status
This is a systems-and-content milestone, not a finished, runtime-verified game. The current playable city is still a procedural blockout. The first Maya interaction and opening dialogue are wired into the scene. Later missions and side activities have data and reusable managers, but still need authored district scenes, world trigger placements, complete NPC interactions, vehicle scenes, audio, final character art and a full QA pass in Godot.

## Documentation
- `docs/GAME_BIBLE.md` — story canon and game direction.
- `docs/CAMPAIGN_CONTENT_LOCK.md` — campaign structure and character arcs.
- `docs/GRAPHICS_AND_PERFORMANCE_PIPELINE.md` — rendering, assets and performance.
- `docs/CHARACTER_AND_WORLD_ASSET_PIPELINE.md` — human models and environment pipeline.
- `docs/BUILD_AND_HANDOFF.md` — controls, run instructions and milestone boundaries.
- `data/campaign.json` — 20 main missions.
- `data/districts.json` — district definitions.
- `data/side_activities_v2.json` — ten side activities.
- `data/dialogue_campaign.json` — dialogue and choice effects.
- `data/endings.json` — five ending conditions.
