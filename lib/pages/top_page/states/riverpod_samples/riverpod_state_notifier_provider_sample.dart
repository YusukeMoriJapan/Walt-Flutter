import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// StateProviderの値を操作するメソッドを格納することができる。
/// 言い換えると、状態操作メソッドを格納できる。
/// Widgetに複雑な状態操作メソッドが紛れ込んでしまうのを防ぐ
// StateNotifierProviderの後に続けて、Notifierクラスの型と、格納する状態の型を明示する
final urlListNotifierProvider =
    StateNotifierProvider<UrlListNotifier, List<String>>(
  (ref) => UrlListNotifier(),
);

class UrlListNotifier extends StateNotifier<List<String>> {
  UrlListNotifier() : super([]);

  /// 新しいurlを追加するメソッド
  void add(String url) {
    state = [...state, url];
  }

  /// urlを削除するメソッド
  void remove(String url) {
    state = [
      for (final url in state)
        if (url != url) url,
    ];
  }
}

class StateNotifierProviderSample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providerの値を取得
    final urlList = ref.watch(urlListNotifierProvider);

    // Notifierの取得
    final UrlListNotifier notifier =
        ref.watch(urlListNotifierProvider.notifier);

    return Scaffold(
      body: ListView(
        children: [
          for (final url in urlList)
            ListTile(
              title: Text(url),
              onTap: () => notifier.remove(url),
            )
        ],
      ),
    );
  }
}
