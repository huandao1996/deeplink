import 'package:flutter/material.dart';

import 'dynamic_link_service.dart';

void main() {
  initDynamicLinks();

  String myurl = Uri.base.toString(); //get complete url
  String para1 = Uri.base.queryParameters["para1"]!; //get parameter with attribute "para1"
  String para2 = Uri.base.queryParameters["para2"]!; //get parameter with attribute "para2"

  runApp(MyApp(myurl: myurl, para1: para1, para2:para2)); //pass to MyApp class
}

class MyApp extends StatefulWidget{

  String myurl, para1, para2;
  MyApp({ required this.myurl,required this.para1,required this.para2}); //constructor of MyApp class

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test App",
      home: Scaffold(
          appBar: AppBar(
            title: Text("Get URL Parameter"),
            backgroundColor: Colors.redAccent,
          ),

          body: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Column(
                children: [
                  //display parameters and URL here
                  Text(widget.para1 == null?"Parameter1 is null":"Parameter 1 = " + widget.para1),
                  Text(widget.para2 == null?"Parameter2 is null":"Parameter 2 = " + widget.para2),
                  Text(widget.myurl == null?"URl is null":"URL = " + widget.myurl)
                ],)
          )
      ),
    );
  }
}