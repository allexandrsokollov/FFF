import uuid
from typing import Any, Optional, TypeVar

from sqlalchemy import UUID, Column, DateTime, MetaData, create_engine
from sqlalchemy.engine import Engine
from sqlalchemy.orm import declarative_base, declared_attr, sessionmaker

from backend.settings.database import postgres_settings
from utils.utils import now_utc, to_snake


DRIVER_NAME = "postgresql"


def make_session_factory(
    database_url: str = postgres_settings.full_url(),
    engine: Optional[Engine] = None,
) -> sessionmaker:  # type: ignore [type-arg]
    engine = engine or create_engine(
        database_url,
    )

    return sessionmaker(autocommit=False, autoflush=False, bind=engine)


metadata = MetaData(
    schema=postgres_settings.schema,
)


DeclarativeBase = declarative_base(metadata=metadata)


class Base(DeclarativeBase):
    def __init__(self, *args: Any, **kwargs: Any):
        """Заглушка для проблем с mypy call-arg"""
        super().__init__(*args, **kwargs)  # pragma: no cover

    id = Column(UUID, primary_key=True, default=lambda: str(uuid.uuid4()))
    created_at = Column(DateTime(timezone=True), index=True, default=now_utc)
    updated_at = Column(DateTime(timezone=True), onupdate=now_utc, default=now_utc)
    deleted_at = Column(
        DateTime(timezone=True), index=True, default=None, nullable=True
    )

    # noinspection PyMethodParameters
    @declared_attr
    def __tablename__(  # pylint: disable=no-self-argument
        cls,  # noqa:N805
    ) -> str:  # pragma: no cover
        """Имя таблицы по-умолчанию, если не указано другое"""
        return to_snake(cls.__name__)  # type: ignore  # pylint: disable=no-member


BaseModelClass = TypeVar("BaseModelClass", bound=Base)
