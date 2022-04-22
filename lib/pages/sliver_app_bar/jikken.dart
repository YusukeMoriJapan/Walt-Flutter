import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Build scheduled during frame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Build scheduled during frame', key: Key ("something"),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool _isBottomWidgetShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: NotificationListener(
                onNotification: (ScrollNotification notification) {
                  final double offset = notification.metrics.pixels;
                  final double maxScrollExtent =
                      notification.metrics.maxScrollExtent;

                  if (maxScrollExtent - offset < 10) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      print("true");
                      setState(() {
                        _isBottomWidgetShow = true;
                      });
                    });
                    Timer(Duration(milliseconds: 3000), () {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        print("timer");
                        setState(() {
                          _isBottomWidgetShow = false;
                        });
                      });
                    });
                  }

                  return true;
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext buildContext, int index) {
                    return Container(
                      height: 80.0,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: _isBottomWidgetShow == true ? 30.0 : 0.0,
              color: const Color(0xffffa500),
            ),
          ],
        ),
      ),
    );
  }
}
