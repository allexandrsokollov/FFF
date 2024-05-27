from typing import Generic, TypeVar, Sequence, Any
from uuid import UUID

from pydantic import BaseModel
from sqlalchemy import func, update, Select, select
from sqlalchemy.exc import IntegrityError, NoResultFound
from sqlalchemy.orm import Session

from backend.filters import BasePaginationFilter
from backend.orm.base import Base as OrmBase

OrmModelT = TypeVar("OrmModelT", bound=OrmBase)

OPERATOR_CONDITION_MAPPING = {
    "like": lambda column, val: column.like(f"%{val}%"),
    "ilike": lambda column, val: column.ilike(f"%{val}%"),
}


class BaseSyncCRUDOperations(Generic[OrmModelT]):
    orm_model: type[OrmModelT]

    def __init__(self, session: Session) -> None:
        self.session = session

    def create(self, details: BaseModel) -> OrmModelT:
        obj: OrmModelT = self.orm_model(**details.model_dump())
        self.session.add(obj)
        try:
            self.session.commit()
        except IntegrityError as exc:
            self.session.rollback()
            raise
        self.session.refresh(obj)
        return obj

    def update(
        self,
        resource_id: UUID,
        details: BaseModel,
    ) -> OrmModelT:
        update_query = (
            update(self.orm_model)
            .where(self.orm_model.id == resource_id)
            .values(details.model_dump(exclude_unset=True, exclude_defaults=True))
            .returning(self.orm_model)
        )
        try:
            result = self.session.execute(update_query)
            resource: OrmModelT = result.scalars().unique().one()
        except IntegrityError as exc:
            self.session.rollback()
            raise IntegrityError from exc
        return resource

    def get(
        self,
        resource_id: UUID,
        with_for_update: bool,  # noqa: FBT001 (bool arg)
    ) -> OrmModelT:
        query = self._statement_get(resource_id)
        if with_for_update:
            query = query.with_for_update()
        result = self.session.execute(query)
        try:
            resource: OrmModelT = result.scalars().unique().one()
        except NoResultFound as exc:
            raise NoResultFound from exc
        return resource

    def _statement_get(self, resource_id: UUID) -> Select[tuple[OrmModelT]]:
        return select(self.orm_model).where(self.orm_model.id == resource_id)

    def _statement_get_multi(
        self,
        filters: BasePaginationFilter,
    ) -> Select[tuple[OrmModelT]]:
        query = select(self.orm_model)
        for key, val in filters.model_dump(
            exclude_unset=True,
            exclude_none=True,
            exclude={"limit", "offset", "order_by", "desc"},
        ).items():
            if "__" in key:
                field_name, op_name = key.split("__")
                query = query.where(
                    OPERATOR_CONDITION_MAPPING[op_name](
                        getattr(self.orm_model, field_name),
                        val,
                    ),
                )
            else:
                query = query.where(getattr(self.orm_model, key) == val)

        return self._apply_order_by(query, filters)

    def get_multi(
        self,
        filters: BasePaginationFilter,
        with_for_update: bool,  # noqa: FBT001 (bool arg)
    ) -> tuple[Sequence[OrmModelT], int]:
        base_query = self._statement_get_multi(filters)
        if with_for_update:
            base_query = base_query.with_for_update()
        result, count = self._execute_get_multi(base_query, filters)
        return result.scalars().unique().all(), count.scalar()

    def _apply_order_by(
        self, query: Select[tuple[OrmModelT]], filters: BasePaginationFilter
    ) -> Select[tuple[OrmModelT]]:
        order_by = getattr(filters, "order_by", None)
        desc = getattr(filters, "desc", False)
        if order_by:
            if desc:
                query = query.order_by(getattr(self.orm_model, order_by).desc())
            else:
                query = query.order_by(getattr(self.orm_model, order_by))

        return query

    def _execute_get_multi(
        self,
        query: Select[tuple[OrmModelT]],
        filters: BasePaginationFilter,
    ) -> Any:
        results = self.session.execute(
            query.limit(filters.limit).offset(filters.offset),
        )
        count = self.session.execute(
            select(func.count()).select_from(  # pylint: disable=not-callable
                query.subquery(),
            ),
        )
        return results, count or 0

    def delete(
        self,
        resource_id: UUID,
    ) -> None:
        obj = self.get(resource_id, with_for_update=False)
        self.session.delete(obj)
        self.session.commit()
