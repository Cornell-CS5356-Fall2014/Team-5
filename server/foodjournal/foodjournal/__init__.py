import os
from flask import Flask
from config import basedir

app = Flask(__name__)
app.config.from_object('config')

@app.route('/')
def index():
    return 'Hello World!'
