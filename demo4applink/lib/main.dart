import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String? _initialLink;
  Uri? _initialUri;
  String? _latestLink = 'Unknown';
  Uri? _latestUri;

  StreamSubscription? _sub;

  late final TabController _tabController;
  UniLinksType _type = UniLinksType.string;
  final TextStyle _cmdStyle = const TextStyle(
      fontFamily: 'Courier', fontSize: 12.0, fontWeight: FontWeight.w700);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(_handleTabChange);
    initPlatformState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  Future<void> initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    if (!kIsWeb)
      _sub = linkStream.listen((String? link) {
        if (!mounted) return;
        setState(() {
          _latestLink = link ?? 'Unknown';
          _latestUri = null;
          try {
            if (link != null) _latestUri = Uri.parse(link);
          } on FormatException {}
        });
      }, onError: (Object err) {
        if (!mounted) return;
        setState(() {
          _latestLink = 'Failed to get latest link: $err.';
          _latestUri = null;
        });
      });

    // Attach a second listener to the stream
    if (!kIsWeb)
      linkStream.listen((String? link) {
        print('got link: $link');
      }, onError: (Object err) {
        print('got err: $err');
      });

    try {
      _initialLink = await getInitialLink();
      print('initial link: $_initialLink');
      if (_initialLink != null) _initialUri = Uri.parse(_initialLink!);
    } on PlatformException {
      _initialLink = 'Failed to get initial link.';
      _initialUri = null;
    } on FormatException {
      _initialLink = 'Failed to parse the initial link as Uri.';
      _initialUri = null;
    }
  }

  /// An implementation using the [Uri] convenience helpers
  Future<void> initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    if (!kIsWeb)
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        setState(() {
          _latestUri = uri;
          _latestLink = uri?.toString() ?? 'Unknown';
        });
      }, onError: (Object err) {
        if (!mounted) return;
        setState(() {
          _latestUri = null;
          _latestLink = 'Failed to get latest link: $err.';
        });
      });
    if (!mounted) return;

    setState(() {
      _latestUri = _initialUri;
      _latestLink = _initialLink;
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryParams = _latestUri?.queryParametersAll.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applink + param'),
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(text: 'STRING LINK'),
        //     Tab(text: 'URI'),
        //   ],
        // ),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          if (!kIsWeb)
            ListTile(
              title: const Text('Link'),
              subtitle: Text('$_latestLink'),
            ),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('Query params'),
            children: queryParams == null
                ? const [
              ListTile(
                dense: true,
                title: const Text('null'),
              ),
            ] : [
              for (final item in queryParams)
                ListTile(
                  title: Text(item.key),
                  trailing: Text(
                    item.value.join(', '),
                  ),
                ),
            ],
          ),

        ],
      ),
    );
  }



  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _type = UniLinksType.values[_tabController.index];
      });
      initPlatformState();
    }
  }

  Future<void> _printAndCopy(String cmd) async {
    print(cmd);

    await Clipboard.setData(ClipboardData(text: cmd));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to Clipboard')),
    );
  }
}
List<Widget> intersperse(Iterable<Widget> list, Widget item) {
  final initialValue = <Widget>[];
  return list.fold(initialValue, (all, el) {
    if (all.isNotEmpty) all.add(item);
    all.add(el);
    return all;
  });
}
