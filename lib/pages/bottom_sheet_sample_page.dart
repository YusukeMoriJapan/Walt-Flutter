import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:walt/pages/sliver_app_bar/sliver_app_bar_flexible_space_expanded_height.dart';
import 'package:walt/pages/top_page/states/top_page_providers.dart';

class BottomSheetDemoPage extends StatefulWidget {
  @override
  _BottomSheetDemoPageState createState() => new _BottomSheetDemoPageState();
}

class _BottomSheetDemoPageState extends State<BottomSheetDemoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback? _showPersistantBottomSheetCallBack;

  @override
  void initState() {
    super.initState();
    _showPersistantBottomSheetCallBack = _showBottomSheet;
  }

  Widget _bottomSheetColumnWidget({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      width: double.infinity,
      child: child,
    );
  }

  Widget _bottomSheetTextButton(
      String text, Widget? icon, void Function() onClick) {
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _controlsIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.apps)),
        IconButton(onPressed: () {}, icon: Icon(Icons.repeat)),
        IconButton(onPressed: () {}, icon: Icon(Icons.waves)),
      ],
    );
  }

  void _showBottomSheet() {
    setState(() {
      _showPersistantBottomSheetCallBack = null;
    });

    _scaffoldKey.currentState
        ?.showBottomSheet((context) {
          return Container(
            height: double.infinity,
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

                  /// Opacity適用するため、Stack x BackdropFilterを組み合わせている
                  child: Container(
                      // color: Colors.white.withOpacity(0.3),
                      ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: statusBarTopPadding,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Colors.amber,
                        ),
                      ),
                      Container(
                          alignment: Alignment.center, child: _controlsIcons()),
                      _bottomSheetColumnWidget(
                          child: _bottomSheetTextButton("いいね!", null, () {})),
                      _bottomSheetColumnWidget(
                          child: _bottomSheetTextButton(
                              "この曲を非表示にする", null, () {})),
                      _bottomSheetColumnWidget(
                          child: _bottomSheetTextButton(
                              "プレイリストに追加する", null, () {})),
                      _bottomSheetColumnWidget(
                          child:
                              _bottomSheetTextButton("[次に再生]に追加", null, () {})),
                    ],
                  ),
                )
              ],
            ),
          );
        }, backgroundColor: Colors.white.withOpacity(0.5))
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersistantBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    statusBarTopPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.cyan[200],
      //   title: Text("Flutter Persistent BottomSheet"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("戻る")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Text("次の画面に遷移")),
            RaisedButton(
              color: Colors.teal[100],
              onPressed: _showPersistantBottomSheetCallBack,
              child: Text(
                "Show Persistent BottomSheet",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
