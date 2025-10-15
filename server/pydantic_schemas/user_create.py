
# response validation mainly to obtain the json data to a class and obtain it's attr
from pydantic import BaseModel


class CreateUser(BaseModel):
    name: str
    email: str
    password: str