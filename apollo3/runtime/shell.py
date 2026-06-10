from apollo3.runtime.engine import Engine
from apollo3.intent.parser import IntentParser

class Shell:
    def __init__(self):
        self.engine = Engine()
        self.parser = IntentParser()

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            try:
                cmd = input(">>> ")
            except KeyboardInterrupt:
                print("\nexit")
                break

            if cmd.strip() == "exit":
                break

            intent = self.parser.parse(cmd)
            print(self.engine.run(intent))
