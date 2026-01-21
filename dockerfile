FROM python:3.11-alpine

# Instalar dependências do sistema para o Postgres
RUN apk add --no-cache gcc musl-dev postgresql-dev

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "app.py"]