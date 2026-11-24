# NEON COAST — Vice District

An original 2D open-world story game made with Python + pygame-ce. Inspired by the genre of open-world city adventures; not affiliated with or a recreation of GTA.

## The story
You play as **Alex**, who arrives in Vice District searching for his missing brother Leo. With help from Maya, a street-smart fixer, and Nico, a mechanic, Alex follows a trail through the docks, night market and harbor. Five story jobs, character conversations, rewards and an ending take you through the first chapter. After the finale, explore the city in free roam.

## Features
- Five story missions with original character dialogue.
- Title screen, conversations, ending and free-roam after the campaign.
- Large coastal city with roads, buildings and scenery.
- Walk, sprint, enter and drive cars; traffic roams the streets.
- Wanted level and police pursuit.
- Cash rewards, health, minimap, HUD and pause menu.
- Resizable window; no external art or sound assets required.

## Run on a Windows 10/11 laptop
1. Install **Python 3.10 or newer** from https://www.python.org/downloads/
2. During installation, tick **Add python.exe to PATH**.
3. On GitHub, click the green **Code** button → **Download ZIP**, then extract it.
4. Open the extracted game folder and double-click `run_game.bat`.

If that does not work, open Command Prompt in the game folder and run:
```bat
py -m pip install --upgrade pip
py -m pip install -r requirements.txt
py main.py
```

## macOS / Linux
```bash
python3 -m pip install -r requirements.txt
python3 main.py
```

## Controls
- WASD / arrow keys: move or drive
- Shift: sprint
- E: enter / exit a nearby car
- Space: handbrake / continue dialogue
- Enter: start / continue dialogue
- Esc: pause / resume
- M: toggle minimap

## Project files
- `main.py` — game loop and states
- `story.py` — original story scenes and dialogue
- `missions.py` — campaign objectives and rewards
- `entities.py` — player, cars, traffic and police
- `world.py` — city layout and collisions
- `ui.py` — title screen, HUD, minimap, dialogue and pause
- `settings.py` — resolution, world size and palette
