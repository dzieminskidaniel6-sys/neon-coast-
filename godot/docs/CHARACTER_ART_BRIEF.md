# NEON COAST — Final Human Character Art Brief
## This phase begins only after gameplay/content lock

## Art direction
Grounded stylized realism: believable human proportions and expressive faces, but optimized for a small indie open-world game. Avoid photorealistic scan assets that are too expensive for the target laptop.

## Player: Alex
- Adult male silhouette, average athletic build, natural proportions.
- Distinct face, eyebrows, eyes, nose, ears, hairstyle and hairline.
- Modular clothing: jacket, shirt, trousers, shoes and optional accessories.
- Neutral palette with one memorable accent color.
- Skeleton supports root motion only if profiling proves safe; default movement remains code-driven.
- Animation set: idle, look around, walk, jog, sprint, start/stop, turn, jump, fall, land, interact, phone, crouch, enter vehicle, exit vehicle, seated driving.

## Story cast
- Maya: confident stance, practical streetwear, expressive face and hand gestures.
- Nico: mechanic workwear, gloves and tool-belt silhouette.
- Vesper: distinctive layered outfit, controlled posture and expressive eyes.
- Leo: visual resemblance to Alex without identical clothing; story-specific worn details.
- Adrian Vale: polished corporate clothing, restrained gestures and controlled facial expression.

## NPC pipeline
1. Blockout silhouette and scale.
2. Human base mesh and shared skeleton.
3. Skinning and deformation checks.
4. Face shape, hair and clothing variants.
5. Animation retargeting and blend tree.
6. LOD0/LOD1/LOD2 meshes and distance-based animation update.
7. In-engine performance profile and readability test.

## Technical budgets (initial targets)
- Main character: 15k–30k triangles at LOD0, reduced LODs for distance.
- Story NPC: 10k–20k triangles at LOD0.
- Ambient NPC: 5k–10k triangles at LOD0; lower LODs at distance.
- One shared material atlas per outfit family where practical.
- 1K textures for hero characters; 512px or atlas textures for ambient characters.
- Reuse skeletons and animation clips; avoid unique high-cost shaders.
- Facial animation uses a limited blend-shape set; full real-time hair simulation is out of scope.

These are starting budgets to validate on Intel UHD 610, not final measured limits.
