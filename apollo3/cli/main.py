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
