import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/movie.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

class HighlightedMoviesHorizontalList extends HookConsumerWidget {
  const HighlightedMoviesHorizontalList(
      this.movies, this.onClickMovieImage, this.onNextPageRequested,
      {Key? key})
      : super(key: key);

  final List<Movie> movies;
  final void Function(int id) onClickMovieImage;
  final void Function() onNextPageRequested;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int i) {
          return InkWell(
              onTap: () {
                onClickMovieImage(i);
              },
              ///TODO FIX 画像サイズをInjectするべき
              child: Image.network(
                "https://image.tmdb.org/t/p/w342${movies[i].posterPath}",
              )
          );
        },
      ),
    );
  }
}
