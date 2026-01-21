FROM python:3.11-alpine

# Instalar dependências para o Postgres e ferramentas de diagnóstico
RUN apk add --no-cache gcc musl-dev postgresql-dev postgresql-client

# Criar utilizador de sistema para não rodar como root (Segurança DevOps)
RUN adduser -D devopsuser
WORKDIR /home/devopsuser/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Ajustar permissões
RUN chown -R devopsuser:devopsuser /home/devopsuser/app
USER devopsuser

EXPOSE 5000

# Usando Gunicorn: 4 workers para lidar com requisições concorrentes
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "4", "--threads", "2"]