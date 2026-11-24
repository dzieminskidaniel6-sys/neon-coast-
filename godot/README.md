# NEON COAST: The Lost Signal — Godot 4 remake

## Design documentation

- [Game & Story Bible](docs/GAME_BIBLE.md) — story canon, characters, 20-mission campaign, choices, endings, gameplay systems and production roadmap.


A lightweight third-person 3D prototype designed for Intel Celeron 4205U, Intel UHD 610 and 4 GB RAM.

## Requirements

- Godot 4.4 or newer (Godot 4.x recommended)
- Arch Linux / Hyprland
- OpenGL 3.3-capable graphics driver (Intel i915)

## Install on Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S godot mesa
```

The project uses Godot's **Compatibility** renderer (OpenGL), not Forward+.

## Run

From the repository root:

```bash
godot --path godot
```

If the native Wayland window backend has trouble under Hyprland, try the X11/XWayland backend:

```bash
godot --display-driver x11 --path godot
```

If the `godot` command is not found, check the package installation with `pacman -Q godot`.

## Controls

- WASD / arrows — move
- Mouse — rotate third-person camera
- Shift — sprint
- Space — jump
- E — interact with Maya when close
- Escape — release mouse; click the game window to capture it again

## Performance profile

- 960×540 internal window
- Compatibility renderer
- No real-time shadows
- No volumetric fog, SSAO, SSR or glow
- Primitive low-poly meshes and small material count
- Static city blockout and simple collision\n- No per-pixel/point lights; street lamps are emissive meshes\n- Simple procedural NPC meshes and labels

The current build includes a larger 7×7 street grid, a central plaza, a boardwalk diner frontage, simple low-poly trees and street lamps, three named NPCs, Maya's first interaction, and a lightweight day/night cycle. Character facing is separated from camera yaw so walking forward does not rotate the camera. This remains an early blockout: NPCs are static, cars are decorative, and the campaign, vehicle driving, save/load and mission chains are not implemented yet.

## Troubleshooting

Run from a terminal to keep errors visible:

```bash
godot --path godot --verbose
```

Under Hyprland, make sure the Intel `i915` driver and Mesa OpenGL userspace are installed. Do not force Vulkan or Forward+ on this low-end machine.
