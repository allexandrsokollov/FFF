from datetime import datetime, timezone


def now_utc() -> datetime:
    return datetime.utcnow().replace(tzinfo=timezone.utc)


def to_snake(string: str) -> str:
    """Преобразование строки из camelCase/UpperCamelCase в snake_case"""

    letters = []
    for index, letter in enumerate(string):
        if letter.isupper() and index != 0:
            letters.append("_")
        letters.append(letter.lower())

    return "".join(letters)
