import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walt/tmdb_client_app/models/mock/mock_movie.dart';
import 'package:walt/tmdb_client_app/utils/hooks/system_hooks.dart';

import '../../../models/entity/movie.dart';
import '../../../utils/ui/hard_spring_page_view_scroll_physics.dart';

class ForYouPage extends HookConsumerWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useFullScreenUntilDispose([true]);

    return const Center(
      child: ForYouPagerContent(),
    );
  }
}

class ForYouPagerContent extends HookConsumerWidget {
  const ForYouPagerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerParent = PreloadPageController();

    return Stack(
      children: [
        PreloadPageView.builder(
            physics: const HardSpringPageViewScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            controller: controllerParent,
            preloadPagesCount: 3,
            itemBuilder: (BuildContext context, int indexParent) {
              switch (indexParent) {
                case 0:
                  return MovieContentPage(ref.read(mock007MoviesProvider));

                case 1:
                  return MovieContentPage(ref.read(mockJohnWickMoviesProvider));

                case 2:
                  return MovieContentPage(
                      ref.read(mockFastAndFuriousMoviesProvider));
                default:

                  ///TODO FIX エラーハンドリング必須
                  return const Text("何か投げる");
              }
            }),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.arrow_back_ios,color: Colors.white)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.arrow_forward_ios,color: Colors.white)),
      ],
    );
  }
}

class MovieContentPage extends HookConsumerWidget {
  final List<Movie> movies;
  final controller = PreloadPageController();

  MovieContentPage(this.movies, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagerIndicatorActiveIndex = useState(0);

    return Stack(
      children: [
        PreloadPageView.builder(
            controller: controller,
            preloadPagesCount: 3,
            itemCount: movies.length,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) {
              pagerIndicatorActiveIndex.value = i;
            },
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Image.network(
                  /// nullハンドリング必要
                  movies[index].posterPath ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            }),
        SafeArea(
          child: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 40),
            child: AnimatedSmoothIndicator(
                activeIndex: pagerIndicatorActiveIndex.value,
                effect: const SlideEffect(
                    dotWidth: 8, dotHeight: 8, spacing: 16),
                count: movies.length,
                axisDirection: Axis.vertical),
          ),
        )
      ],
    );
  }
}

// return Center(
//     child: Stack(
//   children: [
//     Image.network(
//       "https://www.themoviedb.org/t/p/original/2kExe7ImkVP4emxWGoJnraxthWd.jpg",
//       fit: BoxFit.cover,
//       width: double.infinity,
//       height: double.infinity,
//     ),
//     SafeArea(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text("Trending",
//             style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.w300,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 shadows: const <Shadow>[
//                   Shadow(
//                     offset: Offset(2.0, 2.0),
//                     blurRadius: 10.0,
//                     color: Colors.black87,
//                   ),
//                 ])),
//         Text("Casino Royale",
//             style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.w300,
//                 color: Color.fromARGB(255, 255, 255, 255),
//                 shadows: const <Shadow>[
//                   Shadow(
//                     offset: Offset(2.0, 2.0),
//                     blurRadius: 10.0,
//                     color: Colors.black87,
//                   ),
//                 ])),
//       ],
//     ))
//   ],
// ));
