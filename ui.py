"""Resolution-aware interface."""
import pygame
from settings import *
_fonts={}
def font(size,bold=False):
 key=(size,bold)
 if key not in _fonts:_fonts[key]=pygame.font.SysFont("dejavusans",size,bold=bold)
 return _fonts[key]
def text(surf,msg,pos,size=18,color=WHITE,bold=False):
 surf.blit(font(size,bold).render(str(msg),True,color),pos)
def panel(surf,rect,alpha=220):
 box=pygame.Surface((rect.width,rect.height),pygame.SRCALPHA);box.fill((7,13,27,alpha));surf.blit(box,rect.topleft)
def draw_hud(surf,player,mission,wanted,show_hint=True):
 w,h=surf.get_size();panel(surf,pygame.Rect(12,12,245,94))
 text(surf,"NEON COAST",(25,19),20,CYAN,True);text(surf,f"HP {int(player.hp):03d}  STAMINA {int(player.stamina):03d}",(25,48),13,GREEN,True)
 text(surf,f"CASH  $ {player.cash:,}",(25,72),16,YELLOW,True)
 if mission:
  panel(surf,pygame.Rect(w-355,12,343,76));text(surf,mission.kind+" OBJECTIVE",(w-342,19),12,PINK,True)
  text(surf,mission.title,(w-342,39),15,WHITE,True);text(surf,mission.description,(w-342,61),11,MUTED)
 if wanted:text(surf,"WANTED "+"★"*wanted,(w//2-70,18),18,RED,True)
 if player.vehicle:text(surf,f"{abs(int(player.vehicle.speed))} KM/H",(w-145,h-42),20,CYAN,True)
 if show_hint:text(surf,"WASD move/drive  •  E interact/car  •  SHIFT sprint  •  M map  •  F5 save  •  F9 load  •  ESC pause",(15,h-23),11,MUTED)
def draw_minimap(surf,player,world,mission):
 size=142;w,h=surf.get_size();x=w-size-15;y=h-size-15
 mini=pygame.Surface((size,size),pygame.SRCALPHA);mini.fill((5,12,22,225));sx=size/WORLD_W;sy=size/WORLD_H
 for r in world.roads:pygame.draw.rect(mini,(92,102,116),(int(r.x*sx),int(r.y*sy),max(1,int(r.width*sx)),max(1,int(r.height*sy))))
 for r,c in world.buildings:pygame.draw.rect(mini,(112,100,130),(int(r.x*sx),int(r.y*sy),max(1,int(r.width*sx)),max(1,int(r.height*sy))))
 if mission:pygame.draw.circle(mini,YELLOW,(int(mission.target[0]*sx),int(mission.target[1]*sy)),3)
 pygame.draw.circle(mini,CYAN,(int(player.x*sx),int(player.y*sy)),4);surf.blit(mini,(x,y));pygame.draw.rect(surf,(90,115,135),(x,y,size,size),1)
def draw_dialogue(surf,scene,index,total):
 w,h=surf.get_size();shade=pygame.Surface((w,h),pygame.SRCALPHA);shade.fill((2,5,12,125));surf.blit(shade,(0,0))
 box=pygame.Rect(28,h-158,w-56,130);panel(surf,box,245);pygame.draw.rect(surf,CYAN,box,2,border_radius=10)
 text(surf,scene.speaker,(box.x+17,box.y+12),14,PINK,True)
 words=scene.line.split();lines=[];current=""
 for word in words:
  test=(current+" "+word).strip()
  if font(17).size(test)[0]>box.width-38:lines.append(current);current=word
  else:current=test
 if current:lines.append(current)
 for i,line in enumerate(lines[:3]):text(surf,line,(box.x+17,box.y+40+i*23),17,WHITE)
 text(surf,f"{index+1}/{total}  SPACE / ENTER",(box.right-155,box.bottom-20),10,MUTED,True)
def draw_title(surf):
 w,h=surf.get_size();surf.fill((8,13,26))
 for i in range(7):pygame.draw.line(surf,(15,38,55),(0,h*.45+i*24),(w,h*.45+i*24),1)
 title=font(54,True).render("NEON COAST",True,CYAN);surf.blit(title,title.get_rect(center=(w//2,h//2-65)))
 sub=font(22,True).render("THE LOST SIGNAL",True,PINK);surf.blit(sub,sub.get_rect(center=(w//2,h//2-20)))
 text(surf,"A CITY. A MISSING BROTHER. TWENTY JOBS TO FIND THE TRUTH.",(w//2-225,h//2+28),13,WHITE,True)
 text(surf,"ENTER  NEW GAME     F9  LOAD GAME",(w//2-150,h//2+82),15,YELLOW,True)
 text(surf,"Optimized for low-end PCs • 2D open-world story adventure",(w//2-205,h-35),11,MUTED)
def draw_pause(surf):
 w,h=surf.get_size();shade=pygame.Surface((w,h),pygame.SRCALPHA);shade.fill((2,5,12,190));surf.blit(shade,(0,0))
 t=font(46,True).render("PAUSED",True,CYAN);surf.blit(t,t.get_rect(center=(w//2,h//2-35)))
 text(surf,"ESC resume   •   F5 save   •   F9 load   •   Q quit",(w//2-155,h//2+20),14,WHITE)
def draw_toast(surf,msg):
 w,h=surf.get_size();img=font(16,True).render(msg,True,YELLOW);surf.blit(img,img.get_rect(center=(w//2,h-65)))
