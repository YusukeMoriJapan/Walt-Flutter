import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:walt/utils/network/async_snapshot.dart';

import '../../../../models/entity/movie/movie.dart';
import '../../../../utils/network/paging/paging_result.dart';
import '../../../../utils/ui/scroll_detector.dart';
import '../../../states/movies_state.dart';
import '../parts/horizontal_highlighted_movie_list.dart';
import '../parts/horizontal_normal_movie_list.dart';

enum DiscoverRowContentType { normal, highLighted }

class DiscoverRowContentUiModel {
  final String headerName;
  final Key key;
  final Key listKey;
  final MoviesState? moviesState;
  final Function(int id, AutoScrollController controller) onClickMovieImage;
  final String backdropImageUrl;
  final String posterImageUrl;
  final void Function() onNextPageRequested;
  final scrollController = AutoScrollController();

  final DiscoverRowContentType type;

  DiscoverRowContentUiModel(
      {required this.headerName,
      required this.key,
      required this.listKey,
      required this.moviesState,
      required this.onClickMovieImage,
      required this.onNextPageRequested,
      required this.type,
      required this.backdropImageUrl,
      required this.posterImageUrl});

  Widget buildRowContent() {
    final moviesState = this.moviesState;

    if (moviesState == null) {
      return const SizedBox();
    }

    final stream = moviesState.movieListStream;
    final oldMovies = moviesState.currentMovieList;
    // final onNextPageRequested = () => _movieList.requestNextPageMovieList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            headerName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
          child: SizedBox(
            height: 150,
            child: StreamBuilder(
              key: key,
              stream: stream,
              builder: (context, AsyncSnapshot<PagingResult<Movie>?> snapshot) {
                if (snapshot.isFetchingData) {
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

                return const Center(
                    child: SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.black54,
                  ),
                ));
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
          controller: scrollController,
          builder: (context, scrollController) {
            return HighlightedMoviesHorizontalList(
              movies,
              (id) => onClickMovieImage(id, scrollController),
              scrollController,
              backdropImageUrl,
              key: listKey,
            );
          },
          threshold: 0.8,
          onThresholdExceeded: onNextPageRequested,
        );
      case DiscoverRowContentType.normal:
        return ScrollDetector(
          controller: scrollController,
          builder: (context, scrollController) {
            return NormalMoviesHorizontalList(
              movies,
              (id) => onClickMovieImage(id, scrollController),
              scrollController,
              posterImageUrl,
              key: listKey,
            );
          },
          threshold: 0.8,
          onThresholdExceeded: onNextPageRequested,
        );
    }
  }
}
