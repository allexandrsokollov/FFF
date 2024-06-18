from random import randint
from uuid import UUID

from pydantic import BaseModel
from redis import Redis
from sqlalchemy.orm import Session

from backend.authentication.api.models import UserCreate, UserOut, UserUpdate
from backend.authentication.orm.repository import UserRepo
from backend.authentication.services.sec import get_password_hash
from backend.redis.storage import RedisStorage
from backend.redis.utils import get_redis_connection


def get_user(username: str, session: Session) -> UserOut:
    repo = UserRepo(session)
    user = repo.get_by_username(username, with_for_update=False)

    return UserOut.from_orm(user)


def create_user(user: UserCreate, session: Session) -> UserOut:
    repo = UserRepo(session)

    from backend.authentication.services.sec import get_password_hash
    user.password = get_password_hash(user.password)
    user_data = repo.create(user)

    return UserOut.from_orm(user_data)


def update_user_password(user_id: UUID, user: UserUpdate, session: Session) -> UserOut:
    repo = UserRepo(session)

    from backend.authentication.services.sec import get_password_hash
    user.password = get_password_hash(user.password)
    updated_user = repo.update(resource_id=user_id, details=user)
    return UserOut.from_orm(updated_user)


def _get_random_code() -> str:
    return str(randint(100000, 999999))


def create_code_for_password(user_id: str, redis: RedisStorage) -> str:
    if redis.exists(user_id):
        return redis.get(user_id)

    code = _get_random_code()
    redis.put_key(user_id, code)

    return code


def validate_pass_code(user_id: str, code: str, redis: RedisStorage) -> bool:
    return code == redis.get(str(user_id))


def delete_user(user_id: UUID, session: Session) -> None:
    repo = UserRepo(session)
    repo.delete(user_id)


def update_user(user_id: UUID, user: UserUpdate, session: Session) -> UserOut:
    repo = UserRepo(session)
    user_data = repo.update(user_id, user)

    return UserOut.from_orm(user_data)


def update_password(user_id: UUID, password: str, session: Session) -> UserOut:
    repo = UserRepo(session)
    password = get_password_hash(password)
    user_data = repo.update(user_id, BaseModel(password=password))

    return UserOut.from_orm(user_data)
