import 'package:flutter/material.dart';
import 'package:promoscrapperUI/main.dart';
import 'package:promoscrapperUI/pelando.dart';

class PlatformSelector extends StatefulWidget {
  @override
  _PlatformSelectorState createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PromoScrapper'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
        body: Center(
          
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Text("Choose the platform", style: TextStyle(color: Colors.black, fontSize: 60),
              ),


              SizedBox(height: 50),


              ButtonTheme(
                height: 50,
                child: RaisedButton(
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),

                child: Text('Pelando', style: TextStyle(color: Colors.white, fontSize: 20),
                ),

                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pelando())
                  );
                },
              ),
              ),

              SizedBox(height: 20),

              ButtonTheme(
                height: 50,
                child: RaisedButton(
                color: Colors.red[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),

                child: Text('Gatry', style: TextStyle(color: Colors.white, fontSize: 20 ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage())
                  );
                }
              ),
              )
            ],
          ),
        ),
      
      
    );
  }
}