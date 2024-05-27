from datetime import datetime, timedelta, timezone
from typing import Annotated
from uuid import UUID

from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from starlette import status

from backend.authentication.api.models import TokenData, UserOut
from backend.authentication.services.user import get_user
from backend.settings.sec import sec_settings


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class AuthException(Exception):
    ...


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)  # type: ignore[no-any-return]


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)  # type: ignore[no-any-return]


def authenticate_user(username: str, password: str, session: Session):
    user = get_user(username, session)

    if not verify_password(password, user.password):
        raise AuthException("password incorrect")
    return user


def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(
            minutes=sec_settings.access_token_expire_minutes
        )
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(
        to_encode, sec_settings.secret_key, algorithm=sec_settings.algorithm
    )
    return encoded_jwt


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], session: Session):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token, sec_settings.secret_key, algorithms=[sec_settings.algorithm]
        )
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = get_user(username=token_data.username, session=session)
    if user is None:
        raise credentials_exception
    return user


def get_current_active_user(
    current_user: Annotated[UserOut, Depends(get_current_user)],
):
    return current_user
