import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ChangeNotifierを使用して状態変化を通知させたい場合は、
/// ChangeNotifierProviderを使用する
final counterProvider = ChangeNotifierProvider((ref) => Counter());

/// `notifyListeners()` で状態(count)の変化を通知。
///  `count` を使用しているWidgetの再構築が行われる
class Counter extends ChangeNotifier {
  int count = 0;

  // 以下は状態操作メソッド
  void increase() {
    count++;
    notifyListeners(); //状態変化通知
  }

  void decrease() {
    count--;
    notifyListeners(); //状態変化通知
  }

  void reset() {
    count = 0;
    notifyListeners(); //状態変化通知
  }
}

class ChangeNotifierProviderSample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // `Counter` の状態が更新されると再描画が走る
    final counter = ref.watch(counterProvider);

    return Scaffold(
      // 最新の `count` 数を表示
      body: Text('Count: ${counter.count}'),
      floatingActionButton: FloatingActionButton(
        onPressed: counter.increase,
        child: Icon(Icons.add),
      ),
    );
  }
}

