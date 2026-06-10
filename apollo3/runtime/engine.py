class Engine:
    def __init__(self, registry):
        self.registry = registry

    def run(self, intent, *args, **kwargs):
        cap = self.registry.resolve(intent)

        if cap is None:
            raise Exception(f"No capability for intent: {intent}")

        return cap.run(*args, **kwargs)
