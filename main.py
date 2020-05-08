import requests
from bs4 import BeautifulSoup


def Gatry():
    page = requests.get('https://gatry.com/')
    soup = BeautifulSoup(page.text, 'html.parser') ## parsea o html colocando cada tag em uma linha
    divs_info = soup.find_all("div", class_='informacoes')
    for div in soup.find_all("div", class_='informacoes'):
        print(div.find("h3").get_text())
        print(div.find("p", class_='preco').get_text())
    

def Pelando():
    page = requests.get('https://www.pelando.com.br/')
    soup = BeautifulSoup(page.text, 'html.parser')
    for div in soup.find_all("div", class_='gridLayout-item threadCardLayout--card'):
        print(div.find("a", class_='cept-tt thread-link linkPlain thread-title--card').get_text())
        print(div.find("div", class_='threadCardLayout--row--small overflow--fade space--l-3').get_text())


if __name__ == "__main__":
    print("Promoções do Gatry:")
    Gatry()
    print("Promoções do Pelando:")
    Pelando()