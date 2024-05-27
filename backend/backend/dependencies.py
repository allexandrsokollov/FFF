from typing import Generator

from sqlalchemy.orm import Session

from backend.orm.base import session_factory


def get_session() -> Generator[Session, None, None]:  # pragma: no cover
    with session_factory() as session:
        try:
            yield session
            session.commit()
        except Exception:
            session.rollback()
            raise
        finally:
            session.close()
