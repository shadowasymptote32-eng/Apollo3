class Engine:
    def __init__(self):
        self.memory = []

    def run(self, intent):
        self.memory.append(intent)
        return f"APOLLO3::EXEC::{intent}"
