class Engine:
    def __init__(self):
        self.capabilities = {}
        self.graph = {}

    def register(self, name, fn):
        self.capabilities[name] = fn

    def execute(self, intent: str):
        if ":" in intent:
            cap, payload = intent.split(":", 1)
        else:
            cap, payload = "echo", intent

        if cap not in self.capabilities:
            return f"[ERR] missing capability: {cap}"

        return self.capabilities[cap](payload)
