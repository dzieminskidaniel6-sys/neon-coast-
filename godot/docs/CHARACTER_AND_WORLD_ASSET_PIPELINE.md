# Character and world asset pipeline

## Characters
Use human-proportioned rigged GLB characters with a shared skeleton and retargetable animation library. The capsule/sphere characters in the current prototype are placeholders only. Alex, Maya, Leo, Nico, Vesper and Adrian need individual faces, hair silhouettes, clothing layers, materials and readable colour identities.

## Required animation set
Idle, walk, jog, sprint, start/stop, turn-in-place, jump, land, interact, talk gestures, phone use, vehicle enter, vehicle exit, seated driver, hit reaction and optional cinematic poses. Use animation state machines and blend spaces; keep root motion optional and consistent.

## Modular environment
Build each district from reusable road, pavement, wall, facade, shopfront, roof, fence, lamp, sign and vegetation kits. Use shared materials and trim sheets. Hero landmarks may receive unique meshes; background buildings should be modular.

## Import rules
- GLB for models and animation.
- Keep collision separate and simplified.
- Set sensible LODs and visibility ranges.
- Avoid per-instance unique materials for repeated props.
- Keep texture dimensions within the performance budgets in GRAPHICS_AND_PERFORMANCE_PIPELINE.md.

## Visual target
Stylized realism: believable proportions and lighting, slightly simplified geometry, expressive faces and readable silhouettes. The final look should be cohesive rather than photorealistic at any cost.
