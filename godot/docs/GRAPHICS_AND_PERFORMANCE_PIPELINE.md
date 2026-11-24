# NEON COAST — graphics and performance pipeline

## Target hardware
The first guaranteed design target is the Intel Celeron 4205U (2 cores / 2 threads), Intel UHD Graphics 610 and 4 GB RAM. This is a very constrained integrated-GPU platform. A high visual target and this machine cannot be treated as the same preset.

## Rendering direction
- Godot 4 Compatibility renderer (OpenGL).
- 960×540 internal target; upscale to the display.
- Low-poly/stylized realistic art direction, readable silhouettes, restrained material count.
- Human characters should use imported GLB scenes with a shared skeleton and animation library; no permanent capsule placeholders in the final art pass.
- Keep materials opaque where possible; use a small number of transparent effects.
- No mandatory SSAO, SSR, volumetric fog, depth of field, motion blur or heavy bloom.
- Bake lighting where possible. Keep dynamic lights few and use short-range shadows only on higher profiles.

## Asset budgets (initial production targets, to be profiled)
- Hero character: 15k–25k triangles LOD0; 6k–10k LOD1; 2k–4k LOD2.
- Ordinary NPC: 5k–10k triangles LOD0; shared body/rig/materials.
- Vehicle: 8k–18k triangles LOD0 with 2 cheaper LODs.
- Building hero props: 1k–8k triangles; repeated buildings use shared modular meshes.
- Textures: 512 px for common props, 1K for hero assets, 2K only for rare close-up assets.
- Prefer atlases, trim sheets, shared materials and baked ambient detail.

These are budgets, not measured guarantees. Profile on the actual laptop before locking them.

## Streaming and simulation
- Split the world into district chunks.
- Activate nearby chunks only; unload or disable distant AI, animation and physics.
- NPC simulation should be distance-tiered: full behaviour near player, simplified schedules at medium range, static/despawned far away.
- Use simple collision shapes; never use detailed render meshes as physics.
- Limit active rigid bodies and vehicle traffic.
- Use visibility ranges and LODs for buildings and props.

## Presets
- Low: 30 FPS cap, no real-time shadows, no MSAA, low internal resolution, short draw distance.
- Balanced: 45 FPS cap, selective shadows, modest resolution scale.
- High: 60 FPS cap, optional MSAA and longer draw distance.

The FPS caps are targets only; actual performance must be measured.
