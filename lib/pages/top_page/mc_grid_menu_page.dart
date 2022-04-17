import 'package:flutter/material.dart';

void main() {
  runApp(const McGridMenuApp());
}

class McGridMenuApp extends StatelessWidget {
  const McGridMenuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.amber,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          scaffoldBackgroundColor: const Color(-921103)),
      home: Scaffold(
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {}, icon: const Icon(Icons.perm_identity));
            }),
            actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.settings))],
          ),
          body: const McGridMenuPage()),
    );
  }
}

class McGridMenuPage extends StatefulWidget {
  const McGridMenuPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _McGridMenuPageState();
  }
}

class _McGridMenuPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: MyGridView(),
    );
  }
}

class MyGridView extends StatelessWidget {
  final items = List.generate(
    100,
    (index) => Material(
      // onTap: () {},
      borderRadius: BorderRadius.circular(10),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Image.asset("images/burger_image.png"),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "チーズバーガー",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "¥10000",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                  ),
                )
              ],
            ),
          )),
    ),
  );

  MyGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: items,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
    );
  }
}
