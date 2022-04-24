import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SampleSliverDetailList extends HookConsumerWidget {
  const SampleSliverDetailList({Key? key}) : super(key: key);

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
                children: [
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0xE6FFC0A2),
                              Colors.white,
                            ])),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
