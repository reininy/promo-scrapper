import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('http://192.168.15.18:5000/pelando');

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
  final String img;

  Photo({ this.name, this.price, this.img});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'] as String,
      price: json['price'] as String,
      img: json['image'] as String,
      
 
    );
  }
}

class Pelando extends StatelessWidget {
 
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
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(
            top:5,
            bottom:5,
          ),
          child:  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple,
            ),
           
            child: Row(
              children: [
                
                Image.network(photos[index].img, width: 150,),

                SizedBox(width: 45,),
                
                Text(photos[index].price, style: TextStyle(color: Colors.white, fontSize: 13)),



              
            ],
          ),

          
         
        ),
      );
      },
      
     
    );
    
  }
}
