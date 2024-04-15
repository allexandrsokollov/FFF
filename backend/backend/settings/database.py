from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict
from sqlalchemy.engine.url import make_url


class PostgresSettings(BaseSettings):
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

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_prefix="postgres_",
        extra="ignore",
    )


postgres_settings = PostgresSettings()
