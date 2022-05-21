import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/watch_provider/provider_metadata.dart';
import 'package:walt/providers/tmdb_config_provider.dart';
import 'package:walt/ui/components/bottom_sheet/wath_provider/parts/WatchProvidersList.dart';
import 'package:walt/ui/components/bottom_sheet/wath_provider/parts/watch_provider_icons.dart';

class WatchProviderBottomSheetContent extends HookConsumerWidget {
  const WatchProviderBottomSheetContent(this.providerMetadataList, this.movieId,
      {Key? key})
      : super(key: key);

  final ProviderMetadataList providerMetadataList;
  final num movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseImageUrl = "${ref.watch(baseImageUrlProvider)}original";

    final onTapProviderImage = useCallback((ProviderMetadata provider) {
      final tmdbLink = providerMetadataList.link;
      if (tmdbLink != null) {
        launch(tmdbLink);
      } else {
        ///TODO FIX エラーハンドリング snackbar表示する
      }
    }, [providerMetadataList]);

    final Iterable<Widget>? flatrateLogoList =
    providerMetadataList.flatrate?.map((provider) {
      return WatchProviderIcon(provider, baseImageUrl, onTapProviderImage);
    });

    final Iterable<Widget>? buyLogoList =
    providerMetadataList.buy?.map((provider) {
      return WatchProviderIcon(provider, baseImageUrl, onTapProviderImage);
    });

    final Iterable<Widget>? rentLogoList =
    providerMetadataList.rent?.map((provider) {
      return WatchProviderIcon(provider, baseImageUrl, onTapProviderImage);
    });

    return WatchProviderList(flatrateLogoList: flatrateLogoList,
        buyLogoList: buyLogoList,
        rentLogoList: rentLogoList);
  }
}
