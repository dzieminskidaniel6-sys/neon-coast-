# NEON COAST — THE LOST SIGNAL

An original top-down 2D open-world story adventure built with Python and pygame-ce. Designed for low-end laptops, including Intel UHD integrated graphics.

## Campaign
Play as Alex, searching Vice District for his missing brother Leo. Follow a trail through the boardwalk, garages, night market, relay stations, canal district and container port. The campaign is structured as 20 story jobs with original dialogue, rewards and a finale. Four optional side contracts add extra exploration. After the finale, the city remains open for free roam.

## Features
- 20 linked story missions and four optional side contracts.
- Original characters, dialogue, mystery and campaign finale.
- Large 4200 × 3150 city map with roads, buildings and scenery.
- Walk, sprint, enter and drive vehicles; moving traffic.
- Wanted level and police pursuit.
- Cash, health, stamina, minimap, HUD and pause.
- JSON save/load (F5 saves, F9 loads).
- No external art or audio assets required.
- Static map pre-rendering, cached vehicle sprites and 30 FPS target.

## Arch Linux installation
Use a virtual environment so Arch's system Python remains untouched:
```bash
sudo pacman -S --needed python python-pip sdl2
cd neon-coast-
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python main.py
```
Or, after downloading the repository, launch with: bash run_game.sh

If the folder name differs, change into the folder containing main.py. For each new terminal session:
```bash
cd /path/to/neon-coast-
source .venv/bin/activate
python main.py
```

## Other systems
- Windows 10/11: install Python 3.10+, then run: py -m pip install -r requirements.txt and py main.py.
- macOS: python3 -m venv .venv, activate it, install requirements, then run python main.py.

## Controls
- WASD / arrows: walk or drive
- Shift: sprint
- E: enter / exit a nearby car; talk to named contacts
- H: buy first aid for $120 (restores up to 45 health)
- U: upgrade the current car at Nico's garage for $500
- Space: handbrake / continue dialogue
- Enter: start / continue dialogue
- M: toggle minimap
- F5: save
- F9: load
- Esc: pause / resume
- Q: quit from pause menu

## Project structure
- main.py — game loop and state handling
- settings.py — low-end performance settings and palette
- world.py — deterministic city map and static rendering
- entities.py — player, vehicles and police AI
- missions.py — 20 story jobs and optional contracts
- story.py — original story scenes
- savegame.py — JSON save/load
- ui.py — menus, HUD, dialogue and minimap

## Current scope
This is a playable foundation and expanding campaign, not a finished commercial release. Mission flow, performance and save compatibility should be tested on the target laptop before calling it release-ready.
