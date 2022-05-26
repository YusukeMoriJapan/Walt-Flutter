import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MovieDetailPageContent extends HookConsumerWidget {
  const MovieDetailPageContent(
      {required this.videoDetailAppBar,
      required this.sliverMovieDetailList,
      Key? key})
      : super(key: key);

  final Widget videoDetailAppBar;
  final Widget sliverMovieDetailList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          videoDetailAppBar,
          sliverMovieDetailList,
        ],
      ),
    );
  }
}
