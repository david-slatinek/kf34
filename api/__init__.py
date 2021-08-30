from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from subprocess import run
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from config import key

raw_db_url = run(
    ["heroku", "config:get", "DATABASE_URL", "-a", "kf34"],
    capture_output=True).stdout
db_url = raw_db_url.decode("ascii").strip()
db_url = "postgresql:" + db_url.split(":", 1)[1]

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = db_url
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["KEY"] = key
db = SQLAlchemy(app)

engine = create_engine(app.config["SQLALCHEMY_DATABASE_URI"])
Session = sessionmaker(engine)
