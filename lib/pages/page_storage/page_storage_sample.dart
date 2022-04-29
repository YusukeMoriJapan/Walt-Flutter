
import 'package:flutter/material.dart';
import 'package:walt/utils/navigation_history_observer.dart';

import '../../navigation/page_storage_manager.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        navigatorObservers: [NavigationHistoryObserver()],
      ),
    );

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

class MyApp extends StatelessWidget {
  final List<TabInfo> _tabs = [
    TabInfo("FIRST",
        const Page1(key: PageStorageKey<String>("key_Page1"))), // ここでキーを渡している
    TabInfo("SECOND", Page2()),
    TabInfo("THIRD", Page3()),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tab Controller'),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: true,
              tabs: _tabs.map((TabInfo tab) {
                return Tab(text: tab.label);
              }).toList(),
            ),
            preferredSize: const Size.fromHeight(30.0),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  const Page1({required Key key}) : super(key: key); //この行を追加

  @override
  State<StatefulWidget> createState() {
    return _Page1State();
  }
}

class Page1Params {
  int counter1 = 0;
  int counter2 = 0;
}

class _Page1State extends State<Page1> {
  Page1Params? _params;

  @override
  void didChangeDependencies() {
    Page1Params? p =
        PageStorage.of(context)?.readState(context, identifier: "su-ji");
    if (p != null) {
      _params = p;
    } else {
      _params = Page1Params();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // このメソッドをオーバーライド
    PageStorageManager().registerPageStorage("su-ji", context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '${_params?.counter1}',
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove, size: 32.0),
                  onPressed: () {
                    setState(() {
                      _params?.counter1--;
                    });
                    PageStorage.of(context)
                        ?.writeState(context, _params, identifier: "su-ji");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 32.0),
                  onPressed: () {
                    setState(() {
                      _params?.counter1++;
                    });
                    PageStorage.of(context)
                        ?.writeState(context, _params, identifier: "su-ji");
                  },
                ),
              ],
            ),
            Text(
              '${_params?.counter2}',
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove, size: 32.0),
                  onPressed: () {
                    setState(() {
                      _params?.counter2--;
                    });
                    PageStorage.of(context)
                        ?.writeState(context, _params, identifier: "su-ji");
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 32.0),
                  onPressed: () {
                    setState(() {
                      _params?.counter2++;
                    });
                    PageStorage.of(context)
                        ?.writeState(context, _params, identifier: "su-ji");
                  },
                ),
              ],
            ),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            const Text("赤沙汰な"),
            ElevatedButton(
                onPressed: () {
                  PageStorage.of(context)?.writeState(context, null);
                },
                child: const Text("Clear"))
          ],
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
