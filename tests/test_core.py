from apollo3.core.core import Core

def test_basic():
    core = Core()
    core.register("add", lambda a,b: a+b)
    assert core.execute("add", 2, 3) == 5
