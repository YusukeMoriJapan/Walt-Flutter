import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar_flex_space.dart';

import '../../../../../models/entity/movie/movie_detail/movie_details.dart';
import '../../../../../utils/ui/icons.dart';

class VideoDetailAppBar extends HookConsumerWidget {
  VideoDetailAppBar(
      this.appBarHeight, this.onAppBarHeightChanged, this.movieDetail,
      {Key? key})
      : super(key: key);

  final void Function(double? height) onAppBarHeightChanged;
  final double? appBarHeight;
  final maxAppBarHeight = 350.0;
  final MovieDetails movieDetail;
  final flexibleSpaceBerKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 3,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
            icon: const ShadowIcon(
              Icons.close,
              color: Colors.black,
              backgroundColor: Color.fromARGB(76, 255, 255, 255),
              shadowColor: Colors.transparent,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ],
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
        basePosterImageUrl: ref.read(posterImagePathProvider(500)),
        flexibleSpaceBerKey: flexibleSpaceBerKey,
      ),
      floating: false,
    );
  }
}
