import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class DiscoverPage extends HookConsumerWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {



    return const DiscoverPageContent();
  }
}

class DiscoverPageContent extends HookConsumerWidget {
  const DiscoverPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final List<Movie> trendingMovie
    // final List<Movie> upComingMovie
    // final List<Movie> topRatedMovie
    // final List<Movie> popularMovie


    //Header Chipたくさんあり

    return ListView.builder(
        itemCount: 1, //縦の要素数
        itemBuilder: (BuildContext context, int index) {
          //直和型のwhenで網羅する
          return const Text("");
          //パターン1　(Trending, Popular)

          //パターン2  (映像コンテンツ一覧　とかアニメとか)

          //パターン3  (何か)
        });

    const Text("Trending");
    const Text("Up Coming");
    const Text("Top Rated");
    const Text("Popular");
  }
}
