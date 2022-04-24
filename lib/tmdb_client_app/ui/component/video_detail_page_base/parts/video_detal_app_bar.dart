import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _flexibleSpaceBerKey = GlobalKey();

class VideoDetailAppBar extends HookConsumerWidget {
  const VideoDetailAppBar(this.appBarHeight, this.onAppBarHeightChanged,
      {Key? key})
      : super(key: key);

  final void Function(double? height) onAppBarHeightChanged;
  final double? appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: const Color(0xE6FFC0A2),
      leading:
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
      pinned: true,
      stretch: true,
      expandedHeight: 300.0,
      flexibleSpace:
          VideoDetailAppBarFlexSpace(appBarHeight, onAppBarHeightChanged),
      actions: <Widget>[
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Text(appBarHeight.toString());
        }),
        IconButton(
          icon: const Icon(Icons.add_circle),
          tooltip: 'Add new entry',
          onPressed: () {},
        ),
      ],
      floating: false,
    );
  }
}

class VideoDetailAppBarFlexSpace extends HookConsumerWidget {
  const VideoDetailAppBarFlexSpace(
      this.appBarHeight, this.onAppBarHeightChanged,
      {Key? key})
      : super(key: key);

  final void Function(double? height) onAppBarHeightChanged;
  final double? appBarHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (layout) {
          Future.delayed(const Duration(milliseconds: 0), () {
            onAppBarHeightChanged(
                _flexibleSpaceBerKey.currentContext?.size?.height);
          });

          return false;
        },
        child: SizeChangedLayoutNotifier(
            child: FlexibleSpaceBar(
                key: _flexibleSpaceBerKey,
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: const Text(
                  '映画タイトル',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                background: Stack(alignment: Alignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 56),
                    child: Container(
                      width: _calculateAppBarHeight(appBarHeight),
                      height: _calculateAppBarHeight(appBarHeight),
                      child: Image.network(
                          "https://is2-ssl.mzstatic.com/image/thumb/Music125/v4/62/15/02/62150210-5b5e-46fa-bd5c-37da1e8e5653/B.jpg/1000x1000bb.webp"),
                    ),
                  ),
                ]))));
  }
}

_calculateAppBarHeight(double? height) {
  if (height != null) {
    return height * 0.7;
  } else {
    return double.infinity;
  }
}
