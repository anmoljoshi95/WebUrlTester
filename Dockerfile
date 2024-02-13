FROM python:3.8-slim-buster

EXPOSE 8910
EXPOSE 9091

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install python-dev libffi-dev libssl-dev default-libmysqlclient-dev build-essential psmisc -yq

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

WORKDIR /app
COPY . /app

# DB Settings
ENV DB_HOST 43.241.39.36
ENV DB_NAME security_apis_db_2
ENV DB_USER root
ENV DB_PASSWORD rootpassword
ENV DB_PORT 3308

RUN python manage.py makemigrations --noinput && \
python manage.py migrate

CMD ["gunicorn", "--bind", "0.0.0.0:8910", "API_SECURITY_APIS.wsgi"]
