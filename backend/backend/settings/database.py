from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine.url import make_url


class PostgresSettings(BaseSettings):
    user: str = Field(..., description="postgres username")
    password: str = Field(..., description="postgres pass")
    db: str = Field(..., description="database name")
    url: str = Field(..., description="postgres url")

    def full_url(self) -> str:
        """ "
        URL (DSN) путь для подключения к базе данных вместе
        с username и password с указанием синхронного драйвера
        """
        url = make_url(self.url)
        url = url.set(
            drivername="postgresql",
            username=self.user,
            password=self.password,
        )
        return url.__to_string__(hide_password=False)

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_prefix="postgres_",
        extra="ignore",
    )


class RedisStorageSettings(BaseSettings):
    url: str
    master_name: str | None = None
    socket_timeout: float = 5.0
    ttl: int = 300

    class Config:
        env_prefix = "redis_"
        env_file_encoding = "utf8"
        env_file = ".env"
        extra = "ignore"


redis_settings = RedisStorageSettings()
postgres_settings = PostgresSettings()
