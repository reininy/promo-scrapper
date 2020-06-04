import requests
from bs4 import BeautifulSoup
import pandas as pd
import flask
from flask import request, jsonify

def Gatry():
    page = requests.get('https://gatry.com/')
    soup = BeautifulSoup(page.text, 'html.parser') ## parsea o html colocando cada tag em uma linha
    ##divs_info = soup.find_all("div", class_='informacoes')
    
    list = []
    for div in soup.find_all("article", class_='promocao'):
        dict = {} ## inicializa o dicionario
        
        name = div.find("h3")
        price = div.find("p", class_='preco').get_text()
        image = div.find("div", class_='imagem').find('img', src=True)
        print(name)
        dict['name'] = name.text
        dict['price'] = price
        dict['image'] = image['src']

        list.append(dict)

   
    return list

    

def Pelando():
    page = requests.get('https://www.pelando.com.br/')
    soup = BeautifulSoup(page.text, 'html.parser')
    list = []
    for div in soup.find_all("div", class_='gridLayout-item threadCardLayout--card'):
        dict = {}
        name = div.find("strong", {"class": "thread-title"}).get_text()
        price = div.find("div", class_='threadCardLayout--row--small overflow--fade space--l-3').get_text()

        dict['name'] = name
        dict['price'] = price

        list.append(dict)

    return list
  

if __name__ == "__main__":
    print("Promoções do Gatry:")
    list = []
    list2 = []
    list = Gatry()
   # list2 = Pelando()

    app = flask.Flask(__name__)
    
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

    app.run(host='192.168.15.10')

