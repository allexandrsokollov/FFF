from backend.authentication.api.models import User


fake_users_db = {
    "johndoe": {
        "username": "johndoe",
        "email": "johndoe@example.com",
        "password": "$2b$12$uC.EBsLmODikKQQ87vBbzepOneCPsXjPVgeAknFYEFDCBTS/tDxTC",
        "is_admin": False,
    },
    "alice": {
        "username": "alice",
        "email": "alice@example.com",
        "password": "$2b$12$uC.EBsLmODikKQQ87vBbzepOneCPsXjPVgeAknFYEFDCBTS/tDxTC",
        "is_admin": True,
    },
}


def get_user(username: str):
    if username in fake_users_db:
        user_dict = fake_users_db[username]
        return User(**user_dict)
