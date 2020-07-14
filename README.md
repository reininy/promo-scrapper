# PromoScrapper

The proposal of this project is to make an aggregator of products on sale, the application will render the Pelando.com and Gatry.com last products.

![](https://github.com/reininy/promo-scrapper/blob/master/app.gif)

## Flutter Application ##

In order to everything work fine, you will need to change the ip on the `pelando.dart and main.dart` files:

``
Future <List <Photo>> fetchPhotos (http.Client client) async {
  final response = await client.get ('http: // <your-ip>: 5000 / gatry');
 ``

Make sure to use your `ipv4 address`:

``
$ ipconfig
``

## Python Scripts ##

Firstly, install the requirements:

``
$ python -m pip install -r requirements.txt
``

After installing all the requirements, the only thing remaining is the flask server which you can run with the same `ip address` you have used before:

``
$ python server.py <your-ip>
``

## BeautifulSoup ##

The core of the flask API is the web scrapping functions located on `main.py`. If any information is not being displayed, go debug that file.
