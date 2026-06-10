def parse(text):
    t = text.lower()

    if "hello" in t:
        return "echo:hello"

    if "status" in t:
        return "echo:system_status"

    return f"echo:{text}"
