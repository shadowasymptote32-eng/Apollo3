import sys
from apollo3.runtime.engine import Engine
from apollo3.registry.registry import build
from apollo3.intent.parser import parse

def main():
    engine = build(Engine())

    raw = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "hello"
    intent = parse(raw)

    print(engine.execute(intent))

if __name__ == "__main__":
    main()
