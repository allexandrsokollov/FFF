from sqlalchemy import Select, select
from sqlalchemy.exc import NoResultFound

from backend.authentication.orm.models import User
from backend.orm.base_repo import BaseSyncCRUDOperations, OrmModelT


class UserRepo(BaseSyncCRUDOperations[User]):
    orm_model = User

    def get_by_username(self, username: str, with_for_update: bool) -> User:
        query = self._statement_get(username)
        if with_for_update:
            query = query.with_for_update()
        result = self.session.execute(query)
        try:
            resource: OrmModelT = result.scalars().unique().one()
        except NoResultFound as exc:
            raise NoResultFound from exc
        return resource

    def _statement_get(self, username: str) -> Select[tuple[User]]:
        return select(self.orm_model).where(self.orm_model.username == username)
