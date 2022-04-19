import 'package:hooks_riverpod/hooks_riverpod.dart';

/// StateNotifierProviderの後に続けて、Notifierクラスの型と、格納する状態の型を明示する
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