#!/bin/bash
set -e
set -o pipefail

kill_jobs_on_error() {
    jobs -p | xargs -r kill
    wait
    exit 1
}

trap 'kill_jobs_on_error' ERR


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

[ "$2" = "run" ] && uvicorn main:APP --host 0.0.0.0 --port "$PORT" --env-file .env
[ "$2" = "run" ] && exit 0

echo "Running tests..."
uvicorn main:APP --host 0.0.0.0 --port "$PORT" --env-file .env &
sleep 2
python3 test.py "$PORT"
kill %1
wait
echo "Tests passed."
echo "Now you can run the app with: \`$0 $PORT run\`."
