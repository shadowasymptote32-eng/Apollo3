from apollo3.runtime.engine import Engine
from apollo3.registry.registry import Registry
from apollo3.core.capability import Capability

registry = Registry()

registry.register("hello", Capability("hello", lambda x: f"Hello {x}"))

engine = Engine(registry)

print(engine.run("hello", "APOLLO3"))
