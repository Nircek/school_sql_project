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
import re

from fastapi import FastAPI, Response, Request, status as fastapi_status
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
import psycopg
from psycopg import sql
from psycopg.rows import dict_row


SQL_FOLDER = Path("sql")
assert SQL_FOLDER.is_dir(), f"Folder {SQL_FOLDER} does not exist"


def get_sql_commands(file, part=None):
    """Read SQL commands from a file"""
    with open(SQL_FOLDER / file, encoding="utf-8") as f:
        cmd = f.read()
    if part is None:
        return cmd
    regex = re.compile(rf"(?:^|\n)---\s*{part}\s*([\s\S]*?)(?:\n---|$)")
    m = regex.search(cmd)
    if not m:
        assert m, (f"Command {cmd} not found in {file}", regex, cmd)
    return m.group(1)


def select_schema():
    """Check if the schema exists and select it"""
    with APP.db.cursor() as cursor:
        cursor.execute(get_sql_commands("utils.sql", "check schema"))
        APP.db_state = cursor.fetchone() is not None
        if APP.db_state:
            cursor.execute(get_sql_commands("utils.sql", "select schema"))
            APP.db.commit()
            APP.db_tables = [
                "nauczyciel",
                "klasa",
                "uczen",
                "sala",
                "semestr",
                "zajecia",
                "frekwencja",
                "ocena",
                "platnosc",
                "zaplata",
                "postep_platnosci",
            ]
            APP.db_table_pks = {
                "frekwencja": ("zajecia_id", "data", "uczen_id"),
                "zaplata": ("platnosc_id", "uczen_id"),
                "postep_platnosci": ("platnosc_id",)
            }
            APP.db_ordering = {
                "nauczyciel": ("nazwisko", "imie", "nauczyciel_id"),
                "klasa": ("nazwa", "klasa_id"),
                "uczen": ("klasa_id", "nazwisko", "imie", "uczen_id"),
                "sala": ("nazwa", "sala_id"),
                "semestr": ("data_poczatku", "semestr_id"),
                "zajecia": (
                    "semestr_id",
                    "klasa_id",
                    "dzien",
                    "czas_rozp",
                    "zajecia_id",
                ),
                "frekwencja": ("zajecia_id", "data", "uczen_id"),
                "ocena": ("zajecia_id", "uczen_id"),
                "platnosc": ("klasa_id", "tytul", "platnosc_id"),
                "postep_platnosci": ("klasa_id", "tytul", "platnosc_id"),
                "zaplata": ("platnosc_id", "uczen_id"),
            }


def init_db():
    """Initialize the application"""
    try:
        if APP.db is not None:
            APP.db.close()
        APP.db = psycopg.connect(
            f'host={os.getenv("DB_HOST")} port={os.getenv("DB_PORT")} user={os.getenv("DB_USER")}'
            f' password={os.getenv("DB_PASS")} dbname={os.getenv("DB_NAME")}',
            row_factory=dict_row,
        )
        select_schema()
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
    if isinstance(exc, psycopg.errors.InFailedSqlTransaction):
        APP.db.rollback()
    return Response(
        content="".join(traceback.format_exception(None, exc, exc.__traceback__)),
        media_type="text/plain",
        status_code=fastapi_status.HTTP_500_INTERNAL_SERVER_ERROR,
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
            cursor.execute("SELECT 1 AS db_test")
            result = cursor.fetchone()
            return {"db_test": result["db_test"]}
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
        stages = [
            "init",
            "views",
            "triggers",
            # "functions",
            ]
        for file in stages:
            cursor.execute(get_sql_commands(f"{file}.sql"))
        APP.db.commit()
    select_schema()
    return {"status": "ok"}


@API_APP.post("/debug/db_fill")
def debug_sql_fill():
    """Initialize the database"""
    with APP.db.cursor() as cursor:
        cursor.execute(get_sql_commands("fill.sql"))
        APP.db.commit()
    select_schema()
    return {"status": "ok"}


@API_APP.post("/debug/db_drop")
def debug_sql_drop():
    """Drop the database"""
    with APP.db.cursor() as cursor:
        try:
            cursor.execute(get_sql_commands("utils.sql", "drop schema"))
        except psycopg.errors.Error as e:
            APP.db.rollback()
            raise e
        APP.db.commit()
    init_db()
    return {"status": "ok"}


def table_not_found(table):
    """Return a 404 error if the table is not found"""
    return JSONResponse(
        status_code=fastapi_status.HTTP_404_NOT_FOUND,
        content={"error": f"Table {table} not found"},
    )


@API_APP.get("/db/{table}")
def get_table(table: str):
    """Return all rows from a table"""
    if table not in APP.db_tables:
        return table_not_found(table)
    with APP.db.cursor() as cursor:
        cursor.execute(
            sql.SQL("SELECT * FROM {} ORDER BY {}").format(
                sql.Identifier(table),
                sql.SQL(", ").join(map(sql.Identifier, APP.db_ordering[table])),
            )
        )
        return cursor.fetchall()


@API_APP.get("/db/{table}/{entity}")
def get_table_entity(table: str, entity: str):
    """Return a row from a table by ID"""
    if table not in APP.db_tables:
        return table_not_found(table)
    with APP.db.cursor() as cursor:
        if table in APP.db_table_pks:
            cursor.execute(
                sql.SQL("SELECT * FROM {} WHERE {}").format(
                    sql.Identifier(table),
                    sql.SQL(" AND ").join(
                        sql.SQL("{} = %s").format(sql.Identifier(pk))
                        for pk in APP.db_table_pks[table]
                    ),
                ),
                entity.split(","),
            )
        else:
            cursor.execute(
                sql.SQL("SELECT * FROM {} WHERE {} = %s").format(
                    sql.Identifier(table), sql.Identifier(f"{table}_id")
                ),
                [entity],
            )
        return cursor.fetchone()


@API_APP.post("/db/{table}")
async def post_table(table: str, request: Request):
    """Insert a new row into a table"""
    if table not in APP.db_tables:
        return table_not_found(table)
    data = await request.json()
    keys = list(data.keys())
    values = list([data[k] for k in keys])
    with APP.db.cursor() as cursor:
        try:
            cursor.execute(
                sql.SQL("INSERT INTO {} ({}) VALUES ({});").format(
                    sql.Identifier(table),
                    sql.SQL(", ").join(map(sql.Identifier, keys)),
                    sql.SQL(", ").join(map(sql.Literal, values)),
                )
            )
        except psycopg.errors.Error as e:
            APP.db.rollback()
            raise e
        APP.db.commit()


@API_APP.put("/db/{table}/{entity}")
async def put_table_entity(table: str, entity: str, request: Request):
    """Update a row in a table by ID"""
    if table not in APP.db_tables:
        return table_not_found(table)
    data = await request.json()
    keys = list(data.keys())
    values = list([data[k] for k in keys])
    with APP.db.cursor() as cursor:
        try:
            if table in APP.db_table_pks:
                cursor.execute(
                    sql.SQL("UPDATE {} SET {} WHERE {}").format(
                        sql.Identifier(table),
                        sql.SQL(", ").join(
                            sql.SQL("{} = %s").format(sql.Identifier(k)) for k in keys
                        ),
                        sql.SQL(" AND ").join(
                            sql.SQL("{} = %s").format(sql.Identifier(pk))
                            for pk in APP.db_table_pks[table]
                        ),
                    ),
                    [*values, *entity.split(",")],
                )
            else:
                cursor.execute(
                    sql.SQL("UPDATE {} SET {} WHERE {} = %s;").format(
                        sql.Identifier(table),
                        sql.SQL(", ").join(
                            sql.SQL("{} = %s").format(sql.Identifier(k)) for k in keys
                        ),
                        sql.Identifier(f"{table}_id"),
                    ),
                    [*values, entity],
                )
            APP.db.commit()
        except psycopg.errors.Error as e:
            APP.db.rollback()
            raise e


@API_APP.delete("/db/{table}/{entity}")
def delete_table_entity(table: str, entity: str):
    """Delete a row from a table by ID"""
    if table not in APP.db_tables:
        return table_not_found(table)
    with APP.db.cursor() as cursor:
        try:
            if table in APP.db_table_pks:
                cursor.execute(
                    sql.SQL("DELETE FROM {} WHERE {}").format(
                        sql.Identifier(table),
                        sql.SQL(" AND ").join(
                            sql.SQL("{} = %s").format(sql.Identifier(pk))
                            for pk in APP.db_table_pks[table]
                        ),
                    ),
                    entity.split(","),
                )
            else:
                cursor.execute(
                    sql.SQL("DELETE FROM {} WHERE {} = %s").format(
                        sql.Identifier(table), sql.Identifier(f"{table}_id")
                    ),
                    [entity],
                )
            APP.db.commit()
        except psycopg.errors.Error as e:
            APP.db.rollback()
            raise e
