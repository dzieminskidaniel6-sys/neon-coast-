# NEON COAST — native Arch Linux desktop build

This folder builds a standalone Linux x86_64 Godot export and a pacman package. The installed game is launched from the desktop application menu; Godot Editor is not required at runtime.

## Requirements

- Arch Linux x86_64
- Godot 4.7.x
- Godot 4.7.x Linux export templates installed in the Godot Editor
- `base-devel` and `git` for makepkg
- Mesa/OpenGL drivers

Install build tools:

```bash
sudo pacman -S --needed base-devel git godot
```

Open Godot once, choose **Editor → Manage Export Templates**, and install the templates matching the installed Godot 4.7.x version. The export template version must match the editor version.

## Build

From the repository root:

```bash
chmod +x packaging/arch/build_arch.sh
./packaging/arch/build_arch.sh
```

The script imports/checks the project, exports `dist/NEON-COAST.x86_64`, and creates a pacman package in `dist/`.

If your Godot executable is named differently:

```bash
GODOT_BIN=/usr/bin/godot ./packaging/arch/build_arch.sh
```

## Install

```bash
sudo pacman -U dist/neon-coast-*.pkg.tar.zst
```

Launch **NEON COAST: The Lost Signal** from your desktop environment's application menu, or run:

```bash
neon-coast
```

Uninstall:

```bash
sudo pacman -R neon-coast
```

## Notes

- The game uses Godot's Compatibility renderer (OpenGL) and targets x86_64.
- The package installs the exported game under `/opt/neon-coast`, a launcher in `/usr/bin`, a desktop entry and an SVG icon.
- The game stores saves in Godot's per-user application data directory, not in the installation folder.
- Exporting requires the matching official Godot export templates. No paid services or assets are used.
- This package recipe and export path have not yet been executed on the user's laptop. Treat a successful `makepkg` and first launch as the release gate.
