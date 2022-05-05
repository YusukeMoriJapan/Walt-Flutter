import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/sample_sliver_detail_list.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar.dart';

import '../../../../models/entity/movie/movie.dart';
import '../../../../models/entity/movie/movie_detail/movie_details.dart';

class MovieDetailPageContent extends HookConsumerWidget {
  const MovieDetailPageContent(this.movieDetails, {Key? key}) : super(key: key);

  final MovieDetails movieDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarHeight = useState<double?>(null);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          VideoDetailAppBar(appBarHeight.value, (heightValue) {
            appBarHeight.value = heightValue;
          }, movieDetails),
          SliverMovieDetailList(
            movieDetails.overview,
            movieDetails.id,
          ),
        ],
      ),
    );
  }
}
