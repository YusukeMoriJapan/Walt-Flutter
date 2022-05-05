import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/app_bar/movie_detail_app_bar.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/horizontal_credits_list.dart';
import 'package:walt/tmdb_client_app/ui/pages/movie_detail/parts/sample_sliver_detail_list.dart';
import 'package:walt/tmdb_client_app/utils/network/async_snapshot.dart';

import '../../../../models/entity/movie/movie_detail/movie_details.dart';
import '../../../../models/entity/people/credits.dart';
import '../../../../utils/network/result.dart';

class MovieDetailPageContent extends HookConsumerWidget {
  const MovieDetailPageContent(
      {required this.movieDetails, required this.creditsFuture, Key? key})
      : super(key: key);

  final MovieDetails movieDetails;
  final Future<Result<Credits>> creditsFuture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarHeight = useState<double?>(null);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          VideoDetailAppBar(appBarHeight.value, (heightValue) {
            appBarHeight.value = heightValue;
          }, movieDetails),
          SliverMovieDetailList(movieDetails.overview, movieDetails.id,
              /// 主な出演者横スクロールリスト
              HookBuilder(builder: (context) {
            final creditsSnapshot = useFuture(creditsFuture);

            if (creditsSnapshot.isFetchingData) {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Colors.black54,
              ));
            } else {
              return creditsSnapshot.buildWidget(onSuccess: (credits) {
                return SizedBox(
                    height: 220,
                    child: HorizontalCreditsList(credits, (id) {}));
              }, onError: (e) {
                ///TODO FIX エラーハンドリング
                return Text("読み込みに失敗しました");
              });
            }
          })),
        ],
      ),
    );
  }
}
