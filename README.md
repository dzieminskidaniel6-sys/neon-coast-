# NEON COAST — Vice District

A top-down open-world action sandbox built with Python and Pygame-ce.

## Features
- Explore a procedurally laid-out coastal city.
- Walk, sprint, enter and exit drivable cars.
- Traffic vehicles roam the roads.
- Police pursue the player when the wanted level rises.
- Mission markers, cash rewards, minimap, HUD and pause menu.
- No external art assets required: the world is drawn with Pygame primitives.

## Requirements
- Python 3.10+
- pygame-ce

## Run
```bash
python -m pip install -r requirements.txt
python main.py
```

On Windows, you can also double-click `run_game.bat`.

## Controls
- WASD / arrows: move or drive
- Shift: sprint
- E: enter / exit nearby car
- Space: handbrake
- Esc: pause / resume
- M: toggle minimap

## Project layout
- `main.py`: game loop and state management
- `settings.py`: constants and colors
- `world.py`: city map, roads, buildings and collision
- `entities.py`: player, vehicles, traffic and police
- `missions.py`: mission objectives and rewards
- `ui.py`: HUD, minimap and menus

This is an original 2D project inspired by open-world city games; it is not affiliated with or a recreation of Grand Theft Auto.
