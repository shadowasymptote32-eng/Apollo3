#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🧬 APOLLO3 v0.2 FULL BOOTSTRAP START"

# =========================
# STRUCTURE
# =========================
mkdir -p apollo3/{core,runtime,registry,cli,capabilities}
mkdir -p examples tests .github/workflows

# =========================
# CORE
# =========================
cat > apollo3/core/capability.py << 'EOF'
class Capability:
    def __init__(self, name, fn, spec=None):
        self.name = name
        self.fn = fn
        self.spec = spec or {}

    def run(self, *args, **kwargs):
        return self.fn(*args, **kwargs)
EOF

# =========================
# REGISTRY
# =========================
cat > apollo3/registry/registry.py << 'EOF'
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
EOF

# =========================
# ENGINE
# =========================
cat > apollo3/runtime/engine.py << 'EOF'
class Engine:
    def __init__(self, registry):
        self.registry = registry

    def run(self, intent, *args, **kwargs):
        cap = self.registry.resolve(intent)

        if cap is None:
            raise Exception(f"No capability for intent: {intent}")

        return cap.run(*args, **kwargs)
EOF

# =========================
# CLI
# =========================
cat > apollo3/cli/main.py << 'EOF'
import sys
from apollo3.runtime.engine import Engine
from apollo3.registry.registry import Registry
from apollo3.core.capability import Capability

def build_runtime():
    registry = Registry()

    # auto-load plugins
    registry.auto_load()

    # fallback built-in capability
    registry.register(
        "hello",
        Capability("hello", lambda x: f"Hello {x}")
    )

    return Engine(registry)

def main():
    if len(sys.argv) < 3:
        print("Usage: apollo run <intent> [args...]")
        return

    cmd = sys.argv[1]
    intent = sys.argv[2]

    engine = build_runtime()

    if cmd == "run":
        result = engine.run(intent, *sys.argv[3:])
        print(result)

if __name__ == "__main__":
    main()
EOF

# =========================
# EXAMPLE CAPABILITY (PLUGIN)
# =========================
cat > apollo3/capabilities/echo.py << 'EOF'
from apollo3.core.capability import Capability

def register(registry):
    registry.register(
        "echo",
        Capability("echo", lambda x: x)
    )
EOF

# =========================
# JSON SPEC FOUNDATION (future layer)
# =========================
cat > apollo3/capabilities/spec_template.json << 'EOF'
{
  "name": "example",
  "inputs": ["any"],
  "output": "any",
  "deterministic": true,
  "version": "0.1"
}
EOF

# =========================
# EXAMPLE
# =========================
cat > examples/demo.py << 'EOF'
from apollo3.runtime.engine import Engine
from apollo3.registry.registry import Registry
from apollo3.core.capability import Capability

registry = Registry()

registry.register("hello", Capability("hello", lambda x: f"Hello {x}"))

engine = Engine(registry)

print(engine.run("hello", "APOLLO3"))
EOF

# =========================
# README
# =========================
cat > README.md << 'EOF'
# APOLLO3 v0.2

Capability-based deterministic runtime.

## Run CLI
python -m apollo3.cli.main run hello world

## Example plugin
capabilities/echo.py
EOF

echo "🧬 APOLLO3 BOOTSTRAP COMPLETE"
echo "Next: python apollo3/cli/main.py run hello APOLLO3"
