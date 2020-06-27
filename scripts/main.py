# -*- coding: latin-1 -*-
# Encoding schema https://www.python.org/dev/peps/pep-0263

import requests
from bs4 import BeautifulSoup
from flask import request, jsonify


def ReclameAqui(brand):
    

    brands = {'Amazon':'data:image/png;base64,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'}


    if brand in brands:
        return brands[brand]
   
    

def Formatter(string):
    characters_to_remove = "!()@\n\t"
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
        span = div.find("span", class_='data_postado')
        formatted_span = Formatter(str(span.text))
        id = id + 1
        dict['id'] = id
        dict['name'] = formatted_name
        dict['price'] = price
        dict['image'] = image['src']
        dict['span'] = formatted_span

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

        try:
            price = div.find("span", class_='thread-price text--b vAlign--all-tt cept-tp size--all-l').get_text()
        except:
            print("An exception occurred")
        
        try: 
            brand = div.find("span", class_='cept-merchant-name text--b text--color-brandPrimary link').get_text()
            try:
                reclameaqui = ReclameAqui(brand)
            except:
                print("Brand not on the list")
        except:
            print("Brand not found")


        image = div.find("img", class_='thread-image width--all-auto height--all-auto imgFrame-img cept-thread-img', src=True)
        formatted_name = Formatter(str(name))
        id = id + 1
        print(price)
        dict['id'] = id
        dict['name'] = formatted_name
        dict['price'] = price
        dict['image'] = image['src']
        if (reclameaqui != None):
            dict['reclameaqui'] = reclameaqui
        

        list.append(dict)

    return list
  

