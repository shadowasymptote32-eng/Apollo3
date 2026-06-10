def parse(text: str):
    text = text.lower().strip()

    if "hello" in text:
        return "echo:hello"

    if "run" in text:
        return "echo:running"

    return f"echo:{text}"
