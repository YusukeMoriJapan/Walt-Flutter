import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/ui/components/bottom_sheet/wath_provider/watch_provder_bottom_sheet.dart';

class SliverMovieDetailList extends HookConsumerWidget {
  const SliverMovieDetailList(this.overView, this.movieId, this.castList,
      {Key? key})
      : super(key: key);
  final String? overView;
  final int? movieId;
  final Widget? castList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollNotificationObserver.of(context)?.addListener((notification) {
      ///スクロール時に発火するイベント
      // final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
      // print(renderBox?.localToGlobal(Offset.zero).dy);
    });

    final castList =  this.castList;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SafeArea(
            top: false,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    final movieId = this.movieId;
                    if (movieId != null) {
                      showWatchProviderBottomSheet(context, ref, movieId);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: 56,
                    child: Image.network(
                        "https://www.justwatch.com/appassets/img/logo/JustWatch-logo-large.webp"),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Text(
                      AppLocalizations.of(context)!.overView,
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(overView ?? ''),
                ),
                const SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Text(
                      AppLocalizations.of(context)!.topBilledCast,
                      style:
                          const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (castList != null) castList
              ],
            ),
          ),
        ],
      ),
    );
  }
}
