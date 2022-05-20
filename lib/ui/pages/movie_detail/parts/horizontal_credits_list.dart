import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:walt/providers/tmdb_config_provider.dart';

import '../../../../models/entity/people/cast.dart';
import '../../../../models/entity/people/credits.dart';

class HorizontalCreditsList extends HookConsumerWidget {
  const HorizontalCreditsList(this.credits, this.onClickCreditsImage,
      {Key? key})
      : super(key: key);

  final Credits credits;
  final void Function(int id) onClickCreditsImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casts = useRef(credits.cast).value;
    final baseImageUrl = ref.watch(profileImagePathProvider(342));

    /// TODO FIX エラーハンドリング
    if (casts == null || casts.isEmpty) return const Text("出演者が存在しません");

    return ListView.builder(
      itemCount: casts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: _imageHPadding(i, casts)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: InkWell(
                onTap: () {},

                ///TODO FIX 画像サイズをInjectするべき
                child: Stack(
                  children: [
                    Container(
                      foregroundDecoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                            Colors.transparent,
                            Colors.black,
                          ])),
                      color: const Color.fromARGB(255, 165, 165, 165),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image:
                            // "https://image.tmdb.org/t/p/w342${_casts[i].profilePath}",
                            baseImageUrl +
                                _getProfilePath(casts[i].profilePath),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return ConstrainedBox(
                            constraints: BoxConstraints.loose(
                                const Size(100, double.infinity)),
                            child: Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  casts[i].name ?? '',
                                  style: const TextStyle(color: Colors.white),
                                )),
                          );
                        },
                        fit: BoxFit.cover,
                        height: 220,
                        width: 130,
                      ),
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.loose(const Size(100, double.infinity)),
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            casts[i].name ?? '',
                            style: const TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  String _getProfilePath(String? path) => path ?? "";

  _imageHPadding(int i, List<Cast> casts) {
    if (i != 0 || i != casts.length - 1) {
      return 4.0;
    } else {
      return 0.0;
    }
  }
}
