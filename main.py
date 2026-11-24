import math,random,sys
import pygame
from settings import *
from world import World
from entities import Player,Vehicle,PoliceCar
from missions import MissionManager
from story import INTRO,SCENES,ENDING
from ui import draw_hud,draw_minimap,draw_pause,draw_dialogue,draw_title,text
def main():
 pygame.init(); screen=pygame.display.set_mode((WIDTH,HEIGHT),pygame.RESIZABLE); pygame.display.set_caption(TITLE); clock=pygame.time.Clock()
 world=World(); player=Player(430,430); missions=MissionManager(); cars=[Vehicle(600+i*135,390+(i%2)*30,traffic=True) for i in range(12)]; police=[]
 wanted=0; show_map=True; paused=False; started=False; dialogue=list(INTRO); dialogue_index=0; toast=""; toast_timer=0; running=True
 def camera(x,y): return int(x-player.x+screen.get_width()/2),int(y-player.y+screen.get_height()/2)
 while running:
  dt=min(clock.tick(FPS)/1000,0.04)
  for event in pygame.event.get():
   if event.type==pygame.QUIT: running=False
   elif event.type==pygame.VIDEORESIZE: screen=pygame.display.set_mode((max(900,event.w),max(600,event.h)),pygame.RESIZABLE)
   elif event.type==pygame.KEYDOWN:
    if not started:
     if event.key in (pygame.K_RETURN,pygame.K_SPACE): started=True
     continue
    if dialogue:
     if event.key in (pygame.K_SPACE,pygame.K_RETURN):
      dialogue_index+=1
      if dialogue_index>=len(dialogue): dialogue=[]; dialogue_index=0
     continue
    if event.key==pygame.K_ESCAPE: paused=not paused
    elif event.key==pygame.K_m: show_map=not show_map
    elif event.key==pygame.K_e and not paused:
     if player.vehicle:
      v=player.vehicle; player.vehicle=None; player.x=v.x+math.cos(v.angle+math.pi/2)*42; player.y=v.y+math.sin(v.angle+math.pi/2)*42
     else:
      near=min(cars,key=lambda c:math.dist((c.x,c.y),(player.x,player.y)),default=None)
      if near and math.dist((near.x,near.y),(player.x,player.y))<65: player.vehicle=near; wanted=min(5,wanted+1)
    elif event.key==pygame.K_SPACE and player.vehicle: player.vehicle.speed*=0.45
  if not started: draw_title(screen); pygame.display.flip(); continue
  if not paused and not dialogue:
   keys=pygame.key.get_pressed(); player.update(keys,dt,world)
   for car in cars:
    if car is not player.vehicle and car.traffic:
     car.update_traffic(dt)
     if car.x<0 or car.x>WORLD_W or car.y<0 or car.y>WORLD_H: car.x=random.randint(100,WORLD_W-100); car.y=random.randint(100,WORLD_H-100)
   completed=missions.update(player)
   if completed:
    toast=f"MISSION COMPLETE   +$ {completed.reward}"; toast_timer=3.0; dialogue=list(SCENES.get(missions.index,ENDING)); dialogue_index=0
   if wanted and len(police)<wanted: police.append(PoliceCar(player.x+random.choice([-420,420]),player.y+random.choice([-320,320])))
   for cop in police: cop.chase(player,dt,world)
   for cop in police:
    if math.dist((cop.x,cop.y),(player.x,player.y))<32: player.hp=max(0,player.hp-18*dt)
   if toast_timer>0: toast_timer-=dt
   if player.hp<=0:
    player.hp=100; player.x,player.y=430,430; player.vehicle=None; wanted=0; police.clear(); toast="YOU GOT AWAY — lay low for a moment"; toast_timer=4
  screen.fill(BG); world.draw(screen,camera); mission=missions.current
  if mission:
   mx,my=camera(*mission.target); pygame.draw.circle(screen,(255,205,92),(mx,my),36,3); pygame.draw.circle(screen,(255,205,92),(mx,my),9)
  for car in cars: car.draw(screen,camera)
  for cop in police: cop.draw(screen,camera)
  player.draw(screen,camera); draw_hud(screen,player,mission,wanted)
  if show_map: draw_minimap(screen,player,world,mission)
  if toast_timer>0: text(screen,toast,(screen.get_width()//2-190,screen.get_height()-220),19,YELLOW,True)
  if dialogue: draw_dialogue(screen,dialogue[dialogue_index],dialogue_index,len(dialogue))
  if paused: draw_pause(screen)
  pygame.display.flip()
 pygame.quit(); sys.exit()
if __name__=="__main__": main()
