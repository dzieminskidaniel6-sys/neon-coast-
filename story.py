"""Original multi-chapter story for Neon Coast."""
from dataclasses import dataclass
@dataclass
class Scene:
 speaker:str
 line:str
INTRO=[
 Scene("MAYA","Vice District. Pretty lights, ugly secrets. You must be Alex."),
 Scene("ALEX","I'm looking for my brother. Leo disappeared three weeks ago."),
 Scene("MAYA","Then you need to understand this city. Nobody vanishes without someone noticing."),
 Scene("ALEX","You said you had a lead."),
 Scene("MAYA","I do. But first, prove I can trust you. Take this case to Nico."),
 Scene("ALEX","And don't ask what's inside?"),
 Scene("MAYA","Now you're learning.")]
SCENES={
 0:[Scene("NICO","Maya sent you? Put the case down. Slowly."),Scene("ALEX","You know Leo?"),Scene("NICO","I repaired his car. He was scared. Said the Harbor Authority was watching him.")],
 1:[Scene("NICO","Leo's car had a tracker installed after the repair."),Scene("ALEX","Can you trace it?"),Scene("NICO","Not here. Find the technician who fitted it.")],
 2:[Scene("TECH","I only install what customers pay for."),Scene("ALEX","My brother paid you."),Scene("TECH","A woman from the night market arranged it. Ask for Vesper.")],
 3:[Scene("VESPER","Leo bought a transmitter. Then he started asking about shipments."),Scene("ALEX","What shipments?"),Scene("VESPER","The kind that don't appear on any official manifest.")],
 4:[Scene("MAYA","The relay station is old, but its signal is still active."),Scene("ALEX","Could it lead to Leo?"),Scene("MAYA","Or to the people who took him. Be careful.")],
 5:[Scene("ALEX","A note. Leo wrote this."),Scene("MAYA","'If anything happens, look for the blue lantern.' That's the marina."),Scene("ALEX","Then that's where I'm going.")],
 6:[Scene("DOCKWORKER","Those men were asking about a data drive."),Scene("ALEX","Did you see my brother?"),Scene("DOCKWORKER","I saw someone who looked like him being moved in a black van.")],
 7:[Scene("NICO","They stole my tools to make a relay jammer."),Scene("ALEX","Can you build one?"),Scene("NICO","If you get the parts, yes. It might buy us a few minutes.")],
 8:[Scene("VESPER","This transmitter is encrypted. Leo left a key in the signal."),Scene("ALEX","Can you decode it?"),Scene("VESPER","Not without the Harbor Authority's records.")],
 9:[Scene("MAYA","The depot is guarded. Don't start a war you can't finish."),Scene("ALEX","I'm not leaving without answers."),Scene("MAYA","I know. That's why I'm helping.")],
 10:[Scene("MAYA","These files show secret transfers and false identities."),Scene("ALEX","Leo found this. That's why they took him."),Scene("MAYA","Get the copies somewhere safe.")],
 11:[Scene("WORKER","Your brother helped me once. He told me to give you this."),Scene("ALEX","A storage key?"),Scene("WORKER","He said you'd know what to do.")],
 12:[Scene("NICO","Someone is watching the district from that roof."),Scene("ALEX","A lookout?"),Scene("NICO","And maybe the only person who knows where Leo is.")],
 13:[Scene("LOOKOUT","They moved him to a container facility."),Scene("ALEX","Which one?"),Scene("LOOKOUT","The one with no number on the gate. Don't go alone.")],
 14:[Scene("VESPER","The key opens a locker with a clean vehicle and a port pass."),Scene("ALEX","You planned this?"),Scene("VESPER","Leo did. He knew you'd come.")],
 15:[Scene("NICO","Your car is ready. Reinforced doors, better acceleration."),Scene("ALEX","Will it get me through the gate?"),Scene("NICO","It'll get you close. The rest is up to you.")],
 16:[Scene("MAYA","The jammer is online. Their cameras are blind for sixty seconds."),Scene("ALEX","That's all I need."),Scene("MAYA","Bring him back, Alex.")],
 17:[Scene("WITNESS","I saw Leo being taken below the old loading bay."),Scene("ALEX","Is he alive?"),Scene("WITNESS","He was when I saw him. Hurry.")],
 18:[Scene("ALEX","The signal is coming from inside."),Scene("LEO","Alex? If that's really you, don't trust the guards."),Scene("ALEX","I'm coming. Hold on.")],
 19:[Scene("LEO","You actually came all this way."),Scene("ALEX","You're my brother. Of course I did."),Scene("MAYA","The evidence is already on its way to every newsroom."),Scene("NICO","So, who's buying breakfast?"),Scene("LEO","Alex is. He owes me three weeks.")]}
ENDING=[Scene("NARRATOR","SUNRISE OVER VICE DISTRICT"),Scene("MAYA","The city won't change overnight. But now it knows the truth."),Scene("ALEX","Then tomorrow, we make it better."),Scene("NARRATOR","CHAPTER ONE COMPLETE — FREE ROAM UNLOCKED")]
