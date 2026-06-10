class Capability:
    def __init__(self, name, fn):
        self.name = name
        self.fn = fn

    def run(self, *args, **kwargs):
        return self.fn(*args, **kwargs)
