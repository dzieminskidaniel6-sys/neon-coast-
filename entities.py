"""Player, vehicles and police. Draw code avoids per-frame Surface allocation."""
import math, random, pygame
from settings import *

def clamp(v, lo, hi): return max(lo, min(hi, v))

class Player:
    def __init__(self,x,y):
        self.x=float(x); self.y=float(y); self.speed=175; self.hp=100
        self.cash=350; self.vehicle=None; self.facing=0.0
        self.stamina=100; self.weapon_level=0
    def update(self,keys,dt,world):
        if self.vehicle:
            self.vehicle.update_player(keys,dt,world); self.x,self.y=self.vehicle.x,self.vehicle.y; return
        dx=(keys[pygame.K_d] or keys[pygame.K_RIGHT])-(keys[pygame.K_a] or keys[pygame.K_LEFT])
        dy=(keys[pygame.K_s] or keys[pygame.K_DOWN])-(keys[pygame.K_w] or keys[pygame.K_UP])
        if dx or dy:
            length=math.hypot(dx,dy); dx/=length; dy/=length
            sprint=keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]
            if sprint and self.stamina>0:
                speed=self.speed*1.55; self.stamina=max(0,self.stamina-30*dt)
            else:
                speed=self.speed; self.stamina=min(100,self.stamina+18*dt)
            nx=self.x+dx*speed*dt; ny=self.y+dy*speed*dt
            if not world.blocked(nx,self.y,12): self.x=nx
            if not world.blocked(self.x,ny,12): self.y=ny
            self.facing=math.atan2(dy,dx)
        else: self.stamina=min(100,self.stamina+24*dt)
    def draw(self,surf,camera):
        if self.vehicle:return
        x,y=camera(self.x,self.y)
        pygame.draw.ellipse(surf,(7,12,18),(x-10,y+7,21,9))
        pygame.draw.circle(surf,CYAN,(x,y),10); pygame.draw.circle(surf,WHITE,(x,y-2),4)
        pygame.draw.line(surf,PINK,(x,y),(int(x+math.cos(self.facing)*17),int(y+math.sin(self.facing)*17)),3)

class Vehicle:
    COLORS=[(244,91,125),(76,170,230),(239,184,75),(150,118,220),(75,205,160)]
    _cache={}
    def __init__(self,x,y,color=None,traffic=False):
        self.x=float(x); self.y=float(y); self.angle=random.choice([0,math.pi/2,math.pi,-math.pi/2])
        self.speed=0.0; self.max_speed=330; self.color=color or random.choice(self.COLORS)
        self.traffic=traffic; self.length=42; self.width=23
    def update_player(self,keys,dt,world):
        accel=470
        if keys[pygame.K_w] or keys[pygame.K_UP]: self.speed+=accel*dt
        elif keys[pygame.K_s] or keys[pygame.K_DOWN]: self.speed-=accel*dt
        else:self.speed*=0.965**(dt*30)
        self.speed=clamp(self.speed,-115,self.max_speed)
        steer=(keys[pygame.K_d] or keys[pygame.K_RIGHT])-(keys[pygame.K_a] or keys[pygame.K_LEFT])
        if abs(self.speed)>7:self.angle+=steer*2.05*dt*(1 if self.speed>0 else -1)
        nx=self.x+math.cos(self.angle)*self.speed*dt; ny=self.y+math.sin(self.angle)*self.speed*dt
        if world.blocked(nx,ny,17):self.speed*=-0.2
        else:self.x,self.y=nx,ny
    def update_traffic(self,dt):
        self.speed=78; self.x+=math.cos(self.angle)*self.speed*dt; self.y+=math.sin(self.angle)*self.speed*dt
    def draw(self,surf,camera):
        x,y=camera(self.x,self.y)
        bucket=int((self.angle%(2*math.pi))/(math.pi/8))%16
        key=(self.color,bucket)
        image=self._cache.get(key)
        if image is None:
            base=pygame.Surface((44,26),pygame.SRCALPHA)
            pygame.draw.rect(base,self.color,(1,2,42,22),border_radius=6)
            pygame.draw.rect(base,(32,48,65),(12,5,17,16),border_radius=3)
            pygame.draw.rect(base,(180,235,240),(31,5,7,16),border_radius=2)
            image=pygame.transform.rotate(base,-bucket*22.5); self._cache[key]=image
        surf.blit(image,image.get_rect(center=(x,y)))
        pygame.draw.circle(surf,YELLOW,(int(x+math.cos(self.angle)*19),int(y+math.sin(self.angle)*19)),2)

class PoliceCar(Vehicle):
    def __init__(self,x,y):
        super().__init__(x,y,(225,235,245)); self.max_speed=280
    def chase(self,target,dt,world):
        desired=math.atan2(target.y-self.y,target.x-self.x)
        diff=(desired-self.angle+math.pi)%(2*math.pi)-math.pi
        self.angle+=clamp(diff,-1.65*dt,1.65*dt); self.speed=min(self.max_speed,self.speed+170*dt)
        nx=self.x+math.cos(self.angle)*self.speed*dt; ny=self.y+math.sin(self.angle)*self.speed*dt
        if not world.blocked(nx,ny,17):self.x,self.y=nx,ny
        else:self.speed*=0.3
    def draw(self,surf,camera):
        super().draw(surf,camera); x,y=camera(self.x,self.y)
        pygame.draw.circle(surf,RED,(x,y-7),3); pygame.draw.circle(surf,CYAN,(x,y+7),3)
