import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SliverMovieDetailList extends HookConsumerWidget {
  const SliverMovieDetailList(this.overView, {Key? key}) : super(key: key);
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
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 4),
                  child: Text(
                    "概要",
                    style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(overView ?? ''),
              )
            ],
          ),
        ],
      ),
    );
  }
}
