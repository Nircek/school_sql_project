#!/bin/bash

[ ! -f .venv/bin/activate ] && {
    [ ! -f virtualenv.pyz ] && wget https://bootstrap.pypa.io/virtualenv.pyz;
    python3 virtualenv.pyz .venv;
    . .venv/bin/activate;
    pip install -r requirements.txt;
    deactivate;
    echo -e "\n\n\nVirtualenv created and dependencies installed.\n\n\n";
}

PORT=${1:-8234}
echo "PORT: $PORT"

. .venv/bin/activate
cd app

uvicorn main:APP --host 0.0.0.0 --port "$PORT" --env-file .env
