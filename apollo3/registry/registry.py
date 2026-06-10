from apollo3.capabilities.echo import echo

def build(engine):
    engine.register("echo", echo)
    return engine
