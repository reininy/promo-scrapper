import requests
from bs4 import BeautifulSoup
import pandas as pd

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

   
     # create a data frame from the list of dictionaries
    dataFrame = pd.DataFrame.from_dict(list)
    # save the scraped data as CSV file
    dataFrame.to_csv('gatry.csv')

    
   


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

    dataFrame = pd.DataFrame.from_dict(list)
    # save the scraped data as CSV file
    dataFrame.to_csv('pelando.csv')
  

if __name__ == "__main__":
    print("Promoções do Gatry:")

    Gatry()
    Pelando()

