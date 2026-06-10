#!/usr/bin/env bash

set -e

echo "🧬 APOLLO3 V6 — UNIFIED BOOTSTRAP START"

# =========================
# CONFIG FLAGS (overrideable)
# =========================
ENABLE_GRAPH=${ENABLE_GRAPH:-1}
ENABLE_INTENT=${ENABLE_INTENT:-1}
ENABLE_MICRO_ASI=${ENABLE_MICRO_ASI:-1}

REPO_URL_PRIMARY="https://github.com/shadowasymptote32-eng/Apollo3.git"
REPO_URL_OLD="https://github.com/shadowasymptote32/apollo3.git"

# =========================
# FIX REPO ORIGIN
# =========================
echo "🔗 Configuring git remote..."

if git remote get-url origin >/dev/null 2>&1; then
  OLD_URL=$(git remote get-url origin)
  echo "Current origin: $OLD_URL"

  if [[ "$OLD_URL" == *"shadowasymptote32/apollo3"* ]]; then
    echo "⚠️ Detected legacy repo, switching..."
    git remote set-url origin "$REPO_URL_PRIMARY"
  fi
else
  git remote add origin "$REPO_URL_PRIMARY"
fi

# =========================
# ENSURE PYTHON PACKAGE STRUCTURE
# =========================
echo "🏗 Ensuring package structure..."

mkdir -p apollo3/{core,cli,runtime,registry,capabilities,graph,intent,memory,tests,examples}

touch apollo3/__init__.py
touch apollo3/core/__init__.py
touch apollo3/runtime/__init__.py

# Fix ModuleNotFoundError (critical)
if [ ! -f "pyproject.toml" ]; then
cat > pyproject.toml <<EOF
[project]
name = "apollo3"
version = "0.1.0"
description = "APOLLO3 runtime shell"
requires-python = ">=3.10"

[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"
EOF
fi

# =========================
# CORE RUNTIME BOOTSTRAP
# =========================
echo "🧠 Writing minimal runtime guard..."

cat > apollo3/runtime/engine.py <<'EOF'
class Engine:
    def __init__(self):
        self.state = {}

    def run(self, intent: str):
        return f"APOLLO3::EXEC::{intent}"
EOF

cat > apollo3/runtime/shell.py <<'EOF'
from apollo3.runtime.engine import Engine

class Shell:
    def __init__(self):
        self.engine = Engine()

    def loop(self):
        print("🧠 APOLLO3 SHELL ACTIVE (type 'exit')")
        while True:
            cmd = input(">>> ")
            if cmd.strip() == "exit":
                break
            print(self.engine.run(cmd))
EOF

# =========================
# CAPABILITY LAYER
# =========================
cat > apollo3/capabilities/echo.py <<'EOF'
def execute(payload):
    return f"echo::{payload}"
EOF

# =========================
# OPTIONAL MODULE FLAGS
# =========================
echo "🧬 Feature flags:"
echo "Graph=$ENABLE_GRAPH Intent=$ENABLE_INTENT MicroASI=$ENABLE_MICRO_ASI"

# =========================
# GIT COMMIT SAFE
# =========================
echo "📦 Committing..."

git add . >/dev/null 2>&1 || true

git commit -m "Apollo3 V6 unified bootstrap" >/dev/null 2>&1 || true

# =========================
# PUSH WITH MOVE HANDLING
# =========================
echo "🚀 Pushing..."

git push -u origin main || {
  echo "⚠️ Push failed — attempting fetch-rebase..."
  git pull --rebase origin main || true
  git push -u origin main
}

# =========================
# RUNTIME TEST
# =========================
echo "🧪 Runtime test..."

PYTHONPATH=. python -c "
from apollo3.runtime.engine import Engine
e = Engine()
print(e.run('hello_apollo3'))
"

echo "🧬 APOLLO3 V6 COMPLETE"
