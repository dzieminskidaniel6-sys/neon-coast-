"""Original story scenes for Neon Coast."""
from dataclasses import dataclass
@dataclass
class Scene:
    speaker: str
    line: str
INTRO = [
 Scene("MAYA","You're late, Alex. Welcome to Vice District — where the sun is fake and the deals are worse."),
 Scene("ALEX","I didn't come here for the view. You said you had a lead on my brother."),
 Scene("MAYA","I do. But first, I need someone I can trust. The police have half the docks on lockdown."),
 Scene("ALEX","So what's the job?"),
 Scene("MAYA","A simple delivery. Don't ask what's in the case. And try not to make the evening news."),
]
SCENES = {
 0:[Scene("MAYA","The pier is east of here. Take the package to Nico, the mechanic in the blue garage."),Scene("ALEX","And then you'll tell me about my brother?"),Scene("MAYA","One step at a time. This city eats impatient people.")],
 1:[Scene("NICO","You made it. The package is safe. That's more than I expected."),Scene("ALEX","You know my brother, Leo?"),Scene("NICO","I fixed his car the night he vanished. He was asking about a woman called Vesper."),Scene("MAYA","Vesper runs the night market. Find her, but keep your head down.")],
 2:[Scene("VESPER","Leo? He bought a data drive from me. Then the Harbor Authority started asking questions."),Scene("ALEX","Where is the drive?"),Scene("VESPER","At the old observatory. But the road there is watched. You didn't hear that from me.")],
 3:[Scene("MAYA","The drive confirms it. The Harbor Authority is moving people and money through the port."),Scene("ALEX","And Leo?"),Scene("MAYA","He found proof. They grabbed him before he could get it out."),Scene("ALEX","Then we're getting him back.")],
 4:[Scene("NICO","I tuned the car. It won't make you invisible, but it'll get you through the port gates."),Scene("MAYA","The signal ends at the container terminal. Get in, find Leo, and don't stop."),Scene("ALEX","I'm bringing my brother home.")],
 5:[Scene("LEO","Alex? You actually came."),Scene("ALEX","You thought I'd leave you here? Come on. We have a city to expose."),Scene("MAYA","The evidence is already on its way to every newsroom. Vice District just woke up."),Scene("LEO","So... breakfast?"),Scene("ALEX","After we get out of this place. Move!")],
}
ENDING=[Scene("NARRATOR","SUNRISE OVER VICE DISTRICT"),Scene("MAYA","The city won't change overnight. But now it knows the truth."),Scene("ALEX","Then tomorrow, we make it better."),Scene("NARRATOR","THE END — FREE ROAM UNLOCKED")]
