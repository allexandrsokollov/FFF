from backend.authentication.services.models import User


fake_users_db = {
    "johndoe": {
        "username": "johndoe",
        "email": "johndoe@example.com",
        "password": "$2b$12$CLuGaFDcI6sed2mPnVfLgeIUTG29WeZbZRtwLDnRN5kllABxg/6XG",
        "is_admin": False,
        "is_active": True,
    },
    "alice": {
        "username": "alice",
        "email": "alice@example.com",
        "password": "$2b$12$CLuGaFDcI6sed2mPnVfLgeIUTG29WeZbZRtwLDnRN5kllABxg/6XG",
        "is_admin": True,
        "is_active": True,
    },
}


def get_user(username: str):
    if username in fake_users_db:
        user_dict = fake_users_db[username]
        return User(**user_dict)
    else:
        raise Exception
