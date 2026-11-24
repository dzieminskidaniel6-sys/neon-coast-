# NEON COAST — Asset Pipeline & Art Direction

## Target
Stylized, ultra-detail source assets with a performance-scaled in-game presentation.
The source model may be high detail; runtime assets must be profiled on the minimum target.

## Art direction
- Coastal contemporary city with salt-worn plaster, teal painted metal, sun-bleached wood, terracotta roofs and cool blue glass.
- Strong readable silhouettes, slightly exaggerated architectural shapes, restrained bevels, hand-authored material breakup.
- Avoid photorealistic grime/noise. Use large readable material regions and a few distinctive details.
- Palette: sea-glass teal, warm plaster, cream, terracotta, charcoal, faded yellow and ocean glass.
- Buildings should share a modular grammar: 3.2 m floor height, repeatable window bays, belt courses, balconies, parapets and rooftop service structures.

## Alex — identity anchor
Young adult man, around 22; lean athletic build; slightly angular face; warm olive skin; short messy dark-brown hair with one subtle teal streak at the right temple; hazel eyes; faint scar through the left eyebrow. Charcoal lightweight hooded bomber with restrained teal piping and a small cyan patch; muted sand-grey T-shirt; dark tapered cargo trousers; worn off-white sneakers; simple black wristwatch; compact crossbody utility bag. Grounded civilian, never superhero/military.

## Building kit
1. Coast Apartment — 2-storey plaster apartment shell with balconies.
2. Harbor Cafe — same modular footprint, shop glazing and teal awning.
3. Teal Corner Block — taller landmark massing.
4. Street props — lamp, bench, bin and bollards.
The Blender generator is at `godot/tools/blender/generate_neon_coast_building_pack.py`.
Run it with Blender 4.x in background mode. It writes GLB files to `godot/assets/generated/buildings/` relative to the script. This generator creates a first-pass modular blockout asset kit, not final art-approved production models.

## fal production sequence (blocked until credits are available)
1. Generate Alex anchor image (2K, 16:9 turnaround sheet).
2. Inspect identity consistency and approve anchor.
3. Generate Alex image-to-3D mesh, request optional rig if endpoint supports it.
4. Generate building landmark variations from a shared style reference.
5. Generate street prop set.
6. Inspect each mesh, verify scale, UVs, materials, topology and export format.
7. Save approved outputs to fal Assets and import GLB into Godot.
Do not silently claim a generation completed when fal returns a billing block.

## Godot import and optimization
- Import GLB at real-world scale; target human height around 1.75–1.85 m.
- Use shared materials and atlased textures where possible.
- Generate LOD0/LOD1/LOD2 and visibility ranges.
- Use simple collision proxies; do not use render meshes as complex collision.
- Prefer Compatibility renderer and avoid expensive screen-space effects.
- Profile on Intel UHD 610 / 4 GB RAM; no FPS promise before a real test.

## Delivery checklist
- [ ] Alex concept approved
- [ ] Alex mesh generated and inspected
- [ ] Rig and animation clips validated
- [ ] Three building GLBs generated
- [ ] Street prop GLB generated
- [ ] Collision proxies and LODs prepared
- [ ] Godot import verified
- [ ] Runtime performance measured
