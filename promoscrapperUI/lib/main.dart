import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:promoscrapperUI/platformselector.dart';

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://192.168.15.18:5000/gatry');

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
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: photos.length,
      itemBuilder: (context, index) {
           return Padding(
             padding: EdgeInsets.only(
               top:5,
               bottom:5,
             ),
             child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple,
            ),
           
           padding: EdgeInsets.only(
             right:10,
           ),
            child: Row(
              
              children: [
                Image.network(photos[index].imageurl, width: 130,),

                SizedBox(width: 10,),
                
                Flexible(
                  child:  Column(children: [

                    
                    
                    Text(photos[index].name, style: TextStyle(color: Colors.white, fontSize: 18,)),
                    
                    SizedBox(height: 25,),

                    Text(photos[index].price, style: TextStyle(color: Colors.white, fontSize: 15),),
                  
                ],
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