import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/region/region.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/components/watch_provider_bottom_sheet_view_model.dart';

import '../../models/entity/watch_provider/provider_metadata.dart';

showWatchProviderBottomSheet(BuildContext context, WidgetRef ref, num movieId) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

                /// Opacity適用するため、Stack x BackdropFilterを組み合わせている
                child: HookConsumer(builder:
                    (BuildContext context, WidgetRef ref, Widget? child) {
                  final region = ianaCodeToRegion(
                      Localizations.localeOf(context).countryCode);
                  final viewModel =
                      ref.watch(watchProviderViewModelProvider(WatchProviderViewModelParam(region: region)));
                  final snapshot = useFuture(useMemoized(
                      () => viewModel.getMovieWatchProvider(movieId.toInt())));

                  ///TODO FIX エラーハンドリング専用の拡張関数を追加する
                  final data = snapshot.data;
                  if (data != null) {
                    return data.when(
                        success: (providers) =>
                            WatchProviderDetail(providers, movieId),

                        ///TODO FIX エラーハンドリング
                        failure: (e) => Text(e.toString()));
                  } else {
                    ///TODO FIX 読み込み中インジケータ表示する
                    return const Center(
                        child: SizedBox(
                            width: 200,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.black54,
                            )));
                  }
                }),
              ),
            ],
          ),
        );
      });
}

class WatchProviderDetail extends HookConsumerWidget {
  const WatchProviderDetail(this.providerMetadataList, this.movieId, {Key? key})
      : super(key: key);

  final ProviderMetadataList providerMetadataList;
  final num movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseImageUrl = "${ref.watch(baseImageUrlProvider)}original";

    /// flatrate
    final Iterable<Widget>? flatrateLogoList =
        providerMetadataList.flatrate?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              baseImageUrl + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    /// buy
    final Iterable<Widget>? buyLogoList =
        providerMetadataList.buy?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              baseImageUrl + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    /// rent
    final Iterable<Widget>? rentLogoList =
        providerMetadataList.rent?.map((provider) {
      final logo = provider.logoPath;
      if (logo != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              final tmdbLink = providerMetadataList.link;
              if (tmdbLink != null) {
                launch(tmdbLink);
              } else {
                ///TODO FIX エラーハンドリング snackbar表示する
              }
            },
            child: Image.network(
              baseImageUrl + logo,
              width: 50,
              height: 50,
            ),
          ),
        );
      } else {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      }
    });

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(
            AppLocalizations.of(context)!.watchNow,
            style: const TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              AppLocalizations.of(context)!.flatrate,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Align(
            child: Wrap(
              children: [
                ...?flatrateLogoList,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              AppLocalizations.of(context)!.buy,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Wrap(
            children: [
              ...?buyLogoList,
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Text(
              AppLocalizations.of(context)!.rent,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Wrap(
            children: [
              ...?rentLogoList,
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.close,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
          ),
          const SizedBox(
            height: 32,
          )
        ],
      ),
    );
  }
}
