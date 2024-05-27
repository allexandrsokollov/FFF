import uuid
from datetime import datetime
from typing import TypeVar
import re

from sqlalchemy import MetaData, create_engine
from sqlalchemy.orm import (
    Mapped,
    as_declarative,
    declared_attr,
    mapped_column,
    sessionmaker,
)

from backend.settings.database import postgres_settings


DRIVER_NAME = "postgresql"
session_factory = sessionmaker(  # type: ignore[call-overload]
    autoflush=False,
    autocommit=False,
    bind=create_engine(postgres_settings.full_url()),
)

metadata = MetaData()


@as_declarative(metadata=metadata)
class Base:

    @declared_attr  # type: ignore[arg-type]
    def __tablename__(cls) -> str:  # noqa: N805
        # CamelCase to snake_case
        return re.sub(r"(?<!^)(?=[A-Z])", "_", cls.__name__).lower()  # type: ignore[attr-defined]

    id: Mapped[uuid.UUID] = mapped_column(
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
    )
    created_at: Mapped[datetime] = mapped_column(
        default=datetime.now,
    )
    updated_at: Mapped[datetime] = mapped_column(
        onupdate=datetime.now,
        default=datetime.now,
    )


BaseModelClass = TypeVar("BaseModelClass", bound=Base)