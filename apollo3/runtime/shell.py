from apollo3.runtime.engine import Engine

class Shell:
    def __init__(self):
        self.engine = Engine()

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            cmd = input(">>> ")
            if cmd.strip() == "exit":
                break
            print(self.engine.run(cmd))
