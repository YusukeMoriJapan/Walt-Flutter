import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/models/entity/movie/movie.dart';
import 'package:walt/tmdb_client_app/utils/throwable/not_provided_exception.dart';

class HighlightedMoviesHorizontalList extends HookConsumerWidget {
  const HighlightedMoviesHorizontalList(
      this.movies, this.onClickMovieImage, this._scrollController,
      {Key? key})
      : super(key: key);

  final List<Movie> movies;
  final void Function(int id) onClickMovieImage;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: _imageHPadding(i)),
            child: InkWell(
                onTap: () {
                  final id = movies[i].id?.toInt();
                  if (id != null) onClickMovieImage(id);
                },

                ///TODO FIX 画像サイズをInjectするべき
                child: Stack(
                  children: [
                    Container(
                      foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                            Colors.transparent,
                            Colors.black,
                          ])),
                      child: Image.network(
                        "https://image.tmdb.org/t/p/w780${movies[i].backdropPath}",
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.loose(Size(200, double.infinity)),
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            movies[i].title ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  _imageHPadding(int i) {
    if (i != 0 || i != movies.length - 1) {
      return 4.0;
    } else {
      return 0.0;
    }
  }
}
