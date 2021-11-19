FROM python:3.8-slim

# POETRY
# https://python-poetry.org/docs/configuration/#using-environment-variables
ENV POETRY_VERSION=1.1.6 \
    # Задаем директорию для poetry
    POETRY_HOME="/opt/poetry" \
    # включаем создание .venv внутри проекта
    # .venv будет создан там где запускается poetry install
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # отключаем интерактивные вопросы poetry
    POETRY_NO_INTERACTION=1

# Добавляем в PATH бинари poetry и .venv
ENV PATH="$POETRY_HOME/bin:$PATH"

# install poetry
RUN apt-get update \
    && apt-get install --no-install-recommends -y curl build-essential \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

WORKDIR /opt/example_projects/
COPY . .

RUN poetry install

CMD ["poetry", "run" ,"uvicorn", "main:app", "--reload", "--host", "0", "--port", "80"]
