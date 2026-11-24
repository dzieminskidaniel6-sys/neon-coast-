import pygame
from settings import *
def font(size,bold=False): return pygame.font.SysFont("arial",size,bold=bold)
def text(surf,msg,pos,size=20,color=WHITE,bold=False): surf.blit(font(size,bold).render(str(msg),True,color),pos)
def draw_hud(surf,player,mission,wanted):
 panel=pygame.Surface((300,116),pygame.SRCALPHA); panel.fill((8,14,25,225)); surf.blit(panel,(18,18))
 text(surf,"NEON COAST",(32,27),23,CYAN,True); text(surf,f"HEALTH {max(0,int(player.hp)):03d}",(32,60),17,GREEN,True); text(surf,f"CASH $ {player.cash:,}",(32,85),17,YELLOW,True)
 if mission:
  box=pygame.Surface((430,94),pygame.SRCALPHA); box.fill((8,14,25,225)); surf.blit(box,(WIDTH-450,18))
  text(surf,"STORY OBJECTIVE",(WIDTH-432,29),14,PINK,True); text(surf,mission.title,(WIDTH-432,51),19,WHITE,True); text(surf,mission.description,(WIDTH-432,78),14,MUTED)
 if wanted: text(surf,"★"*wanted,(WIDTH//2-45,25),28,RED,True)
 if player.vehicle: text(surf,f"{abs(int(player.vehicle.speed))} KM/H",(WIDTH-190,HEIGHT-58),25,CYAN,True)
 text(surf,"WASD / ARROWS MOVE   E CAR   SHIFT SPRINT   SPACE BRAKE   ESC PAUSE",(20,HEIGHT-30),14,MUTED)
def draw_minimap(surf,player,world,mission):
 size=176; x=WIDTH-size-22; y=HEIGHT-size-24; panel=pygame.Surface((size,size),pygame.SRCALPHA); panel.fill((5,12,22,225)); sx=size/WORLD_W; sy=size/WORLD_H
 for r in world.roads: pygame.draw.rect(panel,(92,102,116),(int(r.x*sx),int(r.y*sy),max(1,int(r.width*sx)),max(1,int(r.height*sy))))
 for r,c in world.buildings: pygame.draw.rect(panel,(112,100,130),(int(r.x*sx),int(r.y*sy),max(1,int(r.width*sx)),max(1,int(r.height*sy))))
 if mission: pygame.draw.circle(panel,YELLOW,(int(mission.target[0]*sx),int(mission.target[1]*sy)),4)
 pygame.draw.circle(panel,CYAN,(int(player.x*sx),int(player.y*sy)),5); surf.blit(panel,(x,y)); pygame.draw.rect(surf,(90,115,135),(x,y,size,size),2)
def draw_dialogue(surf,scene,index,total):
 shade=pygame.Surface((WIDTH,HEIGHT),pygame.SRCALPHA); shade.fill((2,5,12,105)); surf.blit(shade,(0,0)); box=pygame.Rect(42,HEIGHT-205,WIDTH-84,166)
 pygame.draw.rect(surf,(7,13,27),box,border_radius=14); pygame.draw.rect(surf,CYAN,box,2,border_radius=14)
 text(surf,scene.speaker,(box.x+24,box.y+18),17,PINK,True)
 words=scene.line.split(); lines=[]; current=""
 for word in words:
  test=(current+" "+word).strip()
  if font(22).size(test)[0]>box.width-50: lines.append(current); current=word
  else: current=test
 if current: lines.append(current)
 for i,line in enumerate(lines[:3]): text(surf,line,(box.x+24,box.y+55+i*30),22,WHITE)
 text(surf,f"{index+1}/{total}  SPACE / ENTER — CONTINUE",(box.right-360,box.bottom-29),13,MUTED,True)
def draw_pause(surf):
 shade=pygame.Surface((WIDTH,HEIGHT),pygame.SRCALPHA); shade.fill((2,5,12,190)); surf.blit(shade,(0,0)); title=font(54,True).render("PAUSED",True,CYAN); surf.blit(title,title.get_rect(center=(WIDTH//2,HEIGHT//2-30))); sub=font(20).render("Press ESC to return to Vice District",True,WHITE); surf.blit(sub,sub.get_rect(center=(WIDTH//2,HEIGHT//2+30)))
def draw_title(surf):
 surf.fill((8,13,26)); title=font(72,True).render("NEON COAST",True,CYAN); sub=font(27,True).render("VICE DISTRICT",True,PINK)
 surf.blit(title,title.get_rect(center=(WIDTH//2,HEIGHT//2-105))); surf.blit(sub,sub.get_rect(center=(WIDTH//2,HEIGHT//2-48)))
 text(surf,"A STORY OF FAMILY, SECRETS AND ONE VERY BAD CITY",(WIDTH//2-250,HEIGHT//2+5),18,WHITE,True); text(surf,"PRESS ENTER TO START",(WIDTH//2-115,HEIGHT//2+85),20,YELLOW,True); text(surf,"WASD / ARROWS TO MOVE   •   E TO ENTER CARS",(WIDTH//2-210,HEIGHT-65),15,MUTED)
