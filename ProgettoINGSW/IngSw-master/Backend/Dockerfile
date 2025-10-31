FROM python:3.11-slim

WORKDIR /app

# Installa dipendenze sistema
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copia requirements
COPY ./requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copia codice
COPY ./Backend_Python /app/Backend_Python
COPY ./Backend_SQL /app/Backend_SQL

ENV PYTHONPATH="/app:/app/Backend_Python"
ENV FLASK_APP=Backend_Python.main:app
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV PYTHONUNBUFFERED=1

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "4", "--timeout", "120", "Backend_Python.main:app"]