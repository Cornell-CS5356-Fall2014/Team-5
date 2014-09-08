from webapp import app
from flask import jsonify

@app.route('/api/test')
def test():
    return jsonify(
        **{
            "hello": "world"
        }
    )