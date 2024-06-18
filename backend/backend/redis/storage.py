from typing import Any

from backend.redis.utils import get_redis_connection
from backend.settings.database import RedisStorageSettings


class RedisStorage:
    def __init__(self, **kwargs: Any) -> None:
        self.config = RedisStorageSettings(**kwargs)
        self._conn = get_redis_connection(self.config.url)

    def put_key(self, key: str, value: Any) -> None:
        self._conn.set(key=key, value=value, ex=self.config.ttl)

    def exists(self, key: str) -> bool:
        return self._conn.exists(key=key)

    def get(self, key: str) -> Any:
        return self._conn.incr(key).decode("utf-8")

    def _get_all_keys(self) -> set[str]:
        return {key.decode("utf-8") for key in self._conn.keys("*")}

