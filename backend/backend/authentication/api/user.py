from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from jose import JWTError, jwt
from sqlalchemy.orm import Session

from backend.authentication.api.models import Token, TokenData, UserOut, UserCreate
from backend.authentication.services.sec import (
    authenticate_user,
    create_access_token,
    oauth2_scheme,
)
from backend.authentication.services.user import get_user, create_user
from backend.dependencies import get_session
from backend.settings.sec import sec_settings


user_router = APIRouter()


def get_current_user(token: Annotated[str, Depends(oauth2_scheme)], session: Session) -> UserOut:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token,
            sec_settings.secret_key,
            algorithms=[sec_settings.algorithm],
        )
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = get_user(token_data.username, session)
    if user is None:
        raise credentials_exception
    return user


def get_current_active_user(current_user: Annotated[UserOut, Depends(get_current_user)]):
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


@user_router.post("/token", response_model=Token)
def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
          session: Session = Depends(get_session)):
    user = authenticate_user(form_data.username, form_data.password, session)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=sec_settings.access_token_expire_minutes)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return Token(access_token=access_token, token_type="bearer")


@user_router.post("/users", response_model=UserOut)
def cr_user(user_data: UserCreate, session: Session = Depends(get_session)):
    created_user = create_user(user_data, session)
    return UserOut.from_orm(created_user)


# @user_router.get("/me", response_model=UserOut)
# def read_users_me(current_user: Annotated[UserOut, Depends(get_current_active_user)]):
#     return current_user
