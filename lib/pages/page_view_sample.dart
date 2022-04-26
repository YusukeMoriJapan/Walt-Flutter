import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatelessWidget(),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controllerParent = PageController();
    final PageController controllerChild = PageController();

    return PageView.builder(
        scrollDirection: Axis.vertical,
        controller: controllerParent,
        itemBuilder: (BuildContext context, int indexParent) {
          return PageView.builder(
              controller: controllerChild,
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexChild) {
                return Center(
                  child: Text('$indexParent & $indexChild Page'),
                );
              });
        },
        itemCount: 3);
  }
}
