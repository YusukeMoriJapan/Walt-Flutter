import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';

import '../../../../models/entity/movie/movie.dart';
import '../../../../models/entity/movie/movie_list.dart';
import '../../../../utils/network/paging/paging_result.dart';
import '../../../../utils/ui/scroll_detector.dart';
import '../parts/horizontal_highlighted_movie_list.dart';
import '../parts/horizontal_normal_movie_list.dart';

enum DiscoverRowContentType { normal, highLighted }

class DiscoverRowContentUiModel {
  final String headerName;
  final Key key;
  final Key listKey;
  final MovieList? movieList;
  final Function(int id) onClickMovieImage;

  final DiscoverRowContentType type;

  const DiscoverRowContentUiModel(
      {required this.headerName,
      required this.key,
      required this.listKey,
      required this.movieList,
      required this.onClickMovieImage,
      required this.type});

  Widget buildRowContent() {
    final _movieList = movieList;

    if (_movieList == null) {
      return const SizedBox();
    }

    final stream = _movieList.movieListStream;
    final oldMovies = _movieList.currentMovieList;
    final onNextPageRequested = () => _movieList.requestNextPageMovieList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            headerName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: SizedBox(
            height: 150,
            child: StreamBuilder(
              key: key,
              stream: stream,
              builder: (context, AsyncSnapshot<PagingResult<Movie>> snapshot) {
                if (snapshot.isWaiting || snapshot.isNothing) {
                  if (oldMovies != null) {
                    return _showRowContent(oldMovies, onNextPageRequested);
                  } else {
                    return const Center(
                        child: SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.black54,
                    ),
                        ));
                  }
                }

                if (snapshot.hasError) {
                  if (oldMovies != null) {
                    return _showRowContent(oldMovies, onNextPageRequested);
                  } else {
                    return Text(snapshot.error.toString());
                  }
                }

                final data = snapshot.data;
                if (data != null) {
                  return data.when(
                      success: (movies) =>
                          _showRowContent(movies, onNextPageRequested),
                      failure: (reason, oldList) {
                        if (oldList != null) {
                          return _showRowContent(oldList, onNextPageRequested);
                        } else {
                          return Text(reason.toString());
                        }
                      });
                }

                return const Text("データが存在しません");
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _showRowContent(
      List<Movie> movies, void Function() onNextPageRequested) {
    switch (type) {
      case DiscoverRowContentType.highLighted:
        return ScrollDetector(
          builder: (context, scrollController) {
            return HighlightedMoviesHorizontalList(
              movies,
              onClickMovieImage,
              scrollController,
              key: listKey,
            );
          },
          threshold: 0.8,
          onThresholdExceeded: onNextPageRequested,
        );
        break;
      case DiscoverRowContentType.normal:
        return ScrollDetector(
          builder: (context, scrollController) {
            return NormalMoviesHorizontalList(
              movies,
              onClickMovieImage,
              scrollController,
              key: listKey,
            );
          },
          threshold: 0.8,
          onThresholdExceeded: onNextPageRequested,
        );
        break;
    }
  }
}
