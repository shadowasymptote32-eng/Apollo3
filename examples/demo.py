from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build

engine = build(Engine())
print(engine.execute("echo:demo"))
