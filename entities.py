import math
import random
import pygame
from settings import *

def clamp(v, lo, hi):
    return max(lo, min(hi, v))

class Player:
    def __init__(self, x, y):
        self.x, self.y = float(x), float(y)
        self.speed = 230
        self.hp = 100
        self.cash = 250
        self.vehicle = None
        self.facing = 0

    def update(self, keys, dt, world):
        if self.vehicle:
            self.vehicle.update_player(keys, dt, world)
            self.x, self.y = self.vehicle.x, self.vehicle.y
            return
        dx = (keys[pygame.K_d] or keys[pygame.K_RIGHT]) - (keys[pygame.K_a] or keys[pygame.K_LEFT])
        dy = (keys[pygame.K_s] or keys[pygame.K_DOWN]) - (keys[pygame.K_w] or keys[pygame.K_UP])
        if dx or dy:
            length = math.hypot(dx, dy)
            dx, dy = dx / length, dy / length
            sprint = keys[pygame.K_LSHIFT] or keys[pygame.K_RSHIFT]
            speed = self.speed * (1.55 if sprint else 1)
            nx, ny = self.x + dx * speed * dt, self.y + dy * speed * dt
            if not world.blocked(nx, self.y, 13): self.x = nx
            if not world.blocked(self.x, ny, 13): self.y = ny
            self.facing = math.atan2(dy, dx)

    def draw(self, surf, camera):
        if self.vehicle: return
        x, y = camera(self.x, self.y)
        pygame.draw.circle(surf, (0,0,0), (x+2,y+5), 13)
        pygame.draw.circle(surf, CYAN, (x,y), 11)
        pygame.draw.circle(surf, WHITE, (x,y), 5)
        pygame.draw.line(surf, PINK, (x,y), (x+math.cos(self.facing)*19,y+math.sin(self.facing)*19), 3)

class Vehicle:
    COLORS = [(244,91,125),(76,170,230),(239,184,75),(150,118,220),(75,205,160)]
    def __init__(self, x, y, color=None, traffic=False):
        self.x, self.y = float(x), float(y)
        self.angle = random.choice([0, math.pi/2, math.pi, -math.pi/2])
        self.speed = 0
        self.max_speed = 430
        self.color = color or random.choice(self.COLORS)
        self.traffic = traffic
        self.length, self.width = 42, 23

    def update_player(self, keys, dt, world):
        accel = 560
        if keys[pygame.K_w] or keys[pygame.K_UP]: self.speed += accel * dt
        elif keys[pygame.K_s] or keys[pygame.K_DOWN]: self.speed -= accel * dt
        else: self.speed *= 0.985 ** (dt*60)
        self.speed = clamp(self.speed, -150, self.max_speed)
        steer = (keys[pygame.K_d] or keys[pygame.K_RIGHT]) - (keys[pygame.K_a] or keys[pygame.K_LEFT])
        if abs(self.speed) > 8:
            self.angle += steer * 2.3 * dt * (1 if self.speed > 0 else -1)
        nx = self.x + math.cos(self.angle) * self.speed * dt
        ny = self.y + math.sin(self.angle) * self.speed * dt
        if world.blocked(nx, ny, 18):
            self.speed *= -0.22
        else:
            self.x, self.y = nx, ny

    def update_traffic(self, dt):
        self.speed = 105
        self.x += math.cos(self.angle) * self.speed * dt
        self.y += math.sin(self.angle) * self.speed * dt

    def draw(self, surf, camera):
        x, y = camera(self.x, self.y)
        body = pygame.Surface((self.length, self.width), pygame.SRCALPHA)
        pygame.draw.rect(body, self.color, (0,0,self.length,self.width), border_radius=7)
        pygame.draw.rect(body, (35,49,66), (12,4,18,self.width-8), border_radius=4)
        pygame.draw.rect(body, (180,235,240), (31,4,7,self.width-8), border_radius=2)
        rotated = pygame.transform.rotate(body, -math.degrees(self.angle))
        surf.blit(rotated, rotated.get_rect(center=(x,y)))
        pygame.draw.circle(surf, YELLOW, (int(x+math.cos(self.angle)*20),int(y+math.sin(self.angle)*20)), 3)

class PoliceCar(Vehicle):
    def __init__(self, x, y):
        super().__init__(x,y,(225,235,245))
        self.max_speed = 360

    def chase(self, target, dt, world):
        desired = math.atan2(target.y-self.y, target.x-self.x)
        diff = (desired-self.angle+math.pi)%(2*math.pi)-math.pi
        self.angle += clamp(diff, -2.0*dt, 2.0*dt)
        self.speed = min(self.max_speed, self.speed+220*dt)
        nx = self.x+math.cos(self.angle)*self.speed*dt
        ny = self.y+math.sin(self.angle)*self.speed*dt
        if not world.blocked(nx,ny,18): self.x,self.y=nx,ny
        else: self.speed *= .35

    def draw(self, surf, camera):
        super().draw(surf,camera)
        x,y=camera(self.x,self.y)
        pygame.draw.circle(surf, RED, (x,y-7), 4)
        pygame.draw.circle(surf, CYAN, (x,y+7), 4)
