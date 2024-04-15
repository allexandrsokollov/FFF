from sqlalchemy.orm import Session


class User:
    def __init__(self, session: Session):
        self.session = session
