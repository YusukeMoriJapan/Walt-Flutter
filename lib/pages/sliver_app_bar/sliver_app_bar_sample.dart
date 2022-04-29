import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      vsync: this,
      length: 3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: const Text('Sample'),
              leading:
                  RaisedButton(onPressed: () {}, child: const Icon(Icons.settings)),
              actions: <Widget>[
                RaisedButton(onPressed: () {}, child: const Icon(Icons.add)),
                RaisedButton(onPressed: () {}, child: const Icon(Icons.list)),
              ],
              bottom: PreferredSize(
                preferredSize: const Size(60.0, 60.0),
                child: Container(
                  child: TabBar(
                    tabs: const <Widget>[
                      Tab(text: 'Car', icon: Icon(Icons.directions_car)),
                      Tab(text: 'Bicycle', icon: Icon(Icons.directions_bike)),
                      Tab(text: 'Boat', icon: Icon(Icons.directions_boat)),
                    ],
                    controller: _controller,
                  ),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [
                  Container(color: Colors.red),
                  Container(color: Colors.purple),
                  Container(color: Colors.green),
                  Container(color: Colors.orange),
                  Container(color: Colors.yellow),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
