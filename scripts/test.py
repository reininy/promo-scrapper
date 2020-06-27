from bs4 import BeautifulSoup
import requests
from selenium import webdriver

driver = webdriver.Chrome("chromedriver")

driver.get('https://www.reclameaqui.com.br/empresa/amazon/')
content = driver.find_element_by_class_name('score')
html = content.get_attribute("innerHTML")
soup = BeautifulSoup(html, 'html.parser')
print(soup.text)
driver.close()