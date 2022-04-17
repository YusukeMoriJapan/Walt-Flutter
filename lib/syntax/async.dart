import 'dart:io';

import 'package:flutter/foundation.dart';

Future<String> asyncFunc() async {
  return await Future<String>.delayed(const Duration(seconds: 3), () {
    return "3秒経過しました。";
  });
}

/// Isolate compute あらかじめ定義しておいた関数を代入するパターン
void callIsolatedComputation1() async {
  final result = await compute(heavyTask, 1000000000); // 画面がカクつかない
  print(result);
}

/// Isolate compute 無名関数を直接代入するパターン
void callIsolatedComputation2() async {
  await compute((String path) {
    sleep(Duration(seconds: 10));
  }, '引数に入る文字列');
}

/// Isolateを使用していないので処理が終了するまで画面が止まる。
/// (Main Isolateがブロックされる)
void callNotIsolatedComputation() async {
  final result = heavyTask(1000000000); // 画面がカクつく
  print(result);
}

String heavyTask(int value) {
  // 時間が掛かる処理と仮定
  for (int i = 0; i < value; ++i) {}
  return 'Finish heavyTask!';
}
