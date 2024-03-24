from pydantic import Field
from pydantic_settings import SettingsConfigDict
from sqlalchemy.engine.url import make_url

from backend.settings.base import Settings


class PostgresSettings(Settings):
    user: str = Field(..., description="postgres username")
    password: str = Field(..., description="postgres pass")
    db: str = Field(..., description="database name")
    schema: str = Field(..., description="postgres schema")  # type: ignore[assignment]
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

    model_config = SettingsConfigDict(env_prefix="postgres_")


postgres_settings = PostgresSettings()
