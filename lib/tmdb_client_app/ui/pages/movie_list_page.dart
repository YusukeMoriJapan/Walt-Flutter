import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/repository/movie_repository.dart';
import 'package:walt/tmdb_client_app/utils/network/requests/get_movie_request.dart';

import '../../models/entity/movie.dart';
import '../../providers/movie_provider.dart';

class MovieListPage extends HookConsumerWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(child: HookConsumer(builder: (context, ref, child) {
      final moviesResult = ref
          .watch(movieProvider(const GetMovieRequestBase(
              language: Language.japanese,
              page: 1,
              apiVersion: 3,
              // cancelToken: CancelToken(),
              region: "JA")))
          .value;

      return moviesResult?.when<Widget>(success: (data) {
            return MovieList(data);
          }, failure: (e) {
            return const Text("読み込みに失敗しました。");
          }) ??
          const CircularProgressIndicator();
    })));
  }
}

class MovieList extends HookConsumerWidget {
  const MovieList(this.movies, {Key? key}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            _movieItem(context, movies[index]),
        separatorBuilder: (BuildContext context, int index) =>
            _movieListSeparator(),
        itemCount: movies.length);
  }
}

Widget _movieItem(BuildContext context, Movie movie) {
  final imageUrl = movie.posterPath;
  if (imageUrl != null) {
    return Image.network(
      "https://image.tmdb.org/t/p/w500/" + imageUrl,
      fit: BoxFit.fitWidth,
    );
  } else {
    return const Text("映画タイトルを出す");
  }
}

Widget _movieListSeparator() {
  return const Divider();
}
