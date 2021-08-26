from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import subprocess

raw_db_url = subprocess.run(
    ["heroku", "config:get", "DATABASE_URL", "-a", "kf34"],
    capture_output=True).stdout
db_url = raw_db_url.decode("ascii").strip()
db_url = "postgresql:" + db_url.split(":", 1)[1]

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = db_url
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)


@app.route('/')
def hello():
    return 'Hello!'
