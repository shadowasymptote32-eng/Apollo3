class Engine:
    def __init__(self):
        self.capabilities = {}
        self.memory = []
        self.graph = {}

    def register(self, name, fn):
        self.capabilities[name] = fn

    def remember(self, item):
        self.memory.append(item)

    def execute(self, intent: str):
        self.remember(intent)

        if ":" in intent:
            cap, payload = intent.split(":", 1)
        else:
            cap, payload = "echo", intent

        if cap not in self.capabilities:
            return f"[ERR] missing capability: {cap}"

        result = self.capabilities[cap](payload)
        self.remember(result)
        return result
