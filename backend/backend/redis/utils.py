from typing import Any

from pydantic import BaseModel
from redis import Redis, Sentinel

from backend.redis.storage import RedisStorage
from backend.settings.database import redis_settings


class SentinelUrl(BaseModel):
    scheme: str
    hosts: list[Any]
    path: str | None
    password: str | None


def get_redis_connection() -> Any:
    return Redis.from_url(
        redis_settings.url, socket_timeout=redis_settings.socket_timeout
    )


def get_redis_storage() -> RedisStorage:
    return RedisStorage()
