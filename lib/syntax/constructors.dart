class ConstructSample {
  static late ConstructSample _factoryConstructorSample;

  final int number;
  final String chars;

  ///ファクトリーコンストラクター
  factory ConstructSample(int param1) {
    _factoryConstructorSample =
        ConstructSample._internalConstructor(param1, "文字列");
    return _factoryConstructorSample;
  }

  // FactoryConstructorSampleインスタンスを生成するためのコンストラクタ(内部呼び出し用)
  // _で定義しているためこのコンストラクタはprivate!
  ConstructSample._internalConstructor(this.number, this.chars);

  ///名前付きコンストラクター
  ConstructSample.withNameConstructor(this.number, this.chars);

  ///リダイレクトコンストラクタ
  //Kotlinでいうセカンダリコンストラクターに近い
  ConstructSample.redirectConstructor(int numInRedirect)
      : this.withNameConstructor(numInRedirect, "文字列");

  ///定数コンストラクタ
  const ConstructSample.constConstructor(this.number, this.chars);
}

List<ConstructSample> getFactoryConstructorSample() {
  final list = [ConstructSample(3), ConstructSample(4), ConstructSample(5)];

  return list;
}


