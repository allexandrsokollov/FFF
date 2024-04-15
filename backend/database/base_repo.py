from abc import ABC
from typing import Any

from sqlalchemy import sql, select, func
from sqlalchemy.orm import Session

from backend.orm.base import BaseModelClass, Base


class BaseRepo(ABC):
    def __init__(self, session: Session, model: BaseModelClass):
        self.session = session
        self.model = model

    @staticmethod
    def _statement_get_count(base_query: sql.Select) -> sql.Select:
        return select(func.count()).select_from(base_query.subquery())

    def _get_base_statement(self, **filters: dict[str, Any]) -> sql.Select:
        query = self.session.query()
        for key, value in filters.items():
            query = query.filter(getattr(self.model, key) == value)
        return query.statement

    def get_multi(self,
                  *,
                  offset: int = 0,
                  limit: int = 100,
                  **filters: dict[str, Any]) -> tuple[list[Base], int]:
        query = self._get_base_statement(**filters).limit(limit).offset(offset)
        result = self.session.execute(query).scalars().all()
        count = self.session.execute(self._statement_get_count(query))

        return result, int(count.scalars())

    def get_by_attributes(self, **filters: dict[str, Any]) -> Base:
        query = self._get_base_statement(**filters)
        result = self.session.execute(query).scalars().one()
        return result


def save_to_session(session: Session, objects: list[Base]) -> None:
    session.add_all(objects)
    session.flush(objects)
