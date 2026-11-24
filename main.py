"""Neon Coast: The Lost Signal — main game loop."""
import math,random,sys,pygame
from settings import *
from world import World
from entities import Player,Vehicle,PoliceCar
from missions import MissionManager
from story import INTRO,SCENES,ENDING
from savegame import save_game,load_game
from ui import draw_hud,draw_minimap,draw_pause,draw_dialogue,draw_title,draw_toast

def main():
 pygame.init()
 screen=pygame.display.set_mode((WIDTH,HEIGHT),pygame.RESIZABLE)
 pygame.display.set_caption(TITLE);clock=pygame.time.Clock()
 world=World();player=Player(278,248);missions=MissionManager()
 cars=[Vehicle(600+i*155,248,traffic=True) for i in range(9)]
 police=[];wanted=0;show_map=True;paused=False;started=False
 dialogue=list(INTRO);dialogue_index=0;toast="";toast_timer=0;running=True
 npcs=[("MAYA",838,248),("NICO",1398,738),("VESPER",2518,738),("DOCK WORKER",3078,1228),("LOOKOUT",278,1718)]
 def camera(x,y):return int(x-player.x+screen.get_width()/2),int(y-player.y+screen.get_height()/2)
 def notify(msg):
  nonlocal toast,toast_timer
  toast=msg;toast_timer=3.2
 while running:
  dt=min(clock.tick(FPS)/1000,0.05);w,h=screen.get_size()
  for event in pygame.event.get():
   if event.type==pygame.QUIT:running=False
   elif event.type==pygame.VIDEORESIZE:screen=pygame.display.set_mode((max(800,event.w),max(450,event.h)),pygame.RESIZABLE)
   elif event.type==pygame.KEYDOWN:
    if not started:
     if event.key in (pygame.K_RETURN,pygame.K_SPACE):started=True
     elif event.key==pygame.K_F9:
      if load_game(player,missions):started=True;dialogue=[];notify("SAVE LOADED")
     continue
    if dialogue:
     if event.key in (pygame.K_SPACE,pygame.K_RETURN):
      dialogue_index+=1
      if dialogue_index>=len(dialogue):dialogue=[];dialogue_index=0
     continue
    if event.key==pygame.K_ESCAPE:paused=not paused
    elif event.key==pygame.K_m:show_map=not show_map
    elif event.key==pygame.K_F5:save_game(player,missions,wanted);notify("GAME SAVED")
    elif event.key==pygame.K_F9:
     if load_game(player,missions):police.clear();notify("SAVE LOADED")
    elif event.key==pygame.K_q and paused:running=False
    elif event.key==pygame.K_e and not paused:
     if player.vehicle:
      v=player.vehicle;player.vehicle=None;player.x=v.x+math.cos(v.angle+math.pi/2)*35;player.y=v.y+math.sin(v.angle+math.pi/2)*35
     else:
      near=min(cars,key=lambda c:math.dist((c.x,c.y),(player.x,player.y)),default=None)
      if near and math.dist((near.x,near.y),(player.x,player.y))<58:
       player.vehicle=near;wanted=min(5,wanted+1);notify("VEHICLE STOLEN — POLICE ALERT")
      else:
       nearby=min(npcs,key=lambda n:math.dist((n[1],n[2]),(player.x,player.y)),default=None)
       if nearby and math.dist((nearby[1],nearby[2]),(player.x,player.y))<95:
        lines={
         "MAYA":[("MAYA","Keep following Leo's trail. The Harbor Authority is getting nervous.")],
         "NICO":[("NICO","I can tune your ride. Bring cash, and don't ask where I got the parts.")],
         "VESPER":[("VESPER","Information costs money. Fortunately, you look desperate enough to pay.")],
         "DOCK WORKER":[("DOCK WORKER","I work nights. I see things people pretend never happened.")],
         "LOOKOUT":[("LOOKOUT","From up here, the whole district looks innocent. That's the trick.")]}
        from story import Scene
        dialogue=[Scene(speaker,line) for speaker,line in lines.get(nearby[0],[])]
        dialogue_index=0
        if not dialogue:notify("No one here right now.")
    elif event.key==pygame.K_h and not paused:
     if player.cash>=120 and player.hp<100:
      player.cash-=120;player.hp=min(100,player.hp+45);notify("FIRST AID USED  -$120")
     else:notify("FIRST AID COSTS $120 — health already full or not enough cash")
    elif event.key==pygame.K_u and not paused:
     near_nico=math.dist((1398,738),(player.x,player.y))<115
     if player.vehicle and near_nico and player.cash>=500 and player.vehicle.max_speed<430:
      player.cash-=500;player.vehicle.max_speed+=35;notify("ENGINE UPGRADED  -$500")
     else:notify("GARAGE UPGRADE: be near Nico, in a car, with $500")
    elif event.key==pygame.K_SPACE and player.vehicle:player.vehicle.speed*=0.45
  if not started:
   draw_title(screen);pygame.display.flip();continue
  if not paused and not dialogue:
   keys=pygame.key.get_pressed();player.update(keys,dt,world)
   for car in cars:
    if car is not player.vehicle and car.traffic:
     car.update_traffic(dt)
     if car.x<0 or car.x>WORLD_W or car.y<0 or car.y>WORLD_H:car.x=random.randint(100,WORLD_W-100);car.y=random.randint(100,WORLD_H-100)
   completed=missions.update(player)
   if completed:
    notify(f"MISSION COMPLETE  +$ {completed.reward}")
    if missions.index>=len(missions.missions):dialogue=list(SCENES.get(missions.index-1,[]))+list(ENDING)
    else:dialogue=list(SCENES.get(missions.index-1,[]))
    dialogue_index=0
   side=missions.update_side(player)
   if side:notify(f"SIDE JOB COMPLETE  +$ {side.reward}")
   if wanted and len(police)<wanted:police.append(PoliceCar(player.x+random.choice([-360,360]),player.y+random.choice([-260,260])))
   for cop in police:cop.chase(player,dt,world)
   for cop in police:
    if math.dist((cop.x,cop.y),(player.x,player.y))<30:player.hp=max(0,player.hp-12*dt)
   if toast_timer>0:toast_timer-=dt
   if player.hp<=0:
    player.hp=100;player.x,player.y=278,248;player.vehicle=None;wanted=0;police.clear();notify("BUSTED — you were taken back to the boardwalk")
  screen.fill(BG);world.draw(screen,camera)
  mission=missions.current or missions.next_side
  if mission:
   mx,my=camera(*mission.target);pygame.draw.circle(screen,YELLOW,(mx,my),25,2);pygame.draw.circle(screen,YELLOW,(mx,my),5)
  for car in cars:car.draw(screen,camera)
  for cop in police:cop.draw(screen,camera)
  player.draw(screen,camera);draw_hud(screen,player,mission,wanted)
  if show_map:draw_minimap(screen,player,world,mission)
  if toast_timer>0:draw_toast(screen,toast)
  if dialogue:draw_dialogue(screen,dialogue[dialogue_index],dialogue_index,len(dialogue))
  if paused:draw_pause(screen)
  pygame.display.flip()
 pygame.quit();sys.exit()
if __name__=="__main__":main()
