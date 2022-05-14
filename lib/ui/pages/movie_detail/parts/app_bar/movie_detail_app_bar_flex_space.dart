import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoDetailAppBarFlexSpace extends HookConsumerWidget {
  const VideoDetailAppBarFlexSpace(
      {required this.appBarHeight,
      required this.maxAppBarHeight,
      required this.onAppBarHeightChanged,
      required this.posterPath,
      required this.backDropPath,
      required this.title,
      required this.baseBackdropImageUrl,
      required this.basePosterImageUrl,
      required this.flexibleSpaceBerKey,
      Key? key})
      : super(key: key);

  final void Function(double? height) onAppBarHeightChanged;
  final double? appBarHeight;
  final String? posterPath;
  final String? backDropPath;
  final String? title;
  final double maxAppBarHeight;
  final String baseBackdropImageUrl;
  final String basePosterImageUrl;
  final GlobalKey flexibleSpaceBerKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _posterPath = posterPath;
    final _backDropPath = backDropPath;

    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (layout) {
          Future.delayed(const Duration(milliseconds: 0), () {
            onAppBarHeightChanged(
                flexibleSpaceBerKey.currentContext?.size?.height);
          });

          return false;
        },
        child: SizeChangedLayoutNotifier(
            child: FlexibleSpaceBar(
                key: flexibleSpaceBerKey,

                /// AppBar縮小し切った時に、leading Iconと被らないようにするため設定。
                /// bottom:16は、0にするとなぜかAppBarHeightが大きくなってしまうため、設定必要。
                titlePadding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
                title: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                background: Stack(alignment: Alignment.center, children: [
                  if (_backDropPath != null)
                    Image.network(
                      baseBackdropImageUrl + _backDropPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment(
                                0.0,
                                _calculateGradiantHeight(
                                    appBarHeight, maxAppBarHeight)),
                            colors: <Color>[
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ])),
                  ),
                  if (_posterPath != null)
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: SizedBox(
                            width: _calculatePosterHeight(
                                appBarHeight, maxAppBarHeight),
                            height: _calculatePosterHeight(
                                appBarHeight, maxAppBarHeight),
                            child:
                                Image.network(basePosterImageUrl + _posterPath),
                          ),
                        ),
                      ),
                    ),
                ]))));
  }

  _calculatePosterHeight(double? appBarHeight, double maxAppBarHeight) {
    if (appBarHeight != null) {
      return appBarHeight * 0.7;
    } else {
      return maxAppBarHeight * 0.7;
    }
  }

  _calculateGradiantHeight(double? appBarHeight, double maxAppBarHeight) {
    final result = ((appBarHeight ?? maxAppBarHeight) +
            (maxAppBarHeight - (appBarHeight ?? maxAppBarHeight)) * -1.0) /
        maxAppBarHeight;

    /// 下方向へのオーバースクロール時、グラデーションがSliverListの裏側に隠れてしまうのを防ぐため
    // if (result >= 1) {
    //   return 1.0;
    // } else {
    return result - 0.2;
    // }
  }
}
