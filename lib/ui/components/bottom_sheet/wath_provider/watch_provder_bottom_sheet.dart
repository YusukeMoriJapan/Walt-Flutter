import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/region/region.dart';
import 'package:walt/ui/components/bottom_sheet/wath_provider/watch_provider_bottom_sheet_view_model.dart';

import 'parts/watch_provider_bottom_sheet_content.dart';

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
                  final viewModel = ref.watch(watchProviderViewModelProvider(
                      WatchProviderViewModelParam(region: region)));
                  final snapshot = useFuture(useMemoized(
                      () => viewModel.getMovieWatchProvider(movieId.toInt())));

                  ///TODO FIX エラーハンドリング専用の拡張関数を追加する
                  final data = snapshot.data;
                  if (data != null) {
                    return data.when(
                        success: (providers) =>
                            WatchProviderBottomSheetContent(providers, movieId),

                        ///TODO FIX エラーハンドリング
                        failure: (e) => Center(
                                child: Text(
                              AppLocalizations.of(context)!.noProvider,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            )));
                  } else {
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
