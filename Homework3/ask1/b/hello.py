from flask import Flask
import os
app = Flask(__name__)


@app.route(os.environ['ROUTE'])

def index():
    return os.environ['MESSAGE']

app.run(debug=True,host='0.0.0.0', port=8080)
