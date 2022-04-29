import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:walt/pages/top_page/mc_grid_menu_page.dart';
import 'package:walt/pages/top_page/states/top_page_providers.dart';

class TopPage extends HookConsumerWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(topPageTitleProvider);
    return const Scaffold(
      body: McGridMenuPage(),
      bottomSheet: TopPageBottomSheet(),
    );
  }
}

class TopPageBottomSheet extends HookConsumerWidget {
  const TopPageBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.red,
    );
  }
}
