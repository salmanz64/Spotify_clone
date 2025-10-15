# uses sqlalchemy to connect to python to database connect_engine to connect to db
from sqlalchemy import create_engine
# to create session
from sqlalchemy.orm import sessionmaker

DATABASE_URL = 'postgresql://postgres:salman%401205@localhost:5432/flutterMusicApp'

# establish connect with db
engine = create_engine(DATABASE_URL)
# the session must be created in order to get the db
sessionLocal = sessionmaker(autoflush=False,bind=engine)

def get_db():
    db = sessionLocal()
    try:
        yield db
    finally:
        db.close()