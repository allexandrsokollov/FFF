from fastapi import FastAPI, APIRouter
from backend.authentication.api.user_router import user_router


app = FastAPI()

main_api_router = APIRouter()
main_api_router.include_router(user_router, prefix="/users", tags=["user"])

app.include_router(main_api_router)
