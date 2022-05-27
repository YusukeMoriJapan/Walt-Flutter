import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/models/entity/watch_provider/provider_metadata.dart';

class WatchProviderIcon extends HookConsumerWidget {
  const WatchProviderIcon(this.provider, this.baseImageUrl, this.onIconTap, {Key? key})
      : super(key: key);
  final ProviderMetadata provider;
  final String baseImageUrl;
  final void Function(ProviderMetadata) onIconTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logo = provider.logoPath;
    if (logo != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => onIconTap(provider),
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
  }
}
