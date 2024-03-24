from sqlalchemy import Boolean, Column, String

from backend.orm.base import Base


class User(Base):
    username: str = Column(String, unique=True, nullable=False)
    email: str = Column(String, unique=True, nullable=False)
    password: str = Column(String, nullable=False)
    is_admin: bool = Column(Boolean, default=False)
