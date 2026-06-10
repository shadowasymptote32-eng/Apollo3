class Capability:
    def __init__(self, name, fn, spec=None):
        self.name = name
        self.fn = fn
        self.spec = spec or {}

    def run(self, *args, **kwargs):
        return self.fn(*args, **kwargs)
