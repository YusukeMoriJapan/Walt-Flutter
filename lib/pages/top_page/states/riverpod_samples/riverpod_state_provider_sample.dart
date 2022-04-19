import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);

class StateProviderSample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    /// StateProvider.notifier　で　StateControllerが取得できる
    final StateController counter = ref.watch(counterProvider.notifier);

    final int counterValue = ref.watch(counterProvider);

    return Scaffold(
      body: ElevatedButton(
        /// StateProvider.updateでStateProviderの値更新が可能。
        /// 更新されるとwatchしているwidgetが再構築される。
        onPressed: () => counter.update((state) => state + 1),
        child: Text('Count: ${ref.watch(counterProvider)}'),
      ),
    );
  }
}

