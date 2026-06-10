class Node:
    def __init__(self, name, fn, deps=None):
        self.name = name
        self.fn = fn
        self.deps = deps or []

class DAG:
    def __init__(self):
        self.nodes = {}

    def add(self, node):
        self.nodes[node.name] = node

    def run(self):
        done = set()

        def exec_node(name):
            if name in done:
                return
            node = self.nodes[name]
            for d in node.deps:
                exec_node(d)
            node.fn()
            done.add(name)

        for n in list(self.nodes.keys()):
            exec_node(n)
