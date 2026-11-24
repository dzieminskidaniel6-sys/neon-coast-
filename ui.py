import pygame
from settings import *

def font(size,bold=False):
    return pygame.font.SysFont("arial",size,bold=bold)

def text(surf,msg,pos,size=20,color=WHITE,bold=False):
    surf.blit(font(size,bold).render(str(msg),True,color),pos)

def draw_hud(surf,player,mission,wanted,show_map=True):
    panel=pygame.Surface((290,112),pygame.SRCALPHA); panel.fill((8,14,25,220))
    surf.blit(panel,(18,18))
    text(surf,"NEON COAST",32,27,22,CYAN,True)
    text(surf,f"HP  {player.hp:03d}",32,58,17,GREEN,True)
    text(surf,f"CASH  $ {player.cash:,}",32,82,17,YELLOW,True)
    if mission:
        box=pygame.Surface((390,90),pygame.SRCALPHA); box.fill((8,14,25,220))
        surf.blit(box,(WIDTH-410,18))
        text(surf,"CURRENT JOB",WIDTH-392,29,14,PINK,True)
        text(surf,mission.title,WIDTH-392,50,20,WHITE,True)
        text(surf,mission.description,WIDTH-392,76,14,MUTED)
    if wanted:
        text(surf,"★"*wanted,WIDTH//2-40,25,27,RED,True)
    if player.vehicle:
        text(surf,f"{abs(int(player.vehicle.speed))} KM/H",WIDTH-180,HEIGHT-55,25,CYAN,True)
    text(surf,"WASD MOVE  ·  E ENTER/EXIT  ·  SHIFT SPRINT  ·  ESC PAUSE",20,HEIGHT-30,14,MUTED)

def draw_minimap(surf,player,world,mission):
    size=170; x=WIDTH-size-22; y=HEIGHT-size-24
    panel=pygame.Surface((size,size),pygame.SRCALPHA); panel.fill((5,12,22,220))
    scale=size/WORLD_W
    for r in world.roads:
        pygame.draw.rect(panel,(92,102,116),(int(r.x*scale),int(r.y*scale),max(1,int(r.width*scale)),max(1,int(r.height*scale))))
    for r,c in world.buildings:
        pygame.draw.rect(panel,(112,100,130),(int(r.x*scale),int(r.y*scale),max(1,int(r.width*scale)),max(1,int(r.height*scale))))
    if mission:
        pygame.draw.circle(panel,YELLOW,(int(mission.target[0]*scale),int(mission.target[1]*scale)),4)
    pygame.draw.circle(panel,CYAN,(int(player.x*scale),int(player.y*scale)),5)
    surf.blit(panel,(x,y)); pygame.draw.rect(surf,(90,115,135),(x,y,size,size),2)

def draw_pause(surf):
    shade=pygame.Surface((WIDTH,HEIGHT),pygame.SRCALPHA); shade.fill((2,5,12,190)); surf.blit(shade,(0,0))
    title=font(54,True).render("PAUSED",True,CYAN)
    surf.blit(title,title.get_rect(center=(WIDTH//2,HEIGHT//2-30)))
    sub=font(20).render("Press ESC to return to the city",True,WHITE)
    surf.blit(sub,sub.get_rect(center=(WIDTH//2,HEIGHT//2+30)))
