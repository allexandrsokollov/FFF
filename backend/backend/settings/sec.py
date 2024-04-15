from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class SecSettings(BaseSettings):
    secret_key: str = Field(..., description="secret key")
    algorithm: str = "HS256"
    access_token_expire_minutes: int = Field(..., description="access token expiration")

    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", env_prefix="sec_", extra="ignore"
    )


sec_settings = SecSettings()
