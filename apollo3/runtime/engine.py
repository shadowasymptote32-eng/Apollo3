class Engine:
    def __init__(self):
        self.state = {}

    def run(self, intent: str):
        return f"APOLLO3::EXEC::{intent}"
