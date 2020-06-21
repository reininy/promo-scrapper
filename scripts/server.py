from flask import Flask, request, jsonify
from main import Gatry, Pelando

if __name__ == "__main__":
    print("Promoções do Gatry:")
    list = []
    list2 = []
    list = Gatry()
    list2 = Pelando()

    app = Flask(__name__)
    
    @app.route('/', methods=['GET'])
    def home():
        return '''<h1>Distant Reading Archive</h1>
<p>A prototype API for distant reading of science fiction novels.</p>'''


    @app.route('/gatry', methods=['GET'])
    def api_gatry():
        return jsonify(list)   

    @app.route('/pelando', methods=['GET'])
    def api_pelando():
        return jsonify(list2) 

    app.run(host='192.168.15.14')

