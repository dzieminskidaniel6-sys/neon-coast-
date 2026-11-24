"""Small JSON save system. Saves only stable gameplay state."""
import json, os
SAVE_PATH="neon_coast_save.json"
def save_game(player,missions,wanted):
 data={"player":{"x":player.x,"y":player.y,"hp":player.hp,"cash":player.cash,"stamina":player.stamina},
       "missions":{"index":missions.index,"side_index":missions.side_index},"wanted":wanted}
 temp=SAVE_PATH+".tmp"
 with open(temp,"w",encoding="utf-8") as f:json.dump(data,f,indent=2)
 os.replace(temp,SAVE_PATH)
def load_game(player,missions):
 if not os.path.exists(SAVE_PATH):return False
 try:
  with open(SAVE_PATH,encoding="utf-8") as f:data=json.load(f)
  p=data["player"];m=data["missions"]
  player.x=float(p["x"]);player.y=float(p["y"]);player.hp=max(1,min(100,float(p["hp"])))
  player.cash=max(0,int(p["cash"]));player.stamina=max(0,min(100,float(p.get("stamina",100))))
  missions.index=max(0,min(len(missions.missions),int(m["index"])))
  missions.side_index=max(0,min(len(missions.side_missions),int(m.get("side_index",0))))
  missions.free_roam=missions.index>=len(missions.missions)
  return True
 except (OSError,ValueError,KeyError,TypeError,json.JSONDecodeError):return False
