import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import 'package:walt/tmdb_client_app/use_cases/get_trending_movies_use_case.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';

import '../../../models/entity/movie.dart';
import '../../../utils/network/paging/paging_result.dart';
import 'parts/horizontal_highlighted_movie_list.dart';

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// streamの現在値を同期的に取得できないため、別変数で管理
    ///(stream.lastで現在値を取得しようとすると、StateError("Stream has already been listened to.")エラーが発生する)
    final currentTrendingPage = useRef(1);
    final currentTrendingMovies = useRef<List<Movie>?>(null);

    /// useStreamで初期値を与える時は、必ずuseStreamを実行した後にcontroller.addを実行すること
    final trendingPagingController = useStreamController<Object>();

    final fooo = useRef(trendingPagingController.stream.asyncMap((event) {
      return ref.read(getTrendingMoviesUseCase).call(
          language: Language.japanese,
          page: currentTrendingPage.value,
          apiVersion: 3,
          region: "JP",
          timeWindow: TimeWindow.day,
          oldMovieList: currentTrendingMovies.value,
          cancelToken: CancelToken())
        ..then((value) => currentTrendingMovies.value = value.when(
            success: (data) => data, failure: (reason, oldList) => oldList));
    }));

    final trendingSnapshot = useStream(fooo.value);
    useEffect(() {
      trendingPagingController.add(Object);
    }, [true]);

    return _showDiscoverPageContent(
        trendingSnapshot, currentTrendingMovies.value, (id) {
      currentTrendingPage.value++;
      trendingPagingController.add(Object());
    }, () {
      currentTrendingPage.value++;
      trendingPagingController.add(Object());
    });
  }
}

Widget _showDiscoverPageContent(
    AsyncSnapshot<PagingResult<Movie>> snapshot,
    List<Movie>? oldMovies,
    Function(int id) onClickMovieImage,
    Function() onNextPageRequested) {
  if (snapshot.isNotDone) {
    if (oldMovies != null) {
      return HighlightedMoviesHorizontalList(
        oldMovies,
        onClickMovieImage,
        onNextPageRequested,
        key: const ValueKey("一旦これで"),
      );
    } else {
      return Text("読み込み中");
    }
  }

  if (snapshot.hasError) {
    if (oldMovies != null) {
      return HighlightedMoviesHorizontalList(
        oldMovies,
        onClickMovieImage,
        onNextPageRequested,
        key: const ValueKey("一旦これで"),
      );
    } else {
      return Text(snapshot.error.toString());
    }
  }

  final data = snapshot.data;
  if (data != null) {
    return data.when(
        success: (movies) => HighlightedMoviesHorizontalList(
              movies,
              onClickMovieImage,
              onNextPageRequested,
              key: const ValueKey("一旦これで"),
            ),
        failure: (reason, oldList) {
          if (oldList != null) {
            return HighlightedMoviesHorizontalList(
              oldList,
              onClickMovieImage,
              onNextPageRequested,
              key: const ValueKey("一旦これで"),
            );
          } else {
            return Text(reason.toString());
          }
        });
  }

  return Text("データが存在しません");
}

class DiscoverPageContent extends HookConsumerWidget {
  const DiscoverPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<Movie> trendingMovie
    // final List<Movie> upComingMovie
    // final List<Movie> topRatedMovie
    // final List<Movie> popularMovie

    //Header Chipたくさんあり

    return ListView.builder(
        itemCount: 1, //縦の要素数
        itemBuilder: (BuildContext context, int index) {
          //直和型のwhenで網羅する
          return const Text("");
          //パターン1　(Trending, Popular)

          //パターン2  (映像コンテンツ一覧　とかアニメとか)

          //パターン3  (何か)
        });

    const Text("Trending");
    const Text("Up Coming");
    const Text("Top Rated");
    const Text("Popular");
  }
}
