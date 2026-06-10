class Core:
    def __init__(self):
        self.capabilities = {}

    def register(self, name, fn):
        self.capabilities[name] = fn

    def execute(self, name, *args, **kwargs):
        if name not in self.capabilities:
            raise Exception(f"Missing capability: {name}")
        return self.capabilities[name](*args, **kwargs)
