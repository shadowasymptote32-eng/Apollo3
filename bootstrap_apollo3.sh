#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🧬 APOLLO3 bootstrap starting..."

mkdir -p apollo3/core
mkdir -p capabilities examples tests .github/workflows

cat > apollo3/__init__.py << 'EOF'
__version__ = "0.1.0"
EOF

cat > apollo3/core/core.py << 'EOF'
class Core:
    def __init__(self):
        self.capabilities = {}

    def register(self, name, fn):
        self.capabilities[name] = fn

    def execute(self, name, *args, **kwargs):
        if name not in self.capabilities:
            raise Exception(f"Missing capability: {name}")
        return self.capabilities[name](*args, **kwargs)
EOF

cat > apollo3/core/capability.py << 'EOF'
class Capability:
    def __init__(self, name, fn):
        self.name = name
        self.fn = fn

    def run(self, *args, **kwargs):
        return self.fn(*args, **kwargs)
EOF

cat > examples/hello.py << 'EOF'
from apollo3.core.core import Core

core = Core()
core.register("hello", lambda x: f"Hello {x}")

print(core.execute("hello", "APOLLO3"))
EOF

cat > tests/test_core.py << 'EOF'
from apollo3.core.core import Core

def test_basic():
    core = Core()
    core.register("add", lambda a,b: a+b)
    assert core.execute("add", 2, 3) == 5
EOF

cat > README.md << 'EOF'
# APOLLO3

Capability-based deterministic runtime.
EOF

echo "✅ Done."
