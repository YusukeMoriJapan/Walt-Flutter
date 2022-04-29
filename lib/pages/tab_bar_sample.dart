import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: _title,
      home: const MyStatefulWidget(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar Widget'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              icon: Icon(Icons.beach_access_sharp),
            ),
            Tab(
              icon: Icon(Icons.brightness_5_sharp),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(
            child: MyWebView(
              'https://abematv.co.jp/',
            ),
          ),
          Center(
            child: MyWebView(
              'https://awa.fm/',
            ),
          ),
          Center(
            child: MyWebView(
              'https://official.ameba.jp/',
            ),
          ),
        ],
      ),
    );
  }
}

class MyWebView extends StatefulWidget {
  final String url;

  const MyWebView(this.url, {Key? key}) : super(key: key);

  @override
  MyWebViewState createState() => MyWebViewState(url);
}

class MyWebViewState extends State<MyWebView>
    with AutomaticKeepAliveClientMixin<MyWebView> {
  final String initialUrl;

  MyWebViewState(this.initialUrl);

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl: initialUrl, javascriptMode: JavascriptMode.unrestricted);
  }

  @override
  bool get wantKeepAlive => true;
}
