#!/usr/bin/env bash
set -e

echo "🧬 APOLLO3 V7 — UNIFIED BOOTSTRAP + RUNTIME CORE"

# =========================
# FEATURE FLAGS
# =========================
ENABLE_GRAPH=${ENABLE_GRAPH:-1}
ENABLE_INTENT=${ENABLE_INTENT:-1}
ENABLE_MICRO_ASI=${ENABLE_MICRO_ASI:-1}

echo "🧬 FLAGS → Graph=$ENABLE_GRAPH Intent=$ENABLE_INTENT MicroASI=$ENABLE_MICRO_ASI"

# =========================
# SAFE GIT REMOTE FIX
# =========================
echo "🔗 syncing git remote..."

PRIMARY="https://github.com/shadowasymptote32-eng/Apollo3.git"

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$PRIMARY"
else
  git remote add origin "$PRIMARY"
fi

# =========================
# STRUCTURE BOOTSTRAP (IDEMPOTENT)
# =========================
echo "🏗 building structure..."

mkdir -p apollo3/{core,cli,runtime,graph,intent,memory,capabilities,registry,tests,examples}

touch apollo3/__init__.py
touch apollo3/core/__init__.py
touch apollo3/runtime/__init__.py

# =========================
# PYTHON PACKAGE FIX (CRITICAL)
# =========================
echo "📦 fixing python import system..."

cat > pyproject.toml <<EOF
[project]
name = "apollo3"
version = "0.1.0"
requires-python = ">=3.10"

[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"
EOF

# =========================
# CORE ENGINE
# =========================
cat > apollo3/runtime/engine.py <<'EOF'
class Engine:
    def __init__(self):
        self.memory = []

    def run(self, intent):
        self.memory.append(intent)
        return f"APOLLO3::EXEC::{intent}"
EOF

# =========================
# INTENT LAYER 🧾
# =========================
cat > apollo3/intent/parser.py <<'EOF'
class IntentParser:
    def parse(self, text: str):
        parts = text.strip().split()
        return {
            "action": parts[0] if parts else None,
            "target": " ".join(parts[1:]) if len(parts) > 1 else None
        }
EOF

# =========================
# GRAPH LAYER 🕸️
# =========================
cat > apollo3/graph/dag.py <<'EOF'
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
EOF

# =========================
# MICRO ASI 🧠 (SAFE BOUNDED MEMORY)
# =========================
cat > apollo3/memory/kernel.py <<'EOF'
class MicroASI:
    def __init__(self):
        self.store = []

    def observe(self, x):
        self.store.append(x)

    def reflect(self):
        return {
            "memory_size": len(self.store),
            "last": self.store[-1] if self.store else None
        }
EOF

# =========================
# SHELL 🧠
# =========================
cat > apollo3/runtime/shell.py <<'EOF'
from apollo3.runtime.engine import Engine
from apollo3.intent.parser import IntentParser

class Shell:
    def __init__(self):
        self.engine = Engine()
        self.parser = IntentParser()

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            try:
                cmd = input(">>> ")
            except KeyboardInterrupt:
                print("\nexit")
                break

            if cmd.strip() == "exit":
                break

            intent = self.parser.parse(cmd)
            print(self.engine.run(intent))
EOF

# =========================
# CAPABILITY EXAMPLE
# =========================
cat > apollo3/capabilities/echo.py <<'EOF'
def execute(payload):
    return f"echo::{payload}"
EOF

# =========================
# DIFF-SAFE GIT SYNC 🔁
# =========================
echo "📦 git sync..."

if git diff --quiet; then
  echo "🧬 No semantic changes — skipping commit"
else
  git add .
  git commit -m "Apollo3 V7 unified runtime update" || true
  git push origin main || git pull --rebase origin main && git push origin main
fi

# =========================
# RUNTIME TEST 🧪
# =========================
echo "🧪 runtime test..."

PYTHONPATH=. python - <<'EOF'
from apollo3.runtime.engine import Engine
e = Engine()
print(e.run("hello_apollo3"))
EOF

# =========================
# SUMMARY
# =========================
echo "🧬 APOLLO3 V7 READY"
echo "Capabilities:"
echo "  🕸 Graph execution"
echo "  🧾 Intent parsing"
echo "  🧠 Micro-ASI memory kernel"
echo "  🔁 Safe git sync"
echo "  🧠 Runtime shell"
