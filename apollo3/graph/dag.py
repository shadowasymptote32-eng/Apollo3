class DAG:
    def __init__(self):
        self.nodes = {}

    def add(self, name, fn, deps=[]):
        self.nodes[name] = {"fn": fn, "deps": deps}

    def run(self, name):
        node = self.nodes[name]
        return node["fn"]()
