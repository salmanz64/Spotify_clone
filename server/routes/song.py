import uuid
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session

from database import get_db
from middlewares.auth_middleware import auth_middleware;
import cloudinary
import cloudinary.uploader
from sqlalchemy.orm import joinedload
from models.song import Song
from models.favorite import Favorite
from pydantic_schemas.fav_song import FavSong


router = APIRouter()
    
cloudinary.config( 
    cloud_name = "dp0wii5n7", 
    api_key = "244449491432561", 
    api_secret = "iDG8zs-iZucffrli4xI87ogEWUQ", # Click 'View API Keys' above to copy your API secret
    secure=True
)



@router.post('/upload',status_code=201)
def upload_song(song:UploadFile = File(...),
                thumbnail:UploadFile =File(...),
                artist:str = Form(...),
                song_name:str = Form(...),
                hex_code:str = Form(...),
                db:Session = Depends(get_db),
                auth_dict = Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file,resource_type ='auto',folder=f'songs/{song_id}')
    print(song_res)
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file,resource_type ='image',folder=f'songs/{song_id}')
    
    
    
    new_song = Song(
        id=song_id,
        song_name = song_name,
        artist=artist,
        song_url=song_res['url'],
        hex_code=hex_code,
        thumbnail_url = thumbnail_res['url']
    )
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/list')
def list_songs(db: Session=Depends(get_db),auth_details=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs

@router.post('/favorite')
def favorite_song(song:FavSong,db:Session=Depends(get_db),auth_details=Depends(auth_middleware),):

    user_id = auth_details['uid']
    
    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id,Favorite.user_id == user_id).first()
    
    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message':False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()),song_id=song.song_id,user_id=user_id)
        db.add(new_fav) 
        db.commit()
        return {'message':True}
    
@router.get('/list/favorites')
def allFavorites(db:Session=Depends(get_db),auth_details=Depends(auth_middleware)):
    user_id = auth_details['uid']
    all_songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(joinedload(Favorite.song)).all()
    return all_songs
    