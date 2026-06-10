class MemoryStore:
    def __init__(self):
        self.data = []

    def add(self, item):
        self.data.append(item)

    def dump(self):
        return list(self.data)
