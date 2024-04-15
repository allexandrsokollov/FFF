from pydantic import EmailStr
from sqlalchemy.orm import Mapped, MappedColumn

from backend.orm.base import Base


class User(Base):
    username: Mapped[str] = MappedColumn(unique=True)
    password: Mapped[str]
    email: Mapped[EmailStr] = MappedColumn(unique=True)
    is_active: bool = MappedColumn(default=True)
    is_admin: bool = MappedColumn(default=False)
