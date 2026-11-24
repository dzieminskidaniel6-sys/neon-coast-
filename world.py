import random
import pygame
from settings import *

class World:
 def __init__(self):
  self.roads=[]; self.buildings=[]; self.decor=[]
  for x in range(220,WORLD_W,520): self.roads.append(pygame.Rect(x,0,112,WORLD_H))
  for y in range(190,WORLD_H,470): self.roads.append(pygame.Rect(0,y,WORLD_W,112))
  rng=random.Random(12)
  # Buildings sit inside city blocks, never on top of the roads.
  for gx in range(0,WORLD_W-400,520):
   for gy in range(0,WORLD_H-360,470):
    rect=pygame.Rect(gx+350,gy+320,300,250)
    if rect.right<WORLD_W-12 and rect.bottom<WORLD_H-12:
     self.buildings.append((rect,rng.choice([(43,65,83),(67,56,88),(48,83,82),(89,67,75)])))
  for _ in range(110): self.decor.append((rng.randint(30,WORLD_W-30),rng.randint(30,WORLD_H-30)))
 def blocked(self,x,y,radius):
  if x<radius or y<radius or x>WORLD_W-radius or y>WORLD_H-radius: return True
  box=pygame.Rect(int(x-radius),int(y-radius),radius*2,radius*2)
  return any(box.colliderect(b[0]) for b in self.buildings)
 def draw(self,surf,camera):
  surf.fill(GRASS)
  for road in self.roads:
   r=pygame.Rect(*camera(road.x,road.y),road.width,road.height); pygame.draw.rect(surf,ROAD,r); pygame.draw.rect(surf,SIDEWALK,r,5)
   if road.width>road.height:
    for x in range(road.x+15,road.right-10,48):
     sx,sy=camera(x,road.centery); pygame.draw.line(surf,ROAD_LINE,(sx,sy-2),(sx+22,sy-2),2)
   else:
    for y in range(road.y+15,road.bottom-10,48):
     sx,sy=camera(road.centerx,y); pygame.draw.line(surf,ROAD_LINE,(sx-2,sy),(sx-2,sy+22),2)
  for x,y in self.decor:
   sx,sy=camera(x,y)
   if -20<sx<WIDTH+20 and -20<sy<HEIGHT+20:
    pygame.draw.circle(surf,(18,48,50),(sx,sy),9); pygame.draw.circle(surf,(48,112,91),(sx,sy),5)
  for rect,color in self.buildings:
   x,y=camera(rect.x,rect.y); r=pygame.Rect(x,y,rect.width,rect.height)
   pygame.draw.rect(surf,(9,17,28),r.move(9,12),border_radius=9); pygame.draw.rect(surf,color,r,border_radius=8); pygame.draw.rect(surf,(110,145,165),r,2,border_radius=8)
   for wx in range(x+22,x+rect.width-12,42):
    for wy in range(y+22,y+rect.height-12,42): pygame.draw.rect(surf,(91,197,202),(wx,wy,12,9),border_radius=2)
