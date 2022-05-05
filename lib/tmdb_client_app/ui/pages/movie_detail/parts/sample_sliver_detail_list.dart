import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/components/watch_provder_bottom_sheet.dart';

class SliverMovieDetailList extends HookConsumerWidget {
  const SliverMovieDetailList(this.overView, this.movieId, {Key? key})
      : super(key: key);
  final String? overView;
  final int? movieId;

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
              InkWell(
                onTap: () {
                  final _movieId = movieId;
                  if (_movieId != null) {
                    showWatchProviderBottomSheet(context, ref, _movieId);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: 56,
                  child: Image.network(
                      "https://www.justwatch.com/appassets/img/logo/JustWatch-logo-large.webp"),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text(
                    "概要",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(overView ?? ''),
              ),
              SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text(
                    "主な出演者",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
