import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


/// FlutterフレームワークのStreamクラスを使用する場合は、StreamProviderを使用する
final itemsStreamProvider = StreamProvider<List<SampleItem>>((ref) {
  final collection = FirebaseFirestore.instance.collection('items');

  final stream = collection.snapshots().map(
        // CollectionのデータからItemクラスを生成する
        (e) => e.docs.map((e) => SampleItem.fromJson(e.data())).toList(),
      );
  return stream;
});

class StreamProviderSample extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SampleItem>> items = ref.watch(itemsStreamProvider);

    return Scaffold(
      // AsyncValue は `.when` を使ってハンドリング
      body: items.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
          data: (items) {
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final SampleItem = items[index];
                  return ListTile(title: Text(SampleItem.name));
                });
          }),
    );
  }
}

class SampleItem {
  late final String name;

  SampleItem(this.name);

  static SampleItem fromJson(Map<String, dynamic> data) {
    return SampleItem("sample string");
  }
}
