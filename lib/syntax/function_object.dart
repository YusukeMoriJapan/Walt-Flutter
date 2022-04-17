///関数オブジェクトを変数として定義したい時
class InvokeFunctionObjectClass {
  // not nullableの場合はlate modifierが必要
  late String Function(int) computationNotNull;

  // nullable
  String Function(int)? computationNullable;

  // 変数定義時に関数も定義する場合
  final String Function(int) computationFinal = (num) {
    return num.toString();
  };

  InvokeFunctionObjectClass(this.computationNotNull,
      [this.computationNullable]);

  _invokeAllCallbacks() {
    computationNotNull(0);
    // 関数オブジェクトがnullableの場合は、callメソッドで関数を呼び出す。
    computationNullable?.call(0);
    computationFinal(0);
  }
}

/// 関数オブジェクトを引数にとるクラスのインスタンスを生成したい時
createInvokeFunctionObjectClass() {
  InvokeFunctionObjectClass((n) => n.toString(), (r) {
    return r.toString();
  });
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
