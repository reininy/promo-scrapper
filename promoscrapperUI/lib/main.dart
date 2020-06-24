import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:promoscrapperUI/platformselector.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://192.168.15.10:5000/gatry');

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

  Photo({ this.name, this.price, this.imageurl, this.span});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'] as String,
      price: json['price'] as String,
      imageurl: json['image'] as String,
      span: json['span'] as String,
 
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
        backgroundColor: Colors.purple,
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
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Scaffold(
            body: Center(
            child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple,
            ),
           
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(photos[index].imageurl),

                
                Text(photos[index].price, style: TextStyle(color: Colors.white, fontSize: 15),
              ),

              

            
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}