import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider 外部からの変更が不可能。
final appNameProvider = Provider((ref) => 'My TODO');

class SampleRiverpodProviderWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // リアルタイム取得の場合はwatchを使う
    final appName = ref.watch(appNameProvider);

    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: ListView(
        children: const [],
      ),
    );
  }
}

final counterProvider = StateProvider((ref) => 0);

/// 別Providerからの変更は可能
final doubleCounterProvider = Provider((ref) {
  // counterProvider値が変更されるとdoubleCounterProviderも変更される
  final count = ref.watch(counterProvider);
  return count * 2;
});

class SampleRiverpodProviderWidget2 extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // doubleCounterProviderの値が変更されると再構築される
    final doubleCount = ref.watch(doubleCounterProvider);

    return Scaffold(
      // doubleCounterProvider の値を表示
      body: Text('2倍されたカウント値：$doubleCount'),
    );
  }
}
