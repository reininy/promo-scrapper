import requests
from bs4 import BeautifulSoup
from flask import request, jsonify


def Formatter(string):
    characters_to_remove = "!()@\n"
    new_string = string
    for character in characters_to_remove:
        new_string = new_string.replace(character, "")

    return new_string 

def Gatry():
    page = requests.get('https://gatry.com/')
    soup = BeautifulSoup(page.text, 'html.parser') ## parsea o html colocando cada tag em uma linha
    ##divs_info = soup.find_all("div", class_='informacoes')
    
    list = []
    id = 0
    for div in soup.find_all("article", class_='promocao'):
        dict = {} ## inicializa o dicionario
        
        name = div.find("h3")
        formatted_name = Formatter(str(name.text))
        price = div.find("p", class_='preco').get_text()
        image = div.find("div", class_='imagem').find('img', src=True)
        id = id + 1
        dict['id'] = id
        dict['name'] = formatted_name
        dict['price'] = price
        dict['image'] = image['src']

        list.append(dict)

   
    return list

    

def Pelando():
    page = requests.get('https://www.pelando.com.br/')
    soup = BeautifulSoup(page.text, 'html.parser')
    list = []
    id = 0
    for div in soup.find_all("div", class_='gridLayout-item threadCardLayout--card'):
        dict = {}
        name = div.find("strong", {"class": "thread-title"}).get_text()
        price = div.find("div", class_='threadCardLayout--row--small overflow--fade space--l-3').get_text()
        id = id + 1
        dict['id'] = id
        dict['name'] = name
        dict['price'] = price

        list.append(dict)

    return list
  

