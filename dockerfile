FROM python:3.11-alpine

# Dependências do sistema
RUN apk add --no-cache gcc musl-dev postgresql-dev

# Criar usuário não-root para segurança (Prática DevOps)
RUN adduser -D devopsuser
WORKDIR /home/devopsuser/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Mudar permissões para o usuário criado
RUN chown -R devopsuser:devopsuser /home/devopsuser/app
USER devopsuser

# Expor a porta que a aplicação utiliza
EXPOSE 5000

CMD ["python", "app.py"]