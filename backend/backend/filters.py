from pydantic import BaseModel, Field


class BasePaginationFilter(BaseModel):
    limit: int = Field(
        default=1000,
        ge=1,
        description="Размер объектов в возвращаемой странице",
    )
    offset: int = Field(
        default=0,
        ge=0,
        description="Смещение относительно первого объекта в возвращаемой странице",
    )
