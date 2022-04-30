import 'package:flutter/widgets.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';

import '../../../../../models/entity/movie.dart';
import '../../../../../utils/network/paging/paging_result.dart';
import '../horizontal_highlighted_movie_list.dart';

Widget showHighLightedPageContent(
    Key key,
    Key listKey,
    Stream<PagingResult<Movie>> stream,
    List<Movie>? oldMovies,
    Function(int id) onClickMovieImage,
    Function() onNextPageRequested) {
  return SizedBox(
    height: 400,
    child: StreamBuilder(
      key: key,
      stream: stream,
      builder: (context, AsyncSnapshot<PagingResult<Movie>> snapshot) {
        if (snapshot.isWaiting || snapshot.isNothing) {
          if (oldMovies != null) {
            return HighlightedMoviesHorizontalList(
              oldMovies,
              onClickMovieImage,
              onNextPageRequested,
              key: listKey,
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
              key: listKey,
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
                    key: listKey,
                  ),
              failure: (reason, oldList) {
                if (oldList != null) {
                  return HighlightedMoviesHorizontalList(
                    oldList,
                    onClickMovieImage,
                    onNextPageRequested,
                    key: listKey,
                  );
                } else {
                  return Text(reason.toString());
                }
              });
        }

        return Text("データが存在しません");
      },
    ),
  );
}
