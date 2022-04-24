import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/responses/get_movies_result.dart';
import '../../providers/movie_provider.dart';

class MovieListPage extends HookConsumerWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: HookConsumer(builder: (context, ref, child) {
          return ref.watch(movieProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) {
                print(stack);
                return Text('Error: $error');
              },
              data: (movies) => _movieList(movies));
        }),
      ),
    );
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

Widget _movieList(List<Movie>? movies) {
  if (movies != null) {
    return MovieList(movies);
  } else {
    return const Text("読み込み失敗");
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
    return Text("映画タイトルを出す");
  }
}

Widget _movieListSeparator() {
  return const Divider();
}
