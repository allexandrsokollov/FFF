from datetime import datetime, timezone


def now_utc() -> datetime:
    return datetime.utcnow().replace(tzinfo=timezone.utc)
