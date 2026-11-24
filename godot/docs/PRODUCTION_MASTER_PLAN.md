# NEON COAST — Production Master Plan
## Scope freeze before final character art

This document defines the remaining content and systems work before the final visual upgrade. It is a production target, not a claim that every listed feature is already implemented.

## Locked direction
- Single-player third-person open-world action adventure.
- Vice District, seven connected districts.
- Balanced tone: humour, friendship, family drama and crime-thriller mystery.
- 20 main missions, five chapters, multiple endings.
- First hardware target: Celeron 4205U, Intel UHD 610, 4 GB RAM, Arch Linux, Godot 4 Compatibility renderer.
- Final realistic human character art is deliberately postponed until gameplay and content are stable.

## Main campaign: 20 missions
1. A Stranger in Town — Maya gives Alex a sealed case and a lead.
2. The First Package — Alex meets Nico and learns about Leo's last repair.
3. Old Engine, New Lies — the tracker reveals a hidden movement record.
4. Market After Dark — Alex meets Vesper and chooses how to get information.
5. Static on the Line — the relay station records an unknown signal.
6. The Wrong Address — an abandoned apartment contains a blue-lantern clue.
7. Debt Collectors — a marina encounter tests negotiation, escape and trust.
8. A Friend in Need — Alex recovers Nico's tools and strengthens their bond.
9. Ghost Frequency — the transmitter reveals an encrypted data burst.
10. The Harbor Files — the player obtains a shipping manifest through a chosen route.
11. No Safe Route — the player decides who holds the evidence.
12. Night Shift — a port worker provides testimony about Leo's shipment.
13. The Watcher — a rooftop observer can become an ally or a liability.
14. Deep Storage — a hidden bay contains Leo's personal item.
15. The Second Key — Vesper's debt and the second access key are resolved.
16. Port of No Return — the player prepares a vehicle, pass and support contact.
17. Break the Chain — a timed relay operation creates a security blind spot.
18. The Last Witness — the witness at the canal offers the last location clue.
19. Brother's Trail — the final GPS trace leads to Leo's recorded message.
20. The Lost Signal — rescue, evidence and the final choice determine the ending.

## Multiple endings
Ending selection is based on combinations of flags, evidence, public support, relationships and mission outcomes:
- The City Knows: strong evidence + public support; the Harbor Authority scandal becomes public.
- Blood Before Truth: strong Leo bond; Alex prioritizes getting Leo to safety.
- A Deal in the Dark: a negotiated compromise protects Leo but conceals part of the truth.
- No One Gets Away: the evidence is published, but key allies are lost and Leo's outcome is uncertain.
- The Signal Goes Silent: insufficient evidence and support allow the conspiracy to survive.

Never select an ending from one morality number. The final sequence should evaluate multiple independent campaign variables and show the player why their prior actions mattered.

## District content plan
| District | Main identity | Story use | Side activity |
|---|---|---|---|
| Boardwalk | diner, beach, marina | Maya's first contact | photography, beach deliveries |
| Old Quarter | apartments, workshops | Nico and Leo's past | parts recovery, neighbour errands |
| Downtown | offices, hotels, parking | Harbor Authority records | time trials, courier jobs |
| Night Market | stalls, music, back alleys | Vesper's information network | market errands, street races |
| Industrial Belt | warehouses, relay station | signal and transmitter | salvage runs |
| Harbor Port | containers, security, loading bays | campaign climax | optional manifests and hidden caches |
| Canal / Outskirts | service roads, water channels | witness and final GPS trail | exploration, hidden messages |

## Gameplay systems and acceptance criteria

### Player controller
- Independent camera yaw/pitch and player facing.
- Walk, sprint, jump, interact.
- Camera sensitivity and invert-Y options.
- No input should rotate the player repeatedly or cause camera feedback loops.
- Later: animation state machine and human rig.

### Interaction
- One reusable Area3D interaction component.
- Interaction prompts only appear in range.
- Interactions are explicit; proximity alone never completes a mission.
- Mission, NPC, vehicle, door, pickup and terminal interactions use the same contract.

### Dialogue
- Data-driven lines with speaker, text, optional choices, conditions and effects.
- Effects can update relationships, cash, inventory and story flags.
- UI is separate from dialogue logic.
- Critical information cannot be missed due to a single optional response.

### Mission progression
- Mission data is separate from scene scripts.
- Objectives advance only on explicit gameplay events.
- Prerequisites prevent sequence breaks.
- Rewards and flags are granted exactly once.
- Failure states are recoverable.

### Relationships and choices
- Maya, Nico, Vesper and Leo each have an independent relationship value.
- Choices affect later lines, mission support and ending conditions.
- No arbitrary invisible morality score.
- Journal records discovered clues and major decisions.

### Economy and inventory
- Cash from missions and optional work.
- Costs: repairs, vehicles, upgrades and safehouse improvements.
- Main story must not require repetitive grinding.
- Mission items are separate from optional inventory items.

### Vehicles
- Lightweight arcade handling first; suspension/complex physics only if performance allows.
- Enter/exit, camera follow, reverse, brake, handbrake and simple damage state.
- Garage repairs and a small set of meaningful upgrades.
- Traffic AI is added only after player vehicle handling is stable.

### NPCs
- Story NPCs have schedules, dialogue state and relationship hooks.
- Ambient NPCs use simple bounded routines and low update frequency at distance.
- Crowd count is capped for the UHD 610 target.
- Human meshes, facial rigs and detailed animations are final-art phase, not current blockout.

### Save/load
- Versioned save format.
- Saves mission progress, flags, relationships, cash, inventory, district and player position.
- Save migration or safe fallback when schema version changes.
- Never overwrite a valid save with malformed data.

### World and activities
- Seven districts with landmarks and reasons to revisit.
- Side missions, courier jobs, time trials, parts recovery, photography and collectibles.
- No empty expansion just to inflate map size.

## Final human-character art phase (after systems)
### Alex
- Full humanoid skeleton, realistic body proportions, face, hair, clothing layers.
- Idle, walk, jog, sprint, jump, land, turn, interact, phone, sit and vehicle enter/exit.
- Third-person animation blending and foot placement.

### Maya, Nico, Vesper, Leo and story cast
- Distinct silhouettes, facial identity, hairstyle, clothing palette and voice direction.
- Shared base skeleton where practical; unique facial details and outfits.
- Dialogue idles, gestures, reactions, look-at targets and lip-sync-ready mouth shapes.

### Ambient NPCs
- Reusable body/face variants, modular clothing and limited animation set.
- LOD meshes and animation update throttling at distance.

## Performance budgets and console-style optimization
These are targets to profile, not guaranteed results:
- Compatibility renderer / OpenGL.
- 960x540 baseline, scalable resolution.
- 30 FPS target on the reference laptop; 60 FPS optional on stronger hardware.
- Keep active story/ambient NPCs limited; distant agents sleep or update slowly.
- Use visibility ranges, frustum culling, occlusion where beneficial, static batching/mesh merging by district.
- Reuse materials and meshes; avoid unique material instances per prop.
- Simple collision primitives; avoid detailed triangle collision on moving actors.
- Stream districts in bounded chunks; unload distant interiors and inactive NPC groups.
- No volumetric fog, SSAO, SSR, heavy glow or real-time shadow cascades on low profile.
- Profile CPU and GPU separately; never assume a technique helps without measuring.

## Production gates
1. **Narrative lock:** all 20 missions, character arcs, side missions, endings and dialogue pass.
2. **Systems lock:** mission, dialogue, interaction, relationships, inventory, economy, save/load, vehicles and NPC logic work.
3. **Content lock:** districts, mission spaces, side activities and world interactions exist as blockout.
4. **QA/performance lock:** no blocking parser/runtime bugs; saves survive restart; missions can be completed; profile on the reference laptop.
5. **Final art:** replace blockout Alex/NPCs with human characters, rigs, animations, materials, then upgrade world visuals.

## Current status
The autoload and gameplay scripts are foundational modules. They still need scene/UI integration and runtime testing in the user's local Godot installation. The campaign JSON is the complete mission index, not yet a playable implementation of all 20 missions.
