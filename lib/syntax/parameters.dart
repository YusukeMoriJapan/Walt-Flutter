/// 通常の定義
void normalFunc(bool param1, bool param2) {
  // 引数名指定で関数実行はできない
  normalFunc(true, true);
}

///　引数に名前指定が必要な関数。
void withNameParamNormalFunc({required bool param1, required bool param2}) {
  // 引数順番を入れ替えて挿入することができる
  withNameParamNormalFunc(param2: true, param1: true);
}

/// オプショナルパラメータ
void optionalParamFunc({bool? param1, bool? param2}) {
  //　全てオプショナルなので引数なしで実行可能
  optionalParamFunc();

  // オプショナル関数の場合は、引数名の指定が必ず必要
  optionalParamFunc(param2: true);
}

/// オプショナルパラメータ(デフォルト引数あり)
// デフォルト引数ありの場合は、引数の型をnull非許容型として定義できる。
void optionalParamWithDefaultPramFunc({bool param1 = true, bool param2 = true}) {
  //　全てオプショナルなので引数なしで実行可能
  optionalParamFunc();

  // オプショナル関数の場合は、引数名の指定が必ず必要
  optionalParamFunc(param2: true);
}

/// オプショナル位置パラメータ
void optionalPositionParamFunc(bool param1, [bool? param2]) {

  // オプショナル引数を使用しない場合は省略可能
  optionalPositionParamFunc(true);

  // 最後のparam2は入れなくても良い
  optionalPositionParamFunc(true, true);
}

/// 位置パラメータを使用しないオプショナル
void optionalNotPositionParamFunc(bool param1, {bool? param2}) {
  // オプショナルパラメータへ挿入には、引数名の指定が必要
  optionalNotPositionParamFunc(true, param2: true);
}


/// 関数オブジェクトを引数にとる場合
/// 1と2両方とも、関数オブジェクトを引数にとる
//　引数指定パターン1
String? invokeFunctionObject1(String computation()?) {
  return computation?.call();
}
//　引数指定パターン2
String? invokeFunctionObject2(String Function()? computation) {
  return computation?.call();
}


