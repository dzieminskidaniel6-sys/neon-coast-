# Build and handoff

## Project
Open the `godot/` directory in Godot 4.7.x. The project uses the Compatibility renderer and a 960×540 base viewport.

## Controls
- WASD: move
- Shift: sprint
- Space: jump
- E: interact / advance
- Mouse: camera
- Esc: release mouse

## Current milestone contents
The repository contains campaign state, 20 mission definitions, dialogue choices, side activity data and manager, conditional endings, save data, a minimap, district metadata, vehicle controller and garage registry, interaction/mission trigger components, plus streaming/LOD and quality-profile foundations.

## Current limitations
This is not a finished commercial game build. The existing city and people are still procedural blockout geometry. Only the opening Maya contact is wired into the current blockout. Mission data for later chapters needs authored world trigger locations and district scenes. Vehicle controller and garage registry exist, but there are no final vehicle scenes or driving routes. Final human models, facial details, clothing, skeletons, animation clips, audio, UI polish and runtime QA are still production work.

## Hardware target
Low preset baseline: Intel Celeron 4205U, Intel UHD Graphics 610, 4 GB RAM. Aim for 30 FPS, but do not promise it before profiling. Build quality presets around scalable resolution, LOD, shared assets and limited simulation.
