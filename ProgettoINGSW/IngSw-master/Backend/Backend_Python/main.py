import sys
import os

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from flask import Flask
from flask_cors import CORS
from Backend_Python.app.routes.gestionale_route import gestionale_bp
from Backend_Python.app.routes.impiegato_route import impiegato_bp
from Backend_Python.app.routes.laboratorio_route import laboratorio_bp
from Backend_Python.app.routes.progetto_route import progetto_bp
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

# CORS configurato per Render
CORS(app, resources={
    r"/api/*": {
        "origins": ["*"],  # In produzione, specifica il dominio frontend
        "methods": ["GET", "POST", "PUT", "DELETE"],
        "allow_headers": ["Content-Type"]
    }
})

app.register_blueprint(gestionale_bp)
app.register_blueprint(impiegato_bp)
app.register_blueprint(laboratorio_bp)
app.register_blueprint(progetto_bp)

@app.route('/')
def home():
    return {"message": "Backend Flask API is running!", "status": "ok"}

@app.route('/health')
def health():
    try:
        from Backend_Python.database import engine
        from sqlalchemy import text
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))
        return {"status": "healthy", "database": "connected"}, 200
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return {"status": "unhealthy", "error": str(e)}, 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='0.0.0.0', port=port)