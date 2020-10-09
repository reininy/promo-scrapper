# -*- coding: latin-1 -*-
# Encoding schema https://www.python.org/dev/peps/pep-0263

import requests
from bs4 import BeautifulSoup
from flask import request, jsonify
from selenium import webdriver
import warnings

def formatterloja(string):
    characters_to_remove = ["Ir", "para", " "]
    for character in characters_to_remove:
        string = string.replace(character, "")

    string = string.lower()
    print(string)
    
    return string

def Formatter(string):
    characters_to_remove = "!()@\n\t"
    new_string = string
    for character in characters_to_remove:
        new_string = new_string.replace(character, "")

    return new_string 

def reclameaqui(empresa):
    warnings.filterwarnings('ignore')
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size=1920x1080')
    driver = webdriver.Chrome('./chromedriver', chrome_options=options)
    empresainfo = {}
    score = None
    info = None
    try: 
        url = ('https://www.reclameaqui.com.br/empresa/' + empresa)
        driver.get(url)
        html = driver.page_source
        soup = BeautifulSoup(html, 'html.parser')
        score = soup.find("span", class_='score')
        info = soup.find("span", class_='description')
    except:
        print("Corporation not found")

    empresainfo = {}
    if (score != None):
        empresainfo['score'] = score.text
    else:
        empresainfo['score'] = 'Score não informado'
    
    if (info != None):
        empresainfo['info'] = info.text
    else:
        empresainfo['info'] = 'Atribuição não informada'
 
    return empresainfo


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
        linkloja = div.find("a", class_='link_loja')
        linkgatry = div.find("a", class_='mais hidden-xs')
        print(linkloja)
        formatted_span = Formatter(str(span.text))
        id = id + 1
        empresa = formatterloja(linkloja.text)
        dict['id'] = id
        dict['name'] = formatted_name
        dict['price'] = price
        dict['image'] = image['src']
        dict['span'] = formatted_span
        dict['linkloja'] = linkloja['href']
        dict['empresa'] = empresa
        dict['linkgatry'] = 'https://www.gatry.com' +linkgatry['href']
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
        price = ''
        try:
            price = div.find("span", class_='thread-price text--b cept-tp size--all-l').get_text()
        except:
            print("An exception occurred")

        image = div.find("img", class_='thread-image width--all-auto height--all-auto imgFrame-img cept-thread-img', src=True)
        formatted_name = Formatter(str(name))
        id = id + 1
        dict['id'] = id
        dict['name'] = formatted_name
        dict['price'] = price
        dict['image'] = image['src']
        list.append(dict)

    return list
  

