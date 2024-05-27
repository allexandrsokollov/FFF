from uuid import UUID

from sqlalchemy.orm import Session

from backend.authentication.api.models import UserCreate, UserOut, UserUpdate
from backend.authentication.orm.repository import UserRepo


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


def delete_user(user_id: UUID, session: Session) -> None:
    repo = UserRepo(session)
    repo.delete(user_id)


def update_user(user_id: UUID, user: UserUpdate, session: Session) -> UserOut:
    repo = UserRepo(session)
    user_data = repo.update(user_id, user)

    return UserOut.from_orm(user_data)
