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
python3 app/test.py
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
from pathlib import Path

from fastapi import FastAPI, Response, Request, status as fastapi_status
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
import psycopg


SQL_FOLDER = Path("sql")
assert SQL_FOLDER.is_dir(), f"Folder {SQL_FOLDER} does not exist"


def get_sql_commands(file, cmd=None):
    """Read SQL commands from a file"""
    # TODO: Implement cmd argument
    with open(SQL_FOLDER / file, encoding="utf-8") as f:
        sql = f.read()
    return list([f"{x};" for x in sql.strip().split(";") if x])


def init_db():
    """Initialize the application"""
    try:
        if APP.db is not None:
            APP.db.close()
        APP.db = psycopg.connect(
            f'host={os.getenv("DB_HOST")} port={os.getenv("DB_PORT")} user={os.getenv("DB_USER")}'
            f' password={os.getenv("DB_PASS")} dbname={os.getenv("DB_NAME")}'
        )
        with APP.db.cursor() as cursor:
            cursor.execute(get_sql_commands("check_schema.sql")[0])
            APP.db_state = cursor.fetchone() is not None
    except Exception as e:  # pylint: disable=W0718
        APP.db_state = str(e)


APP = FastAPI(title="System zarządzania szkołą")
API_APP = FastAPI(title="System zarządzania szkołą - API")
APP.db = None  # https://github.com/fastapi/fastapi/issues/592
APP.db_state = None  # True if the database is initialized
init_db()
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
    """Return a 503 error if the database connection failed and redirect to setup_db if needed"""
    if APP.db is None:
        return JSONResponse(
            status_code=503, content={"type": "db_error", "error": APP.db_state}
        )
    if request.scope["path"] == "/setup_db.html":
        if request.method == "POST":
            request.scope["path"] = "/api/debug/db_init"
    elif not APP.db_state:
        return RedirectResponse(
            url="/setup_db.html", status_code=fastapi_status.HTTP_303_SEE_OTHER
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
        with APP.db.cursor() as cursor:
            cursor.execute("SELECT 1")
            result = cursor.fetchone()
            return {"db_test": result}
    except Exception as e:  # pylint: disable=W0718
        return {"error": str(e)}


@API_APP.get("/debug/error")
def debug_error():
    """Raise an exception to test the exception handler in middleware"""
    raise Exception("Test error")  # pylint: disable=W0719


@API_APP.post("/debug/db_init")
def debug_sql_init():
    """Initialize the database"""
    with APP.db.cursor() as cursor:
        for sql in get_sql_commands("init.sql"):
            cursor.execute(sql)
        APP.db.commit()
    APP.db_state = True
    return {"status": "ok"}


@API_APP.post("/debug/db_drop")
def debug_sql_drop():
    """Drop the database"""
    with APP.db.cursor() as cursor:
        for sql in get_sql_commands("drop.sql"):
            cursor.execute(sql)
        APP.db.commit()
    init_db()
    return {"status": "ok"}
