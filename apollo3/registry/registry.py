import os
import importlib

class Registry:
    def __init__(self):
        self.capabilities = {}

    def register(self, name, capability):
        self.capabilities[name] = capability

    def resolve(self, intent: str):
        return self.capabilities.get(intent)

    def auto_load(self):
        """
        Plugin auto-loader (capabilities folder)
        """
        base = "apollo3.capabilities"

        for file in os.listdir("apollo3/capabilities"):
            if file.endswith(".py") and not file.startswith("__"):
                module_name = file[:-3]
                module = importlib.import_module(f"{base}.{module_name}")

                if hasattr(module, "register"):
                    module.register(self)
