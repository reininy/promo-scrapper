import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:promoscrapperUI/platformselector.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get('http://<your-ip>:5000/gatry');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String name;
  final String price;
  final String imageurl;
  final String span;
  final String linkloja;

  Photo({this.name, this.price, this.imageurl, this.span, this.linkloja});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'] as String,
      price: json['price'] as String,
      imageurl: json['image'] as String,
      span: json['span'] as String,
      linkloja: json['linkloja'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlatformSelector(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PromoScrapper'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple[800],
            ),
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Row(
              children: [
                Image.network(
                  photos[index].imageurl,
                  width: 180,
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [

                          Text(photos[index].name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            photos[index].price,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          FlatButton(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductPage(),
                                      settings: RouteSettings(
                                        arguments: photos[index],
                                      )));
                            },
                          ),
                      ],
                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LinkLoja extends StatelessWidget {
  final String title;
  final String url;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  LinkLoja({
    @required this.title,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[800],
          title: Text(title),
        ),
        body: WebView(
          initialUrl: url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ));
  }
}

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final Photo photos = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.purple[800]),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(20),
        children: [
          Image.network(photos.imageurl),
          Align(
            child: Text(
              photos.name,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 5,
          ),
          Align(
            child: Text(photos.price, style: TextStyle(fontSize: 20)),
            alignment: Alignment.centerLeft,
          ),
          SizedBox(height: 30),
          Align(
            child: SizedBox(
              width: 200,
              height: 45,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.purple[800],
                  child: Text(
                    'Open Up',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinkLoja(
                          title: photos.name,
                          url: photos.linkloja,
                        ),
                      ),
                    );
                  }),
            ),
          ),

          
          
        ],
      ),
    );
  }
}
