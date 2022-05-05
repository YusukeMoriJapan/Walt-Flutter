import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/movie_detail_page_content.dart';
import 'package:walt/tmdb_client_app/ui/view_model/movie_view_model.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';

import '../../../models/entity/movie/movie_detail/movie_details.dart';
import '../../../utils/network/result.dart';
import '../../view_model/credits_view_model.dart';

class MovieDetailPage extends HookConsumerWidget {
  const MovieDetailPage(this.movieId, {Key? key}) : super(key: key);

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieViewModel = ref.watch(movieViewModelProvider);
    final creditsViewModel = ref.watch(creditsViewModelProvider);

    final AsyncSnapshot<Result<MovieDetails>> movieSnapshot =
        useFuture(useRef(movieViewModel.getMovieDetails(movieId)).value);

    final creditsSnapshot =
        useRef(creditsViewModel.getMovieCredits(movieId)).value;

    if (movieSnapshot.isFetchingData) {
      return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black,
                icon: const Icon(Icons.arrow_back_ios))),
        body: Center(
            child: SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.black54,
                ))),
      );
    } else {
      return movieSnapshot.buildWidget(onSuccess: (movie) {
        return MovieDetailPageContent(
          movieDetails: movie,
          creditsFuture: creditsSnapshot,
        );
      }, onError: (e) {
        ///TODO FIX エラーハンドリング必要
        return Center(
            child: Text(
          "読み込めませんでした。",
          style: TextStyle(fontSize: 16),
        ));
      });
    }
  }
}

class MovieDetailPageArguments {
  final int movieId;

  const MovieDetailPageArguments(this.movieId);
}
