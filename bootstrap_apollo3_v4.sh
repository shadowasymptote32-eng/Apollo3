#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "🧬 APOLLO3 BOOTSTRAP v4 — FULL RUNTIME SYSTEM"

# ---------------------------
# FLAGS (edit or pass env vars)
# ---------------------------
ENABLE_GRAPH=${ENABLE_GRAPH:-1}
ENABLE_INTENT=${ENABLE_INTENT:-1}
ENABLE_MICRO_ASI=${ENABLE_MICRO_ASI:-1}

REPO="Apollo3"
USER="shadowasymptote32-eng"
REMOTE="https://github.com/$USER/$REPO.git"

# ---------------------------
# INIT GIT SAFE
# ---------------------------
if [ ! -d .git ]; then
  git init
  git branch -M main
fi

git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

# ---------------------------
# CORE STRUCTURE
# ---------------------------
mkdir -p apollo3/{core,runtime,cli,registry,capabilities,graph,intent}
mkdir -p examples tests

touch apollo3/__init__.py
touch apollo3/core/__init__.py
touch apollo3/runtime/__init__.py

# ---------------------------
# ENGINE
# ---------------------------
cat > apollo3/runtime/engine.py << 'EOF'
class Engine:
    def __init__(self):
        self.capabilities = {}
        self.graph = {}

    def register(self, name, fn):
        self.capabilities[name] = fn

    def execute(self, intent: str):
        if ":" in intent:
            cap, payload = intent.split(":", 1)
        else:
            cap, payload = "echo", intent

        if cap not in self.capabilities:
            return f"[ERR] missing capability: {cap}"

        return self.capabilities[cap](payload)
EOF

# ---------------------------
# DEFAULT CAPABILITY
# ---------------------------
cat > apollo3/capabilities/echo.py << 'EOF'
def echo(x):
    return f"APOLLO3::echo::{x}"
EOF

# ---------------------------
# REGISTRY
# ---------------------------
cat > apollo3/registry/registry.py << 'EOF'
from apollo3.capabilities.echo import echo

def build(engine):
    engine.register("echo", echo)
    return engine
EOF

# ---------------------------
# CLI
# ---------------------------
cat > apollo3/cli/main.py << 'EOF'
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build

def main():
    engine = build(Engine())
    intent = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "echo:hello"
    print(engine.execute(intent))

if __name__ == "__main__":
    main()
EOF

# ---------------------------
# OPTION A — GRAPH ENGINE (DAG)
# ---------------------------
if [ "$ENABLE_GRAPH" = "1" ]; then
cat > apollo3/graph/dag.py << 'EOF'
class DAG:
    def __init__(self):
        self.nodes = {}

    def add(self, name, fn, deps=[]):
        self.nodes[name] = {"fn": fn, "deps": deps}

    def run(self, name):
        node = self.nodes[name]
        return node["fn"]()
EOF
fi

# ---------------------------
# OPTION B — INTENT PARSER
# ---------------------------
if [ "$ENABLE_INTENT" = "1" ]; then
cat > apollo3/intent/parser.py << 'EOF'
def parse(text: str):
    text = text.lower().strip()

    if "hello" in text:
        return "echo:hello"

    if "run" in text:
        return "echo:running"

    return f"echo:{text}"
EOF
fi

# ---------------------------
# OPTION C — MICRO ASI SHELL
# ---------------------------
if [ "$ENABLE_MICRO_ASI" = "1" ]; then
cat > apollo3/runtime/shell.py << 'EOF'
from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build

class Shell:
    def __init__(self):
        self.engine = build(Engine())

    def run(self, intent: str):
        return self.engine.execute(intent)

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            cmd = input(">>> ")
            if cmd == "exit":
                break
            print(self.run(cmd))
EOF
fi

# ---------------------------
# PYPROJECT (fix pip install -e .)
# ---------------------------
cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project]
name = "apollo3"
version = "0.1.0"
description = "Apollo3 capability runtime shell"

[tool.setuptools]
packages = ["apollo3"]
EOF

# ---------------------------
# EXAMPLE
# ---------------------------
cat > examples/demo.py << 'EOF'
from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build

engine = build(Engine())
print(engine.execute("echo:demo"))
EOF

# ---------------------------
# GIT COMMIT
# ---------------------------
git add .
git commit -m "Apollo3 v4 micro-ASI runtime shell" || true

echo "🚀 pushing..."
git push -u origin main || git push -f origin main

# ---------------------------
# SANITY TEST
# ---------------------------
echo "🧪 runtime test:"
PYTHONPATH=. python apollo3/cli/main.py echo:system_check

echo "🧬 APOLLO3 BOOTSTRAP v4 COMPLETE"
echo "Options:"
echo "  A (Graph): $ENABLE_GRAPH"
echo "  B (Intent): $ENABLE_INTENT"
echo "  C (Micro ASI): $ENABLE_MICRO_ASI"
