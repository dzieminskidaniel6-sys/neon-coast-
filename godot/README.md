# NEON COAST: The Lost Signal — Godot 4 remake

A lightweight third-person 3D prototype designed for Intel Celeron 4205U, Intel UHD 610 and 4 GB RAM.

## Requirements

- Godot 4.4 or newer (Godot 4.x recommended)
- Arch Linux / Hyprland
- OpenGL 3.3-capable graphics driver (Intel i915)

## Install on Arch Linux

```bash
sudo pacman -Syu
sudo pacman -S godot mesa vulkan-intel
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
- Static city blockout and simple collision

This is the first playable vertical slice, not the finished campaign. It establishes third-person movement, camera, a starter district, HUD and the first story interaction. Vehicles, save/load, combat, mission chains and the larger city are planned follow-up systems.

## Troubleshooting

Run from a terminal to keep errors visible:

```bash
godot --path godot --verbose
```

Under Hyprland, make sure the Intel `i915` driver and Mesa OpenGL userspace are installed. Do not force Vulkan or Forward+ on this low-end machine.
