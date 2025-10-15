# main web framework
#http exception is called to raise errors like user already exixts
from fastapi import FastAPI, HTTPException
from models.base import Base
from routes import auth,song
from database import engine
#initialize api
app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(song.router,prefix='/song')


#creates the table in db if user not exists
Base.metadata.create_all(engine)
    
    
