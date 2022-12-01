// import 'package:flutter/material.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   String? linkMessage = '';
//
//   void initDynamicLinks() async {
//     PendingDynamicLinkData? data =
//     await FirebaseDynamicLinks.instance.getInitialLink();
//     final Uri? deepLink = data?.link;
//
//     if (deepLink != null) {
//       handleDynamicLink(deepLink);
//     }
//     FirebaseDynamicLinks.instance.onLink.listen((event) {
//       final Uri deepLink = event.link;
//       print(event);
//       handleDynamicLink(deepLink);
//     });
//   }
//
//   void handleDynamicLink(Uri url) {
//     print(url);
//     linkMessage = url.toString();
//   }
//   @override
//   void initState() {
//     initDynamicLinks();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: Center(
//             child: Column(
//               children: [
//                 Text(linkMessage??""),
//                 const SizedBox(height: 15,),
//                 Container(
//                   height: 50,
//                   width: 100,
//                 ),
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }

import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dynamic Links Example',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => _MainScreen(),
    },
  ));
}

class _MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<_MainScreen> {
  String deeplinkString = "";
  int age = 0;
  String name = "";
  @override
  void initState()  {
    super.initState();
    initDynamicLinks();

  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
          final Uri? deepLink = dynamicLink?.link;
            if (deepLink != null) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                deeplinkString = deepLink?.toString() ?? "khong co";
                name = deepLink?.queryParameters['name'].toString() ?? '';
                age = int.tryParse(deepLink.queryParameters['age'] ??'') ?? 0;
                setState((){});
              });
            }
        },
        onError: (OnLinkErrorException e) async {});

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: (){},
                  child: Text(deeplinkString),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text(name),
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text(age.toString()),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


