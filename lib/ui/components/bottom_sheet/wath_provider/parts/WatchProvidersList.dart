import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WatchProviderList extends HookConsumerWidget {
  const WatchProviderList(
      {required this.flatrateLogoList,
      required this.buyLogoList,
      required this.rentLogoList,
      Key? key})
      : super(key: key);
  final Iterable<Widget>? flatrateLogoList;
  final Iterable<Widget>? buyLogoList;
  final Iterable<Widget>? rentLogoList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          _showLogList(flatrateLogoList, context),
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
          _showLogList(buyLogoList, context),
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
          _showLogList(rentLogoList, context),
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

  Widget _showLogList(Iterable<Widget>? logoList, BuildContext context) {
    if (logoList == null) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of(context)!.noProvider,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return Wrap(
        children: [
          ...logoList,
        ],
      );
    }
  }
}
