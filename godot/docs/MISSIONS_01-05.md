# NEON COAST — MISSION DESIGN
## Missions 01–05 | Production draft v0.1

This document expands the existing campaign outline into playable mission specifications. It preserves the existing mission titles, core plot beats, and dialogue from `story.py` and `missions.py`. New gameplay sequences, optional dialogue, branches, and rewards are proposals, not implemented features or locked canon.

## Shared mission rules

- Every mission has a clear start, objective, active gameplay, conclusion, and reward.
- The player should perform the key action; missions must not complete merely because Alex walks near a distant marker.
- Critical story information is never missable. Optional actions can change trust, money, evidence quality, or later dialogue.
- Failure should usually create a recoverable setback (lost time, reduced reward, changed route), not silently break the campaign.
- Dialogue is data-driven. The scene system should support speaker, line, optional choices, conditions, and consequences.
- All reward amounts below are balancing placeholders. The original 2D prototype has cash rewards; the Godot implementation still needs its own economy.

---

# MISSION 01 — A STRANGER IN TOWN

**Chapter:** I — A Stranger in Town  
**Location:** Boardwalk, outside the diner  
**Cast:** Alex, Maya  
**Purpose:** Introduce Alex's search, establish Maya, teach walking, camera, interaction, and dialogue choices.  
**Estimated time:** 8–12 minutes

### Narrative setup

Alex arrives in Vice District after three weeks of searching for his missing brother Leo. Maya has contacted him with a possible lead. She does not immediately trust him and asks him to deliver a sealed case to Nico.

### Opening scene

Use the existing opening lines from `story.py` as the canonical first-pass dialogue:

- MAYA: “Vice District. Pretty lights, ugly secrets. You must be Alex.”
- ALEX: “I'm looking for my brother. Leo disappeared three weeks ago.”
- MAYA: “Then you need to understand this city. Nobody vanishes without someone noticing.”
- ALEX: “You said you had a lead.”
- MAYA: “I do. But first, prove I can trust you. Take this case to Nico.”
- ALEX: “And don't ask what's inside?”
- MAYA: “Now you're learning.”

### Playable flow

1. **Arrival:** short camera reveal of the boardwalk and diner. Player gains control.
2. **Find Maya:** objective marker points to Maya, but her name and a small interaction prompt are visible within interaction range.
3. **Talk:** player starts the dialogue. The opening scene plays.
4. **Choice — how Alex responds to the sealed case:**
   - “Fine. I'll deliver it.” Neutral response; mission continues.
   - “You could at least tell me why.” Maya gives a short evasive explanation; small trust-positive flag for asking directly but respectfully.
   - “I don't take orders.” Maya warns Alex that he can walk away; player can still accept or decline once. Declining pauses the mission and leaves it available.
5. **Accept the case:** case becomes a mission item. The next objective points to Nico's garage.
6. **Mission complete:** only after the player accepts the case and the next mission is unlocked.

### Gameplay systems taught

- Basic movement and camera look.
- Interact key and interaction range.
- Dialogue start/advance.
- Dialogue choice UI.
- Mission objective update and mission completion event.

### Consequences

- Set `maya_trust` to baseline on first meeting.
- Respectful/direct response: `maya_trust +1` (proposal).
- Hostile response: no trust gain; Maya's next greeting is colder (proposal).
- No choice blocks the main story.

### Rewards

- Unlock Mission 02.
- Optional small cash/experience reward: none; this is an introduction.
- Case added to inventory/mission state.

### Acceptance criteria

- Player can move and look around before speaking.
- Maya's dialogue cannot trigger repeatedly while already active.
- Choice is saved once and is not duplicated after reloading.
- The case is required to start Mission 02.
- No objective completes from proximity alone.

---

# MISSION 02 — THE FIRST PACKAGE

**Chapter:** I — A Stranger in Town  
**Location:** Boardwalk streets to Nico's garage, Old Quarter edge  
**Cast:** Alex, Nico  
**Purpose:** Teach navigation, carrying/delivering a mission item, first driving introduction if the vehicle system is ready, and establish Nico's connection to Leo.  
**Estimated time:** 10–15 minutes

### Narrative setup

Alex takes Maya's sealed case to Nico. The case is a reason for the meeting, but the important outcome is learning that Nico repaired Leo's car and noticed that Leo was frightened.

### Existing story dialogue

Preserve the existing opening at Nico's garage:

- NICO: “Maya sent you? Put the case down. Slowly.”
- ALEX: “You know Leo?”
- NICO: “I repaired his car. He was scared. Said the Harbor Authority was watching him.”

### Playable flow

1. **Leave the diner:** case is visible as a carried prop or mission icon; do not require a complex carry animation in the first implementation.
2. **Navigate to garage:** player follows the route marker through one short street segment.
3. **Optional exploration:** a nearby shopkeeper can give a one-line comment about the port. This is flavor only and cannot block the mission.
4. **Deliver case:** interact with the garage counter/door to trigger the scene.
5. **Conversation:** Alex asks whether Nico knew Leo. Nico reveals that he repaired Leo's car and that Leo seemed scared.
6. **Follow-up choice:**
   - “What did he say about the Authority?” Nico explains that Leo was worried about being watched.
   - “Why didn't you call me?” Nico says he did not know Alex existed / could not reach him (exact truth to be decided in the character bible).
   - “I need to see the car.” Nico says the car is not here, setting up Mission 03.
7. **Mission complete:** Nico agrees to help Alex investigate the repair history.

### Driving implementation note

The mission should be playable on foot in the first milestone. If vehicle entry and driving are implemented and tested, add a short optional/required drive segment. Do not make campaign progression depend on an unfinished vehicle controller.

### Consequences

- Set `nico_trust` baseline.
- Helpful/patient dialogue may add `nico_trust +1` (proposal).
- Unlock Nico's garage as a world location.
- Record `leo_car_repaired_by_nico = true`.

### Rewards

- Unlock Mission 03.
- Garage location added to map.
- Placeholder reward: 500 cash, matching the original mission reward, once the economy exists.

### Acceptance criteria

- Case delivery triggers the scene exactly once.
- Mission cannot be completed before the delivery interaction.
- Dialogue choice updates the correct story flag.
- If vehicle driving is unavailable, the mission remains fully completable on foot.

---

# MISSION 03 — OLD ENGINE, NEW LIES

**Chapter:** I — A Stranger in Town  
**Location:** Nico's garage and nearby backstreet  
**Cast:** Alex, Nico, optional technician clue  
**Purpose:** Turn the brother's disappearance into an investigation; introduce inspectable clues and a simple evidence log.  
**Estimated time:** 12–18 minutes

### Narrative setup

Nico confirms that Leo's car had a tracker installed after the repair. He cannot trace it from the garage. Alex must identify the technician who fitted it.

### Existing story dialogue

Preserve the original scene:

- NICO: “Leo's car had a tracker installed after the repair.”
- ALEX: “Can you trace it?”
- NICO: “Not here. Find the technician who fitted it.”

### Playable flow

1. **Garage briefing:** Nico marks the service date in a work ledger.
2. **Inspect the ledger:** player interacts with the ledger and finds a partial invoice number and the name of a local installation shop.
3. **Search the garage:** optional inspection of three props (old tire, toolbox, photo of Leo's car). Only the work ledger is required.
4. **Reconstruct the route:** player uses the invoice clue to mark a small workshop on the map.
5. **Backstreet search:** reach the workshop. The door is closed; an employee nearby points to the technician's current work location at Night Market.
6. **Evidence log update:** add “Tracker installation — technician identified” to the case file.
7. **Mission complete:** Vesper is not met yet; her name is saved as the next lead.

### Optional clue

A handwritten note in the ledger suggests Leo asked Nico to keep the repair quiet. Finding it adds a line to Alex's journal and can improve `evidence_strength`, but is not required.

### Consequences

- Set `tracker_lead_found = true`.
- Optional note: `evidence_strength +1`.
- Unlock Mission 04 and mark Night Market as a search area.

### Rewards

- Placeholder reward: 560 cash, matching the original mission reward.
- Evidence log feature introduced.

### Acceptance criteria

- Required clue is highlighted subtly (sound/outline/prompt), not hidden behind pixel hunting.
- Optional clue is genuinely optional.
- Journal records the clue and does not duplicate it after reload.
- Mission completes on evidence confirmation, not merely entering the workshop radius.

---

# MISSION 04 — MARKET AFTER DARK

**Chapter:** I — A Stranger in Town  
**Location:** Night Market  
**Cast:** Alex, technician, Vesper  
**Purpose:** Introduce Vesper, the first meaningful approach choice, and the idea that information has a cost.  
**Estimated time:** 15–20 minutes

### Narrative setup

The technician admits that a woman from Night Market arranged the tracker installation. The woman is Vesper. Vesper knows that Leo bought a transmitter and asked about shipments missing from official manifests.

### Existing story dialogue

Preserve the existing beats:

- TECH: “I only install what customers pay for.”
- ALEX: “My brother paid you.”
- TECH: “A woman from the night market arranged it. Ask for Vesper.”
- VESPER: “Leo bought a transmitter. Then he started asking about shipments.”
- ALEX: “What shipments?”
- VESPER: “The kind that don't appear on any official manifest.”

### Playable flow

1. **Enter Night Market:** crowd ambience can be represented with a few static/low-cost NPCs in the first pass.
2. **Find technician:** player identifies the technician by matching the shop sign/invoice clue.
3. **Talk to technician:** dialogue confirms Vesper arranged the tracker.
4. **Find Vesper:** player follows a clue to a stall/side entrance, not a floating marker directly on her head.
5. **Vesper's offer:** she reveals the transmitter and suspicious shipments, but refuses to provide more for free.
6. **Main choice — how Alex earns the information:**
   - **Pay:** spend a placeholder 150 cash; Vesper gives the information immediately. `vesper_debt` remains unchanged.
   - **Do a favor:** accept a future optional favor flag; no cash cost. `vesper_debt +1`, and Vesper's later dialogue acknowledges it.
   - **Refuse and press:** Vesper gives only the essential clue, but relationship does not improve. Optional side lead is not unlocked.
7. **Mission complete:** Maya contacts Alex and points him toward the old relay station.

### Consequences

- Set `vesper_met = true`.
- Set one of `vesper_paid`, `vesper_favor_owed`, or `vesper_pressed`.
- All paths unlock the next main mission.
- Later dialogue and one optional side job can vary by approach.

### Rewards

- Placeholder reward: 620 cash, matching the original mission reward; paying Vesper is a separate expense.
- Unlock Vesper as a contact.
- Unlock Mission 05.

### Acceptance criteria

- The three approaches are all completable.
- Payment is checked before money is deducted.
- Favor debt is stored in the save.
- Essential information is always delivered, regardless of approach.
- The choice is reflected in Vesper's next interaction.

---

# MISSION 05 — STATIC ON THE LINE

**Chapter:** II — Ghost Frequency  
**Location:** Old relay station, Industrial Belt outskirts  
**Cast:** Alex, Maya (radio/phone)  
**Purpose:** First investigation mission in a more isolated space; teach environmental interaction, signal tracing, and a timed but forgiving puzzle.  
**Estimated time:** 15–20 minutes

### Narrative setup

Maya says the old relay station is abandoned but its signal is still active. Alex investigates and discovers that the signal is not random: it is a trace connected to Leo's transmitter.

### Existing story dialogue

Preserve the existing scene:

- MAYA: “The relay station is old, but its signal is still active.”
- ALEX: “Could it lead to Leo?”
- MAYA: “Or to the people who took him. Be careful.”

### Playable flow

1. **Briefing:** Maya calls Alex and explains that the station is active.
2. **Travel to Industrial Belt:** objective marker points to the station perimeter.
3. **Find a safe entrance:** player can use the main gate (slower, requires finding a maintenance switch) or a side gap (shorter, but includes a simple obstacle).
4. **Restore power:** interact with a breaker panel. Three switches are labeled with faded symbols; environmental hints make the correct order readable.
5. **Tune the receiver:** a simple three-step frequency puzzle. The UI shows signal strength; player adjusts a dial until the signal stabilizes.
6. **Signal spike:** a short scripted event suggests someone is monitoring the station. No forced combat; Alex can hide behind cover or leave the room.
7. **Recover the log:** download/photograph a short signal log. It contains a timestamp and points to an old apartment block.
8. **Call Maya:** she confirms the next lead. The note about the blue lantern is reserved for Mission 06.
9. **Mission complete:** unlock The Wrong Address.

### Optional evidence

A secondary terminal contains a partial shipment ID. Finding it adds `evidence_strength +1` and a later optional dialogue line with Vesper.

### Consequences

- Set `relay_signal_logged = true`.
- Optional terminal: `evidence_strength +1`.
- Set `harbor_attention +1` only if the player triggers the loud/obvious route (proposal; avoid punishing normal play).
- Unlock Mission 06.

### Rewards

- Placeholder reward: 700 cash, matching the original mission reward.
- New evidence entry: “Relay signal — timestamp and apartment lead.”

### Acceptance criteria

- Puzzle can be solved with keyboard and mouse; no precision timing required.
- No mandatory combat.
- Signal log persists after reload.
- Optional evidence is recorded separately from the critical story clue.
- The next mission is unlocked only after Alex sends the log to Maya.

---

## Cross-mission continuity and state

Suggested persistent story state (names are stable IDs; values are proposals):

| Key | Type | Set by | Purpose |
|---|---|---|---|
| `maya_trust` | integer | M01 and later | Dialogue tone and optional support |
| `nico_trust` | integer | M02 and later | Garage support and vehicle help |
| `vesper_debt` | integer | M04 and later | Favor obligations |
| `vesper_met` | bool | M04 | Contact unlock |
| `tracker_lead_found` | bool | M03 | Evidence progression |
| `evidence_strength` | integer | optional clues | Final evidence quality |
| `relay_signal_logged` | bool | M05 | Main campaign progression |
| `harbor_attention` | integer | loud/visible actions | Later security pressure |

Do not implement every proposed variable before the save/load system exists. First define a versioned story-state dictionary and test persistence.

## Implementation order for Godot

1. Dialogue panel with speaker, line, advance, and choice buttons.
2. Interaction target with distance check and one active interaction at a time.
3. Mission state machine: `locked → available → active → completed`.
4. Objective text and journal entries.
5. Persistent story flags and save/load.
6. Implement Mission 01 end-to-end before building the remaining four.
7. Add the next mission only after the previous one passes its acceptance criteria.

## Not yet implemented

This is a design document only. It does not claim that these missions, choices, dialogue UI, evidence log, puzzles, or rewards are implemented in the Godot build. Each system must be prototyped and tested before being marked complete.
