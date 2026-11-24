import math
import random
import sys
import pygame
from settings import *
from world import World
from entities import Player, Vehicle, PoliceCar
from missions import MissionManager
from ui import draw_hud, draw_minimap, draw_pause, text

def main():
    pygame.init()
    screen=pygame.display.set_mode((WIDTH,HEIGHT))
    pygame.display.set_caption(TITLE)
    clock=pygame.time.Clock()
    world=World()
    player=Player(430,430)
    missions=MissionManager()
    cars=[Vehicle(600+i*135, 390+(i%2)*30, traffic=True) for i in range(12)]
    police=[]
    wanted=0
    show_map=True
    paused=False
    toast=""
    toast_timer=0
    running=True

    def camera(x,y):
        return int(x-player.x+WIDTH/2), int(y-player.y+HEIGHT/2)

    while running:
        dt=min(clock.tick(FPS)/1000,0.04)
        for event in pygame.event.get():
            if event.type==pygame.QUIT: running=False
            elif event.type==pygame.KEYDOWN:
                if event.key==pygame.K_ESCAPE: paused=not paused
                elif event.key==pygame.K_m: show_map=not show_map
                elif event.key==pygame.K_e and not paused:
                    if player.vehicle:
                        v=player.vehicle
                        player.vehicle=None
                        player.x=v.x+math.cos(v.angle+math.pi/2)*42
                        player.y=v.y+math.sin(v.angle+math.pi/2)*42
                    else:
                        near=min(cars,key=lambda c:math.dist((c.x,c.y),(player.x,player.y)),default=None)
                        if near and math.dist((near.x,near.y),(player.x,player.y))<65:
                            player.vehicle=near
                            wanted=min(5,wanted+1)
                elif event.key==pygame.K_SPACE and player.vehicle:
                    player.vehicle.speed*=0.45
        if not paused:
            keys=pygame.key.get_pressed()
            player.update(keys,dt,world)
            for car in cars:
                if car is not player.vehicle and car.traffic:
                    car.update_traffic(dt)
                    if car.x<0 or car.x>WORLD_W or car.y<0 or car.y>WORLD_H:
                        car.x=random.randint(100,WORLD_W-100); car.y=random.randint(100,WORLD_H-100)
            completed=missions.update(player)
            if completed:
                toast=f"MISSION COMPLETE  +$ {completed.reward}"
                toast_timer=3.0
            if wanted and len(police)<wanted:
                police.append(PoliceCar(player.x+random.choice([-420,420]),player.y+random.choice([-320,320])))
            for cop in police: cop.chase(player,dt,world)
            for cop in police:
                if math.dist((cop.x,cop.y),(player.x,player.y))<32:
                    player.hp=max(0,player.hp-18*dt)
            if toast_timer>0: toast_timer-=dt
        screen.fill(BG)
        world.draw(screen,camera)
        mission=missions.current
        if mission:
            mx,my=camera(*mission.target)
            pygame.draw.circle(screen,(255,205,92), (mx,my),34,3)
            pygame.draw.circle(screen,(255,205,92), (mx,my),8)
        for car in cars: car.draw(screen,camera)
        for cop in police: cop.draw(screen,camera)
        player.draw(screen,camera)
        draw_hud(screen,player,mission,wanted)
        if show_map: draw_minimap(screen,player,world,mission)
        if toast_timer>0: text(screen,toast,(WIDTH//2-160,HEIGHT-90),20,YELLOW,True)
        if paused: draw_pause(screen)
        if player.hp<=0:
            text(screen,"BUSTED — press ESC to pause",(WIDTH//2-170,HEIGHT//2),28,RED,True)
        pygame.display.flip()
    pygame.quit()
    sys.exit()

if __name__=="__main__":
    main()
