import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/combined_entity/movie_details_with_credits.dart';
import 'package:walt/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar.dart';
import 'package:walt/ui/pages/movie_detail/parts/horizontal_credits_list.dart';
import 'package:walt/ui/pages/movie_detail/parts/sliver_movie_detail_list.dart';

class MovieDetailPageContent extends HookConsumerWidget {
  const MovieDetailPageContent(
      {required this.movieDetailsWithCredits, Key? key})
      : super(key: key);

  final MovieDetailsWithCredits movieDetailsWithCredits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = useRef(MovieDetailPageContentState()).value;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          VideoDetailAppBar(state.appBarHeight, (heightValue) {
            state.updateAppBarHeight(heightValue);
          }, movieDetailsWithCredits.movieDetails),
          SliverMovieDetailList(
              movieDetailsWithCredits.movieDetails.overview,
              movieDetailsWithCredits.movieDetails.id,
              _buildHorizontalCreditList()),
        ],
      ),
    );
  }

  Widget _buildHorizontalCreditList() {
    final credits = movieDetailsWithCredits.credits;

    if (credits != null) {
      return SizedBox(
        height: 220,
        child: HorizontalCreditsList(credits, (id) {}),
      );
    } else {
      ///TODO FIX エラーハンドリング
      return const Text("読み込みに失敗しました");
    }
  }
}

class MovieDetailPageContentState {
  final appBarHeight = ValueNotifier<double?>(null);

  updateAppBarHeight(double? height) {
    appBarHeight.value = height;
  }
}
