from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build

class Shell:
    def __init__(self):
        self.engine = build(Engine())

    def run(self, intent: str):
        return self.engine.execute(intent)

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            cmd = input(">>> ")
            if cmd == "exit":
                break
            print(self.run(cmd))
