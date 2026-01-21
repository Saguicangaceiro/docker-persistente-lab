import os
from flask import Flask, render_template, request, redirect
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

# O DevOps injeta essa variável via Docker Compose ou Kubernetes
db_url = os.getenv("DATABASE_URL", "postgresql://admin:senha123@db:5432/clientes_db")
app.config['SQLALCHEMY_DATABASE_URI'] = db_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
# ... restante do código permanece igual
# Modelo do Banco de Dados
class Usuario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(80), nullable=False)
    senha = db.Column(db.String(80), nullable=False)

# Criar o banco na primeira execução
with app.app_context():
    db.create_all()

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        novo_usuario = Usuario(nome=request.form['nome'], senha=request.form['senha'])
        db.session.add(novo_usuario)
        db.session.commit()
        return redirect('/')
    
    usuarios = Usuario.query.all()
    return render_template('index.html', usuarios=usuarios)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)