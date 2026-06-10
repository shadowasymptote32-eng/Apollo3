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
