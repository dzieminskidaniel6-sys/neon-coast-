"""Deterministic city map; static geometry is rendered once for cheap frame blits."""
import random, pygame
from settings import *
class World:
 def __init__(self):
  self.roads=[]; self.buildings=[]; self.decor=[]
  for x in range(220,WORLD_W,560):self.roads.append(pygame.Rect(x,0,116,WORLD_H))
  for y in range(190,WORLD_H,490):self.roads.append(pygame.Rect(0,y,WORLD_W,116))
  rng=random.Random(44)
  palette=[(43,65,83),(67,56,88),(48,83,82),(89,67,75),(58,72,91)]
  for gx in range(0,WORLD_W-420,560):
   for gy in range(0,WORLD_H-370,490):
    rect=pygame.Rect(gx+355,gy+320,300,255)
    if rect.right<WORLD_W-15 and rect.bottom<WORLD_H-15:self.buildings.append((rect,rng.choice(palette)))
  self.decor=[(rng.randint(25,WORLD_W-25),rng.randint(25,WORLD_H-25),rng.randint(5,10)) for _ in range(180)]
  self.static=pygame.Surface((WORLD_W,WORLD_H)).convert()
  self.static.fill(GRASS)
  for road in self.roads:
   pygame.draw.rect(self.static,ROAD,road); pygame.draw.rect(self.static,SIDEWALK,road,4)
   if road.width>road.height:
    for x in range(road.x+15,road.right-10,52):pygame.draw.line(self.static,ROAD_LINE,(x,road.centery),(x+22,road.centery),2)
   else:
    for y in range(road.y+15,road.bottom-10,52):pygame.draw.line(self.static,ROAD_LINE,(road.centerx,y),(road.centerx,y+22),2)
  for x,y,r in self.decor:
   pygame.draw.circle(self.static,(15,45,43),(x,y),r+3);pygame.draw.circle(self.static,(48,112,82),(x,y),r)
  for rect,color in self.buildings:
   pygame.draw.rect(self.static,(9,17,28),rect.move(9,12),border_radius=8)
   pygame.draw.rect(self.static,color,rect,border_radius=8);pygame.draw.rect(self.static,(110,145,165),rect,2,border_radius=8)
   for wx in range(rect.x+22,rect.right-12,42):
    for wy in range(rect.y+22,rect.bottom-12,42):pygame.draw.rect(self.static,(91,177,190),(wx,wy,12,9),border_radius=2)
 def blocked(self,x,y,radius):
  if x<radius or y<radius or x>WORLD_W-radius or y>WORLD_H-radius:return True
  box=pygame.Rect(int(x-radius),int(y-radius),radius*2,radius*2)
  return any(box.colliderect(b[0]) for b in self.buildings)
 def draw(self,surf,camera):
  cx,cy=camera(0,0)
  view=pygame.Rect(-cx,-cy,surf.get_width(),surf.get_height())
  src=view.clip(self.static.get_rect())
  if src.width and src.height:surf.blit(self.static,(src.x+cx,src.y+cy),src)
