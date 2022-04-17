class LambdaFunctionSample {
  final list = ['A', 'B', 'C'];

  _invokeLambdaFunc() {
    /** ラムダ式定義方法 */
    list.forEach((String item) {
      print(item);
    });

    /** ラムダ式省略記法 */
    list.forEach((String item) => print(item));
  }
}
