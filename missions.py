"""Main campaign and optional contracts."""
import math
class Mission:
 def __init__(self,title,description,target,reward,kind="STORY"):
  self.title=title;self.description=description;self.target=target;self.reward=reward;self.kind=kind;self.complete=False
 def check(self,player):
  if not self.complete and math.dist((player.x,player.y),self.target)<76:
   self.complete=True;player.cash+=self.reward;return True
  return False
class MissionManager:
 def __init__(self):
  points=[(838,248),(1398,738),(2518,738),(3078,1228),(1958,1718),(1398,2208),(278,2698),(838,1718),(1958,1228),(3078,248),(2518,2208),(1398,2698),(278,1718),(838,1228),(1958,248),(3078,2208),(2518,2698),(278,738),(1398,1718),(3078,2698)]
  data=[
   ("A STRANGER IN TOWN","Meet Maya outside the boardwalk diner.",420),
   ("THE FIRST PACKAGE","Deliver the sealed case to Nico's garage.",500),
   ("OLD ENGINE, NEW LIES","Find the mechanic who serviced Leo's car.",560),
   ("MARKET AFTER DARK","Track down Vesper at the night market.",620),
   ("STATIC ON THE LINE","Investigate the abandoned relay station.",700),
   ("THE WRONG ADDRESS","Search the old apartment block for Leo's note.",720),
   ("DEBT COLLECTORS","Reach the marina before the collectors do.",760),
   ("A FRIEND IN NEED","Help Nico recover his stolen tool case.",780),
   ("GHOST FREQUENCY","Recover the encrypted transmitter.",850),
   ("THE HARBOR FILES","Break into the records depot.",900),
   ("NO SAFE ROUTE","Get the evidence to Maya.",950),
   ("NIGHT SHIFT","Meet the dock worker who saw Leo.",980),
   ("THE WATCHER","Find the rooftop lookout.",1050),
   ("DEEP STORAGE","Locate the hidden storage unit.",1100),
   ("THE SECOND KEY","Bring the key to Vesper.",1150),
   ("PORT OF NO RETURN","Reach the container terminal.",1250),
   ("BREAK THE CHAIN","Disable the signal relay.",1350),
   ("THE LAST WITNESS","Find the witness near the canal.",1450),
   ("BROTHER'S TRAIL","Follow Leo's final GPS ping.",1600),
   ("THE LOST SIGNAL","Bring Leo home and expose the Harbor Authority.",2500)]
  self.missions=[Mission(t,d,p,r) for (t,d,r),p in zip(data,points)]
  self.index=0;self.side_index=0;self.free_roam=False
  self.side_missions=[
   Mission("SIDE JOB: COURIER RUN","Take a quick delivery across the district.",(838,2698),280,"SIDE"),
   Mission("SIDE JOB: LOST WALLET","Return the wallet to the boardwalk.",(2518,248),220,"SIDE"),
   Mission("SIDE JOB: NIGHT PHOTOGRAPH","Visit the canal lookout.",(278,1228),320,"SIDE"),
   Mission("SIDE JOB: SPARE PARTS","Collect the parts near the garage.",(1958,738),350,"SIDE")]
 @property
 def current(self):return self.missions[self.index] if self.index<len(self.missions) else None
 @property
 def next_side(self):return self.side_missions[self.side_index] if self.side_index<len(self.side_missions) else None
 def update(self,player):
  m=self.current
  if m and m.check(player):
   self.index+=1
   if self.index>=len(self.missions):self.free_roam=True
   return m
  return None
 def update_side(self,player):
  m=self.next_side
  if m and m.check(player):self.side_index+=1;return m
  return None
