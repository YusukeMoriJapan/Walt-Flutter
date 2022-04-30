import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/parts/builder/show_discover_page_content.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';
import 'package:walt/tmdb_client_app/use_cases/get_movies_use_case.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';
import 'package:walt/tmdb_client_app/utils/network/result.dart';

import '../../../models/entity/movie.dart';
import '../../../utils/network/paging/paging_result.dart';
import 'parts/horizontal_highlighted_movie_list.dart';

class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieViewModel = ref.watch(movieViewModelProvider);

    useEffect(() {
      if (movieViewModel.currentTrendingMoviesAreNull) {
        movieViewModel.refreshTrendingMovies();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.currentUpComingMoviesAreNull) {
        movieViewModel.refreshUpComingMovies();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.currentPopularMoviesAreNull) {
        movieViewModel.refreshPopularMovies();
      }
    }, [true]);
    useEffect(() {
      if (movieViewModel.currentTopRatedMoviesAreNull) {
        movieViewModel.refreshTopRatedMovies();
      }
    }, [true]);

    return PageStorage(
      bucket: PageStorageBucket(),
      child: ListView(
        children: [
          showHighLightedPageContent(
              const PageStorageKey("trending"),
              const ValueKey("trendingList"),
              movieViewModel.trendingMovieStream,
              movieViewModel.getCurrentTrendingMovies(), (id) {
            movieViewModel.requestNextPageTrendingMovies();
          }, () {
            movieViewModel.requestNextPageTrendingMovies();
          }),
          showHighLightedPageContent(
              const PageStorageKey("upComing"),
              const ValueKey("upComingList"),
              movieViewModel.upComingMovieStream,
              movieViewModel.getCurrentUpComingMovies(), (id) {
            // movieViewModel.requestNextPageUpComingMovies();
          }, () {
            // movieViewModel.requestNextPageUpComingMovies();
          }),
          showHighLightedPageContent(
              const PageStorageKey("topRated"),
              const ValueKey("topRatedList"),
              movieViewModel.topRatedMovieStream,
              movieViewModel.getCurrentTopRatedMovies(), (id) {
            // movieViewModel.requestNextPageTrendingMovies();
          }, () {
            // movieViewModel.requestNextPageTrendingMovies();
          }),
          showHighLightedPageContent(
              const PageStorageKey("popular"),
              const ValueKey("popularList"),
              movieViewModel.popularMovieStream,
              movieViewModel.getCurrentPopularMovies(), (id) {
            // movieViewModel.requestNextPageTrendingMovies();
          }, () {
            // movieViewModel.requestNextPageTrendingMovies();
          })
        ],
      ),
    );
  }
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
