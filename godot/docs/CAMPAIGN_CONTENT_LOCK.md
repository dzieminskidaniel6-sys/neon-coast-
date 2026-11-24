# Campaign content lock — The Lost Signal

## Tone
Balanced: character humour and friendship alongside family drama, a grounded crime mystery and consequences. Violence is not the only solution; evidence, trust and witness safety matter.

## Structure
Five chapters, twenty main missions, seven city districts plus the outskirts, ten side activities and five conditional endings. Mission order is linear for the main spine, while player choices alter trust, evidence custody, support contacts and ending eligibility.

## Player fantasy
Alex is not a superhero. The player investigates, explores, drives, talks, collects proof and decides which relationships to protect. Combat, if added later, should be short and avoid turning the story into a power fantasy.

## Character arcs
- Alex: moves from panic and guilt to taking responsibility for choices.
- Leo: missing brother whose messages reveal that he hid to protect the evidence and his family.
- Maya: loyal friend who wants honesty and agency; trust changes if Alex shuts her out.
- Nico: mechanic and practical problem-solver; loyalty is earned through actions, not cash alone.
- Vesper: information broker who can become a genuine ally, remain transactional or sell the group out.
- Adrian Vale: polished redevelopment executive whose public story hides an illegal logistics network.

## Ending logic
The five ending definitions are in data/endings.json. Resolve by evidence count, public support, relationship values and explicit final choice flags. The fallback ending must always be reachable.

## Production rule
Each mission entry is a narrative and objective specification. It is not considered playable until its district scene, target markers, interaction points, dialogue, fail/retry rules and save checkpoints are authored and tested.
