#generates random id's mainly used for id's
import uuid
# to make the password protected
import bcrypt
import jwt
from fastapi import Depends, HTTPException,APIRouter, Header
from database import  get_db
from sqlalchemy.orm import joinedload
from middlewares.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import CreateUser
from sqlalchemy.orm import Session

from pydantic_schemas.user_login import UserLogin

router = APIRouter()

@router.post('/signup',status_code=201)
# Depends is a dependency injection tool it is of type session must use in scalable or need to close and open manually session
def signup_user(user:CreateUser,db:Session = Depends(get_db)):
    userdb = db.query(User).filter(User.email == user.email).first()

     
    if userdb:
        raise HTTPException(400,"User already Exists")
    
    #encode is used to convert to bytes hash only works bytes->bytes
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    #convert to str since it is a text
    userdb = User(id= str(uuid.uuid4()),email = user.email,name = user.name,password = hashed_pw)
    
    
    db.add(userdb)
    #writes the user to db just like git
    db.commit()
    # refreshes
    db.refresh(userdb)
    print(userdb)
    return {
    "id": userdb.id,
    "name": userdb.name,
    "email": userdb.email,
    "favorites": [f.song_id for f in userdb.favorites]
}

    
@router.post('/login')
def loginUser(user: UserLogin,db:Session = Depends(get_db)):
    userdb = db.query(User).filter(User.email == user.email).first()
    
    if not userdb:
        raise HTTPException(400,"Email Id not found")
    
    if not bcrypt.checkpw(user.password.encode(),userdb.password):
        raise HTTPException(400,"Incorrect Password!")
    
    token = jwt.encode({'id':userdb.id},'password_key')
    print(token)
    
    return {'token':token,'user': {
    "id": userdb.id,
    "name": userdb.name,
    "email": userdb.email,
    "favorites": [f.song_id for f in userdb.favorites]
}
}


@router.get('/')
def current_user_data(db: Session = Depends(get_db),user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(joinedload(User.favorites)).first()
    
    if not user:
        raise HTTPException(404,'User not found!')
    
    return user 
