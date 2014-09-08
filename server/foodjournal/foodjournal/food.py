#!/usr/bin/env python
from argparse import ArgumentParser
from flask import Flask
from flask_config import ProductionConfig, DevelopmentConfig, TestingConfig

VERSION = "0.01a"

parser = ArgumentParser(
    prog="Food Journal", 
    description='Food Journaling (CS 5356).'
)
group = parser.add_mutually_exclusive_group()
group.add_argument('--dev', action='store_true')
group.add_argument('--test', action='store_true')
parser.add_argument('--version', action='version', version='%(prog)s %(VERSION)d')
args = parser.parse_args()
print args

app = Flask(__name__)

if args.dev:
    app.config.from_object('flask_config.DevelopmentConfig')
elif args.test:
    app.config.from_object('flask_config.TestingConfig')
else:
    app.config.from_object('flask_config.ProductionConfig')


@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()
