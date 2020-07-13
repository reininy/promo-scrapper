from flask import Flask, request, jsonify
from main import Gatry, Pelando
from os import sys
from flask_cors import CORS

if __name__ == "__main__":
    ip = sys.argv[1]
    app = Flask(__name__)
    CORS(app)
    
    @app.route('/', methods=['GET'])
    def home():
        return '''<h1>Produtos</h1>
<p>A prototype API for Products and devices.</p>'''


    @app.route('/gatry', methods=['GET'])
    def api_gatry():
        list = []
        list= Gatry()
        return jsonify(list), 200

    @app.route('/pelando', methods=['GET'])
    def api_pelando():
        list2 = []
        list2 = Pelando()
        return jsonify(list2), 200 

    app.run(host=ip)

