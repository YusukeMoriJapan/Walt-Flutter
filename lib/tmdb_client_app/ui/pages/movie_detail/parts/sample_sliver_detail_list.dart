import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleSliverDetailList extends HookConsumerWidget {
  const SampleSliverDetailList(this.overView, {Key? key}) : super(key: key);
  final String? overView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollNotificationObserver.of(context)?.addListener((notification) {
      ///スクロール時に発火するイベント
      // final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
      // print(renderBox?.localToGlobal(Offset.zero).dy);
    });

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              Column(
                children: [Text(overView ?? '')],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
