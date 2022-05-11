import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/providers/tmdb_config_provider.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar_flex_space.dart';

import '../../../../../models/entity/movie/movie_detail/movie_details.dart';

final flexibleSpaceBerKey = GlobalKey();

class VideoDetailAppBar extends HookConsumerWidget {
  const VideoDetailAppBar(
      this.appBarHeight, this.onAppBarHeightChanged, this.movieDetail,
      {Key? key})
      : super(key: key);

  final void Function(double? height) onAppBarHeightChanged;
  final double? appBarHeight;
  final maxAppBarHeight = 350.0;
  final MovieDetails movieDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      elevation: 3,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios)),
      pinned: true,
      stretch: true,
      expandedHeight: maxAppBarHeight,
      flexibleSpace: VideoDetailAppBarFlexSpace(
          appBarHeight: appBarHeight,
          maxAppBarHeight: maxAppBarHeight + 20,
          onAppBarHeightChanged: onAppBarHeightChanged,
          posterPath: movieDetail.posterPath,
          backDropPath: movieDetail.backdropPath,
          title: movieDetail.title,
          baseBackdropImageUrl: ref.read(backdropImagePathProvider(780)),
          basePosterImageUrl: ref.read(posterImagePathProvider(500))),
      floating: false,
    );
  }
}
