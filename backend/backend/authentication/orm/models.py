from pydantic import EmailStr
from sqlalchemy import Boolean, String
from sqlalchemy.orm import Mapped, mapped_column

from backend.orm.base import Base


class User(Base):
    username: Mapped[str] = mapped_column(String, unique=True, index=True)
    email: Mapped[EmailStr] = mapped_column(String, unique=True, index=True)
    password: Mapped[str]
    is_admin: Mapped[bool] = mapped_column(Boolean, default=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
