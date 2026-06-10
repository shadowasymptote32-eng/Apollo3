from apollo3.core.capability import Capability

def register(registry):
    registry.register(
        "echo",
        Capability("echo", lambda x: x)
    )
