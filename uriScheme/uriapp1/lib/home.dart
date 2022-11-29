import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  final String lat = "37.3230";
  final String lng = "-122.0312";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uri scheme"),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title:const Text("open app"),
            onTap: () async {
              final String url = 'def://abc';
              //Uri url = Uri.parse('https://google.com');
              await launch(url);
              //final String googleMapsUrl = "comgooglemaps://?center=$lat,$lng";  //?center=$lat,$lng
              //Uri urilink = Uri.parse(googleMapsUrl);
              //await launch(googleMapsUrl);
            },
          ),
        ],
      ),
    );
  }
}