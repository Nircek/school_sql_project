FROM python:3.11-slim
EXPOSE 8000
WORKDIR /app
COPY requirements.txt /app
RUN pip install -r requirements.txt
CMD uvicorn main:APP --host 0.0.0.0 --port 8000 --reload --env-file docker.env
