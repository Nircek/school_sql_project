"""
System zarządzania szkołą
=========================

Development steps:
```bash
# Run the application
virtualenv .venv
source .venv/bin/activate
pip install -r requirements.txt
docker compose up
python3 test.py
```
"""

import sys

if __name__ == "__main__" and __spec__ is None:
    print(
        "Ta aplikacja musi zostać uruchomiona przez "
        "`uvicorn main:APP --host 0.0.0.0 --port 8000 --env-file .env`",
        file=sys.stderr,
    )
    sys.exit(1)

# flake8: noqa:
# pylint: disable=C0413
import traceback
import os
from fastapi import FastAPI, Response, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
import psycopg2

DB, DB_ERR = None, None
try:
    DB = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASS"),
        dbname=os.getenv("DB_NAME"),
    )
except Exception as e:  # pylint: disable=W0718
    DB_ERR = str(e)

APP = FastAPI(title="System zarządzania szkołą")
API_APP = FastAPI(title="System zarządzania szkołą - API")
APP.mount("/api", API_APP)
APP.mount("/", StaticFiles(directory="static", html=True), name="static")


@API_APP.exception_handler(Exception)
async def debug_exception_handler(_: Request, exc: Exception):
    """Return the full traceback in the response if an exception occurs"""
    return Response(
        content="".join(traceback.format_exception(None, exc, exc.__traceback__))
    )


@APP.middleware("http")
async def db_middleware(request: Request, call_next):
    """Return a 503 error if the database connection failed"""
    if DB is None:
        return JSONResponse(
            status_code=503, content={"type": "db_error", "error": DB_ERR}
        )
    response = await call_next(request)
    return response


@API_APP.get("/")
def api_root():
    """Return an empty dictionary"""
    return {}


@API_APP.get("/debug/hello")
def debug_hello():
    """Hello world"""
    return {"Hello": "World"}


@API_APP.get("/debug/db")
def debug_db():
    """Test the database connection"""
    try:
        with DB.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()
            return {"db_test": result}
    except Exception as e:  # pylint: disable=W0718
        return {"error": str(e)}


@API_APP.get("/debug/error")
def debug_error():
    """Raise an exception to test the exception handler in middleware"""
    raise Exception("Test error")  # pylint: disable=W0719
