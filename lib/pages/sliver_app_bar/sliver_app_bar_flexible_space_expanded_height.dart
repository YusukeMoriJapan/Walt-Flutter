import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _flexibleSpaceBerKey = GlobalKey();

final _appBarHeight = StateNotifierProvider<AppBarHeightNotifier, double>(
    (ref) => AppBarHeightNotifier());

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light),
    );

    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Color(0xE6FFC0A2),
              leading: IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
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
                    /* ... */
                  },
                ),
              ],
              floating: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                      Text(""),
                      Text(
                          "ウィキペディア（英: Wikipedia）とは、世界中のボランティアの共同作業によって執筆及び作成されるフリーの多言語[4]インターネット百科事典である[5]。収録されている全ての内容がオープンコンテントで商業広告が存在しないということを特徴とし、主に寄付に依って活動している非営利団体「ウィキメディア財団」が所有・運営している[6][7][8][9]。「ウィキペディア（Wikipedia）」という名前は、ウェブブラウザ上でウェブページを編集することができる「ウィキ（Wiki）」というシステムを使用した「百科事典」（英: Encyclopedia）であることに由来する造語である[10]。設立者の1人であるラリー・サンガーにより命名された[11][12]。"),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _flexibleSpaceBar(WidgetRef ref, double? appBarHeight) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (layout) {
        print(_flexibleSpaceBerKey.currentContext?.size?.height);
        ref.read(_appBarHeight.notifier).updateheight(
            _flexibleSpaceBerKey.currentContext?.size?.height ?? 0);
        return false;
      },
      child: SizeChangedLayoutNotifier(
        key: _flexibleSpaceBerKey,
        child: FlexibleSpaceBar(
          stretchModes: <StretchMode>[
            StretchMode.zoomBackground,
            StretchMode.blurBackground,
            StretchMode.fadeTitle,
          ],
          collapseMode: CollapseMode.parallax,
          centerTitle: true,
          title: const Text(
            '4 Walls',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          background: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 56),
                child: Image.network(
                    "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/62/15/02/62150210-5b5e-46fa-bd5c-37da1e8e5653/B.jpg/1000x1000bb.webp"),
              ),
              Container(
                  alignment: Alignment.center,
                  child: Text(appBarHeight.toString()))
              // const DecoratedBox(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment(0.0, -0.8),
              //       end: Alignment(0.0, 0.0),
              //       colors: <Color>[
              //         Color(0x60000000),
              //         Color(0x00000000),
              //       ],
              //     ),
              //   ),
              // ),
              // const DecoratedBox(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment(0.0, 0.8),
              //       end: Alignment(0.0, 0.0),
              //       colors: <Color>[
              //         Color(0x60000000),
              //         Color(0x00000000),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class RiverpodFlexAppBar extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarHeightNotifier = ref.watch(_appBarHeight.notifier);
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (layout) {
          print(_flexibleSpaceBerKey.currentContext?.size?.height);
          appBarHeightNotifier.updateheight(
              _flexibleSpaceBerKey.currentContext?.size?.height ?? 0);
          return false;
        },
        child: SizeChangedLayoutNotifier(
            key: _flexibleSpaceBerKey,
            child: FlexibleSpaceBar(
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
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
                background: Stack(fit: StackFit.expand, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 56),
                    child: Image.network(
                        "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/62/15/02/62150210-5b5e-46fa-bd5c-37da1e8e5653/B.jpg/1000x1000bb.webp"),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(ref.watch(_appBarHeight).toString()))
                ]))));
  }
}

class AppBarHeightNotifier extends StateNotifier<double> {
  AppBarHeightNotifier() : super(0);

  void updateheight(double height) {
    print("updateHeight" + height.toString());
    state = height;
  }
}
