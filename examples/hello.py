from apollo3.core.core import Core

core = Core()
core.register("hello", lambda x: f"Hello {x}")

print(core.execute("hello", "APOLLO3"))
