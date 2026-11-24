import math

class Mission:
    def __init__(self, title, description, target, reward):
        self.title = title
        self.description = description
        self.target = target
        self.reward = reward
        self.active = False
        self.complete = False

    def check(self, player):
        if self.complete:
            return False
        if math.dist((player.x, player.y), self.target) < 70:
            self.complete = True
            player.cash += self.reward
            return True
        return False

class MissionManager:
    def __init__(self):
        self.missions = [
            Mission("A QUICK DELIVERY", "Drive to the pier marker.", (2780, 390), 350),
            Mission("NIGHT SHIFT", "Reach the downtown garage.", (1600, 1770), 600),
            Mission("COAST RUN", "Visit the beach lookout.", (360, 2050), 900),
        ]
        self.index = 0

    @property
    def current(self):
        return self.missions[self.index] if self.index < len(self.missions) else None

    def update(self, player):
        mission = self.current
        if mission and mission.check(player):
            self.index += 1
            return mission
        return None
