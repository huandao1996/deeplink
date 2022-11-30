import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

void initDynamicLinks() async {
  PendingDynamicLinkData? data =
  await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri? deepLink = data?.link;

  if (deepLink != null) {
    handleDynamicLink(deepLink);
  }
  FirebaseDynamicLinks.instance.onLink.listen((event) {
    final Uri deepLink = event.link;
    print(event);
    handleDynamicLink(deepLink);
  });
}

void handleDynamicLink(Uri url) {
  print(url);
}