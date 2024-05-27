from uuid import UUID

from pydantic import BaseModel, EmailStr, field_validator, ConfigDict
from pydantic_core import ValidationError


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str | None = None
    id: UUID


class UserCreate(BaseModel):
    username: str
    email: EmailStr
    password: str

    @classmethod
    @field_validator("password", mode="before")
    def password_validator(cls, v: str):
        if len(v) < 8:
            raise ValidationError("Password must be at least 8 characters")
        has_numbers = False
        has_capital_letters = False
        for char in v:
            if char.isdigit():
                has_numbers = True
            if char.isalpha():
                has_capital_letters = True

        if not has_numbers and not has_capital_letters:
            raise ValidationError(
                "Password must contain at least one number and one capital letter"
            )


class UserUpdate(BaseModel):
    username: str | None
    email: EmailStr | None
    is_active: bool | None


class UserOut(BaseModel):
    id: UUID
    username: str
    email: EmailStr
    is_admin: bool
    password: str

    model_config = ConfigDict(from_attributes=True, extra='ignore')


class UserWithPass(UserOut):
    password: str
