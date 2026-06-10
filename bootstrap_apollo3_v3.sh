#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "🧬 APOLLO3 BOOTSTRAP v3 START"

REPO_NAME="Apollo3"
USER="shadowasymptote32-eng"
REMOTE="https://github.com/$USER/$REPO_NAME.git"

# ----------------------------
# 1. Ensure repo exists
# ----------------------------
if [ ! -d .git ]; then
    git init
    git branch -M main
fi

echo "🔗 Setting remote..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE"

# ----------------------------
# 2. Structure
# ----------------------------
echo "🏗 Creating structure..."

mkdir -p apollo3/core
mkdir -p apollo3/runtime
mkdir -p apollo3/cli
mkdir -p examples
mkdir -p tests

touch apollo3/__init__.py
touch apollo3/core/__init__.py
touch apollo3/runtime/__init__.py
touch apollo3/cli/__init__.py

# ----------------------------
# 3. Minimal runtime core (safe overwrite)
# ----------------------------
cat > apollo3/core/core.py << 'EOF'
class Core:
    def __init__(self):
        self.state = {}

    def run(self, signal: str):
        return f"APOLLO3 processed: {signal}"
EOF

# ----------------------------
# 4. CLI entry
# ----------------------------
cat > apollo3/cli/main.py << 'EOF'
import os
import sys

# ensure import root works
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

from apollo3.core.core import Core

def main():
    core = Core()
    args = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "hello"
    print(core.run(args))

if __name__ == "__main__":
    main()
EOF

# ----------------------------
# 5. Example
# ----------------------------
cat > examples/hello.py << 'EOF'
from apollo3.core.core import Core

c = Core()
print(c.run("hello world"))
EOF

# ----------------------------
# 6. Git commit
# ----------------------------
git add .
git commit -m "Apollo3 bootstrap v3 runtime core" || true

# ----------------------------
# 7. Push
# ----------------------------
echo "🚀 pushing..."
git push -u origin main || git push -f origin main

# ----------------------------
# 8. sanity test
# ----------------------------
echo "🧪 runtime test..."
PYTHONPATH=. python apollo3/cli/main.py hello_apollo3

echo "🧬 APOLLO3 BOOTSTRAP COMPLETE"
