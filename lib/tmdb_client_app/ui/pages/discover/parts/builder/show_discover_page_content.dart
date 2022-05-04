import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:walt/tmdb_client_app/ui/pages/discover/parts/horizontal_genre_movie_list.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';
import 'package:walt/tmdb_client_app/utils/ui/scroll_detector.dart';

import '../../../../../models/entity/movie/movie.dart';
import '../../../../../utils/network/paging/paging_result.dart';
import '../horizontal_highlighted_movie_list.dart';

List<Widget> showHighLightedPageContent(
    Key key,
    Key listKey,
    String headerName,
    Stream<PagingResult<Movie>> stream,
    List<Movie>? oldMovies,
    Function(int id) onClickMovieImage,
    Function() onNextPageRequested) {
  return [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        headerName,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: SizedBox(
        height: 150,
        child: StreamBuilder(
          key: key,
          stream: stream,
          builder: (context, AsyncSnapshot<PagingResult<Movie>> snapshot) {
            if (snapshot.isWaiting || snapshot.isNothing) {
              if (oldMovies != null) {
                return ScrollDetector(
                  builder: (context, scrollController) {
                    return HighlightedMoviesHorizontalList(
                      oldMovies,
                      onClickMovieImage,
                      scrollController,
                      key: listKey,
                    );
                  },
                  threshold: 0.8,
                  onThresholdExceeded: onNextPageRequested,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }

            if (snapshot.hasError) {
              if (oldMovies != null) {
                return ScrollDetector(
                  builder: (context, scrollController) {
                    return HighlightedMoviesHorizontalList(
                      oldMovies,
                      onClickMovieImage,
                      scrollController,
                      key: listKey,
                    );
                  },
                  threshold: 0.8,
                  onThresholdExceeded: onNextPageRequested,
                );
              } else {
                return Text(snapshot.error.toString());
              }
            }

            final data = snapshot.data;
            if (data != null) {
              return data.when(
                  success: (movies) => ScrollDetector(
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
                      ),
                  failure: (reason, oldList) {
                    if (oldList != null) {
                      return ScrollDetector(
                        builder: (context, scrollController) {
                          return HighlightedMoviesHorizontalList(
                            oldList,
                            onClickMovieImage,
                            scrollController,
                            key: listKey,
                          );
                        },
                        threshold: 0.8,
                        onThresholdExceeded: onNextPageRequested,
                      );
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
  ];
}

Widget showHighLightedPageContent2(
    Key key,
    Key listKey,
    Stream<PagingResult<Movie>> stream,
    List<Movie>? oldMovies,
    Function(int id) onClickMovieImage,
    Function() onNextPageRequested) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 0, 16),
    child: SizedBox(
      height: 150,
      child: StreamBuilder(
        key: key,
        stream: stream,
        builder: (context, AsyncSnapshot<PagingResult<Movie>> snapshot) {
          if (snapshot.isWaiting || snapshot.isNothing) {
            if (oldMovies != null) {
              return ScrollDetector(
                builder: (context, scrollController) {
                  return NormalMoviesHorizontalList(
                    oldMovies,
                    onClickMovieImage,
                    scrollController,
                    key: listKey,
                  );
                },
                threshold: 0.8,
                onThresholdExceeded: onNextPageRequested,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }

          if (snapshot.hasError) {
            if (oldMovies != null) {
              return ScrollDetector(
                builder: (context, scrollController) {
                  return NormalMoviesHorizontalList(
                    oldMovies,
                    onClickMovieImage,
                    scrollController,
                    key: listKey,
                  );
                },
                threshold: 0.8,
                onThresholdExceeded: onNextPageRequested,
              );
            } else {
              return Text(snapshot.error.toString());
            }
          }

          final data = snapshot.data;
          if (data != null) {
            return data.when(
                success: (movies) => ScrollDetector(
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
                    ),
                failure: (reason, oldList) {
                  if (oldList != null) {
                    return ScrollDetector(
                      builder: (context, scrollController) {
                        return NormalMoviesHorizontalList(
                          oldList,
                          onClickMovieImage,
                          scrollController,
                          key: listKey,
                        );
                      },
                      threshold: 0.8,
                      onThresholdExceeded: onNextPageRequested,
                    );
                  } else {
                    return Text(reason.toString());
                  }
                });
          }

          return const Text("データが存在しません");
        },
      ),
    ),
  );
}
