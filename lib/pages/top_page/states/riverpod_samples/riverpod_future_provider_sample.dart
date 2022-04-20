import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


///非同期で値を提供するときはFutureProviderを使用する
final configProvider = FutureProvider<Map<String, Object?>>((ref) async {
  final jsonString = await rootBundle.loadString('assets/config.json');
  final content = json.decode(jsonString) as Map<String, Object?>;
  return content;
});

class FutureProviderSample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Map<String, Object?>> config = ref.watch(configProvider);

    return Scaffold(
      // 非同期で取得するときはwhenを使う
      body: config.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (config) {
            return Text(config['host'] as String);
          }),
    );
  }
}
