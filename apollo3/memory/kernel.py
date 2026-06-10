class MicroASI:
    def __init__(self):
        self.store = []

    def observe(self, x):
        self.store.append(x)

    def reflect(self):
        return {
            "memory_size": len(self.store),
            "last": self.store[-1] if self.store else None
        }
