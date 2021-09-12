from os import environ

from dotenv import load_dotenv
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

load_dotenv()

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql:" + environ.get("DATABASE_URL").split(":", 1)[1]
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["KEY"] = environ.get("KEY")
db = SQLAlchemy(app)

engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])
Session = sessionmaker(engine)
