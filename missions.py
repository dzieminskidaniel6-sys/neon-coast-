import math
class Mission:
 def __init__(self,title,description,target,reward):
  self.title,self.description=title,description; self.target,self.reward=target,reward; self.complete=False
 def check(self,player):
  if not self.complete and math.dist((player.x,player.y),self.target)<78:
   self.complete=True; player.cash+=self.reward; return True
  return False
class MissionManager:
 def __init__(self):
  self.missions=[
   Mission("01 | FIRST IMPRESSION","Deliver Maya's case to the pier.",(2820,245),350),
   Mission("02 | OLD FRIENDS","Meet Nico at the downtown garage.",(1780,715),500),
   Mission("03 | THE NIGHT MARKET","Find Vesper near the beach lookout.",(740,1185),650),
   Mission("04 | GHOST SIGNAL","Recover Leo's data drive at the observatory.",(2820,1655),800),
   Mission("05 | THE PORT","Reach the container terminal.",(1780,2125),1200)]
  self.index=0; self.free_roam=False
 @property
 def current(self): return self.missions[self.index] if self.index<len(self.missions) else None
 def update(self,player):
  mission=self.current
  if mission and mission.check(player):
   self.index+=1
   if self.index>=len(self.missions): self.free_roam=True
   return mission
  return None
