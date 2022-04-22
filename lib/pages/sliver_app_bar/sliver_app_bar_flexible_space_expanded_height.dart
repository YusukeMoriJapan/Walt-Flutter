import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/navigation_history_observer.dart';

final _flexibleSpaceBerKey = GlobalKey();
final _textKey = GlobalKey();

final _appBarHeight = StateNotifierProvider<AppBarHeightNotifier, double>(
    (ref) => AppBarHeightNotifier());

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PageStorage.of(context).readState(context)

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light),
    );

    return const MaterialApp(
        home: SliverAppBarFlexSpaceExpandedHeightPage(
      key: PageStorageKey("test"),
    ));
  }
}

class SliverAppBarFlexSpaceExpandedHeightPage extends HookConsumerWidget {
  const SliverAppBarFlexSpaceExpandedHeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      NavigationHistoryObserver().history.forEach((route) {
        print(route.navigator?.widget.toString());
      });
    }, [Object()]);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            backgroundColor: Color(0xE6FFC0A2),
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/bottomSheetDemo");
                },
                icon: Icon(Icons.arrow_back_ios)),
            pinned: true,
            stretch: true,
            expandedHeight: 300.0,
            flexibleSpace: RiverpodFlexAppBar(),
            // flexibleSpace: Builder(builder: (context) {
            //   final watchedAppBarHeight = ref.watch(_appBarHeight);
            //   return _flexibleSpaceBar(ref, watchedAppBarHeight);
            // }),
            actions: <Widget>[
              Consumer(builder:
                  (BuildContext context, WidgetRef ref, Widget? child) {
                return Text(ref.watch(_appBarHeight).toString());
              }),
              IconButton(
                icon: const Icon(Icons.add_circle),
                tooltip: 'Add new entry',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/bottomSheetDemo");
                },
              ),
            ],
            floating: false,
          ),
          Builder(builder: (context) {
            ScrollNotificationObserver.of(context)?.addListener((notification) {
              final renderBox =
                  _textKey.currentContext?.findRenderObject() as RenderBox?;
              print(renderBox?.localToGlobal(Offset.zero).dy);
            });
            return SliverList(
              delegate: SliverChildListDelegate(
                [
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                  Color(0xE6FFC0A2),
                                  Colors.white,
                                ])),
                          ),
                          MyMetricsText(),
                          Text(
                            "ウィキペディア（英: Wikipedia）とは、世界中のボランティアの共同作業によって執筆及び作成されるフリーの多言語[4]インターネット百科事典である[5]。収録されている全ての内容がオープンコンテントで商業広告が存在しないということを特徴とし、主に寄付に依って活動している非営利団体「ウィキメディア財団」が所有・運営している[6][7][8][9]。「ウィキペディア（Wikipedia）」という名前は、ウェブブラウザ上でウェブページを編集することができる「ウィキ（Wiki）」というシステムを使用した「百科事典」（英: Encyclopedia）であることに由来する造語である[10]。設立者の1人であるラリー・サンガーにより命名された[11][12]。",
                            key: _textKey,
                          ),
                          Text(
                              "ウィキペディア（英: Wikipedia）とは、世界中のボランティアの共同作業によって執筆及び作成されるフリーの多言語[4]インターネット百科事典である[5]。収録されている全ての内容がオープンコンテントで商業広告が存在しないということを特徴とし、主に寄付に依って活動している非営利団体「ウィキメディア財団」が所有・運営している[6][7][8][9]。「ウィキペディア（Wikipedia）」という名前は、ウェブブラウザ上でウェブページを編集することができる「ウィキ（Wiki）」というシステムを使用した「百科事典」（英: Encyclopedia）であることに由来する造語である[10]。設立者の1人であるラリー・サンガーにより命名された[11][12]。"),
                          Text(
                              "ウィキペディア（英: Wikipedia）とは、世界中のボランティアの共同作業によって執筆及び作成されるフリーの多言語[4]インターネット百科事典である[5]。収録されている全ての内容がオープンコンテントで商業広告が存在しないということを特徴とし、主に寄付に依って活動している非営利団体「ウィキメディア財団」が所有・運営している[6][7][8][9]。「ウィキペディア（Wikipedia）」という名前は、ウェブブラウザ上でウェブページを編集することができる「ウィキ（Wiki）」というシステムを使用した「百科事典」（英: Encyclopedia）であることに由来する造語である[10]。設立者の1人であるラリー・サンガーにより命名された[11][12]。"),
                          Text(
                              "ウィキペディア（英: Wikipedia）とは、世界中のボランティアの共同作業によって執筆及び作成されるフリーの多言語[4]インターネット百科事典である[5]。収録されている全ての内容がオープンコンテントで商業広告が存在しないということを特徴とし、主に寄付に依って活動している非営利団体「ウィキメディア財団」が所有・運営している[6][7][8][9]。「ウィキペディア（Wikipedia）」という名前は、ウェブブラウザ上でウェブページを編集することができる「ウィキ（Wiki）」というシステムを使用した「百科事典」（英: Encyclopedia）であることに由来する造語である[10]。設立者の1人であるラリー・サンガーにより命名された[11][12]。"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class RiverpodFlexAppBar extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (layout) {
          // print(_flexibleSpaceBerKey.currentContext?.size?.height);

          Future.delayed(Duration(milliseconds: 0), () {
            ref.read(_appBarHeight.notifier).updateheight(
                _flexibleSpaceBerKey.currentContext?.size?.height ?? 0);
          });

          return false;
        },
        child: SizeChangedLayoutNotifier(
            child: FlexibleSpaceBar(
                key: _flexibleSpaceBerKey,
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: const Text(
                  '4 Walls',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                background: Stack(alignment: Alignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 56),
                    child: Container(
                      width: ref.watch(_appBarHeight) * 0.7,
                      height: ref.watch(_appBarHeight) * 0.7,
                      child: Image.network(
                          "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/62/15/02/62150210-5b5e-46fa-bd5c-37da1e8e5653/B.jpg/1000x1000bb.webp"),
                    ),
                  ),
                ]))));
  }
}

class AppBarHeightNotifier extends StateNotifier<double> {
  AppBarHeightNotifier() : super(double.infinity);

  void updateheight(double height) {
    // print("updateHeight" + height.toString());
    state = height;
  }
}

class MyMetricsText extends StatefulWidget {
  const MyMetricsText({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyMetricsTextState();
  }
}

class _MyMetricsTextState extends State<MyMetricsText>
    with WidgetsBindingObserver {
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    print("in didChangeMetrics");
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    print("position : ${position?.dx},${position?.dy}");
  }

  @override
  Widget build(BuildContext context) {
    return Text("サンプルString", key: _key);
  }
}
