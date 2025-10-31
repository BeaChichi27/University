import os
import logging
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from sqlalchemy.exc import SQLAlchemyError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

load_dotenv()

# Usa DATABASE_URL di Render (automaticamente fornito)
DATABASE_URL = os.getenv('DATABASE_URL') or os.getenv('DB_URL_DOCKER')

# Render usa postgres:// ma SQLAlchemy richiede postgresql://
if DATABASE_URL and DATABASE_URL.startswith('postgres://'):
    DATABASE_URL = DATABASE_URL.replace('postgres://', 'postgresql://', 1)

logger.info(f"🔗 Connessione database configurata")

if not DATABASE_URL:
    raise ValueError("Database URL not set!")

try:
    engine = create_engine(
        DATABASE_URL, 
        echo=False,
        pool_pre_ping=True,
        pool_recycle=300,
        connect_args={"connect_timeout": 30}
    )
    
    # Test connessione
    with engine.connect() as connection:
        connection.execute(text("SELECT 1"))
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    logger.info("✅ Database connesso con successo")
    
except Exception as e:
    logger.error(f"❌ Errore database: {e}")
    raise RuntimeError(f"Error connecting to the database: {str(e)}")

def get_db():
    db = SessionLocal()
    try:
        yield db
    except Exception as e:
        logger.error(f"❌ Errore sessione DB: {e}")
        db.rollback()
        raise
    finally:
        db.close()