import 'package:flutter/material.dart';

class TernaryOperatorSample {
  String? expr1;
  final String expr2 = "expr2";

  bool _isRed = false;

  _nullCheckTernary() {
    //expr1がnullじゃなければexpr1を返し、もしexpr1がnullならexpr2を返す
    final value1 = expr1 ?? expr2;

    //expr1がnullなら、expr2をexpr1に代入する
    expr1 ??= expr2;
  }

  Color _ternary() {
    // (条件) ? trueの場合 : falseの場合
    return _isRed ? Colors.red : Colors.blue;
  }
}
