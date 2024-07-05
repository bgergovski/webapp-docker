from flask import Flask
from http import HTTPStatus

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello world'

@app.route('/health')
def health_check():
    return 'Healthy', HTTPStatus.OK

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)