class IntentParser:
    def parse(self, text: str):
        parts = text.strip().split()
        return {
            "action": parts[0] if parts else None,
            "target": " ".join(parts[1:]) if len(parts) > 1 else None
        }
